class ValidatorUtil {
  static bool isValidEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool isValidPassword(String value) {
    String pattern = r'^(?=.*\d)(?=.*[a-z])[0-9a-zA-Z!@#$%^&*?]{6,}$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value);
  }

  static bool isStringNonEmpty(String? value) {
    return (value != null && value.isNotEmpty);
  }

  static bool isValidNumber(String value) {
    String pattern = r'^\d+$';
    RegExp regex = new RegExp(pattern);
    return regex.hasMatch(value);
  }
}
