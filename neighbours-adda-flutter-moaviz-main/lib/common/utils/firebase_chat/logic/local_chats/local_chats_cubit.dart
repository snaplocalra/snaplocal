import 'dart:async';
import 'dart:math';
import 'package:designer/utility/theme_toast.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geohash_plus/geohash_plus.dart';
import 'package:snap_local/common/utils/firebase_chat/logic/local_chats/local_chats_state.dart';
import 'package:snap_local/common/utils/firebase_chat/model/blocked_user_history_model.dart';
import 'package:snap_local/common/utils/firebase_chat/model/local_chat_model.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/firebase_chat_setting_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chats_repository.dart';
import 'package:snap_local/common/utils/firebase_chat/repository/local_chat_blocked_users_repository.dart';
import 'package:snap_local/profile/profile_settings/logic/profile_settings/profile_settings_cubit.dart';

import '../../../../../profile/profile_settings/models/profile_settings_model.dart';
import '../../../../../profile/profile_settings/repository/profile_settings_repository.dart';

class LocalChatsCubit extends Cubit<LocalChatsState> {
  final LocalChatsRepository _repository;
  final LocalChatBlockedUsersRepository _blockedUsersRepo;
  List<BlockedUserHistoryModel> _blockHistory = [];
  StreamSubscription? _chatsSubscription;
  List<String> _blockedUserIds = [];
  StreamSubscription? _blockedUsersSubscription;
  ProfileSettingsCubit profileSettingsCubit=ProfileSettingsCubit(ProfileSettingsRepository());

  LocalChatsCubit({
    required LocalChatsRepository repository,
    required LocalChatBlockedUsersRepository blockedUsersRepo,
  })  : _repository = repository,
        _blockedUsersRepo = blockedUsersRepo,
        super(const LocalChatsState()) {
    initializeChats();
  }

  void setCurrentUserId(String userId) {
    print("Setting currentUserId: $userId"); // Debug print
    if (userId.isEmpty) {
      print("Warning: Attempting to set empty userId"); // Debug print
      return;
    }
    
    final newState = state.copyWith(
      currentUserId: userId,
      status: LocalChatsStatus.loaded
    );
    print("New state currentUserId: ${newState.currentUserId}"); // Debug verification
    emit(newState);
    
    startListeningToBlockedUsers(userId);
    loadBlockHistory(userId);
  }

