import 'dart:math';

import 'package:flutter/material.dart';

/// The color palette of our app.
class Palette {
  static const primaryColor = Color(0xFF70626A);
  static const primaryDarkColor = Color(0xFFC8C8C8);
  static const primaryLightColor = Color(0XFFFFFFFF);

  static const accentColor = Color(0xFF00C3B4);

  static const activeColor = Color(0xFF70626A);
  static const inactiveColor = Color(0xFFCDC1CB);

  static const textColor = Color(0xFF000000);
  static const subtitleColor = Color(0xFFAE9DA4);
  static const hintColor = Color(0x99000000);

  static const backgroundColor = Color(0xFFf7efef);
  static const white = Color(0xFFFFFFFF);
}

MaterialColor generateMaterialColor(Color color) {
  return MaterialColor(color.value, {
    50: tintColor(color, 0.9),
    100: tintColor(color, 0.8),
    200: tintColor(color, 0.6),
    300: tintColor(color, 0.4),
    400: tintColor(color, 0.2),
    500: color,
    600: shadeColor(color, 0.1),
    700: shadeColor(color, 0.2),
    800: shadeColor(color, 0.3),
    900: shadeColor(color, 0.4),
  });
}

int tintValue(int value, double factor) =>
    max(0, min((value + ((255 - value) * factor)).round(), 255));

Color tintColor(Color color, double factor) => Color.fromRGBO(
    tintValue(color.red, factor),
    tintValue(color.green, factor),
    tintValue(color.blue, factor),
    1);

int shadeValue(int value, double factor) =>
    max(0, min(value - (value * factor).round(), 255));

Color shadeColor(Color color, double factor) => Color.fromRGBO(
    shadeValue(color.red, factor),
    shadeValue(color.green, factor),
    shadeValue(color.blue, factor),
    1);
