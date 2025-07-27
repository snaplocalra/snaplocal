import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/connection_ignore_response.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

part 'connection_ignore_state.dart';

class ConnectionIgnoreCubit extends Cubit<ConnectionIgnoreState> {
  final HomeDataRepository _repository;

  ConnectionIgnoreCubit(this._repository) : super(ConnectionIgnoreInitial());

  Future<void> ignoreConnection(String userId) async {
    emit(ConnectionIgnoreLoading(userId));
    try {
      final response = await _repository.ignoreConnection(userId);
      if (response.status == 'valid') {
        emit(ConnectionIgnoreSuccess(userId));
      } else {
        emit(ConnectionIgnoreError(response.message, userId));
      }
    } catch (e) {
      emit(ConnectionIgnoreError(e.toString(), userId));
    }
  }
} 