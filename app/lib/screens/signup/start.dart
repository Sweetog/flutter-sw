import 'package:app/@core/ui-components/button_primary.dart';
import 'package:app/@core/ui-components/button_secondary.dart';
import 'package:app/screens/signup/shared/account_model.dart';
import 'package:app/screens/signup/sign-in/email.dart';
import 'package:flutter/material.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/ui-components/logo_container.dart';
import 'package:logger/logger.dart';

import 'create-account/email.dart';
import 'forgot-password.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80.0, left: 20.0, right: 20.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              LogoContainer(),
              Container(
                height: 20.0,
              ),
              ButtonPrimary(
                text: 'Create Account',
                onPressed: () {
                  _navigateCreateAccount(context);
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: ButtonSecondary(
                  text: 'Sign In',
                  onPressed: () {
                    _navigateSignInEmail(context);
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              InkWell(
                child: Text(
                  'Forgot Password',
                  style: UIUtil.getTxtStyleCaption2Underline(),
                ),
                onTap: () {
                  _navigateForgotPassword(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateForgotPassword(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ForgotPassword()),
    );
  }

  void _navigateCreateAccount(BuildContext context) async {
    var model = AccountModel();
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateAccountEmail(model: model)),
    );
  }

  void _navigateSignInEmail(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInEmail()),
    );
  }
}
