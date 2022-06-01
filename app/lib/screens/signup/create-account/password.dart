import 'package:app/@core/ui-components/text_form_field.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/util/validator_util.dart';
import 'package:app/screens/signup/shared/account_form.dart';
import 'package:app/screens/signup/shared/account_model.dart';
import 'package:flutter/material.dart';

import 'create_account.dart';

class CreateAccountPassword extends StatelessWidget {
  final AccountModel model;
  CreateAccountPassword({required this.model});

  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      icon: Icons.lock,
      titleText: 'Enter your password',
      instructionText: 'You can change this later if you need.',
      textFormField: _buildTxField(context),
    );
  }

  SdTextFormField _buildTxField(context) {
    return SdTextFormField(
      keyboardType: TextInputType.text,
      validator: validatePassword,
      textInputAction: TextInputAction.done,
      obscureText: true,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidPassword(val)) {
          return;
        }
        navigateCreateAccount(context, val);
      },
      onSaved: (String? val) {
        navigateCreateAccount(context, val!);
      },
    );
  }

  String? validatePassword(String? value) {
    if (value == null) return null;

    if (!ValidatorUtil.isValidPassword(value))
      return 'Minimum 6 chars,1 number';
    else
      return null;
  }

  void navigateCreateAccount(BuildContext context, String value) async {
    model.password = value;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountCreate(
          model: model,
        ),
      ),
    );
  }
}
