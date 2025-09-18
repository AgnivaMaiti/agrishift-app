class UserModel {
  final String name;
  final String email;
  final String phone;
  final String userType;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.userType,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      userType: json['userType'] ?? 'farmer',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'userType': userType,
    };
  }
}
