import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snap_local/authentication/auth_shared_preference/authentication_token_shared_pref.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import 'package:snap_local/common/utils/firebase_chat/model/message_request_status_model.dart';

class MessageRequestStatusRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _authSharedPref = AuthenticationTokenSharedPref();

  Future<void> initializeMessageRequestStatus(
    String communicationId,
    String requestReceiver,
  ) async {
    final requestSender = await _authSharedPref.getUserId();

    final messageRequestStatus = MessageRequestStatusModel(
      communicationId: communicationId,
      status: MessageRequestStatus.pending,
      requestSender: requestSender,
      requestReceiver: requestReceiver,
    );
    await _firebaseFirestore
        .collection(FirebasePath.messageRequestStatus)
        .doc(communicationId)
        .set(messageRequestStatus.toMap());
  }

  Future<void> updateRequestAcceptStatus(
    String communicationId,
    MessageRequestStatus status,
  ) async {
    await _firebaseFirestore
        .collection(FirebasePath.messageRequestStatus)
        .doc(communicationId)
        .update({'status': status.name});
  }

  //Stream message request status
  Stream<MessageRequestStatusModel> messageRequestStatusStream(
    String communicationId,
  ) {
    return _firebaseFirestore
        .collection(FirebasePath.messageRequestStatus)
        .doc(communicationId)
        .snapshots()
        .map((snapshot) {
      return MessageRequestStatusModel.fromMap(snapshot.data()!);
    });
  }
}
