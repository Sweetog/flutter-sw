import 'package:app/@core/ui-components/text_form_field.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/signup/create-account/password.dart';
import 'package:app/screens/signup/shared/account_form.dart';
import 'package:app/screens/signup/shared/account_model.dart';
import 'package:flutter/material.dart';

const profileNameMinLength = 5;
const profileNameMaxLength = 25;

class CreateAccountProfile extends StatelessWidget {
  CreateAccountProfile({required this.model});

  final AccountModel model;

  final TextStyle textFieldStyle = UIUtil.getDefaultTxtFieldStyle();

  @override
  Widget build(BuildContext context) {
    return AccountForm(
      icon: Icons.person,
      titleText: 'Enter your Full Name',
      instructionText: 'For example: Jane Brown',
      textFormField: _buildTxField(context),
    );
  }

  SdTextFormField _buildTxField(context) {
    return SdTextFormField(
      hintText: 'Enter Full Name',
      keyboardType: TextInputType.text,
      validator: _validateProfileName,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!_isValidProfileName(val)) {
          return;
        }
        _navigatePassword(context, val);
      },
      onSaved: (String? val) {
        _navigatePassword(context, val!);
      },
    );
  }

  String? _validateProfileName(String? value) {
    if (value == null) return null;
    if (!_isValidProfileName(value))
      return 'Minimum $profileNameMinLength characters and no more than $profileNameMaxLength';
    else
      return null;
  }

  void _navigatePassword(BuildContext context, String value) async {
    model.profileName = value;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateAccountPassword(
          model: model,
        ),
      ),
    );
  }

  bool _isValidProfileName(String value) {
    return (value.length >= profileNameMinLength &&
        value.length <= profileNameMaxLength);
  }
}
