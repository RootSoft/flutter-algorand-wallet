import 'package:flutter_algorand_wallet/theme/themes.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final bool selected;
  final MaterialColor? selectedColor;
  final Color unselectedColor;
  final VoidCallback? onPressed;

  RoundedButton({
    required this.text,
    this.selected = false,
    this.selectedColor,
    this.unselectedColor = Palette.backgroundColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    MaterialColor? color = this.selectedColor;
    if (color == null) color = generateMaterialColor(Palette.accentColor);

    return OutlinedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style: TextStyle(
              color: selected ? Palette.white : Palette.textColor,
              fontWeight: FontWeight.bold),
        ),
      ),
      style: OutlinedButton.styleFrom(
        primary: color.shade700,
        backgroundColor: selected ? color.shade500 : Palette.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
