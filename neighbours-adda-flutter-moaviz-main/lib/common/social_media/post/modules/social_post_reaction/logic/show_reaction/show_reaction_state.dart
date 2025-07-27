// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'show_reaction_cubit.dart';

class ShowReactionState extends Equatable {
  final bool showEmojiOption;

  ///this is will use to carry the current object id, on which the reaction need to show
  ///on the ui this id will compare will the objects id, and only matched condition the reaction box will visible
  final String? objectId;

  const ShowReactionState({
    this.showEmojiOption = false,
    this.objectId,
  });

  @override
  List<Object?> get props => [showEmojiOption, objectId];

  ShowReactionState copyWith({
    required bool showEmojiOption,
    String? objectId,
  }) {
    return ShowReactionState(
      showEmojiOption: showEmojiOption,
      objectId: objectId,
    );
  }
}
