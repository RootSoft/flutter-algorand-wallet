import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/di/service_locator.dart';
import 'package:flutter_algorand_wallet/repositories/account_repository.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/assets/bloc/list_asset_event.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/assets/bloc/list_asset_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListAssetBloc extends Bloc<ListAssetEvent, ListAssetState> {
  final AccountRepository accountRepository;

  ListAssetBloc({required this.accountRepository}) : super(ListAssetInitial());

  /// Start the Bloc
  void start() {
    add(ListAssetStarted());
  }

  /// Search for assets
  void search(String input) {
    add(ListAssetSearched(input));
  }

  /// Opt in to an asset
  void optIn(Asset asset) {
    add(ListAssetOptInStarted(asset));
  }

  @override
  Stream<ListAssetState> mapEventToState(ListAssetEvent event) async* {
    final currentState = state;
    if (event is ListAssetStarted) {
      // Display the loading screen
      yield ListAssetInProgress();

      // Fetch the assets
      final response = await algorand.indexer().assets().search();

      yield ListAssetSuccess(assets: response.assets);
      return;
    }

    if (event is ListAssetSearched) {
      final input = event.input;

      // Display the loading screen
      yield ListAssetInProgress();

      // Check to search for name or asset id.
      final searchAssetId = isInt(input);

      final builder = algorand.indexer().assets();
      if (searchAssetId) {
        builder.whereAssetId(int.tryParse(input) ?? 0);
      } else {
        builder.whereAssetName(input);
      }

      // Search the assets
      final response = await builder.search();

      yield ListAssetSuccess(assets: response.assets);
      return;
    }

    if (event is ListAssetOptInStarted && currentState is ListAssetSuccess) {
      final asset = event.asset;

      // Display the loading screen
      yield ListAssetInProgress();

      final account = accountRepository.account;
      if (account == null) {
        yield ListAssetFailure(
          exception: AlgorandException(message: 'No existing account'),
        );
        return;
      }

      try {
        // Opt in to the asset
        final txId = await algorand.assetManager
            .optIn(assetId: asset.index, account: account);
        await algorand.waitForConfirmation(txId);

        // Update the dashboard
        accountRepository.reload();

        yield ListAssetOptInSuccess(asset: asset, assets: currentState.assets);
      } on AlgorandException catch (ex) {
        yield ListAssetFailure(exception: ex);
      }
    }
  }

  bool isInt(String s) {
    return int.tryParse(s) != null;
  }
}
