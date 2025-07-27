import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

abstract class PickMediaImpl {
  Future<List<File>> pickGalleryMedia({
    bool allowMultiple = false,
    required FileType type,
  });
}

class PickMediaByFilePicker implements PickMediaImpl {
  @override
  Future<List<File>> pickGalleryMedia({
    bool allowMultiple = false,
    required FileType type,
  }) async {
    print("|||||||||||||||||||||||||||||||||||||||||||MediaFilePicker|||||||||||||||||||||");

    List<File> rawFiles = [];

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      type: type,
    );

    if (result != null) {
      rawFiles = result.paths.map((path) => File(path!)).toList();
    }

    return rawFiles;
  }
}

class PickMediaByImagePicker implements PickMediaImpl {
  @override
  Future<List<File>> pickGalleryMedia({
    bool allowMultiple = false,
    required FileType type,
  }) async {
    print("|||||||||||||||||||||||||||||||||||||||||||MediaImagePicker|||||||||||||||||||||");
    List<File> rawFiles = [];

    ///If the user allows multiple files to be selected, the user can select multiple files at once.
    if (allowMultiple) {
      //For image type, user can select multiple images
      if (type == FileType.image) {
        final List<XFile> images = await ImagePicker().pickMultiImage();
        rawFiles = images.map((image) => File(image.path)).toList();
      }
      //For video type, or media type, user can select multiple videos
      else if (type == FileType.video || type == FileType.media) {
        final List<XFile> videos = await ImagePicker().pickMultipleMedia();
        rawFiles = videos.map((video) => File(video.path)).toList();
      }
    } 
    
    ///If the user does not allow multiple files to be selected, the user can only select one file at a time.
    ///here separate conditions are used for image, video and media types.
    else {
      if (type == FileType.image) {
        final XFile? image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          rawFiles.add(File(image.path));
        }
      } else if (type == FileType.video) {
        final XFile? video =
            await ImagePicker().pickVideo(source: ImageSource.gallery);
        if (video != null) {
          rawFiles.add(File(video.path));
        }
      } else {
        final XFile? media = await ImagePicker().pickMedia();
        if (media != null) {
          rawFiles.add(File(media.path));
        }
      }
    }

    return rawFiles;
  }
}
