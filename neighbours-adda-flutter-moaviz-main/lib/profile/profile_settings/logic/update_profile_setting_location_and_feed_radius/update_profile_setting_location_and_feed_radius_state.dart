// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'update_profile_setting_location_and_feed_radius_cubit.dart';

class UpdateProfileSettingLocationState extends Equatable {
  final bool isLoading;
  final bool requestSucceed;

  const UpdateProfileSettingLocationState({
    this.isLoading = false,
    this.requestSucceed = false,
  });

  @override
  List<Object?> get props => [isLoading, requestSucceed];

  UpdateProfileSettingLocationState copyWith({
    bool? isLoading,
    bool? requestSucceed,
  }) {
    return UpdateProfileSettingLocationState(
      isLoading: isLoading ?? false,
      requestSucceed: requestSucceed ?? false,
    );
  }
}
