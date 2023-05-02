class AppFormatterHelper {
  AppFormatterHelper._();
  // static final _currencyFormat = NumberFormat.currency(
  //   locale: 'pt_BR',
  //   symbol: r'R$',
  // );
  static String formatCurrency(double value) {
    return 'R\$ ${formatValue(value)}';
  }

  static String formatValue(double value) {
    return value.toStringAsFixed(2);
  }
}
