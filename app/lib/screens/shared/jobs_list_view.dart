import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/util/format_util.dart';
import 'package:app/@core/util/map_util.dart';
import 'package:app/@core/util/sd_colors.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/jobs/inlets.dart';
import 'package:app/screens/jobs/jobs_detail.dart';
import 'package:flutter/material.dart';

import 'job_status_drop_down.dart';

const CARD_HEIGHT = 250.0;
const emp1 = 'Odi';
const emp2 = 'Sean';

class JobsListView extends StatelessWidget {
  const JobsListView({Key? key, required this.jobModel, this.scrollPhysics})
      : super(key: key);

  final List<JobModel>? jobModel;
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: scrollPhysics,
      itemCount: (jobModel != null) ? jobModel!.length : 0,
      itemBuilder: (context, index) => _buildCard(context, index),
    );
  }

  Widget _buildCard(BuildContext context, int index) {
    var job = jobModel![index];
    return Card(
      color: job.status == 'Complete'
          ? Colors.green
          : job.status == 'In progress'
              ? Colors.amber
              : SdColors.primaryBackground,
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.only(top: 2, left: 10, right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: SdColors.primaryForeground,
          ),
        ),
        height: CARD_HEIGHT,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Job Name: ${job.name}',
                  style: UIUtil.getTxtStyleTitle3(),
                ),
                Text(
                  job.address,
                  style: UIUtil.getTxtStyleCaption2(),
                ),
                GestureDetector(
                  onTap: () {
                    MapUtil.openMapAddress(job.address, job.state, job.zip);
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
                // Text(
                //   'Start Date:${FormatUtil.formatDateDefault(job.startDate)}',
                //   style: UIUtil.getTxtStyleCaption1(),
                // ),
                if (job.route != '' && job.route != null)
                  Text(
                    'Job assigned to: ${job.route == '001' ? emp1 : emp2}',
                    style: UIUtil.getTxtStyleCaption1(),
                  ),
                if (job.serviceCode != '' && job.serviceCode != null)
                  Text(
                    'Service code: ${job.serviceCode}',
                    style: UIUtil.getTxtStyleCaption1(),
                  ),
                JobStatusDropDown(
                  id: job.id,
                  status: job.status,
                ),
                FlatButton(
                  color: SdColors.swLightBlue,
                  child: Text(
                    'Inlets',
                    style: UIUtil.getTxtStyleCaption1(),
                  ),
                  onPressed: () {
                    _navigateJobInlets(context, job.id);
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateJobInlets(BuildContext context, String jobId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobInlets(jobId)),
    );
  }
}

class JobsDataTable extends StatelessWidget {
  const JobsDataTable({Key? key, required this.jobModel, this.scrollPhysics})
      : super(key: key);

  final List<JobModel>? jobModel;
  final ScrollPhysics? scrollPhysics;

  @override
  Widget build(BuildContext context) {
    List<DataRow> rowsWidget = [];
    if (jobModel != null) {
      if (jobModel!.isNotEmpty) {
        for (var job in jobModel!) {
          rowsWidget.add(DataRow(
              cells: createCellsForElement(job),
              onSelectChanged: (_) async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => JobDetails(
                            jobModel: job,
                          )),
                );
              }));
        }
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        columns: <DataColumn>[
          DataColumn(
            label: Text(
              'Date',
              style: UIUtil.getTxtStyleTitle3(),
            ),
          ),
          DataColumn(
            label: Text('Name', style: UIUtil.getTxtStyleTitle3()),
          ),
          DataColumn(
            label: Text(
              'Address',
              style: UIUtil.getTxtStyleTitle3(),
            ),
          ),
          /*DataColumn(
            label: Text(
              'Assigned',
                style: UIUtil.getTxtStyleTitle3()
            ),
            numeric: true,
          ),*/
          DataColumn(
            label: Text('Status', style: UIUtil.getTxtStyleTitle3()),
          ),
          DataColumn(
            label: Text('ServiceNote', style: UIUtil.getTxtStyleTitle3()),
          ),
        ],
        rows: rowsWidget,
      ),
    );
  }

  List<DataCell> createCellsForElement(JobModel jobModel) {
    return <DataCell>[
      DataCell(Text(
        FormatUtil.formatDateDefault(jobModel.startDate)!,
        style: UIUtil.getTxtStyleCaption2(),
      )),
      DataCell(Text(
        jobModel.name,
        style: UIUtil.getTxtStyleCaption2(),
      )),
      DataCell(Text(
        jobModel.address,
        style: UIUtil.getTxtStyleCaption2(),
      )),
      //DataCell(Text(jobModel.)),
      DataCell(Text(
        (jobModel.status) ?? '',
        style: UIUtil.getTxtStyleCaption2(),
      )),
      DataCell(Text(
        (jobModel.serviceNote) ?? '',
        style: UIUtil.getTxtStyleCaption2(),
      )),
    ];
  }

  Widget _buildCard(BuildContext context, int index) {
    var job = jobModel![index];
    return Card(
      color: job.status == 'Complete'
          ? Colors.green
          : job.status == 'In progress'
              ? Colors.amber
              : SdColors.primaryBackground,
      elevation: 2.0,
      child: Container(
        padding: EdgeInsets.only(top: 2, left: 10, right: 10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2.0,
            color: SdColors.primaryForeground,
          ),
        ),
        height: CARD_HEIGHT,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Job Name: ${job.name}',
                  style: UIUtil.getTxtStyleTitle3(),
                ),
                Text(
                  job.address,
                  style: UIUtil.getTxtStyleCaption2(),
                ),
                GestureDetector(
                  onTap: () {
                    MapUtil.openMapAddress(job.address, job.state, job.zip);
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
                // Text(
                //   'Start Date:${FormatUtil.formatDateDefault(job.startDate)}',
                //   style: UIUtil.getTxtStyleCaption1(),
                // ),
                if (job.route != '' && job.route != null)
                  Text(
                    'Job assigned to: ${job.route == '001' ? emp1 : emp2}',
                    style: UIUtil.getTxtStyleCaption1(),
                  ),
                if (job.serviceCode != '' && job.serviceCode != null)
                  Text(
                    'Service code: ${job.serviceCode}',
                    style: UIUtil.getTxtStyleCaption1(),
                  ),
                JobStatusDropDown(
                  id: job.id,
                  status: job.status,
                ),
                FlatButton(
                  color: SdColors.swLightBlue,
                  child: Text(
                    'Inlets',
                    style: UIUtil.getTxtStyleCaption1(),
                  ),
                  onPressed: () {
                    _navigateJobInlets(context, job.id);
                  },
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateJobInlets(BuildContext context, String jobId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobInlets(jobId)),
    );
  }
}
