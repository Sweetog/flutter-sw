import 'package:app/@core/ui-components/text_form_field.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/util/validator_util.dart';
import 'package:app/screens/signup/create-account/profile.dart';
import 'package:app/screens/signup/shared/account_form.dart';
import 'package:app/screens/signup/shared/account_model.dart';
import 'package:flutter/material.dart';

class CreateAccountEmail extends StatelessWidget {
  final AccountModel model;
  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  CreateAccountEmail({required this.model});

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      icon: Icons.email,
      titleText: 'What is your email address?',
      instructionText:
          'You will login with this email address, which also allows us to keep in touch with you.',
      textFormField: _buildTxField(context),
    );
  }

  SdTextFormField _buildTxField(context) {
    return SdTextFormField(
      hintText: 'Enter Email',
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidEmail(val)) {
          return;
        }
        _navigateProfileName(context, val);
      },
      onSaved: (String? val) {
        _navigateProfileName(context, val!);
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

  void _navigateProfileName(BuildContext context, String value) async {
    model.email = value;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountProfile(
          model: model,
        ),
      ),
    );
  }
}
