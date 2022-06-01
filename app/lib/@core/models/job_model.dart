import 'package:app/@core/models/contact_model.dart';
import 'package:app/@core/models/inlet_model.dart';
import 'package:app/@core/models/location_model.dart';
import 'package:logger/logger.dart';

class JobModel {
  static final _lg = Logger();
  final String id;
  final String address;
  List<int>? drainOrder;
  List<InletModel>? inlets;
  LocationModel? location;
  String name;
  DateTime? startDate;
  final String state;
  final String zip;
  ContactModel? contact;
  final String? route;
  final String? serviceCode;
  final String? serviceNote;
  final String? status;

  JobModel({
    required this.id,
    required this.address,
    required this.name,
    required this.state,
    required this.zip,
    required this.startDate,
    required this.contact,
    required this.inlets,
    required this.route,
    required this.serviceCode,
    required this.serviceNote,
    this.status,
  });

  JobModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        address = json['address'],
        inlets = _buildInlets(json['inlets']),
        location = json['location'] != null
            ? LocationModel.fromJson(json['location'])
            : null,
        name = json['name'],
        startDate = dateTimeFromJsonTimestamp(json['startDate']),
        state = json['state'],
        zip = json['zip'],
        route = json['Route'] == null ? '' : json['Route'],
        contact = json['contact'] != null
            ? ContactModel.fromJson(json['contact'])
            : null,
        serviceCode = json['serviceCode'] == null ? '' : json['serviceCode'],
        serviceNote = json['serviceNote'] == null ? '' : json['serviceNote'],
        status = json['status'] == null ? null : json['status'];

  static List<InletModel>? _buildInlets(List<dynamic>? json) {
    if (json == null || json.length <= 0) {
      return null;
    }
    final List<InletModel> ret = [];
    for (var i = 0; i < json.length; i++) {
      ret.add(InletModel.fromJson(json[i]));
    }
    return ret;
  }

  static DateTime? dateTimeFromJsonTimestamp(Map<String, dynamic>? json) {
    if (json == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(json['_seconds'] * 1000);
  }
}
