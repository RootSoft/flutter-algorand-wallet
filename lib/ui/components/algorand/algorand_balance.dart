import 'package:flutter/cupertino.dart';
import 'package:flutter_algorand_wallet/theme/themes.dart';
import 'package:flutter_algorand_wallet/ui/components/spacing.dart';

class AlgorandBalance extends StatelessWidget {
  final String balance;

  AlgorandBalance({required this.balance});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 16,
          height: 16,
          child: Image.asset("assets/images/algo_icon.png"),
        ),
        HorizontalSpacing(of: paddingSizeNormal),
        Text(
          this.balance,
          style: Theme.of(context).textTheme.headline5?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
