import 'package:flutter_algorand_wallet/theme/themes.dart';

class WalletCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onTapped;

  WalletCard({
    required this.title,
    required this.subtitle,
    required this.onTapped,
    this.textColor = Palette.textColor,
    this.backgroundColor = const Color(0xFFfff9f9),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: onTapped,
        child: Container(
          padding: EdgeInsets.all(paddingSizeNormal),
          width: double.infinity,
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    ?.copyWith(color: textColor),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.subtitle1?.copyWith(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
