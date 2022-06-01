import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/ui-components/button_primary.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_scaffold.dart';

class AccountForm extends StatefulWidget {
  AccountForm({
    this.textFormField,
    required this.titleText,
    required this.instructionText,
    required this.icon,
    this.hintText,
  });

  final TextFormField? textFormField;
  final String titleText;
  final String instructionText;
  final IconData icon;
  final String? hintText;

  @override
  State<StatefulWidget> createState() => _CreateAccountFormState(
        textFormField: textFormField,
        titleText: titleText,
        instructionText: instructionText,
        icon: icon,
        hintText: hintText
      );
}

class _CreateAccountFormState extends State {
  _CreateAccountFormState({
    this.textFormField,
    required this.titleText,
    required this.instructionText,
    required this.icon,
    this.hintText
  });

  final TextFormField? textFormField;
  final String titleText;
  final String instructionText;
  final IconData icon;
  final String? hintText;

  //  _formKey and _autoValidate
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return AccountScaffold(
      child: Container(
        margin: EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: formUI(),
        ),
      ),
    );
  }

  Widget formUI() {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          size: 38.0,
          color: SdColors.primaryForeground,
        ),
        Text(this.titleText, style: UIUtil.getTxtStyleTitle1()),
        Padding(
          padding:
              EdgeInsets.only(top: 8.0, left: 35.0, right: 35.0, bottom: 15.0),
          child: Text(this.instructionText,
              style: UIUtil.getListTileSubtitileStyle()),
        ),
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0),
          child: textFormField,
        ),
        SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: ButtonPrimary(
            text: 'Continue',
            onPressed: () {
              _handleContinuePress();
            },
          ),
        ),
      ],
    );
  }

  void _handleContinuePress() {
    _validateForm();
  }

  void _validateForm() {
    if (_formKey.currentState!.validate()) {
      //    If all data are correct then save data to out variables
      _formKey.currentState!.save();
    } else {
      //    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
