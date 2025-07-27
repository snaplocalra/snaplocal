part of 'data_upload_status_cubit.dart';

enum DataUploadStatus { ideal, uploading }

class DataUploadStatusState extends Equatable {
  final DataUploadStatus dataUploadStatus;
  final double? progressValue;
  final String? message;
  const DataUploadStatusState({
    required this.dataUploadStatus,
    this.progressValue,
    this.message,
  });

  @override
  List<Object?> get props => [dataUploadStatus, progressValue, message];

  DataUploadStatusState copyWith({
    DataUploadStatus? dataUploadStatus,
    double? progressValue,
    String? message,
  }) {
    return DataUploadStatusState(
      dataUploadStatus: dataUploadStatus ?? this.dataUploadStatus,
      progressValue: progressValue ?? this.progressValue,
      message: message ?? this.message,
    );
  }
}
