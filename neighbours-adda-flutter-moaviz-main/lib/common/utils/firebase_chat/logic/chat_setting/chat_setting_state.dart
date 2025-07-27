part of 'chat_setting_cubit.dart';

class ChatSettingState extends Equatable {
  final bool requestLoading;
  final bool requestSuccess;
  const ChatSettingState({
    this.requestLoading = false,
    this.requestSuccess = false,
  });

  @override
  List<Object> get props => [requestLoading, requestSuccess];

  ChatSettingState copyWith({
    bool? requestLoading,
    bool? requestSuccess,
  }) {
    return ChatSettingState(
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
    );
  }
}
