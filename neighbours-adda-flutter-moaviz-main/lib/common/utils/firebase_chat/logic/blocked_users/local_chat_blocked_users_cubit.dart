import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/local_chat_blocked_users_repository.dart';

class LocalChatBlockedUsersCubit extends Cubit<List<String>> {
  final LocalChatBlockedUsersRepository _repository;
  StreamSubscription? _blockedUsersSubscription;
  
  LocalChatBlockedUsersCubit(this._repository) : super([]);

  void startListening(String userId) {
    _blockedUsersSubscription?.cancel();
    _blockedUsersSubscription = _repository
        .getBlockedUserIds(userId)
        .listen((blockedIds) => emit(blockedIds));
  }

  // Future<void> blockUser({
  //   required String blockerId,
  //   required String blockedUserId,
  //   required String blockedUserName,
  //   String? blockedUserProfileImage,
  // }) async {
  //   await _repository.blockUser(
  //     blockerId: blockerId,
  //     blockedUserId: blockedUserId,
  //     blockedUserName: blockedUserName,
  //     blockedUserProfileImage: blockedUserProfileImage,
  //   );
  // }

  // Future<void> unblockUser({
  //   required String blockerId,
  //   required String blockedUserId,
  // }) async {
  //   await _repository.unblockUser(
  //     blockerId: blockerId,
  //     blockedUserId: blockedUserId,
  //   );
  // }

  // Future<bool> isUserBlocked({
  //   required String blockerId,
  //   required String blockedUserId,
  // }) async {
  //   return _repository.isUserBlocked(
  //     blockerId: blockerId,
  //     blockedUserId: blockedUserId,
  //   );
  // }

  // @override
  // Future<void> close() {
  //   _blockedUsersSubscription?.cancel();
  //   return super.close();
  // }
}