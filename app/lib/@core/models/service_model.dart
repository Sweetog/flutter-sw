class ServiceModel {
  bool? inspect;
  bool? cleaned;
  bool? repairs;
  bool? media;

  ServiceModel({
    this.inspect,
    this.cleaned,
    this.repairs,
    this.media,
  });

  ServiceModel.fromJson(Map<String, dynamic> json)
      : inspect = json['inspect'],
        cleaned = json['cleaned'],
        repairs = json['repairs'],
        media = json['media'];

  Map<String, dynamic> toJson() => {
        'inspect': inspect,
        'cleaned': cleaned,
        'repairs': repairs,
        'media': media
      };
}
