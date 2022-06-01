import 'package:app/@core/ui-components/button_primary.dart';
import 'package:app/@core/ui-components/button_secondary.dart';
import 'package:app/@core/util/auth_util.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:app/screens/signup/start.dart';
import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildBody(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Text(
            'Confirm Logout?',
            style: UIUtil.getTxtStyleTitle3(),
          ),
          SizedBox(
            height: 10,
          ),
          ButtonPrimary(
            text: 'Logout',
            onPressed: () {
              AuthUtil.signOut();
              UIUtil.navigateAsRoot(Start(), context);
            },
          ),
          SizedBox(
            height: 10,
          ),
          ButtonSecondary(
            text: 'Cancel',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScaffold(context) {
    return Scaffold(
      appBar: SdAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: NavBar(index: 0),
    );
  }
}
