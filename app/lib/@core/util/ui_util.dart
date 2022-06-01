import 'package:flutter/material.dart';
import 'sd_colors.dart';

class UIUtil {
  //dart singleton pattern
  // static final UIUtil _uiUtil = UIUtil._internal();
  // UIUtil._internal();
  // factory UIUtil() => _uiUtil;

  static const double _defaultFontSize = 22.0;
  static const double _defaultBorderRadius = 8.0;
  static const double _defaultTextFieldFontSize = 24.0;
  static const double _txtSizeTitle1 = 30.0;
  static const double _txtSizeTitle2 = 26.0;
  static const double _txtSizeTitle3 = 20.0;
  static const double _txtSizeCaption1 = 18.0;
  static const double _txtSizeCaption2 = 15.0;
  static const String _font = 'Lalezar';
  static final Color _fontColor = SdColors.swBlue;

  static double get defaultBorderRadius => _defaultBorderRadius;
  static double get txtSizeCaption1 => _txtSizeCaption1;
  static double get txtSizeCaption2 => _txtSizeCaption2;
  static double get txtSizeTitle1 => _txtSizeTitle1;
  static double get txtSizeTitle2 => _txtSizeTitle2;
  static double get txtSizeTitle3 => _txtSizeTitle3;
  static ScaffoldFeatureController<SnackBar, SnackBarClosedReason>?
      _snackbarScaffoldFeatureController;

  static TextStyle getTxtStyleError1() {
    return TextStyle(
      fontFamily: _font,
      color: SdColors.funZoneRed,
      fontSize: _txtSizeTitle1,
    );
  }

  static TextStyle createTxtStyle(double size, {Color? color}) {
    if (color == null) {
      color = _fontColor;
    }
    return TextStyle(
      fontFamily: _font,
      color: color,
      fontSize: size,
    );
  }

  static TextStyle getDefaultTxtStyle() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _defaultFontSize,
    );
  }

  static TextStyle getListTileSubtitileStyle() {
    return TextStyle(
      fontFamily: _font,
      color: SdColors.accent,
      fontSize: _txtSizeCaption2,
    );
  }

  static TextStyle getDefaultTxtFieldStyle() {
    return TextStyle(
        fontFamily: _font,
        color: _fontColor,
        fontSize: _defaultTextFieldFontSize);
  }

  static TextStyle getTxtStyleTitle1() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeTitle1,
    );
  }

  static TextStyle getTxtStyleTitle2() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeTitle2,
    );
  }

  static TextStyle getTxtStyleTitle3() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeTitle3,
    );
  }

  static TextStyle getTxtStyleCaption1() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeCaption1,
    );
  }

  static TextStyle getTxtStyleCaption1Underline() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeCaption1,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle getTxtStyleCaption2() {
    return TextStyle(
      fontFamily: _font,
      color: _fontColor,
      fontSize: _txtSizeCaption2,
    );
  }

  static TextStyle getTxtStyleSnackBar() {
    return TextStyle(
      fontFamily: _font,
      color: SdColors.funZoneGreen,
      fontSize: _txtSizeCaption2,
    );
  }

  static TextStyle getTxtStyleCaption2Underline() {
    return TextStyle(
        fontFamily: _font,
        color: _fontColor,
        fontSize: _txtSizeCaption2,
        decoration: TextDecoration.underline);
  }

  static navigateAsRoot(Widget widget, BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget), (route) => false);
  }

  static snackBar(BuildContext context, String msg, {int seconds = 5}) {
    _snackbarScaffoldFeatureController =
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  static snackBarClose() {
    if (_snackbarScaffoldFeatureController == null) return;
    _snackbarScaffoldFeatureController!.close();
  }
}
