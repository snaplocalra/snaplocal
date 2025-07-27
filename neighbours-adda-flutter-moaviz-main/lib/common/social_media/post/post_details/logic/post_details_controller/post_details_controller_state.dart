part of 'post_details_controller_cubit.dart';

class PostDetailsControllerState extends Equatable {
  final bool dataLoading;
  final bool removeItemFromList;
  final bool removeByUnsaved;
  final SocialPostModel socialPostModel;
  const PostDetailsControllerState({
    this.dataLoading = false,
    this.removeItemFromList = false,
    this.removeByUnsaved = false,
    required this.socialPostModel,
  });

  @override
  List<Object> get props => [
        dataLoading,
        removeItemFromList,
        removeByUnsaved,
        socialPostModel,
      ];

  PostDetailsControllerState copyWith({
    bool? dataLoading,
    bool? removeItemFromList,
    bool? removeByUnsaved,
    SocialPostModel? socialPostModel,
  }) {
    return PostDetailsControllerState(
      dataLoading: dataLoading ?? false,
      removeByUnsaved: removeByUnsaved ?? false,
      removeItemFromList: removeItemFromList ?? false,
      socialPostModel: socialPostModel ?? this.socialPostModel,
    );
  }
}
