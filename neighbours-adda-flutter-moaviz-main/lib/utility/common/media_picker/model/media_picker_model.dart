import 'package:equatable/equatable.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';

class MediaPickerModel extends Equatable {
  final List<MediaFileModel> pickedFiles;

  const MediaPickerModel({required this.pickedFiles});

  @override
  List<Object?> get props => [pickedFiles];
}
