class RegisterUserModel {
  final String name;
  final String userName;
  final DateTime? dateOfBirth;
  final String gender;
  final String? password;
  RegisterUserModel({
    required this.name,
    required this.userName,
    required this.dateOfBirth,
    required this.gender,
    required this.password,
  });

  /// getter to check username is email or phone number
  bool get isEmail => userName.contains('@');

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      if (isEmail) 'email': userName,
      if (!isEmail) 'mobile': userName,
      'dob': dateOfBirth?.millisecondsSinceEpoch,
      'gender': gender,
      'password': password,
    };
  }
}
