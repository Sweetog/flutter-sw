import 'package:app/@core/constants/nav_bar_index.dart';
import 'package:app/@core/ui-components/center_text.dart';
import 'package:app/@core/ui-components/progress_indicator.dart';
import 'package:app/@core/util/ui_util.dart';
import 'package:app/screens/import/import_view_model.dart';
import 'package:app/screens/jobs/jobs.dart';
import 'package:app/screens/shared/jobs_list_view.dart';
import 'package:app/screens/shared/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class Import extends StatefulWidget {
  @override
  _ImportState createState() => _ImportState();
}

class _ImportState extends State<Import> {
  @override
  Widget build(BuildContext context) {
    return _buildScaffold(context, true);
  }

  Widget _buildScaffold(BuildContext context, bool isAdmin) {
    final ImportViewModel importViewModel = Provider.of(context);

    /// Show snackbar and reset imported job list
    /// Once jobs is imported
    if (importViewModel.isJobsImported) {
      SchedulerBinding.instance?.addPostFrameCallback((_) {
        UIUtil.navigateAsRoot(Jobs(), context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Job is imported',
            ),
          ),
        );
        importViewModel.resetJobModel();
        importViewModel.resetJobsImported();
      });
    }

    return Scaffold(
      body: importViewModel.jobModel.isEmpty
          ? Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller:
                          TextEditingController(text: importViewModel.filename),
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Upload File From Computer',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                        suffixIcon: importViewModel.filename == null
                            ? OutlinedButton(
                                onPressed: () => importViewModel
                                    .selectExcelFile()
                                    .then((value) => setState(() {})),
                                child: Text('Select'),
                              )
                            : OutlinedButton(
                                onPressed: () async {
                                  importViewModel.resetImportViewModel();
                                },
                                child: Text('Reset'),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    /// Disable button till file is not selected
                    SizedBox(
                      height: 40,
                      child: OutlinedButton(
                        onPressed: importViewModel.filename == null
                            ? null
                            : () async {
                                importViewModel.uploadFile().then((_) async {
                                  await importViewModel.jobsCreate();
                                });
                              },
                        child: Text('Upload'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                Opacity(
                  opacity: 0.8,
                  child: JobsListView(
                    scrollPhysics: NeverScrollableScrollPhysics(),
                    jobModel: importViewModel.jobModel,
                  ),
                ),
                Center(
                  child: SdProgressIndicator(),
                ),
              ],
            ),
      bottomNavigationBar: NavBar(index: NavBarIndex.Import),
    );
  }
}
