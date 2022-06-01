import 'package:flutter/material.dart';
import '../util/sd_colors.dart';
import 'button_base.dart';

class ButtonSecondary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ButtonSecondary({Key? key, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: SdColors.accent,
      borderColor: SdColors.primaryForeground,
      highlightColor: SdColors.primaryBackground,
      textColor: SdColors.white,
    );
  }
}
