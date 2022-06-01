import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/scroll_behavior.dart';
import 'package:flutter/material.dart';

class AccountScaffold extends StatelessWidget {
  final Widget child;
  final bool automaticallyImplyLeading;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  AccountScaffold(
      {required this.child,
      this.automaticallyImplyLeading = true,
      this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: SdColors.primaryBackground,
        //resizeToAvoidBottomPadding: true,
        appBar: SdAppBar(),
        body: ScrollConfiguration(
          behavior: ScrollBehaviorHideSplash(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      child,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
