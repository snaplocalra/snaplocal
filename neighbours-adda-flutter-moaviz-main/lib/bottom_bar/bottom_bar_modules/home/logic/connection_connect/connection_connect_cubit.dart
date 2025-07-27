import 'package:designer/utility/theme_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/connection_connect_response.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/repository/home_data_repository.dart';

part 'connection_connect_state.dart';

class ConnectionConnectCubit extends Cubit<ConnectionConnectState> {
  final HomeDataRepository _repository;

  ConnectionConnectCubit(this._repository) : super(ConnectionConnectInitial());

  Future<void> handleConnection(String userId, {bool isCancel = false}) async {
    emit(ConnectionConnectLoading(userId));
    try {
      final response = await _repository.connectConnection(userId, isCancel: isCancel);
      if (response.status == 'valid') {
        emit(ConnectionConnectSuccess(userId));
        ThemeToast.successToast(response.message);
      } else {
        emit(ConnectionConnectError(response.message, userId));
        ThemeToast.errorToast(response.message);
      }
    } catch (e) {
      emit(ConnectionConnectError(e.toString(), userId));
      ThemeToast.errorToast(e.toString());
    }
  }

  Future<void> acceptConnection(String connectionId) async {
    emit(ConnectionConnectLoading(connectionId));
    try {
      final response = await _repository.acceptConnection(connectionId);
      if (response.status == 'valid') {
        emit(ConnectionConnectSuccess(connectionId));
        ThemeToast.successToast(response.message);
      } else {
        emit(ConnectionConnectError(response.message, connectionId));
        ThemeToast.errorToast(response.message);
      }
    } catch (e) {
      emit(ConnectionConnectError(e.toString(), connectionId));
      ThemeToast.errorToast(e.toString());
    }
  }

  Future<void> rejectConnection(String connectionId) async {
    emit(ConnectionConnectLoading(connectionId));
    try {
      final response = await _repository.rejectConnection(connectionId);
      if (response.status == 'valid') {
        emit(ConnectionConnectSuccess(connectionId));
        ThemeToast.successToast(response.message);
      } else {
        emit(ConnectionConnectError(response.message, connectionId));
        ThemeToast.errorToast(response.message);
      }
    } catch (e) {
      emit(ConnectionConnectError(e.toString(), connectionId));
      ThemeToast.errorToast(e.toString());
    }
  }
} 