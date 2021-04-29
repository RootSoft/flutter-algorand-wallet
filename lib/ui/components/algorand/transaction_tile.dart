import 'dart:math';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter_algorand_wallet/models/transaction_event.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';

typedef OnTransactionTap = void Function(TransactionEvent);

class TransactionTile extends StatelessWidget {
  final TransactionEvent transaction;
  final OnTransactionTap onLongPress;

  TransactionTile({required this.transaction, required this.onLongPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => onLongPress(transaction),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: paddingSizeDefault),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                transaction.id,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
            Spacer(),
            Icon(iconData),
            HorizontalSpacing(of: paddingSizeNormal),
            Text((transaction.amount * pow(10, transaction.decimals * -1))
                .toStringAsFixed(transaction.decimals))
          ],
        ),
      ),
    );
  }

  IconData get iconData {
    switch (transaction.type) {
      case TransactionEventType.UNKNOWN:
        return FeatherIcons.xCircle;
      case TransactionEventType.SEND:
        return FeatherIcons.chevronsDown;
      case TransactionEventType.RECEIVE:
        return FeatherIcons.chevronsUp;
      case TransactionEventType.COMPOUND:
        return FeatherIcons.code;
    }
  }
}
