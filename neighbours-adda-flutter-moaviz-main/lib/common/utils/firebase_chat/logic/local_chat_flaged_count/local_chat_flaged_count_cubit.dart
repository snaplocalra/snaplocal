import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repository/report_local_chat_spam_repository.dart';
import '../../model/local_chat_flag_response.dart';
import 'local_chat_flaged_count_state.dart';

class LocalChatFlagedCountCubit extends Cubit<LocalChatFlagedCountState> {
  final ReportLocalChatSpamRepository _repository;
  Timer? _refreshTimer;

  LocalChatFlagedCountCubit({
    required ReportLocalChatSpamRepository repository,
  })  : _repository = repository,
        super(const LocalChatFlagedCountState());

  void startListening(String userId) {
    emit(state.copyWith(isLoading: true));
    _fetchFlagCount(userId);

    // Refresh every 30 seconds
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _fetchFlagCount(userId);
    });
  }

  Future<void> _fetchFlagCount(String userId) async {
    try {
      print('Fetching flag count for user: $userId');
      emit(state.copyWith(isLoading: true));
      // Fetch the flag count from the repository 
      final response = await _repository.getFlagCount(userId);
      print('object: ${response.data.access}, message: ${response.data.message}');
      // Update the state with the fetched data
      
      emit(state.copyWith(
        flagCount: response.data.count,
        hasAccess: response.data.access,
        status: response.status,
        message: response.data.message,
        isLoading: false,
      ));
    } catch (e) {
      print('Error fetching flag count: $e');
      emit(state.copyWith(
        error: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> updateFlagCount({
    required String userId,
    required String messageId,
  }) async {
    try {
      await _repository.updateFlagCount(
        userId: userId,
        messageId: messageId,
      );
      await _fetchFlagCount(userId);
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _refreshTimer?.cancel();
    return super.close();
  }
}