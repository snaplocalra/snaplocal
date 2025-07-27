part of 'post_comment_control_cubit.dart';

enum PostCommentPermission {
  enable(
    displayName: LocaleKeys.enableComments,
    svgPath: SVGAssetsImages.enableComment,
  ),
  disable(
    displayName: LocaleKeys.disableComments,
    svgPath: SVGAssetsImages.disableComment,
  );

  bool get allowComment => this == enable;

  PostCommentPermission get opposite => this == enable ? disable : enable;

  final String svgPath;
  final String displayName;
  const PostCommentPermission({
    required this.svgPath,
    required this.displayName,
  });

  factory PostCommentPermission.fromBool(bool value) {
    switch (value) {
      case true:
        return PostCommentPermission.enable;
      case false:
        return PostCommentPermission.disable;
      default:
        throw ArgumentError("Invalid comment control type: $value");
    }
  }

  bool toBool() => this == enable;
}

class PostCommentControlState extends Equatable {
  final PostCommentPermission postCommentControlEnum;

  const PostCommentControlState(this.postCommentControlEnum);

  @override
  List<Object> get props => [postCommentControlEnum];

  PostCommentControlState copyWith(
      {PostCommentPermission? postCommentControlEnum}) {
    return PostCommentControlState(
      postCommentControlEnum ?? this.postCommentControlEnum,
    );
  }
}
