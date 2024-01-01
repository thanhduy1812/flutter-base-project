import 'package:intl/intl.dart';

extension GtdDouble on double {
  String toCurrency({String? lang}) {
    return '${NumberFormat.decimalPattern().format(this)} đ';
  }

  String toCurrencyWithPrefix({String? lang}) {
    return this == 0 ? toCurrency() : '${this > 0 ? "+" : "-"}${NumberFormat.decimalPattern().format(this)} đ';
  }
}

extension GtdInt on int {
  String toCurrency({String? lang}) {
    return '${NumberFormat.decimalPattern().format(this)} đ';
  }
}
