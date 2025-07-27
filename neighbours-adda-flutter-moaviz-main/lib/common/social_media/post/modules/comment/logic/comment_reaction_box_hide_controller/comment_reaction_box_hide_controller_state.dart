part of 'comment_reaction_box_hide_controller_cubit.dart';

class CommentReactionBoxHideControllerState extends Equatable {
  final bool visible;
  const CommentReactionBoxHideControllerState({this.visible = true});

  @override
  List<Object> get props => [visible];

  CommentReactionBoxHideControllerState copyWith({bool? visible}) {
    return CommentReactionBoxHideControllerState(visible: visible ?? false);
  }
}
