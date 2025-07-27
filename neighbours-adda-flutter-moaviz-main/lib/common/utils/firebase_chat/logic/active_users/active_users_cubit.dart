import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:snap_local/common/utils/firebase_chat/constant/firebase_table_name.dart';
import 'package:snap_local/common/utils/firebase_chat/model/active_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// State
class ActiveUsersState extends Equatable {
  final List<ActiveUserModel> activeUsers;
  final bool isLoading;
  final String? error;

  const ActiveUsersState({
    this.activeUsers = const [],
    this.isLoading = false,
    this.error,
  });

  ActiveUsersState copyWith({
    List<ActiveUserModel>? activeUsers,
    bool? isLoading,
    String? error,
  }) {
    return ActiveUsersState(
      activeUsers: activeUsers ?? this.activeUsers,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [activeUsers, isLoading, error];
}

// Cubit
class ActiveUsersCubit extends Cubit<ActiveUsersState> {
  final FirebaseFirestore _firestore;
  StreamSubscription? _activeUsersSubscription;

  ActiveUsersCubit({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(const ActiveUsersState()) {
    _initializeActiveUsers();
  }

  void _initializeActiveUsers() {
    emit(state.copyWith(isLoading: true));

    _activeUsersSubscription = _firestore
        .collection(FirebasePath.users)
        .where('is_online', isEqualTo: true)
        .snapshots()
        .listen(
      (snapshot) {
        final activeUsers = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return ActiveUserModel.fromJson(data);
        }).toList();

        emit(state.copyWith(
          activeUsers: activeUsers,
          isLoading: false,
        ));
      },
      onError: (error) {
        emit(state.copyWith(
          error: error.toString(),
          isLoading: false,
        ));
      },
    );
  }

  @override
  Future<void> close() {
    _activeUsersSubscription?.cancel();
    return super.close();
  }
} 