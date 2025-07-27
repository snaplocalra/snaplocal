import 'package:snap_local/profile/compliment_badge/models/compliment_badge_selection_strategy.dart';

abstract class ComplimentType {
  final String dialogHeadingText;
  final ComplimentBadgeSelectionStrategy selectionStrategy;
  ComplimentType(
    this.dialogHeadingText,
    this.selectionStrategy,
  );
}

//Send a compliment to the receiver
class SendCompliment extends ComplimentType {
  final String receiverId;

  SendCompliment({
    required this.receiverId,
    required ComplimentBadgeSelectionStrategy selectionStrategy,
    required String dialogHeadingText,
  }) : super(dialogHeadingText, selectionStrategy);
}

//Own profile compliment
class OwnProfileCompliment extends ComplimentType {
  OwnProfileCompliment({
    required ComplimentBadgeSelectionStrategy selectionStrategy,
    required String dialogHeadingText,
  }) : super(dialogHeadingText, selectionStrategy);
}
