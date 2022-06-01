import 'dart:io';
import 'dart:async';
import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/models/inlet_model.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/models/location_model.dart';
import 'package:app/@core/models/material_model.dart';
import 'package:app/@core/models/service_model.dart';
import 'package:app/@core/services/constant_service.dart';
import 'package:app/@core/services/site_service.dart';
import 'package:app/@core/ui-components/button_primary.dart';
import 'package:app/@core/ui-components/text_form_field.dart';
import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/util/storage_util.dart';
import 'package:app/@core/util/string_util.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/util/validator_util.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:app/screens/shared/scroll_behavior.dart';
import 'package:app/screens/site/image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:geolocator/geolocator.dart';

final TextStyle errorStyle = UIUtil.createTxtStyle(18, color: Colors.red);

/// The _site!.inlets![editIndex!] assumption:
/// alot of assumptions made here but the integrity is good:
/// - the site has been retrieved in initData
/// - the site has inlets because argument editIndex is not null
class InletSiteUpsert extends StatefulWidget {
  final String _siteId;
  final int? editIndex;

  InletSiteUpsert(this._siteId, {this.editIndex});

  @override
  _InletSiteUpsertState createState() =>
      _InletSiteUpsertState(this._siteId, editIndex: this.editIndex);
}

class _InletSiteUpsertState extends State<InletSiteUpsert> {
  static final _lg = new Logger();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final String _siteId;
  int? editIndex;
  List<CameraDescription>? _cameras;
  List<String>? _inletTypes;
  String? _inletType;
  XFile? _beforeImg;
  XFile? _afterImg;
  Position? _currentPosition;
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  bool _initComplete = false;
  JobModel? _site;
  bool _updateLocation = false;
  bool? _serviceInspect = true;
  bool? _serviceCleaned = false;
  bool? _serviceRepairs = false;
  bool? _serviceMedia = false;
  TextEditingController _materialConstructionController =
      TextEditingController();
  TextEditingController _materialSiltSandController = TextEditingController();
  TextEditingController _materialGravelController = TextEditingController();
  TextEditingController _materialOrganicsController = TextEditingController();
  TextEditingController _materialTrashController = TextEditingController();
  TextEditingController _materialOtherController = TextEditingController();
  TextEditingController _volumeUsedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initData();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   if (editIndex != null) {
    //     UIUtil.snackBar(
    //         context, 'Edit Mode: Tap The Map Icon To Update Inlet Location', seconds: 2);
    //   }
    // });
  }

  @override
  void dispose() {
    _materialConstructionController.dispose();
    _materialSiltSandController.dispose();
    _materialGravelController.dispose();
    _materialOrganicsController.dispose();
    _materialTrashController.dispose();
    _materialOtherController.dispose();
    _volumeUsedController.dispose();
    super.dispose();
  }

  @override
  _InletSiteUpsertState(this._siteId, {this.editIndex});

  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: SdAppBar(),
      body: _buildBody(context),
      bottomNavigationBar: NavBar(index: NavBarIndex.Jobs),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (!_initComplete) {
      return Loading();
    }

    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            Text('Images', style: UIUtil.getTxtStyleTitle3()),
            Divider(),
            _imgRow(
              _getBeforeImgPath(),
              _getAfterImgPath(),
            ),
            _buildForm(),
            SizedBox(height: 40),
            Text('Geo', style: UIUtil.getTxtStyleTitle3()),
            Divider(),
            _buildLocation(),
            SizedBox(height: 8),
            ButtonPrimary(
                text: editIndex != null ? 'Update' : 'Add',
                onPressed: () => _validateForm(context)),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  String? _getBeforeImgPath() {
    //if edit mode and no new/replacement img
    if (_beforeImg == null && editIndex != null) {
      return _site!.inlets![editIndex!].beforeImgUrl;
    }
    return _beforeImg?.path;
  }

  String? _getAfterImgPath() {
    //if edit mode and no new/replacement img
    if (_afterImg == null && editIndex != null) {
      return _site!.inlets![editIndex!].afterImgUrl;
    }
    return _afterImg?.path;
  }

  void _navigateImage(BuildContext context, isBeforeImg) async {
    InletImage widget = InletImage(camera: _cameras!.first);
    MaterialPageRoute<bool> imgRoute =
        MaterialPageRoute(builder: (context) => widget);

    imgRoute.popped.then((value) {
      if (widget.image == null) return;

      setState(() {
        if (isBeforeImg) {
          _beforeImg = widget.image;
        } else {
          _afterImg = widget.image;
        }
      });
    });

    await Navigator.push(context, imgRoute);
  }

