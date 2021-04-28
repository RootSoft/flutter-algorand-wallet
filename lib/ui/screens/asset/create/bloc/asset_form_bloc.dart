import 'dart:math';

import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/di/service_locator.dart';
import 'package:flutter_algorand_wallet/repositories/account_repository.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/create/asset_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetFormBloc extends Bloc<AssetFormEvent, AssetFormState> {
  final AccountRepository accountRepository;

  AssetFormBloc({required this.accountRepository}) : super(AssetFormInitial());

  void start() {
    add(AssetFormStarted());
  }

  /// Create a new asset
  void createAsset({
    required String assetName,
    required String unitName,
    required int amount,
    required int decimals,
  }) {
    add(AssetFormCreateStarted(
      assetName: assetName,
      unitName: unitName,
      amount: amount,
      decimals: decimals,
    ));
  }

  @override
  Stream<AssetFormState> mapEventToState(AssetFormEvent event) async* {
    if (event is AssetFormCreateStarted) {
      final account = accountRepository.account;

      if (account == null) {
        yield AssetFormFailure(
            exception: AlgorandException(message: 'No account specified'));
        return;
      }

      yield AssetFormInProgress();

      try {
        // Calculate the correct number of total assets to create
        final amount = (event.amount * pow(10, event.decimals)).toInt();

        final txId = await algorand.assetManager.createAsset(
          account: account,
          assetName: event.assetName,
          unitName: event.unitName,
          totalAssets: amount,
          decimals: event.decimals,
        );

        await algorand.waitForConfirmation(txId);

        yield AssetFormSuccess();

        accountRepository.reload();
      } on AlgorandException catch (ex) {
        yield AssetFormFailure(exception: ex);
      }
    }
  }
}
