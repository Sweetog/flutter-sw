import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/services/job_service.dart';
import 'package:app/screens/loading.dart';
import 'package:app/screens/shared/app_bar.dart';
import 'package:app/screens/shared/jobs_list_view.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:app/screens/shared/scroll_behavior.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Jobs extends StatefulWidget {
  Jobs({Key? key}) : super(key: key);

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  List<JobModel>? _jobs;
  static final Logger _lg = new Logger();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: kIsWeb ? JobService.getJobs() : JobService.getJobsIncomplete(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return _buildScaffold();
          }

          //_lg.d(snapshot.data);
          _jobs = snapshot.data;
          return _buildScaffold();
        });
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: SdAppBar(),
      body: Center(child: _buildBody()),
      bottomNavigationBar: NavBar(index: NavBarIndex.Jobs),
    );
  }

  Widget _buildBody() {
    if (_jobs == null) {
      return Loading();
    }

    if (kIsWeb) {
      return _buildWebJobListView();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[_buildJobListView()],
    );
  }

  Widget _buildWebJobListView() {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical, child: JobsDataTable(jobModel: _jobs));
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
}
