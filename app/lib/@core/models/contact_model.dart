class ContactModel {
  final String name;
  final String phone;
  final String? email;

  ContactModel({required this.name, required this.phone, this.email});

  ContactModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        name = json['name'],
        phone = json['phone'];

  Map<String, dynamic> toJson() =>
      {'email': email, 'name': name, 'phone': phone};
}
