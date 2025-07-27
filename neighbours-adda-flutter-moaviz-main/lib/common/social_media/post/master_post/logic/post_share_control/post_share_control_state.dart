part of 'post_share_control_cubit.dart';

enum PostSharePermission {
  allow(
    displayName: LocaleKeys.allowSharing,
    svgPath: SVGAssetsImages.allowSharing,
  ),
  restrict(
    displayName: LocaleKeys.restrictSharing,
    svgPath: SVGAssetsImages.dontAllowSharing,
  );

  bool get allowShare => this == allow;

  PostSharePermission get opposite => this == allow ? restrict : allow;

  final String svgPath;
  final String displayName;
  const PostSharePermission({
    required this.svgPath,
    required this.displayName,
  });

  factory PostSharePermission.fromBool(bool value) {
    switch (value) {
      case true:
        return PostSharePermission.allow;
      case false:
        return PostSharePermission.restrict;
      default:
        throw ArgumentError("Invalid share control display name: $value");
    }
  }

  bool toBool() => this == allow;
}

class PostShareControlState extends Equatable {
  final PostSharePermission postShareControlEnum;

  const PostShareControlState(this.postShareControlEnum);

  @override
  List<Object> get props => [postShareControlEnum];

  PostShareControlState copyWith({PostSharePermission? postShareControlEnum}) {
    return PostShareControlState(
      postShareControlEnum ?? this.postShareControlEnum,
    );
  }
}
