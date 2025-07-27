part of 'chat_controller_cubit.dart';

class ChatControllerState extends Equatable {
  final bool chatInitLoading;
  final bool messageSendLoading;
  final CommunicationModel? communicationModel;
  final bool isSendMessageRequestSuccess;
  const ChatControllerState({
    this.chatInitLoading = false,
    this.messageSendLoading = false,
    this.communicationModel,
    this.isSendMessageRequestSuccess = false,
  });

  bool get isCommunicationInitialized => communicationModel != null;

  @override
  List<Object?> get props => [
        chatInitLoading,
        messageSendLoading,
        communicationModel,
        isSendMessageRequestSuccess,
      ];

  ChatControllerState copyWith({
    bool? chatInitLoading,
    bool? messageSendLoading,
    CommunicationModel? communicationModel,
    bool? isSendMessageRequestSuccess,
  }) {
    return ChatControllerState(
      chatInitLoading: chatInitLoading ?? false,
      messageSendLoading: messageSendLoading ??
          this.messageSendLoading, //Do not change the value of messageSendLoading
      communicationModel: communicationModel ?? this.communicationModel,
      isSendMessageRequestSuccess: isSendMessageRequestSuccess ?? false,
    );
  }
}
