import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_model.dart';
import 'package:snap_local/profile/compliment_badge/models/compliment_badge_selection_strategy.dart';
import 'package:snap_local/profile/compliment_badge/repository/compliment_badge_repository.dart';

part 'compliment_badge_state.dart';

class ComplimentBadgeCubit extends Cubit<ComplimentBadgeState> {
  final ComplimentBadgeRepository _complimentBadgeRepository;
  ComplimentBadgeCubit(this._complimentBadgeRepository)
      : super(ComplimentBadgeInitial());

  Future<void> fetchComplimentBadgesSender({required String userId}) async {
    try {
      emit(ComplimentBadgeLoading());
      final complimentBadges = await _complimentBadgeRepository
          .fetchComplimentBadgesSender(userId: userId);
      emit(ComplimentBadgeLoaded(complimentBadges));
    } catch (e) {
      emit(ComplimentBadgeError(e.toString()));
    }
  }

  // Fetch the compliment badges for the receiver
  Future<void> fetchOwnProfileComplimentBadges() async {
    try {
      emit(ComplimentBadgeLoading());
      final complimentBadges =
          await _complimentBadgeRepository.fetchOwnProfileComplimentBadges();
      emit(ComplimentBadgeLoaded(complimentBadges));
    } catch (e) {
      emit(ComplimentBadgeError(e.toString()));
    }
  }

  // Select the badge
  void selectBadge({
    required ComplimentBadgeSelectionStrategy selectionStrategy,
    required String badgeId,
  }) {
    try {
      if (state is ComplimentBadgeLoaded) {
        final complimentBadges =
            (state as ComplimentBadgeLoaded).complimentBadges;
        emit(ComplimentBadgeLoading());
        selectionStrategy.selectBadge(complimentBadges, badgeId);
        emit(ComplimentBadgeLoaded(complimentBadges));
      }
    } catch (e) {
      emit(ComplimentBadgeError(e.toString()));
    }
  }
}
