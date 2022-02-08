import 'package:algorand_dart/algorand_dart.dart';
import 'package:equatable/equatable.dart';

class TransactionEvent extends Equatable {
  final String id;
  final TransactionEventType type;
  final String sender;
  final String receiver;
  final int amount;
  final int decimals;

  TransactionEvent({
    required this.id,
    required this.type,
    required this.sender,
    required this.receiver,
    required this.amount,
    required this.decimals,
  });

  /// Create a new transaction event from a given transaction.
  static TransactionEvent fromTransaction({
    required Account account,
    required Transaction transaction,
    required int decimals,
  }) {
    final isAssetTransfer = transaction.assetTransferTransaction != null;
    final sender = transaction.sender;
    final receiver = isAssetTransfer
        ? transaction.assetTransferTransaction?.receiver
        : transaction.paymentTransaction?.receiver;
    final amount = isAssetTransfer
        ? transaction.assetTransferTransaction?.amount
        : transaction.paymentTransaction?.amount;

    TransactionEventType type = TransactionEventType.UNKNOWN;
    if (sender == account.publicAddress && receiver == account.publicAddress) {
      type = TransactionEventType.COMPOUND;
    } else if (sender == account.publicAddress) {
      type = TransactionEventType.SEND;
    } else if (receiver == account.publicAddress) {
      type = TransactionEventType.RECEIVE;
    }

    return TransactionEvent(
      id: transaction.id ?? '',
      type: type,
      sender: sender,
      receiver: receiver ?? '',
      amount: amount ?? 0,
      decimals: decimals,
    );
  }

  @override
  List<Object?> get props => [
        type,
        sender,
        receiver,
        amount,
        decimals,
      ];
}

enum TransactionEventType {
  UNKNOWN,
  SEND,
  RECEIVE,
  COMPOUND,
}
