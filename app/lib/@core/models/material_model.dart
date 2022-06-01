class MaterialModel {
  int? construction;
  int? siltSand;
  int? gravel;
  int? organics;
  int? trash;
  int? other;

  MaterialModel({
    this.construction,
    this.siltSand,
    this.gravel,
    this.organics,
    this.trash,
    this.other
  });

  MaterialModel.fromJson(Map<String, dynamic> json)
      : construction = json['construction'],
        siltSand = json['siltSand'],
        gravel = json['gravel'],
        organics = json['organics'],
        trash = json['trash'],
        other = json['other'];

  Map<String, dynamic> toJson() => {
        'construction': construction,
        'siltSand': siltSand,
        'gravel': gravel,
        'organics': organics,
        'trash': trash,
        'other': other
      };
}
