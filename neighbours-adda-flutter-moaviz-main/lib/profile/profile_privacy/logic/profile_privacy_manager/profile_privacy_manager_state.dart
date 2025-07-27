// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_privacy_manager_cubit.dart';

class ProfilePrivacyManagerState extends Equatable {
  final bool dataLoading;
  final bool isRequestLoading;
  final bool isRequestSuccess;
  final bool isError;
  final String? error;
  final ProfilePrivacyModel? profilePrivacyModel;

  const ProfilePrivacyManagerState({
    this.dataLoading = false,
    this.isRequestLoading = false,
    this.isRequestSuccess = false,
    this.isError = false,
    this.error,
    this.profilePrivacyModel,
  });

  bool get isProfilePrivacyModelAvailable => profilePrivacyModel != null;

  @override
  List<Object?> get props => [
        dataLoading,
        isRequestLoading,
        isRequestSuccess,
        isError,
        error,
        profilePrivacyModel,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dataLoading': dataLoading,
      'isRequestLoading': isRequestLoading,
      'isRequestSuccess': isRequestSuccess,
      'isError': isError,
      'error': error,
      'profilePrivacyModel': profilePrivacyModel?.toMap(),
    };
  }

  factory ProfilePrivacyManagerState.fromMap(Map<String, dynamic> map) {
    return ProfilePrivacyManagerState(
      dataLoading: (map['dataLoading'] ?? false) as bool,
      isRequestLoading: (map['isRequestLoading'] ?? false) as bool,
      isRequestSuccess: (map['isRequestSuccess'] ?? false) as bool,
      isError: (map['isError'] ?? false) as bool,
      error: map['error'] != null ? map['error'] as String : null,
      profilePrivacyModel: map['profilePrivacyModel'] != null
          ? ProfilePrivacyModel.fromMap(
              map['profilePrivacyModel'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProfilePrivacyManagerState.fromJson(String source) =>
      ProfilePrivacyManagerState.fromMap(
          json.decode(source) as Map<String, dynamic>);

  ProfilePrivacyManagerState copyWith({
    bool? dataLoading,
    bool? isRequestLoading,
    bool? isRequestSuccess,
    bool? isError,
    String? error,
    ProfilePrivacyModel? profilePrivacyModel,
  }) {
    return ProfilePrivacyManagerState(
      dataLoading: dataLoading ?? false,
      isRequestLoading: isRequestLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
      isError: isError ?? false,
      error: error,
      profilePrivacyModel: profilePrivacyModel ?? this.profilePrivacyModel,
    );
  }
}
