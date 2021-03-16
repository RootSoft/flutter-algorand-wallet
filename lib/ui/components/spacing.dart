import 'package:flutter_algorand_wallet/theme/themes.dart';

class VerticalSpacing extends StatelessWidget {
  final double of;

  VerticalSpacing({this.of = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: of,
    );
  }
}

class HorizontalSpacing extends StatelessWidget {
  final double of;

  HorizontalSpacing({this.of = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: of,
    );
  }
}
