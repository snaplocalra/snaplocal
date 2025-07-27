import 'dart:convert';

import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';

class ManagePollOptionList {
  final List<ManagePollOptionModel> data;
  ManagePollOptionList({this.data = const []});

  ///return true, if any of 1st 2 options name is empty
  bool get minimumOptionEmpty {
    if (data.length >= 2) {
      return data[0].optionName.trim().isEmpty ||
          data[1].optionName.trim().isEmpty;
    }
    return false;
  }

  ///return true, if any option name is empty
  bool get emptyOptionAvailable =>
      data.any((element) => element.optionName.trim().isEmpty);

  bool get isEmptyImageAvailable =>
      data.any((element) => element.fileImage == null);

  List<Map<String, dynamic>> toMap() {
    return data.map((x) => x.toMap()).toList();
  }

  String toJson() => json.encode(toMap());
}

class ManagePollOptionModel {
  final String optionId;
  String optionName;

  //to show data during creation
  MediaFileModel? fileImage;

  String? optionImage;

  ManagePollOptionModel({
    required this.optionId,
    required this.optionName,
    this.fileImage,
    this.optionImage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'option_id': optionId,
      'option_name': optionName,
      'option_image': optionImage?.split('/').last,
    };
  }

  //copyWith method to update the object
  ManagePollOptionModel copyWith({
    String? optionId,
    String? optionName,
    MediaFileModel? fileImage,
    String? optionImage,
  }) {
    return ManagePollOptionModel(
      optionId: optionId ?? this.optionId,
      optionName: optionName ?? this.optionName,
      fileImage: fileImage ?? this.fileImage,
      optionImage: optionImage ?? this.optionImage,
    );
  }
}
