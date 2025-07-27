import 'dart:convert';

import 'package:snap_local/authentication/models/register_user_model.dart';

class SocialLoginUserRegisterModel extends RegisterUserModel {
  final String socialLoginId;

  SocialLoginUserRegisterModel({
    required this.socialLoginId,
    required super.dateOfBirth,
    required super.userName,
    required super.name,
    required super.gender,
    required super.password,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'social_login_id': socialLoginId,
    };
  }

  String toJson() => json.encode(toMap());
}
