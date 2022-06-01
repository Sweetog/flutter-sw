import 'package:app/@core/models/location_model.dart';
import 'package:app/@core/models/material_model.dart';
import 'package:app/@core/models/service_model.dart';

class InletModel {
  String? afterImgUrl;
  final String beforeImgUrl;
  String? bmpId;
  final String type;
  final LocationModel location;
  ServiceModel? service;
  MaterialModel? material;
  int? volumeUsed;

  InletModel(
      {this.afterImgUrl,
      required this.beforeImgUrl,
      this.bmpId,
      required this.type,
      required this.location,
      this.service,
      this.material,
      this.volumeUsed});

  InletModel.fromJson(Map<String, dynamic> json)
      : afterImgUrl = json['afterImgUrl'],
        beforeImgUrl = json['beforeImgUrl'],
        bmpId = json['bmpId'],
        type = json['type'],
        location = LocationModel.fromJson(json['location']),
        service = json['service'] != null
            ? ServiceModel.fromJson(json['service'])
            : null,
        material = json['material'] != null
            ? MaterialModel.fromJson(json['material'])
            : null,
        volumeUsed = json['volumeUsed'];

  Map<String, dynamic> toJson() => {
        'afterImgUrl': afterImgUrl,
        'beforeImgUrl': beforeImgUrl,
        'bmpId': bmpId,
        'type': type,
        'location': location.toJson(),
        'service': service?.toJson(),
        'material': material?.toJson(),
        'volumeUsed': volumeUsed
      };
}
