import 'package:algorand_dart/algorand_dart.dart';
import 'package:flutter_algorand_wallet/di/service_locator.dart';
import 'package:flutter_algorand_wallet/models/models.dart';
import 'package:flutter_algorand_wallet/repositories/account_repository.dart';
import 'package:flutter_algorand_wallet/ui/screens/asset/asset_transfer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssetTransferBloc extends Bloc<AssetTransferEvent, AssetTransferState> {
  final AccountRepository accountRepository;

  AssetTransferBloc({required this.accountRepository})
      : super(AssetTransferInitial());

  void start(AlgorandStandardAsset asset) {
    add(AssetTransferStarted(asset));
  }

  /// Publish an event to send the amount to the given recipient.
  void sendPayment({required double amount, required String recipientAddress}) {
    add(AssetTransferSent(amount: amount, recipientAddress: recipientAddress));
  }

  @override
  Stream<AssetTransferState> mapEventToState(AssetTransferEvent event) async* {
    final currentState = this.state;
    if (event is AssetTransferStarted) {
      yield AssetTransferSuccess(asset: event.asset);
    }

    if (event is AssetTransferSent && currentState is AssetTransferSuccess) {
      final account = accountRepository.account;
      if (account == null) return;

      final amount = Algo.format(event.amount, currentState.asset.decimals);

      // Transfer the assets
      try {
        final txId = await algorand.assetManager.transfer(
          assetId: currentState.asset.id,
          account: account,
          receiver:
              Address.fromAlgorandAddress(address: event.recipientAddress),
          amount: amount.toInt(),
        );

        yield AssetTransferSentSuccess(txId);
      } on AlgorandException catch (ex) {
        yield AssetTransferFailure(ex);
      }
    }
  }
}
