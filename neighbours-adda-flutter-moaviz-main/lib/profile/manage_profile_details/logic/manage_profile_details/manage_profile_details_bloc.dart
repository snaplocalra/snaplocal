import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:snap_local/common/utils/firebase_chat/model/firebase_user_profile_details_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_user_repository.dart';
import 'package:snap_local/profile/manage_profile_details/model/edit_profile_details_model.dart';
import 'package:snap_local/profile/manage_profile_details/model/profile_details_model.dart';
import 'package:snap_local/profile/manage_profile_details/repository/profile_repository.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_upload_type.dart';
import 'package:snap_local/utility/common/media_picker/repository/media_upload_repository.dart';

part 'manage_profile_details_event.dart';
part 'manage_profile_details_state.dart';

class ManageProfileDetailsBloc
    extends Bloc<ManageProfileDetailsEvent, ManageProfileDetailsState>
    with HydratedMixin {
  final ProfileRepository profileRepository;
  final MediaUploadRepository mediaUploadRepository;
  ManageProfileDetailsBloc({
    required this.profileRepository,
    required this.mediaUploadRepository,
  }) : super(const ManageProfileDetailsState()) {
    on<ManageProfileDetailsEvent>((event, emit) async {
      if (event is FetchProfileDetails) {
        try {
          if (state.profileDetailsModel == null) {
            emit(state.copyWith(dataLoading: true));
          }
          final profileDetails = await profileRepository.fetchProfileDetails();
          emit(state.copyWith(profileDetailsModel: profileDetails));
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);

          if (!state.isProfileDetailsAvailable) {
            emit(state.copyWith(error: e.toString()));
          }
          ThemeToast.errorToast(e.toString());
        }
      } else if (event is UpdateProfileDetails) {
        try {
          final editedProfileDetails = event.editProfileDetailsModel;
          final oldProfileDetails = state.profileDetailsModel;

          final updatedProfileDetails = oldProfileDetails!.copyWith(
            name: editedProfileDetails.name,
            email: editedProfileDetails.email,
            profileImage: editedProfileDetails.profileImageUrl ??
                oldProfileDetails.profileImage,
            coverImage: editedProfileDetails.coverImageUrl ??
                oldProfileDetails.coverImage,
            gender: editedProfileDetails.gender,
            dob: editedProfileDetails.dateOfBirth,
            bio: editedProfileDetails.bio,
            languageKnownList: editedProfileDetails.languageKnownList,
            occupation: editedProfileDetails.occupation,
            workPlace: editedProfileDetails.workPlace,
          );

          emit(state.copyWith(
            isRequestLoading: true,
            profileDetailsModel: updatedProfileDetails,
          ));

          //upload profile image
          String? profileImageServerName =
              await uploadMedia(media: event.pickedImageFile);

          //upload cover image
          String? coverImageServerName =
              await uploadMedia(media: event.pickedCoverImageFile);

          await profileRepository.updateProfileDetails(
            event.editProfileDetailsModel,
            profileImageServerName: profileImageServerName,
            coverImageServerName: coverImageServerName,
          );

          final profileDetails = await updateData();

          emit(state.copyWith(
            profileDetailsModel: profileDetails,
            isRequestSuccess: true,
          ));
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          emit(state.copyWith());
          ThemeToast.errorToast(e.toString());
        }
      }

      /// Update profile image
      else if (event is UpdateProfileImage) {
        try {
          final editedProfileDetails = state.profileDetailsModel;

          emit(state.copyWith(isRequestLoading: true));

          final profileImageServerName =
              await uploadMedia(media: event.pickedImageFile);

          final updatedProfileDetails = editedProfileDetails!
              .copyWith(profileImage: profileImageServerName);

          // Update the profile image in the backend
          await profileRepository.updateProfileDetails(
            convertProfileDetails(updatedProfileDetails),
            profileImageServerName: profileImageServerName,
          );

          final profileDetails = await updateData();

          emit(state.copyWith(
            profileDetailsModel: profileDetails,
            isRequestSuccess: true,
          ));
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          emit(state.copyWith());
          ThemeToast.errorToast(e.toString());
        }
      }

      /// Update cover image
      else if (event is UpdateCoverImage) {
        try {
          final editedProfileDetails = state.profileDetailsModel;

          emit(state.copyWith(isRequestLoading: true));

          final coverImageServerName =
              await uploadMedia(media: event.pickedCoverImageFile);

          final updatedProfileDetails =
              editedProfileDetails!.copyWith(coverImage: coverImageServerName);

          // Update the cover image in the backend
          await profileRepository.updateProfileDetails(
            convertProfileDetails(updatedProfileDetails),
            coverImageServerName: coverImageServerName,
          );

          final profileDetails = await updateData();

          emit(state.copyWith(
            profileDetailsModel: profileDetails,
            isRequestSuccess: true,
          ));
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          emit(state.copyWith());
          ThemeToast.errorToast(e.toString());
        }
      }

      /// Set SetShowProfileComplete
      else if (event is SetShowProfileComplete) {
        try {
          emit(state.copyWith(setProfileShowLoading: true));
          await profileRepository.setShowProfileComplete();

          final profileDetails = await profileRepository.fetchProfileDetails();
          emit(state.copyWith(
            setProfileShowSuccess: true,
            profileDetailsModel: profileDetails,
          ));
        } catch (e) {
          // Record the error in Firebase Crashlytics
          FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
          if (!state.isProfileDetailsAvailable) {
            emit(state.copyWith(error: e.toString()));
          }
          ThemeToast.errorToast(e.toString());
        }
      }
    });
  }

  EditProfileDetailsModel convertProfileDetails(
      ProfileDetailsModel profileDetails) {
    return EditProfileDetailsModel(
      name: profileDetails.name,
      email: profileDetails.email,
      profileImageUrl: profileDetails.profileImage,
      coverImageUrl: profileDetails.coverImage,
      gender: profileDetails.gender,
      dateOfBirth: profileDetails.dob,
      bio: profileDetails.bio,
      occupation: profileDetails.occupation,
      workPlace: profileDetails.workPlace,
      languageKnownList: profileDetails.languageKnownList,
    );
  }

  /// Update profile data
  Future<ProfileDetailsModel> updateData() async {
    final profileDetails = await profileRepository.fetchProfileDetails();

    //create firebase user instance
    final profileDetailsForFirebase = FirebaseUserProfileDetailsModel(
      id: profileDetails.id,
      name: profileDetails.name,
      email: profileDetails.email,
      mobile: profileDetails.mobile,
      gender: profileDetails.gender,
      profileImage: profileDetails.profileImage,
    );
    //update profile on firebase
    await FirebaseUserRepository().manageUser(profileDetailsForFirebase);

    return profileDetails;
  }

  /// Upload media
  Future<String?> uploadMedia({
    required MediaFileModel? media,
  }) async {
    try {
      if (media == null) {
        return null;
      }
      final response = await mediaUploadRepository.uploadMedia(
        mediaUploadType: MediaUploadType.profile,
        mediaList: [media],
      );
      return response.mediaList.first.mediaUrl;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
    return null;
  }

  @override
  ManageProfileDetailsState? fromJson(Map<String, dynamic> json) {
    return ManageProfileDetailsState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(ManageProfileDetailsState state) {
    return state.toMap();
  }
}
