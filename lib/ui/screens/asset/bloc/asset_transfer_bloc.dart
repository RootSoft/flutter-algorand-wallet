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

      final asset = currentState.asset;
      final recipient =
          Address.fromAlgorandAddress(address: event.recipientAddress);

      if (asset.id == -1) {
        final amount = event.amount;
        yield* _sendPayment(account, recipient, amount);
      } else {
        final amount = Algo.format(event.amount, asset.decimals);
        yield* _transferAsset(account, asset.id, recipient, amount);
      }
    }
  }

  Stream<AssetTransferState> _sendPayment(
      Account account, Address recipient, double amount) async* {
    try {
      final txId = await algorand.sendPayment(
        account: account,
        recipient: recipient,
        amount: Algo.toMicroAlgos(amount),
      );

      yield AssetTransferInProgress();

      // Wait until the transaction is confirmed
      final pendingTx = await algorand.waitForConfirmation(txId);

      yield AssetTransferSentSuccess(txId);
    } on AlgorandException catch (ex) {
      yield AssetTransferFailure(ex);
    }
  }

  Stream<AssetTransferState> _transferAsset(
      Account account, int assetId, Address recipient, int amount) async* {
    try {
      final txId = await algorand.assetManager.transfer(
        assetId: assetId,
        account: account,
        receiver: recipient,
        amount: amount.toInt(),
      );

      yield AssetTransferInProgress();

      // Wait until the transaction is confirmed
      final pendingTx = await algorand.waitForConfirmation(txId);

      yield AssetTransferSentSuccess(txId);
    } on AlgorandException catch (ex) {
      yield AssetTransferFailure(ex);
    }
  }
}
