import 'package:app/@core/ui-components/button_primary.dart';
import 'package:app/@core/ui-components/button_secondary.dart';
import 'package:app/@core/util/auth_util.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/signup/start.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class NotAuthorized extends StatelessWidget {
  const NotAuthorized({Key? key}) : super(key: key);
  static final _lg = new Logger();

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: SdAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
      SizedBox(
        height: 100,
      ),
      Text('You Are Not Authorized', style: UIUtil.getTxtStyleError1()),
      Text('Contact Your Administrator', style: UIUtil.getTxtStyleError1()),
      SizedBox(
        height: 10,
      ),
      ButtonPrimary(
          text: 'Try Again',
          onPressed: () async {
            _navigateHome(context);
          }),
      SizedBox(
        height: 10,
      ),
      ButtonSecondary(
          text: 'Signout/Leave',
          onPressed: () {
            AuthUtil.signOut();
            _navigateStart(context);
          }),
    ]));
  }

  void _navigateStart(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Start()),
    );
  }

  void _navigateHome(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }
}
