class FormatUtil {
  static String? formatDateDefault(DateTime? date) {
    return "${date?.month.toString().padLeft(2, '0')}-${date?.day.toString().padLeft(2, '0')}-${date?.year.toString()}";
  }

  static String formatCurrencyInt(int val) {
    return FormatUtil.formatCurrency(1.0 * val);
  }

  static String formatCurrency(double val) {
    return '\$${_format(val)}';
  }

  static String formatCredit(double val) {
    return '${_format(val)}';
  }

  static String _format(double val) {
    double n = val / 100;
    String strVal = (n.round()).toString();
    RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return strVal.replaceAllMapped(reg, (Match match) => '${match[1]},');
  }
}
