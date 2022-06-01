import 'package:flutter/material.dart';
import '../util/sd_colors.dart';
import 'button_base.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ButtonPrimary({Key? key, required this.text, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonBase(
      key: key,
      text: text,
      onPressed: onPressed,
      backgroundColor: SdColors.primaryForeground,
      borderColor: SdColors.accent,
      highlightColor: SdColors.accent,
      textColor: SdColors.white,
    );
  }
}
