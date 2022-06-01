import 'dart:typed_data';
import 'package:app/@core/models/contact_model.dart';
import 'package:app/@core/models/job_model.dart';
import 'package:app/@core/services/job_service.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class ImportViewModel extends ChangeNotifier {
  Uint8List? file;
  String? filename;
  List<JobModel> jobModel = [];
  bool isJobsImported = false;

  /// Parse excel data to [JobModel]
  Future<void> uploadFile() async {
    var excel = Excel.decodeBytes(file!);

    for (var row in excel.tables[excel.tables.keys.first]!.rows) {
      if (row.first?.value.toString().toLowerCase() != 'site id')

        /// Add excel data to[JobModel]
        jobModel.add(
          JobModel(
            id: row.first?.value.toString() ?? '',
            address: row[7]?.value.toString() ?? '',
            name: row[6]?.value.toString() ?? '',
            state: row[8]?.value.toString() ?? '',
            zip: row[11]?.value.toString() ?? '',
            startDate: row[10]?.value.toString() == null
                ? null
                : _excelDateToJSDate(
                    int.tryParse(row[10]?.value.toString() ?? '0') ?? 0),
            contact: ContactModel(
              name: row[6]?.value.toString() ?? '',
              phone: row[34]?.value.toString() ?? '',
            ),
            route: row[2]?.value.toString() ?? '',
            inlets: [],
            serviceCode: row[5]?.value.toString() ?? '',
            serviceNote: row[14]?.value.toString() ?? '',
          ),
        );
    }

    notifyListeners();
  }

  /// Convert excel date format to normal date format
  DateTime _excelDateToJSDate(int serial) {
    var utc_days = serial - 25569;
    var utc_value = utc_days * 86400;
    DateTime date_info = DateTime.fromMillisecondsSinceEpoch(utc_value * 1000);

    return new DateTime(date_info.year, date_info.month, date_info.day);
  }

  /// Select excel file from [FilePicker]
  Future<void> selectExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['xlsx'],
    );
    if (result != null && result.files.isNotEmpty) {
      file = result.files.first.bytes!;
      filename = result.files.first.name;
    } else {
      // TODO: Admin canceled the picker
    }

    notifyListeners();
  }

  /// Upload jobs to firestore
  Future<void> jobsCreate() async {
    for (var item in jobModel) {
      await JobService.createFromImport(
        siteId: item.id,
        name: item.name,
        address: item.address,
        state: item.state,
        zip: item.zip,
        date: item.startDate,
        contact: item.contact,
        route: item.route,
        serviceCode: item.serviceCode,
        serviceNote: item.serviceNote,
      );
    }

    isJobsImported = true;
    filename = null;
    file = null;
    notifyListeners();
  }

  /// Reset [JobModel] list
  void resetJobModel() {
    jobModel.clear();
    notifyListeners();
  }

  void resetJobsImported() {
    isJobsImported = false;
    notifyListeners();
  }

  /// Reset All state of [ImportViewModel]
  void resetImportViewModel() {
    file = null;
    filename = null;
    jobModel = [];
    isJobsImported = false;
    notifyListeners();
  }
}
