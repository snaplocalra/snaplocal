part of 'chat_contact_cubit.dart';

class ChatContactState extends Equatable {
  final bool chatDeleteLoading;
  final bool chatDeleteSuccess;

  //clean chat
  final bool chatCleanLoading;
  final bool chatCleanSuccess;

  const ChatContactState({
    this.chatDeleteLoading = false,
    this.chatDeleteSuccess = false,
    this.chatCleanLoading = false,
    this.chatCleanSuccess = false,
  });

  @override
  List<Object> get props => [
        chatDeleteLoading,
        chatDeleteSuccess,
        chatCleanLoading,
        chatCleanSuccess,
      ];

  ChatContactState copyWith({
    bool? chatDeleteLoading,
    bool? chatDeleteSuccess,
    bool? chatCleanLoading,
    bool? chatCleanSuccess,
  }) {
    return ChatContactState(
      chatDeleteLoading: chatDeleteLoading ?? false,
      chatDeleteSuccess: chatDeleteSuccess ?? false,
      chatCleanLoading: chatCleanLoading ?? false,
      chatCleanSuccess: chatCleanSuccess ?? false,
    );
  }
}
