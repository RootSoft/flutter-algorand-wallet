import 'package:flutter_algorand_wallet/di/service_locator.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/assets/bloc/list_asset_event.dart';
import 'package:flutter_algorand_wallet/ui/screens/main/assets/bloc/list_asset_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListAssetBloc extends Bloc<ListAssetEvent, ListAssetState> {
  ListAssetBloc() : super(ListAssetInitial());

  /// Start the Bloc
  void start() {
    add(ListAssetStarted());
  }

  /// Search for assets
  void search(String input) {
    add(ListAssetSearched(input));
  }

  @override
  Stream<ListAssetState> mapEventToState(ListAssetEvent event) async* {
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
  }

  bool isInt(String s) {
    return int.tryParse(s) != null;
  }
}
