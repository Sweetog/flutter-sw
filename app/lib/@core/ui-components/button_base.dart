import 'package:app/@core/util/ui_util.dart';
import 'package:flutter/material.dart';

class ButtonBase extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color borderColor;
  final Color? textColor;
  final Color? highlightColor;

  const ButtonBase(
      {Key? key,
      required this.text,
      this.onPressed,
      this.backgroundColor,
      required this.borderColor,
      this.textColor,
      this.highlightColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 45.0,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 2.0),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(UIUtil.defaultBorderRadius),
      ),
      child: RawMaterialButton(
        fillColor: backgroundColor,
        elevation: 0,
        splashColor: Colors.transparent,
        highlightColor: highlightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIUtil.defaultBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Lalezar',
                fontWeight: FontWeight.w400,
                fontSize: 22.0,
                color: this.textColor),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
