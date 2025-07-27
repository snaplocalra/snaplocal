import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/compliment_badge/repository/compliment_badge_repository.dart';

part 'manage_compliment_state.dart';

class ManageComplimentCubit extends Cubit<ManageComplimentState> {
  final ComplimentBadgeRepository _complimentBadgeRepository;
  ManageComplimentCubit(
    this._complimentBadgeRepository,
  ) : super(ManageComplimentInitial());

  // Send a compliment to the receiver
  Future<void> sendCompliment({
    required String receiverId,
    required List<String> badgeIdList,
  }) async {
    try {
      emit(ManageComplimentRequestLoading());
      // Send the compliment to the receiver
      await _complimentBadgeRepository.sendCompliment(
        receiverId: receiverId,
        badgeIdList: badgeIdList,
      );
      emit(
        const ManageComplimentRequestSuccess('Compliment sent successfully'),
      );
    } catch (e) {
      emit(ManageComplimentRequestError(e.toString()));
    }
  }

  // Assign a compliment to own profile
  Future<void> setProfileBadge({required String badgeId}) async {
    try {
      emit(ManageComplimentRequestLoading());
      // Assign the compliment to own profile
      await _complimentBadgeRepository.assignCompliment(badgeId: badgeId);
      emit(const ManageComplimentRequestSuccess(
          'Compliment assigned successfully'));
    } catch (e) {
      emit(ManageComplimentRequestError(e.toString()));
    }
  }
}
