class UserModel {
  final String email;
  final String userId;
  final String role;

  UserModel({required this.email, required this.userId, required this.role});

  UserModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        userId = json['userId'],
        role = json['role'];
}
