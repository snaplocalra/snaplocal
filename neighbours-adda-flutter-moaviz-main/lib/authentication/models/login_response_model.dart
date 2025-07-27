import 'package:snap_local/authentication/models/authenticated_user_details.dart';

class LoginResponseModel {
  final AuthenticatedUserDetails authenticatedUserDetails;
  final bool otpVerified;

  LoginResponseModel({
    required this.authenticatedUserDetails,
    required this.otpVerified,
  });

  factory LoginResponseModel.fromMap(Map<String, dynamic> map) {
    return LoginResponseModel(
      authenticatedUserDetails: AuthenticatedUserDetails.fromMap(map['data']),
      otpVerified: (map['otp_status'] ?? false) as bool,
    );
  }
}
