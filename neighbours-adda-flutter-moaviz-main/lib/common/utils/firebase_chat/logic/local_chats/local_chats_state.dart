import 'package:equatable/equatable.dart';
import 'package:snap_local/common/utils/firebase_chat/model/local_chat_model.dart';

enum LocalChatsStatus { loading, loaded, error }

class LocalChatsState extends Equatable {
  final LocalChatsStatus status;
  final List<LocalChatModel> chats;
  final List<LocalChatModel> filteredChats;
  final String? errorMessage;
  final String? searchQuery;
  final String? currentUserId;  // Add this field
  final bool toggleBlockLoading;
  final bool toggleBlockRequestSuccess;

  const LocalChatsState({
    this.status = LocalChatsStatus.loading,
    this.chats = const [],
    this.filteredChats = const [],
    this.errorMessage,
    this.searchQuery,
    this.currentUserId,  // Add this parameter
    this.toggleBlockLoading = false,
    this.toggleBlockRequestSuccess = false,
  });

  LocalChatsState copyWith({
    LocalChatsStatus? status,
    List<LocalChatModel>? chats,
    List<LocalChatModel>? filteredChats,
    String? errorMessage,
    String? searchQuery,
    String? currentUserId,  // Add this parameter
    bool? toggleBlockLoading,
    bool? toggleBlockRequestSuccess,
    bool stopAllLoading = false,
  }) {
    return LocalChatsState(
      status: status ?? this.status,
      chats: chats ?? this.chats,
      filteredChats: filteredChats ?? this.filteredChats,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      currentUserId: currentUserId ?? this.currentUserId,  // Add this field
      toggleBlockLoading: stopAllLoading ? false : toggleBlockLoading ?? this.toggleBlockLoading,
      toggleBlockRequestSuccess: stopAllLoading ? false : toggleBlockRequestSuccess ?? this.toggleBlockRequestSuccess,
    );
  }


  @override
  List<Object?> get props => [chats, status, errorMessage, searchQuery, filteredChats, 
  currentUserId, toggleBlockLoading, toggleBlockRequestSuccess];
}