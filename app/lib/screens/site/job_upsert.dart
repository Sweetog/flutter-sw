import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:flutter/material.dart';

class SiteJobUpsert extends StatefulWidget {
  final String _siteId;

  SiteJobUpsert(this._siteId);

  @override
  _SiteJobUpsertState createState() => _SiteJobUpsertState(_siteId);
}

class _SiteJobUpsertState extends State<SiteJobUpsert> {
  final String _siteId;

  _SiteJobUpsertState(this._siteId);

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
        appBar: SdAppBar(),
        body: Center(child: _buildBody()),
        bottomNavigationBar: NavBar(index: NavBarIndex.Jobs));
  }

  Widget _buildBody() {
    return Container();
  }

  //ask the right questions
  //or wait, is there not really any questions?
  //do you just copy the site into the job and add
  //start_date and site_id?
}
