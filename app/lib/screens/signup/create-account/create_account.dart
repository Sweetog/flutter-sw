import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/ui-components/button_primary.dart';
import 'package:app/@core/ui-components/progress_indicator.dart';
import 'package:app/@core/util/auth_util.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/signup/shared/account_model.dart';
import 'package:app/screens/signup/shared/account_scaffold.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../start.dart';



class CreateAccountCreate extends StatefulWidget {
  final AccountModel model;

  CreateAccountCreate({required this.model});

  @override
  State<StatefulWidget> createState() =>
      _CreateAccountCreateState(model: model);
}

class _CreateAccountCreateState extends State<CreateAccountCreate> {
  final AccountModel model;

  _CreateAccountCreateState({required this.model});

  AuthResult? _authResult;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _createAccount(model),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildBody();
          }

          _authResult = snapshot.data;
          return _buildBody();
        });
  }

  Widget _buildBody() {
    return Container(
      child: WillPopScope(
        onWillPop: () async => false,
        child: _buildAccountScaffold(),
      ),
    );
  }

  Widget _buildAccountScaffold() {

    return AccountScaffold(
      automaticallyImplyLeading: true,
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 38.0,
              color: SdColors.primaryForeground,
            ),
            Text('Creating Account...', style: UIUtil.getTxtStyleTitle1()),
            Center(
              child: _buildProgressIndicator(_authResult),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: _buildStatusTxt(_authResult),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: _buildBtn(_authResult),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTxt(AuthResult? result) {
    if (result == null) {
      return Container();
    }

    var txt;

    switch (result) {
      case AuthResult.CreationError:
      case AuthResult.Unknown:
      case AuthResult.UserDbRecordCreationError:
        txt = 'Account Creation Failed, Please Try Again';
        break;
      case AuthResult.Exists:
        txt = 'Your Account Already Exists';
        break;
      case AuthResult.Created:
        txt = 'Account Created!';
        break;
      case AuthResult.TooManyAttempts:
      case AuthResult.InvalidUsernameOrPassword:
      case AuthResult.SignInSuccess:
      case AuthResult.NoProviderPassword:
      case AuthResult.DoesNotExist:
        // Nothing to do
        return Container();
        break;
    }

    return Text(
      txt,
      style: UIUtil.getTxtStyleCaption1(),
    );
  }

  Widget _buildBtn(AuthResult? result) {
    if (result == null) {
      return Container();
    }

    var btnText;
    var onPressed;

    switch (result) {
      case AuthResult.CreationError:
      case AuthResult.Unknown:
      case AuthResult.UserDbRecordCreationError:
        btnText = 'Try Again';
        onPressed = () {
          _redraw();
        };
        break;
      case AuthResult.Exists:
        btnText = 'Login To Your Account';
        onPressed = () {
          _navigateStart(context);
        };
        break;
      case AuthResult.Created:
        btnText = 'Continue';
        onPressed = () {
          _navigateHome(context);
        };
        break;
      case AuthResult.TooManyAttempts:
      case AuthResult.InvalidUsernameOrPassword:
      case AuthResult.SignInSuccess:
      case AuthResult.NoProviderPassword:
      case AuthResult.DoesNotExist:
        // Nothing to do
        return Container();
        break;
    }

    return ButtonPrimary(
      text: btnText,
      onPressed: onPressed,
    );
  }

  Future<AuthResult> _createAccount(AccountModel model) async {
    return await AuthUtil.createAccount(model.profileName!, model.email!,
        model.password!, 'user');
  }

  Widget _buildProgressIndicator(AuthResult? result) {
    if (result == null) {
      return Loading();
    }

    return Container();
  }

  void _redraw() {
    setState(() {
      _authResult = null;
    });
  }

  void _navigateHome(BuildContext context) async {
    UIUtil.navigateAsRoot(Home(), context);
  }

  void _navigateStart(BuildContext context) async {
    UIUtil.navigateAsRoot(Start(), context);
  }
}