  Widget _buildLocation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            _showConfirmLocationUpdateDialog();
          },
          child: Icon(
            Icons.location_on,
            size: 40.0,
            color: SdColors.primaryForeground,
          ),
        ),
        Text('Latitude: ${_truncate(_currentPosition!.latitude.toString())}',
            style: UIUtil.getTxtStyleCaption2()),
        SizedBox(width: 15),
        Text('Longitude: ${_truncate(_currentPosition!.longitude.toString())}',
            style: UIUtil.getTxtStyleCaption2()),
        SizedBox(width: 15),
      ],
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      autovalidateMode: _autoValidateMode,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 40),
            Text('Inlet Type', style: UIUtil.getTxtStyleTitle3()),
            Divider(),
            DropdownButtonFormField<String>(
              value: _inletType,
              decoration: InputDecoration(
                  labelStyle: UIUtil.getTxtStyleCaption2(),
                  errorStyle: errorStyle),
              isDense: true,
              iconSize: 25,
              validator: _validateRequiredString,
              onSaved: (String? val) {
                _inletType = val;
              },
              items: _inletTypes!.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: UIUtil.getDefaultTxtFieldStyle(),
                  ),
                );
              }).toList(),
              onChanged: (_) {},
            ),
            SizedBox(height: 40),
            Text('Services', style: UIUtil.getTxtStyleTitle3()),
            Divider(),
            _services(),
            SizedBox(height: 40),
            Text('Materials %', style: UIUtil.getTxtStyleTitle3()),
            Divider(),
            _materials(),
            SizedBox(height: 40),
            Divider(),
            Text('Volume Used %', style: UIUtil.getTxtStyleTitle3()),
            Divider(),
            SdTextFormField(
              hintText: ' Enter Volume Used %',
              controller: _volumeUsedController,
              keyboardType: TextInputType.number,
              validator: _validateNumber,
              textInputAction: TextInputAction.done,
              // onSaved: (String? val) {
              //   if (val == null) val = '';
              //   _volumeUsedController.text = '${int.tryParse(val)}';
              // },
            ),
          ],
        ),
      ),
    );
  }

  Widget _imgRow(String? beforeImgPath, String? afterImgPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: _img(
                'Before Image',
                beforeImgPath,
                () => _navigateImage(context, true),
                () => setState(() => this._beforeImg = null))),
        SizedBox(
          height: 20,
          width: 20,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: _img(
                'After Image',
                afterImgPath,
                () => _navigateImage(context, false),
                () => setState(() => this._afterImg = null))),
      ],
    );
  }

  Widget _materials() {
    var spacerWidth = 40.0;
    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: SdTextFormField(
                hintText: 'Construction %',
                controller: _materialConstructionController,
                keyboardType: TextInputType.number,
                validator: _validateNumber,
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(width: spacerWidth),
            Flexible(
              child: SdTextFormField(
                hintText: 'Silt/Sand %',
                controller: _materialSiltSandController,
                keyboardType: TextInputType.number,
                validator: _validateNumber,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: SdTextFormField(
                  hintText: 'Gravel %',
                  controller: _materialGravelController,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  textInputAction: TextInputAction.done),
            ),
            SizedBox(width: spacerWidth),
            Flexible(
              child: SdTextFormField(
                  hintText: 'Organics %',
                  controller: _materialOrganicsController,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  textInputAction: TextInputAction.done),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: SdTextFormField(
                  hintText: 'Trash %',
                  controller: _materialTrashController,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  textInputAction: TextInputAction.done),
            ),
            SizedBox(width: spacerWidth),
            Flexible(
              child: SdTextFormField(
                  hintText: 'Other %',
                  controller: _materialOtherController,
                  keyboardType: TextInputType.number,
                  validator: _validateNumber,
                  textInputAction: TextInputAction.done),
            )
          ],
        ),
      ],
    );
  }

  Widget _services() {
    return Column(
      children: [
        CheckboxListTile(
          title: Text('Inspect', style: UIUtil.getTxtStyleCaption2()),
          secondary: Icon(Icons.search),
          controlAffinity: ListTileControlAffinity.leading,
          value: _serviceInspect ?? false,
          onChanged: (bool? value) {
            setState(() {
              _serviceInspect = value;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Cleaned', style: UIUtil.getTxtStyleCaption2()),
          secondary: Icon(Icons.cleaning_services),
          controlAffinity: ListTileControlAffinity.leading,
          value: _serviceCleaned ?? false,
          onChanged: (bool? value) {
            setState(() {
              _serviceCleaned = value;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Repairs', style: UIUtil.getTxtStyleCaption2()),
          secondary: Icon(Icons.home_repair_service),
          controlAffinity: ListTileControlAffinity.leading,
          value: _serviceRepairs ?? false,
          onChanged: (bool? value) {
            setState(() {
              _serviceRepairs = value;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Media', style: UIUtil.getTxtStyleCaption2()),
          secondary: Icon(Icons.restore_from_trash_outlined),
          controlAffinity: ListTileControlAffinity.leading,
          value: _serviceMedia ?? false,
          onChanged: (bool? value) {
            setState(() {
              _serviceMedia = value;
            });
          },
        ),
      ],
    );
  }

  Widget _img(String text, String? imagePath, VoidCallback? onTap,
      Function onTapDelete) {
    const IMAGE_SIZE = 100.0;
    var isHttp = imagePath == null ? false : StringUtil.isHttp(imagePath);

    var imageWidget = imagePath != null
        ? isHttp
            ? Image.network(imagePath,
                width: IMAGE_SIZE, height: IMAGE_SIZE, fit: BoxFit.fitWidth)
            : Image.file(
                File(imagePath),
                width: IMAGE_SIZE,
                height: IMAGE_SIZE,
                fit: BoxFit.fitWidth,
              )
        : Icon(Icons.image, size: IMAGE_SIZE);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: onTap,
                child: imageWidget,
              ),
            ),
            imagePath != null
                ? Positioned(
                    right: -5.0,
                    top: -5.0,
                    child: GestureDetector(
                      onTap: () => _showConfirmDeleteImg(onTapDelete),
                      child: Icon(
                        Icons.delete_forever_sharp,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
        Text(text, style: UIUtil.getDefaultTxtFieldStyle())
      ],
    );
  }

  Future<void> _initData() async {
    try {
      _cameras = await availableCameras();
      _currentPosition = await _getCurrentLocation();
      _inletTypes = await ConstantService.inletTypes();

      if (editIndex != null) {
        _site = await SiteService.getSite(_siteId);
        var editInlet = _site!.inlets![editIndex!];
        _inletType = editInlet.type;
        _serviceInspect = editInlet.service?.inspect;
        _serviceCleaned = editInlet.service?.cleaned;
        _serviceRepairs = editInlet.service?.repairs;
        _serviceMedia = editInlet.service?.media;
        _materialConstructionController.text =
            '${editInlet.material?.construction ?? ''}';
        _materialGravelController.text = '${editInlet.material?.gravel ?? ''}';
        _materialOrganicsController.text =
            '${editInlet.material?.organics ?? ''}';
        _materialOtherController.text = '${editInlet.material?.other ?? ''}';
        _materialSiltSandController.text =
            '${editInlet.material?.siltSand ?? ''}';
        _materialTrashController.text = '${editInlet.material?.trash ?? ''}';
        _volumeUsedController.text = '${editInlet.volumeUsed ?? ''}';
        //image and position updates handled by other means/other places in the code
      }

      _initComplete = true;
      setState(() {});
    } catch (e) {
      _lg.d('_initData exception');
      _lg.d(e);
    }
  }

  void _showConfirmDeleteImg(Function onTapDelete) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Confirm Image Delete',
              style: UIUtil.getTxtStyleCaption1(),
            ),
            content: Text(
              'Yes, Delete the Image',
              style: UIUtil.getTxtStyleCaption2(),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  onTapDelete();
                  Navigator.pop(context); //pop confirm dialog
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

  String? _validateNumber(String? val) {
    if (!ValidatorUtil.isStringNonEmpty(val)) return null;

    if (!ValidatorUtil.isValidNumber(val!)) return 'Invalid Number';

    return null;
  }

  void _validateForm(BuildContext context) {
    if (editIndex == null && _beforeImg == null) {
      UIUtil.snackBar(context, 'Please add a Before Image of the Inlet.');
      return;
    }

    var volumeUsed = int.tryParse(_volumeUsedController.text);

    if (volumeUsed != null) {
      var materialConstruction =
          int.tryParse(_materialConstructionController.text) ?? 0;
      var materialGravel = int.tryParse(_materialGravelController.text) ?? 0;
      var materialOrganics =
          int.tryParse(_materialOrganicsController.text) ?? 0;
      var materialOther = int.tryParse(_materialOtherController.text) ?? 0;
      var materialSiltSand =
          int.tryParse(_materialSiltSandController.text) ?? 0;
      var materialTrash = int.tryParse(_materialTrashController.text) ?? 0;
      var materialTotals = materialConstruction +
          materialGravel +
          materialOrganics +
          materialOther +
          materialSiltSand +
          materialTrash;

      if (materialTotals != volumeUsed) {
        //If all data are not valid then start auto validation.
        setState(() {
          _autoValidateMode = AutovalidateMode
              .onUserInteraction; // Start validating on every change.
        });
        UIUtil.snackBar(context,
            'ERROR: Materials %: $materialTotals not equal Volume Used %: $volumeUsed.');
        return;
      }
    }

    if (!_formKey.currentState!.validate()) {
      _lg.w('Form Not Valid');
      UIUtil.snackBar(context, 'Please add all required values.');
      //If all data are not valid then start auto validation.
      setState(() {
        _autoValidateMode = AutovalidateMode
            .onUserInteraction; // Start validating on every change.
      });
      return;
    }

    //VALID
    _formKey.currentState!.save();
    _saveAndPop();
  }

  _saveAndPop() async {
    UIUtil.snackBar(context, 'Saving Inlet.');

    if (editIndex != null) {
      await _updateInlet();
    } else {
      await _createInlet();
    }

    Navigator.of(context).pop();
    UIUtil.snackBarClose();
  }

  Future<void> _createInlet() async {
    String beforeImgUrl = await StorageUtil.uploadInlet(
        File(_beforeImg!.path), 'before-$_siteId-${_beforeImg?.name}');

    String? afterImgUrl;
    if (_afterImg != null)
      afterImgUrl = await StorageUtil.uploadInlet(
          File(_afterImg!.path), 'after-$_siteId-${_afterImg!.name}');

    var model = _instantiateInletModel(beforeImgUrl, afterImgUrl,
        _currentPosition!.latitude, _currentPosition!.longitude);
    await SiteService.createInlet(siteId: _siteId, model: model);
  }

  Future<void> _updateInlet() async {
    InletModel editModel = _site!.inlets![editIndex!];
    String beforeImgUrl;
    String? afterImgUrl;

    if (_beforeImg == null) {
      beforeImgUrl = editModel.beforeImgUrl;
    } else {
      beforeImgUrl = await StorageUtil.uploadInlet(
          File(_beforeImg!.path), 'before-$_siteId-${_beforeImg?.name}');
    }

    if (_afterImg == null) {
      afterImgUrl = editModel.afterImgUrl;
    } else {
      afterImgUrl = await StorageUtil.uploadInlet(
          File(_afterImg!.path), 'before-$_siteId-${_afterImg?.name}');
    }

    double latitude = editModel.location.latitude;
    double longitude = editModel.location.longitude;

    if (_updateLocation) {
      latitude = _currentPosition!.latitude;
      longitude = _currentPosition!.longitude;
      _updateLocation = false;
    }

    var model =
        _instantiateInletModel(beforeImgUrl, afterImgUrl, latitude, longitude);
    await SiteService.updateInlet(
        siteId: _siteId, model: model, inletIndex: editIndex!);
  }

  InletModel _instantiateInletModel(String beforeImgUrl, String? afterImgUrl,
      double latitude, double longitude) {
    return InletModel(
        beforeImgUrl: beforeImgUrl,
        afterImgUrl: afterImgUrl,
        type: _inletType!,
        location: LocationModel(
          latitude,
          longitude,
        ),
        service: ServiceModel(
            cleaned: _serviceCleaned,
            inspect: _serviceInspect,
            media: _serviceMedia,
            repairs: _serviceRepairs),
        material: MaterialModel(
            construction: int.tryParse(_materialConstructionController.text),
            gravel: int.tryParse(_materialGravelController.text),
            organics: int.tryParse(_materialOrganicsController.text),
            other: int.tryParse(_materialOtherController.text),
            siltSand: int.tryParse(_materialSiltSandController.text),
            trash: int.tryParse(_materialTrashController.text)),
        volumeUsed: int.tryParse(_volumeUsedController.text));
  }

  String? _validateRequiredString(String? value) {
    if (!ValidatorUtil.isStringNonEmpty(value)) return 'Required';

    return null;
  }

  String _truncate(String value) {
    return value.replaceRange(7, value.length, '...');
  }

  Future<Position> _getCurrentLocation() {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        forceAndroidLocationManager: true);
  }

  Future<void> _showConfirmLocationUpdateDialog() async {
    if (editIndex == null) {
      _currentPosition = await _getCurrentLocation();
      UIUtil.snackBar(context, 'Inlet Location Updated');
      Navigator.pop(context); //pop confirm dialog
    }

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Are you sure want to update the location of the inlet? (Your current position is used)',
              style: UIUtil.getTxtStyleCaption1(),
            ),
            content: Text(
              'Yes, Update Inlet Location',
              style: UIUtil.getTxtStyleCaption2(),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () async {
                  _currentPosition = await _getCurrentLocation();
                  _updateLocation = true;
                  UIUtil.snackBar(context, 'Inlet Location Updated');
                  Navigator.pop(context); //pop confirm dialog
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
}
