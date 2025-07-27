import 'package:equatable/equatable.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_setting_repository.dart';
import 'package:snap_local/profile/connections/repository/profile_conenction_repository.dart';

part 'chat_setting_state.dart';

class ChatSettingCubit extends Cubit<ChatSettingState> {
  final FirebaseChatRepository firebaseChatRepository;
  final FirebaseChatSettingRepository firebaseChatSettingRepository;
  final authSharedPref = AuthenticationTokenSharedPref();

  ChatSettingCubit({
    required this.firebaseChatRepository,
    required this.firebaseChatSettingRepository,
  }) : super(const ChatSettingState());

  ///This method will stream the block status of the sender user
  Stream<bool> streamSenderBlockReceiverStatus(
      {required String receiverUserId}) async* {
    final currentUserId = await authSharedPref.getUserId();

    yield* firebaseChatSettingRepository.streamBlockStatus(
      primaryUserId: currentUserId,
      secondaryUserId: receiverUserId,
    );
  }

  ///This method will stream the block status of the receiver user
  Stream<bool> streamReceiverBlockSenderStatus(
      {required String receiverUserId}) async* {
    final currentUserId = await authSharedPref.getUserId();

    yield* firebaseChatSettingRepository.streamBlockStatus(
      primaryUserId: receiverUserId,
      secondaryUserId: currentUserId,
    );
  }

  ///This method will check the block status for both the user, if block status is true from
  ///any party (ex: if 1st party blocked the other one), then true will return.
  Future<bool> isMessageBlockedByEitherParty(
      {required String receiverUserId}) async {
    final currentUserId = await authSharedPref.getUserId();

    final isReceiverBlockSender =
        await firebaseChatSettingRepository.checkBlockStatus(
      primaryUserId: receiverUserId,
      secondaryUserId: currentUserId,
    );

    final isSenderBlockReceiver =
        await firebaseChatSettingRepository.checkBlockStatus(
      primaryUserId: currentUserId,
      secondaryUserId: receiverUserId,
    );

    //If any side party blocked the other party then return true
    return isSenderBlockReceiver || isReceiverBlockSender;
  }

  Future<void> toggleUserBlock(String receiverUserId) async {
    try {
      emit(state.copyWith(requestLoading: true));

      await Future.wait([
        //Toggle the block in firebase
        firebaseChatSettingRepository.toggleUserBlock(receiverUserId),
        //Toggle the block in server
        ProfileConnectionRepository().toggleBlockUser(receiverUserId)
      ]);

      emit(state.copyWith(requestSuccess: true));
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      Fluttertoast.showToast(
        msg: e.toString(),
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
      emit(state.copyWith());
    }
  }
}
