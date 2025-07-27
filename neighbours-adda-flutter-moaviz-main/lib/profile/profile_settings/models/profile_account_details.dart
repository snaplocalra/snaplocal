import '../../../utility/constant/errors.dart';

class ProfileAccountDetails {
  final String mobile;
  final String email;

  ProfileAccountDetails({required this.mobile, required this.email});

  factory ProfileAccountDetails.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _build(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _build(map);
    }
  }

  static ProfileAccountDetails _build(Map<String, dynamic> map) {
    return ProfileAccountDetails(
      mobile: (map['mobile'] ?? '') as String,
      email: (map['email'] ?? '') as String,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mobile': mobile,
      'email': email,
    };
  }
}
