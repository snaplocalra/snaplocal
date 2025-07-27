import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'data_upload_status_state.dart';

class DataUploadStatusCubit extends Cubit<DataUploadStatusState> {
  DataUploadStatusCubit()
      : super(const DataUploadStatusState(
            dataUploadStatus: DataUploadStatus.ideal));

  void showProgress({required double progrssValue, required String message}) {
    if (progrssValue == 100) {
      stop();
    } else {
      emit(state.copyWith(
        dataUploadStatus: DataUploadStatus.uploading,
        progressValue: progrssValue,
        message: message,
      ));
    }
  }

  void show() {
    emit(state.copyWith(
      dataUploadStatus: DataUploadStatus.uploading,
      message: "Uploading...",
    ));
  }

  void stop() {
    emit(state.copyWith(dataUploadStatus: DataUploadStatus.ideal));
  }
}
