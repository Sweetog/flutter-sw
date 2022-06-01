import 'package:app/@core/constants/roles.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/services/site_service.dart';
import 'package:app/@core/services/user_service.dart';
import 'package:app/@core/util/map_util.dart';
import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/shared/scroll_behavior.dart';
import 'package:app/screens/signup/start.dart';
import 'package:app/screens/site/site_jobs.dart';
import 'package:app/screens/site/upsert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/ui-components/logo_container.dart';
import 'package:app/@core/util/auth_util.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:logger/logger.dart';
import 'package:app/@core/models/user_model.dart';
import '../not_authorized.dart';
import 'package:app/env.dart';

//Home was the Sites for Admin
//at this time though Sites not being used
//and Admins are going to probably do site work on web app
//IF sites are even used again
const SITES_DEPRECATED = true;

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final _url = env.functionsUrl;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _lg = new Logger();
  List<JobModel>? _sites;
  UserModel? _user;
  String _log = '';
  bool _debug = false;

  void _buildLog(String msg) {
    _log = '$_log\n$msg';
  }

  Future<void> _getDataLog() async {
    _log = '';
    _buildLog('url: $_url');
    _buildLog('_auth.currentUser');
    var firebaseAuthUser = _auth.currentUser;

    if (firebaseAuthUser == null) {
      _buildLog('firebaseAuthUser is null');
      _buildLog('we done, somehow sessions was lost');
      return;
    }

    _buildLog('firebaseAuthUser.uid: ${firebaseAuthUser.uid}');

    _user = await UserService.getUser(firebaseAuthUser.uid);

    if (_user == null) {
      _buildLog('user is null');
      _buildLog('we done, some reason UserService.getUser failed');
      return;
    }
    _buildLog('user is NOT null');
    _buildLog('user role is: ${_user!.role}');
    _buildLog('starting SiteService.getAll');
    _sites = await SiteService.getAll();
    _buildLog('completed SiteService.getAll');
    if (_sites == null) {
      _buildLog('_sites is null');
      _buildLog('we done, some reason SiteService.getAll failed');
      return;
    }
    _buildLog('sites count: ${_sites!.length}');
  }

  Future<void> _getData() async {
    _user = await AuthUtil.getCurrentUserDetails();
    if (_user == null || _user!.role != Roles.Admin || SITES_DEPRECATED) return;
    _sites = await SiteService.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _debug ? _getDataLog() : _getData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Loading();
          }

          if (_debug) return _buildScaffold(context, true);

          if (_user == null) return Start();

          if (!AuthUtil.isElevated(_user!)) return NotAuthorized();

          return _buildScaffold(
              context, (_user!.role == Roles.Admin && !SITES_DEPRECATED));
        });
  }

  Widget _buildScaffold(BuildContext context, bool isAdmin) {
    return Scaffold(
      appBar: SdAppBar(),
      body: _debug
          ? _buildBodyLogger()
          : isAdmin
              ? _buildBodyAdmin(context)
              : _buildBodyEmployee(context),
      bottomNavigationBar: NavBar(index: NavBarIndex.Home),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              child: Icon(
                Icons.add,
              ),
              onPressed: () => _navigateSiteUpsert(context: context),
            )
          : null,
    );
  }

  Widget _buildBodyLogger() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: TextFormField(
            initialValue: _log,
            readOnly: true,
            maxLines: 20,
            keyboardType: TextInputType.multiline,
            style: UIUtil.getTxtStyleCaption2(),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyEmployee(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LogoContainer(),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildBodyAdmin(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _buildSiteListView(),
      ],
    );
  }

  Widget _buildSiteListView() {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: ListView.builder(
          itemCount: (_sites != null) ? _sites!.length : 0,
          itemBuilder: _buildCard,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    var site = _sites![index];
    return Card(
      color: SdColors.primaryBackground,
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: SdColors.primaryForeground,
          ),
        ),
        height: 140,
        child: Column(
          children: <Widget>[
            Text(
              site.name,
              style: UIUtil.getTxtStyleTitle3(),
            ),
            Text(
              site.address,
              style: UIUtil.getTxtStyleTitle3(),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      MapUtil.openMapAddress(
                          site.address, site.state, site.zip);
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_pin,
                          color: SdColors.swLightBlue,
                        ),
                        Text(
                          'Navigate to Site',
                          style: UIUtil.getTxtStyleCaption2(),
                        )
                      ],
                    ),
                  ),
                  FlatButton(
                    color: Colors.amber,
                    child: Text(
                      'Jobs',
                      style: UIUtil.getTxtStyleCaption1(),
                    ),
                    onPressed: () {
                      _navigateSiteJobs(
                          context: context,
                          siteId: _sites![index].id,
                          siteName: _sites![index].name);
                    },
                  ),
                  FlatButton(
                    color: SdColors.swLightBlue,
                    child: Text(
                      'View/Edit',
                      style: UIUtil.getTxtStyleCaption1(),
                    ),
                    onPressed: () {
                      _navigateSiteUpsert(
                          context: context, siteId: _sites![index].id);
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 10.0,
                left: 8.0,
                right: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _navigateSiteJobs(
      {required BuildContext context,
      required String siteId,
      required String siteName}) async {
    var route = MaterialPageRoute(
      builder: (context) => SiteJobs(siteId, siteName),
    );

    await Navigator.push(
      context,
      route,
    );
  }

  void _navigateSiteUpsert(
      {required BuildContext context, String? siteId}) async {
    var siteUpsertRoute =
        MaterialPageRoute(builder: (context) => SiteUpsert(siteId));

    siteUpsertRoute.popped.then((value) {
      SiteService.getAll().then((sites) => setState(() => _sites = sites));
    });

    await Navigator.push(
      context,
      siteUpsertRoute,
    );
  }
}
