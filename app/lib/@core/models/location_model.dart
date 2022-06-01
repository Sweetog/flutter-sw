class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel(this.latitude, this.longitude);

  LocationModel.fromJson(Map<String, dynamic> json)
      : latitude = json['_latitude'],
        longitude = json['_longitude'];

  Map<String, dynamic> toJson() =>
      {'latitude': latitude, 'longitude': longitude};
}
