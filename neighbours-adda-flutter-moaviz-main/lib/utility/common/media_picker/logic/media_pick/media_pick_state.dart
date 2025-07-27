// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'media_pick_cubit.dart';

class MediaPickState extends Equatable {
  final bool mediaPickCancelled;
  final String? error;
  final bool dataLoading;
  final MediaPickerModel mediaPickerModel;
  const MediaPickState({
    this.dataLoading = false,
    this.mediaPickCancelled = false,
    required this.mediaPickerModel,
    this.error,
  });

  @override
  List<Object?> get props =>
      [mediaPickerModel, mediaPickCancelled, dataLoading, error];

  MediaPickState copyWith({
    MediaPickerModel? mediaPickerModel,
    bool? dataLoading,
    bool? mediaPickCancelled,
    String? error,
  }) {
    return MediaPickState(
      mediaPickerModel: mediaPickerModel ?? this.mediaPickerModel,
      dataLoading: dataLoading ?? false,
      mediaPickCancelled: mediaPickCancelled ?? false,
      error: error,
    );
  }
}
