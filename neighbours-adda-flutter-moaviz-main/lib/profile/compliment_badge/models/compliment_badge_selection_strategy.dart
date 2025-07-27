import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';

abstract class ComplimentBadgeSelectionStrategy {
  void selectBadge(
    List<ComplimentBadgeModel> badges,
    String badgeId,
  );
}

class MultiSelectComplimentBadgeSelectionStrategy
    implements ComplimentBadgeSelectionStrategy {
  @override
  void selectBadge(
    List<ComplimentBadgeModel> badges,
    String badgeId,
  ) {
    for (var badge in badges) {
      if (badge.id == badgeId) {
        badge.isSelected = !badge.isSelected;
        return;
      }
    }
  }
}

class SingleComplimentBadgeSelectionStrategy
    implements ComplimentBadgeSelectionStrategy {
  @override
  void selectBadge(
    List<ComplimentBadgeModel> badges,
    String badgeId,
  ) {
    for (var badge in badges) {
      if (badge.id == badgeId) {
        badge.isSelected = true;
      } else {
        // Change the state of the previously selected badge
        badge.isSelected = false;
      }
    }
  }
}
