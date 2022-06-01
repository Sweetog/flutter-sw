class StringUtil {
  static String? removeWhiteSpace(String? s) {
    if (s == null || s.isEmpty) {
      return s;
    }
    return s.replaceAll(RegExp(r"\s\b|\b\s"), "");
  }

  static String? onlyNumbers(String? s) {
    if (s == null || s.isEmpty) {
      return s;
    }
    RegExp regExp = new RegExp(r"[^0-9]");
    return s.replaceAll(regExp, '');
  }

  static bool isHttp(String path) {
    RegExp regExp = RegExp(
      r"^https?",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(path);
  }
}
