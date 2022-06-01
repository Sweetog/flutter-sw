import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/@core/util/sd_colors.dart';

class SdProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      backgroundColor: SdColors.swLightBlue,
      valueColor: AlwaysStoppedAnimation<Color>(SdColors.primaryForeground),
    );
  }
}
