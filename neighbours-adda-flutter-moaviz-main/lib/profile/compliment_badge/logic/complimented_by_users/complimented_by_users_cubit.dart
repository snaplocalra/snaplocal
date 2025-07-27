import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/profile/compliment_badge/models/complimented_user_model.dart';
import 'package:snap_local/profile/compliment_badge/repository/complimented_by_user_repository.dart';

part 'complimented_by_users_state.dart';

class ComplimentedByUsersCubit extends Cubit<ComplimentedByUsersState> {
  final ComplimentedByUserRepository complimentedByUserRepository;

  ComplimentedByUsersCubit(this.complimentedByUserRepository)
      : super(ComplimentedByUsersInitial());

  Future<void> fetchComplimentedByUsers({
    required String userId,
    required String badgeId,
  }) async {
    try {
      emit(LoadingComplimentedByUsers());
      final complimentedUsers =
          await complimentedByUserRepository.fetchComplimentedByUsers(
        userId: userId,
        badgeId: badgeId,
      );
      emit(ComplimentedByUsersLoaded(complimentedUsers));
    } catch (e) {
      emit(ComplimentedByUsersError(e.toString()));
    }
  }
}
