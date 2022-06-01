import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/ui-components/button_primary.dart';
import 'package:app/@core/ui-components/logo_container.dart';
import 'package:app/@core/ui-components/text_form_field.dart';
import 'package:app/@core/util/auth_util.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/util/validator_util.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/scroll_behavior.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: SdAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40.0, left: 35.0, right: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:
                CrossAxisAlignment.stretch, //probably not needed
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              _buildMemberNumForm(context),
              SizedBox(
                height: 15,
              ),
              ButtonPrimary(
                text: 'Reset Password',
                onPressed: () {
                  _validateForm();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberNumForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.disabled,
      // autovalidate: _autoValidate,
      child: _buildTxField(context),
    );
  }

  SdTextFormField _buildTxField(BuildContext context) {
    return SdTextFormField(
      hintText: 'Enter Email Address',
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (String val) {
        //onFieldSubmitted used to capture textInputAction
        if (!ValidatorUtil.isValidEmail(val)) {
          return;
        }
        _sendForgotPasswordEmail(context, val);
      },
      onSaved: (String? val) {
        _sendForgotPasswordEmail(context, val!);
      },
    );
  }

  String? _validateEmail(String? value) {
    if (value == null) return value;

    if (!ValidatorUtil.isValidEmail(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  void _sendForgotPasswordEmail(BuildContext context, String email) async {
    FocusScope.of(context).unfocus();
    UIUtil.snackBar(context, 'Sending Password Reset Email', seconds: 10);
    await AuthUtil.sendPasswordResetEmail(email);
    UIUtil.snackBar(context, 'Email Sent', seconds: 5);
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
