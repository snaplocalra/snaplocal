// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_settings_cubit.dart';

class ProfileSettingsState extends Equatable {
  final bool dataLoading;
  final bool isError;
  final String? error;
  final ProfileSettingsModel? profileSettingsModel;
  const ProfileSettingsState({
    this.dataLoading = false,
    this.isError = false,
    this.error,
    this.profileSettingsModel,
  });

  @override
  List<Object?> get props => [
        dataLoading,
        isError,
        error,
        profileSettingsModel,
      ];

  bool get isProfileSettingModelAvailable => profileSettingsModel != null;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dataLoading': dataLoading,
      'isError': isError,
      'error': error,
      'profileSettingsModel': profileSettingsModel?.toMap(),
    };
  }

  factory ProfileSettingsState.fromMap(Map<String, dynamic> map) {
    return ProfileSettingsState(
      dataLoading: (map['dataLoading'] ?? false) as bool,
      isError: (map['isError'] ?? false) as bool,
      error: map['error'] != null ? map['error'] as String : null,
      profileSettingsModel: map['profileSettingsModel'] != null
          ? ProfileSettingsModel.fromMap(
              map['profileSettingsModel'] as Map<String, dynamic>)
          : null,
    );
  }

  ProfileSettingsState copyWith({
    bool? dataLoading,
    bool? isError,
    String? error,
    ProfileSettingsModel? profileSettingsModel,
  }) {
    return ProfileSettingsState(
      dataLoading: dataLoading ?? false,
      isError: isError ?? false,
      error: error,
      profileSettingsModel: profileSettingsModel ?? this.profileSettingsModel,
    );
  }
}