  Future<void> initializeChats() async {
    emit(state.copyWith(status: LocalChatsStatus.loading, searchQuery: null));
    //ProfileSettingsModel profile= await profileSettingsCubit.profileSettingsRepository.fetchProfileSettings();
    _chatsSubscription = _repository.getLocalChats(await getGetHash()).listen(
      (chats) async {
        print('Fetched chats: $chats'); // Debug print
        //final chat30km = await _filter30Km(chats);
        final filteredChats = _filterBlockedUsers(chats);
        emit(state.copyWith(
          chats: filteredChats,
          status: LocalChatsStatus.loaded,
        ));       
      },
      onError: (error) {
        emit(state.copyWith(
          status: LocalChatsStatus.error,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  void startListeningToBlockedUsers(String userId) {
    print('Listening to blocked users for userId: $userId');
    _blockedUsersSubscription?.cancel();
    _blockedUsersSubscription = _blockedUsersRepo
        .getBlockedUserIds(userId)
        .listen((blockedIds) {
          print('Blocked user IDs: $blockedIds');
          _blockedUserIds = blockedIds;
          // Re-filter chats when blocked users list changes
          if (state.status == LocalChatsStatus.loaded) {
            final filteredChats = _filterBlockedUsers(state.chats);
            emit(state.copyWith(chats: filteredChats));
          }
        });
  }

  Future<String> getGetHash() async {
    ProfileSettingsModel profile= await profileSettingsCubit.profileSettingsRepository.fetchProfileSettings();
    // return chats;
    print("------------------------------------------------------");
    print(profile.marketPlaceLocation?.toJson());
    final geohash = GeoHash.encode(
      profile.marketPlaceLocation!.latitude,
      profile.marketPlaceLocation!.latitude,
      precision: 3,
    );
    return geohash.hash;
  }

  Future<List<LocalChatModel>> _filter30Km(List<LocalChatModel> chats) async {
    ProfileSettingsModel profile= await profileSettingsCubit.profileSettingsRepository.fetchProfileSettings();
    // return chats;
    print("------------------------------------------------------");
    print(profile.marketPlaceLocation?.toJson());
    final geohash = GeoHash.encode(
      profile.marketPlaceLocation!.latitude,
      profile.marketPlaceLocation!.latitude,
      precision: 3,
    );
    return chats.where((c) {
      if(c.latitude==null||profile.marketPlaceLocation?.latitude==null) {
        return false;
      } else if(c.geoHash==geohash.hash) {
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  double calculateDistance({
    required double lat1,
    required double lon1,
    required double lat2,
    required double lon2,
  }) {
    const double earthRadiusKm = 6371.0;

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    print("Distance is ${earthRadiusKm*c}km");
    return earthRadiusKm * c;
  }

  double _degreesToRadians(double degree) {
    return degree * pi / 180;
  }

  List<LocalChatModel> _filterBlockedUsers(List<LocalChatModel> chats) {
    if (_blockedUserIds.isEmpty) return chats;

    return chats.where((chat) {
      // Convert Timestamp to DateTime directly using toDate()
      final messageTime = chat.timestamp.toDate();

      print('===========================');
      print('Message Details:');
      print('Sender ID: ${chat.senderId}');
      print('Message: ${chat.message}');
      print('Message Time: $messageTime');

      if (_blockedUserIds.contains(chat.senderId)) {
        print('User is in blocked History list');
        //print(_blockHistory);

        final blockHistory = _blockHistory.where((u) => u.blockedUserId==chat.senderId).toList();
        if (blockHistory.isEmpty) {
          print('No block history found - showing message');
          return true;
        }

        print('Block History Records:');
        for (var history in blockHistory) {
          final blockedAt = DateTime.parse(history.blockedAt);
          final unblockedAt = DateTime.tryParse(history.unblockedAt??"");
          print('- Blocked At: $blockedAt');
          print('- UnBlocked At: $unblockedAt');
          print('- Message Time: $messageTime');

          if (messageTime.isAfter(blockedAt)&&unblockedAt==null) {
            print('Message was sent after blocking - Still Block- hiding message');
            return false;
          }
          else if (unblockedAt!=null&&(messageTime.isAfter(blockedAt)&&messageTime.isBefore(unblockedAt))) {
            print('Message was sent after blocking - Block History- hiding message');
            return false;
          }

          // if (history.unblockedAt != null) {
          //   final unblockedAt = DateTime.parse(history.unblockedAt!);
          //   print('- Unblocked At: $unblockedAt');
          //   print('- Is After Unblock: ${messageTime.isAfter(unblockedAt)}');
          //
          //   if (messageTime.isAfter(unblockedAt)) {
          //     print('Message was sent after unblocking - showing message');
          //     return true;
          //   }
          // }
        }
        print('Message was not falls within blocked period - showing message');
        return true;
      }

      print('User is not blocked - showing message');
      return true;
    }).toList();
  }

  void _filterMessages(List<LocalChatModel> messages) {
    final filteredMessages = messages.where((message) {
      if (!_blockHistory.any((u) => u.blockedUserId==message.senderId)) {
        return true;
      }

      final userBlockHistory = _blockHistory.where((b) => b.blockedUserId==message.senderId).toList();
      final messageTime = DateTime.parse(message.timestamp.toString());
      
      // Check each block record
      for (var blockRecord in userBlockHistory) {
        final blockedAt = DateTime.parse(blockRecord.blockedAt);
        final unblockedAt = blockRecord.unblockedAt != null 
            ? DateTime.parse(blockRecord.unblockedAt!) 
            : null;
        
        // If message is within any blocked period, filter it out
        if (messageTime.isAfter(blockedAt) && 
            (unblockedAt == null || messageTime.isBefore(unblockedAt))) {
          return false;
        }
      }
      return true;
    }).toList();

    emit(state.copyWith(
      status: LocalChatsStatus.loaded,
      chats: filteredMessages,
      filteredChats: state.searchQuery != null ? filteredMessages.where((chat) =>
        chat.message.toLowerCase().contains(state.searchQuery!.toLowerCase()) ||
        chat.senderName.toLowerCase().contains(state.searchQuery!.toLowerCase())
      ).toList() : [],
    ));
  }

  void filterChats(String query) {
    final filtered = state.chats.where((chat) {
      final isNotBlocked = !_blockedUserIds.contains(chat.senderId);
      final matchesQuery = chat.message.toLowerCase().contains(query.toLowerCase()) ||
             chat.senderName.toLowerCase().contains(query.toLowerCase());
      return isNotBlocked && matchesQuery;
    }).toList();

    emit(state.copyWith(
      searchQuery: query,
      filteredChats: filtered,
    ));
  }

  searchQueryClear(){    
    initializeChats();
  }

  void clearFilter() {
    emit(state.copyWith(
      searchQuery: null,
      filteredChats: [],
    ));
  }

  Future<void> sendMessage(LocalChatModel message) async {
    try {
      await _repository.sendLocalChatMessage(message);
    } catch (e) {
      emit(state.copyWith(
        status: LocalChatsStatus.error,
        errorMessage: 'Failed to send message: $e',
      ));
    }
  }

  Future<void> addEmojiReaction(
      String messageId, String emoji, String userId) async {
    try {
      await _repository.updateEmojiReaction(messageId, emoji, state.currentUserId!);
      // Refresh the chats to show updated reactions
      initializeChats();
    } catch (e) {
      emit(state.copyWith(
        status: LocalChatsStatus.error,
        errorMessage: 'Failed to add emoji reaction: $e',
      ));
    }
  }

  Future<void> reportSpam(String messageId) async {
    try {
      // await _repository.reportSpam(messageId);
      // Refresh the chats to show updated status
      initializeChats();
    } catch (e) {
      emit(state.copyWith(
        status: LocalChatsStatus.error,
        errorMessage: 'Failed to report message: $e',
      ));
    }
  }

  @override
  Future<void> close() {
    _chatsSubscription?.cancel();
    _blockedUsersSubscription?.cancel();
    return super.close();
  }

  void loadBlockHistory(String blockedUserId) {
    if (state.currentUserId == null) return;
    
    _blockedUsersRepo
        .getBlockHistory(state.currentUserId!)
        .listen((history) {
      _blockHistory = history;
      //_filterMessages(state.chats);
    });
  }

  Future<void> addBlockHistory(String blockedUserId) async {
    print("Adding block history - currentUserId: ${state.currentUserId}, blockedUserId: $blockedUserId");
    if (state.currentUserId == null || state.currentUserId!.isEmpty) {
      print("Error: currentUserId is null or empty");
      return;
    }
    
    try {
      await _blockedUsersRepo.addBlockHistory(state.currentUserId!, blockedUserId);
      loadBlockHistory(blockedUserId);
    } catch (e) {
      print("Error adding block history: $e");
      emit(state.copyWith(
        status: LocalChatsStatus.error,
        errorMessage: 'Failed to add block history: $e',
      ));
    }
  }

  Future<void> updateBlockHistory(String blockedUserId) async {
    print("Adding block history - currentUserId: ${state.currentUserId}, blockedUserId: $blockedUserId");
    if (state.currentUserId == null || state.currentUserId!.isEmpty) {
      print("Error: currentUserId is null or empty");
      return;
    }

    try {
      await _blockedUsersRepo.updateUnblockHistory(state.currentUserId!, blockedUserId);
      loadBlockHistory(blockedUserId);
    } catch (e) {
      print("Error adding block history: $e");
      emit(state.copyWith(
        status: LocalChatsStatus.error,
        errorMessage: 'Failed to add block history: $e',
      ));
    }
  }
}