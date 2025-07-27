// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_profile_details_bloc.dart';

abstract class ManageProfileDetailsEvent extends Equatable {
  const ManageProfileDetailsEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileDetails extends ManageProfileDetailsEvent {}

class UpdateProfileDetails extends ManageProfileDetailsEvent {
  final MediaFileModel? pickedImageFile;
  final MediaFileModel? pickedCoverImageFile;
  final EditProfileDetailsModel editProfileDetailsModel;

  const UpdateProfileDetails({
    this.pickedImageFile,
    this.pickedCoverImageFile,
    required this.editProfileDetailsModel,
  });

  @override
  List<Object?> get props => [
        editProfileDetailsModel,
        pickedImageFile,
        pickedCoverImageFile,
      ];
}

//Update profile image
class UpdateProfileImage extends ManageProfileDetailsEvent {
  final MediaFileModel pickedImageFile;

  const UpdateProfileImage(this.pickedImageFile);

  @override
  List<Object?> get props => [pickedImageFile];
}

//Update cover image
class UpdateCoverImage extends ManageProfileDetailsEvent {
  final MediaFileModel pickedCoverImageFile;

  const UpdateCoverImage(this.pickedCoverImageFile);

  @override
  List<Object?> get props => [pickedCoverImageFile];
}

class SetShowProfileComplete extends ManageProfileDetailsEvent {
  const SetShowProfileComplete();

  @override
  List<Object?> get props => [];
}
