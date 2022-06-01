import 'package:flutter/material.dart';
import 'package:app/@core/util/sd_colors.dart';
import 'package:app/screens/shared/app_title.dart';

class SdAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool automaticallyImplyLeading;

  SdAppBar({this.automaticallyImplyLeading = true});
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      title: AppTitle(),
      iconTheme: IconThemeData(
        color: SdColors.white,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
