import 'dart:math';

class CryptoUtils {
  static String format(int amount, int decimals) {
    return (amount / pow(10, decimals)).toStringAsFixed(2);
  }
}
