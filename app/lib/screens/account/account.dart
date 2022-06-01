import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/services/user_service.dart';
import 'package:app/@core/models/user_model.dart';
import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/util/auth_util.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/@core/util/validator_util.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:logger/logger.dart';

import 'logout.dart';

var _usernameStyle = UIUtil.createTxtStyle(23);
var _profileInfoStyle = UIUtil.createTxtStyle(16);

class Account extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  bool? _isDataRequestComplete;
  DateTime? _memberDate;
  String? _displayName;
  UserModel? _userModel;
  Logger _lg = new Logger();

  @override
  void initState() {
    super.initState();
    AuthUtil.getDisplayName().then((displayName) {
      AuthUtil.getCreatedDate().then((date) {
        setState(() {
          _isDataRequestComplete = true;
          _displayName = displayName;
          _memberDate = date;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _lg.d('Account widget');
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: SdAppBar(),
      body: Center(child: _buildBody()),
      bottomNavigationBar: NavBar(index: NavBarIndex.Account),
    );
  }

  Widget _buildBody() {
    if (_isDataRequestComplete == null) {
      return Loading();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildProfileHeaderFuture(),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            _navigateLogout(context);
          },
          child: _buildMenuItem('Logout', Icons.low_priority),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    var menuTitleStyle = UIUtil.getTxtStyleCaption1();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: SdColors.primaryBackground,
        border: Border(
          bottom: BorderSide(
            //                   <--- left side
            color: SdColors.swBlue,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(title, style: menuTitleStyle),
          Expanded(
            child: Flex(
              direction: Axis.horizontal,
            ),
          ),
          Icon(
            icon,
            size: 22.0,
            color: SdColors.primaryForeground,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeaderFuture() {
    //return _buildProfileHeader();
    return FutureBuilder(
        future: _getUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }

          _userModel = snapshot.data;
          return _buildProfileHeader();
        });
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(color: SdColors.primaryBackground),
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          _profileCircle(),
          Padding(
            padding: EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  ValidatorUtil.isStringNonEmpty(_displayName)
                      ? _displayName!
                      : '',
                  style: _usernameStyle,
                ),
                Text(
                  (_memberDate != null)
                      ? 'Account Created: ${_memberDate!.month}-${_memberDate!.day}-${_memberDate!.year}'
                      : '',
                  style: _profileInfoStyle,
                ),
                Text(
                  'Role: ${_userModel!.role}',
                  style: _profileInfoStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileCircle() {
    var letterStyle =
        UIUtil.createTxtStyle(32.0, color: SdColors.verdantGoldBlack);
    return RawMaterialButton(
      onPressed: () {
        print('account profile circle touch');
      },
      child: Padding(
        padding: EdgeInsets.only(top: 6),
        child: Text(
          ValidatorUtil.isStringNonEmpty(_displayName)
              ? '${_displayName![0].toUpperCase()}'
              : '',
          style: letterStyle,
        ),
      ),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: SdColors.primaryForeground,
      padding: const EdgeInsets.all(15.0),
    );
  }

  _getUser() async {
    var result = await AuthUtil.getCurrentUser();
    return UserService.getUser(result!.uid);
  }

  void _navigateLogout(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Logout()),
    );
  }
}
