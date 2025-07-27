// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_preview_view_cubit.dart';

class PostPreviewViewState extends Equatable {
  final bool visibility;
  const PostPreviewViewState({
    this.visibility = false,
  });

  @override
  List<Object> get props => [visibility];

  PostPreviewViewState copyWith({bool? visibility}) {
    return PostPreviewViewState(visibility: visibility ?? false);
  }
}
