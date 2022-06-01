import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/models/contact_model.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/services/site_service.dart';
import 'package:app/@core/ui-components/button_primary.dart';
import 'package:app/@core/ui-components/text_form_field.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/util/validator_util.dart';
import 'package:app/screens/home/home.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:app/screens/shared/scroll_behavior.dart';
import 'package:app/screens/site/inlets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

const CALIFORNIA = 'CA';

class SiteUpsert extends StatefulWidget {
  final String? _siteId;

  SiteUpsert(this._siteId);

  @override
  State<StatefulWidget> createState() => _SiteUpsertState(this._siteId);
}

class _SiteUpsertState extends State<SiteUpsert> {
  String? _siteId;
  static final _lg = Logger();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool _done = false;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  String? _siteName;
  String? _address;
  String? _zip;
  String? _contactPhone;
  String? _contactEmail;
  String? _contactName;

  _SiteUpsertState(this._siteId);

  Future<void> _getData() async {
    if (this._siteId == null) return null;
    JobModel? model = await SiteService.getSite(this._siteId!);
    _siteName = model?.name;
    _address = model?.address;
    _zip = model?.zip;
    _contactName = model?.contact?.name;
    _contactPhone = model?.contact?.phone;
    _contactEmail = model?.contact?.email;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done)
            return _buildScaffold(context);
          _done = true;
          return _buildScaffold(context);
        });
  }

  Widget _buildScaffold(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_siteId == null) {
          _showConfirmCancel(context);
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: SdAppBar(),
        body: _buildBody(context),
        bottomNavigationBar: NavBar(index: NavBarIndex.Home),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (!_done) {
      return Center(
        child: Loading(),
      );
    }

    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: _buildForm(),
            ),
            SizedBox(
              height: 15,
            ),
            ButtonPrimary(
                text: _siteId == null ? 'Create Site' : 'Update Site',
                onPressed: () async {
                  if (_validateForm(context)) {
                    var siteId = await _upsert(_siteId);
                    setState(() {
                      _siteId = siteId;
                    });
                    UIUtil.snackBar(context,
                        _siteId == null ? 'Site Created' : 'Site Updated');
                  }
                }),
            Divider(),
            SizedBox(
              height: 15,
            ),
            _siteId != null
                ? ButtonPrimary(
                    text: 'Add/Edit Inlets',
                    onPressed: () async {
                      if (_validateForm(context)) {
                        var siteId = await _upsert(_siteId);
                        _navigateSiteInlets(context, siteId);
                      }
                    })
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SdTextFormField(
              initialValue: _siteName,
              hintText: 'Site Name',
              textInputAction: TextInputAction.next,
              validator: _validateRequiredString,
              inputFormatters: [LengthLimitingTextInputFormatter(50)],
              onSaved: (String? val) {
                _siteName = val;
              }
              //validator: _validateOtherAmount,
              ),
          SdTextFormField(
            initialValue: _address,
            hintText: 'Address',
            keyboardType: TextInputType.streetAddress,
            validator: _validateRequiredString,
            inputFormatters: [LengthLimitingTextInputFormatter(75)],
            onSaved: (String? val) {
              _address = val;
            },
          ),
          SdTextFormField(
            initialValue: _zip,
            hintText: 'Zip Code',
            keyboardType: TextInputType.number,
            validator: _validateRequiredString,
            inputFormatters: [LengthLimitingTextInputFormatter(9)],
            onSaved: (String? val) {
              _zip = val;
            },
          ),
          SdTextFormField(
            initialValue: _contactName,
            hintText: 'Contact Name',
            validator: _validateRequiredString,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            onSaved: (String? val) {
              _contactName = val;
            },
          ),
          SdTextFormField(
            initialValue: _contactPhone,
            hintText: 'Contact Phone',
            keyboardType: TextInputType.phone,
            validator: _validateRequiredString,
            textInputAction: TextInputAction.done,
            inputFormatters: [LengthLimitingTextInputFormatter(15)],
            onSaved: (String? val) {
              _contactPhone = val;
            },
          ),
          SdTextFormField(
            initialValue: _contactEmail,
            hintText: 'Contact Email',
            textInputAction: TextInputAction.done,
            inputFormatters: [LengthLimitingTextInputFormatter(50)],
            onSaved: (String? val) {
              _contactEmail = val;
            },
          ),
        ],
      ),
    );
  }

  String? _validateRequiredString(String? value) {
    if (!ValidatorUtil.isStringNonEmpty(value)) return 'Required';
    return null;
  }

  bool _validateForm(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      _lg.w('Form Not Valid');
      //If all data are not valid then start auto validation.
      setState(() {
        _autoValidateMode = AutovalidateMode
            .onUserInteraction; // Start validating on every change.
      });
      return false;
    }

    //VALID
    _formKey.currentState?.save();
    return true;
  }

  bool _isFormDirty() {
    return _siteName != null ||
        _address != null ||
        _zip != null ||
        _contactName != null ||
        _contactPhone != null ||
        _contactEmail != null;
  }

  Future<void> _showConfirmCancel(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Are you sure you want cancel creating site?',
              style: UIUtil.getTxtStyleCaption1(),
            ),
            // content: Text(
            //   'Yes,',
            //   style: UIUtil.getTxtStyleCaption2(),
            // ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () async {
                  _navigateHome(context);
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<String> _upsert(String? siteId) async {
    var contact = ContactModel(
        name: _contactName!, phone: _contactPhone!, email: _contactEmail);

    if (siteId != null) {
      await SiteService.update(
          id: _siteId!,
          name: _siteName!,
          address: _address!,
          state: CALIFORNIA,
          zip: _zip!,
          contact: contact);
      return siteId;
    }

    var createSiteId = await SiteService.create(
        name: _siteName!,
        address: _address!,
        state: CALIFORNIA,
        zip: _zip!,
        contact: contact);

    return createSiteId!;
  }

  void _navigateSiteInlets(BuildContext context, String siteId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SiteInlets(siteId)),
    );
  }

  void _navigateHome(BuildContext context) async {
    UIUtil.navigateAsRoot(Home(), context);
  }
}
