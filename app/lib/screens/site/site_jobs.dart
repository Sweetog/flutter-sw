import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/services/job_service.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/jobs_list_view.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:app/screens/shared/scroll_behavior.dart';
import 'package:app/screens/site/job_upsert.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class SiteJobs extends StatefulWidget {
  final String _siteId;
  final String _siteName;

  SiteJobs(this._siteId, this._siteName);

  @override
  _SiteJobsState createState() => _SiteJobsState(_siteId, this._siteName);
}

class _SiteJobsState extends State<SiteJobs> {
  final String _siteId;
  final String _siteName;
  List<JobModel>? _jobs;
  static final Logger _lg = Logger();

  _SiteJobsState(this._siteId, this._siteName);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: JobService.getJobsBySite(_siteId),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold();
          }

          _jobs = snapshot.data;
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: SdAppBar(),
      body: Center(child: _buildBody()),
      bottomNavigationBar: NavBar(index: NavBarIndex.Jobs),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        onPressed: () {
          //_navigateSiteJob(context: context, siteId: this._siteId);
          _showJobCreateDialog(context, this._siteId, this._siteName);
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_jobs == null) {
      return Loading();
    }

    if (_jobs!.length == 0) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'No Jobs exist for Site: $_siteName',
              style: UIUtil.getDefaultTxtStyle(),
            )
          ]);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[_buildJobListView()],
    );
  }

  Widget _buildJobListView() {
    return ScrollConfiguration(
      behavior: ScrollBehaviorHideSplash(),
      child: Flexible(
        child: JobsListView(
          jobModel: _jobs,
        ),
      ),
    );
  }

  void _navigateSiteJob(
      {required BuildContext context, required String siteId}) async {
    var route = MaterialPageRoute(
      builder: (context) => SiteJobUpsert(
        siteId,
      ),
    );

    await Navigator.push(
      context,
      route,
    );
  }

  void _showJobCreateDialog(
      BuildContext context, String siteId, String siteName) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Confirm Job Create for Site: $siteName',
              style: UIUtil.getTxtStyleCaption1(),
            ),
            content: Text(
              'Yes, Create New Job for Site: $siteName',
              style: UIUtil.getTxtStyleCaption2(),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Yes'),
                onPressed: () async {
                  var _ = await JobService.create(siteId: siteId);
                  setState(() {});
                  UIUtil.snackBar(context, 'Job created for Site: $siteName.');
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
