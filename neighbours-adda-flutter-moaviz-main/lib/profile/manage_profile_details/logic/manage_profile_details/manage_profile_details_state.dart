part of 'manage_profile_details_bloc.dart';

class ManageProfileDetailsState extends Equatable {
  final bool dataLoading;
  final bool isRequestLoading;
  final bool isRequestSuccess;

  final bool setProfileShowLoading;
  final bool setProfileShowSuccess;
  final ProfileDetailsModel? profileDetailsModel;
  final String? error;

  const ManageProfileDetailsState({
    this.dataLoading = false,
    this.isRequestLoading = false,
    this.isRequestSuccess = false,
    this.setProfileShowLoading = false,
    this.setProfileShowSuccess = false,
    this.profileDetailsModel,
    this.error,
  });

  bool get isProfileDetailsAvailable => profileDetailsModel != null;

  @override
  List<Object?> get props => [
        dataLoading,
        isRequestLoading,
        isRequestSuccess,
        profileDetailsModel,
        setProfileShowLoading,
        setProfileShowSuccess,
        error,
      ];

  ManageProfileDetailsState copyWith({
    bool? dataLoading,
    bool? isRequestLoading,
    bool? isRequestSuccess,
    bool? setProfileShowLoading,
    bool? setProfileShowSuccess,
    ProfileDetailsModel? profileDetailsModel,
    String? error,
  }) {
    return ManageProfileDetailsState(
      dataLoading: dataLoading ?? false,
      isRequestLoading: isRequestLoading ?? false,
      isRequestSuccess: isRequestSuccess ?? false,
      setProfileShowLoading: setProfileShowLoading ?? false,
      setProfileShowSuccess: setProfileShowSuccess ?? false,
      profileDetailsModel: profileDetailsModel ?? this.profileDetailsModel,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dataLoading': dataLoading,
      'isRequestLoading': isRequestLoading,
      'isRequestSuccess': isRequestSuccess,
      'setProfileShowLoading': setProfileShowLoading,
      'setProfileShowSuccess': setProfileShowSuccess,
      'profileDetailsModel': profileDetailsModel?.toJson(saveToDb: true),
      'error': error,
    };
  }



  factory ManageProfileDetailsState.fromMap(Map<String, dynamic> map) {
    return ManageProfileDetailsState(
      dataLoading: (map['dataLoading'] ?? false) as bool,
      isRequestLoading: (map['isRequestLoading'] ?? false) as bool,
      isRequestSuccess: (map['isRequestSuccess'] ?? false) as bool,
      setProfileShowLoading: (map['setProfileShowLoading'] ?? false) as bool,
      setProfileShowSuccess: (map['setProfileShowSuccess'] ?? false) as bool,
      profileDetailsModel: map['profileDetailsModel'] != null
          ? ProfileDetailsModel.fromJson(
              map['profileDetailsModel'] as Map<String, dynamic>,
              isOwnProfile: true,
            )
          : null,
      error: map['error'] != null ? map['error'] as String : null,
    );
  }
}
