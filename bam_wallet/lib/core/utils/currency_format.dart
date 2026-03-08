import 'package:intl/intl.dart';

class CurrencyFormat {
  
  static final NumberFormat _gtqFormatGrouped = NumberFormat('#,##0.00', 'en_US');

  static String formatGtq(double amount) {
    return 'Q ${_gtqFormatGrouped.format(amount)}';
  }

  static String formatGtqFromString(String amountStr) {
    if (amountStr.isEmpty) return formatGtq(0);
    final cleaned = amountStr.replaceAll(RegExp(r'[^0-9.]'), '');
    final value = double.tryParse(cleaned);
    return formatGtq(value ?? 0);
  }
}