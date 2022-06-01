import 'package:app/@core/ui-components/text_form_field.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/util/validator_util.dart';
import 'package:app/screens/signup/shared/account_form.dart';
import 'package:app/screens/signup/shared/account_model.dart';
import 'package:app/screens/signup/sign-in/password.dart';
import 'package:flutter/material.dart';

class SignInEmail extends StatelessWidget {
  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      icon: Icons.email,
      titleText: 'Sign In',
      instructionText:
          'Use the Email Address you provided when you created your account.',
      textFormField: _buildTxField(context),
    );
  }

  SdTextFormField _buildTxField(context) {
    return SdTextFormField(
      validator: _validateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidEmail(val)) {
          return;
        }
        _navigatePassword(context, val);
      },
      onSaved: (String? val) {
        _navigatePassword(context, val!);
      },
    );
  }

  String? _validateEmail(String? value) {
    if (value == null) return null;

    if (!ValidatorUtil.isValidEmail(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void _navigatePassword(BuildContext context, String value) async {
    var model = AccountModel();
    model.email = value;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignInPassword(
          model: model,
        ),
      ),
    );
  }
}
