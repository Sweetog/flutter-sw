import 'package:app/@core/ui-components/text_form_field.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/util/validator_util.dart';
import 'package:app/screens/signup/shared/account_form.dart';
import 'package:app/screens/signup/shared/account_model.dart';
import 'package:app/screens/signup/sign-in/sign-in.dart';
import 'package:flutter/material.dart';

class SignInPassword extends StatelessWidget {
  SignInPassword({required this.model});

  final AccountModel model;

  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      icon: Icons.lock,
      titleText: 'Enter your password',
      instructionText: '',
      textFormField: _buildTxField(context),
    );
  }

  SdTextFormField _buildTxField(context) {
    return SdTextFormField(
      validator: _validatePassword,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidPassword(val)) {
          return;
        }
        _navigateSignIn(context, val);
      },
      onSaved: (String? val) {
        _navigateSignIn(context, val!);
      },
    );
  }

  String? _validatePassword(String? value) {
    if (value == null) return null;

    if (!ValidatorUtil.isValidPassword(value))
      return 'At least: 6 chars, 1 letter, 1 number';
    else
      return null;
  }

  void _navigateSignIn(BuildContext context, String value) async {
    model.password = value;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignIn(
          model: model,
        ),
      ),
    );
  }
}
