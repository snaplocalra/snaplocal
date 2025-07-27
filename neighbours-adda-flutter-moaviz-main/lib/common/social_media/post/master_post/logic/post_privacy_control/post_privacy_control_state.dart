part of 'post_privacy_control_cubit.dart';

enum PostVisibilityControlEnum {
  public(
    type: 'public',
    displayName: LocaleKeys.public,
    svgPath: SVGAssetsImages.globe,
  ),
  connections(
    type: 'connections',
    displayName: LocaleKeys.connections,
    svgPath: SVGAssetsImages.connection,
  ),
  connectionGroups(
    type: 'connections_and_groups',
    displayName: LocaleKeys.connectionsAndGroups,
    svgPath: SVGAssetsImages.connectionGroup,
  ),
  private(
    type: 'private',
    displayName: LocaleKeys.private,
    svgPath: SVGAssetsImages.private,
  );

  final String type;
  final String svgPath;
  final String displayName;
  const PostVisibilityControlEnum({
    required this.type,
    required this.displayName,
    required this.svgPath,
  });

  factory PostVisibilityControlEnum.fromString(String value) {
    switch (value) {
      case 'public':
        return PostVisibilityControlEnum.public;
      case 'connections':
        return PostVisibilityControlEnum.connections;
      case 'connections_and_groups':
        return PostVisibilityControlEnum.connectionGroups;
      case 'private':
        return PostVisibilityControlEnum.private;
      default:
        throw ArgumentError("Invalid visibility control type: $value");
    }
  }
}

class PostVisibilityControlState extends Equatable {
  final PostVisibilityControlEnum postVisibilityControlEnum;
  const PostVisibilityControlState(this.postVisibilityControlEnum);

  @override
  List<Object> get props => [postVisibilityControlEnum];

  PostVisibilityControlState copyWith(
      {PostVisibilityControlEnum? postVisibilityControlEnum}) {
    return PostVisibilityControlState(
      postVisibilityControlEnum ?? this.postVisibilityControlEnum,
    );
  }
}
