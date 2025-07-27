// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:designer/utility/theme_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import 'package:flutter/foundation.dart';
// import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_minimal/return_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_native_video_trimmer/flutter_native_video_trimmer.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sm_camera/sm_image/screen/sm_image_screen.dart';
import 'package:snap_local/utility/common/media_picker/model/file_media_model.dart';
import 'package:snap_local/utility/common/media_picker/model/media_picker_model.dart';
import 'package:snap_local/utility/common/media_picker/model/pick_media_impl.dart';
import 'package:snap_local/utility/custom_exception/media_picker_exception.dart';
import 'package:snap_local/utility/helper/permanent_permission_denied_dialog.dart';
import 'package:snap_local/utility/tools/file_format_checker.dart';
import 'package:snap_local/utility/tools/file_format_converter.dart';
import 'package:snap_local/utility/tools/thumbnail_generator/ffmpeg_thumbnail_generator.dart';
import 'package:snap_local/utility/tools/video_compressor/video_compressor.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

part 'media_pick_state.dart';

class MediaPickCubit extends Cubit<MediaPickState> {
  MediaPickCubit()
      : super(
          const MediaPickState(
            mediaPickerModel: MediaPickerModel(pickedFiles: <MediaFileModel>[]),
          ),
        );

  Future<int> _getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  Future<bool> _greaterThanAndroid13() async {
    if (Platform.isAndroid) {
      final androidSdkVersion = await _getAndroidSdkVersion();
      if (androidSdkVersion >= 33) {
        return true;
      }
    }
    return false;
  }

  Future<bool> allowMediaPick({BuildContext? context}) async {
    bool allow = false;

    if (await _greaterThanAndroid13()) {
      return true;
    }
    final status = await Permission.storage.request();

    if (status.isGranted) {
      allow = true;
    } else if (status.isPermanentlyDenied) {
      if (context != null) {
        await showPermanentMediaDeniedHandlerDialog(context);
      }
    }

    return allow;
  }

  int? _allowedMediaPickCount;
  final _videoTrimmer = VideoTrimmer();


  //set the allowed media pick count
  void setAllowedMediaPickCount(int count) {
    _allowedMediaPickCount = count;
  }

  int get allowedMediaPickCountValue => _allowedMediaPickCount ?? 0;

  void _mediaPickCancelled({String? error}) {
    emit(state.copyWith(
      mediaPickCancelled: true,
      error: error,
    ));
    return;
  }

  void _emitPickedMedia(
    List<MediaFileModel> pickedMediaList, {
    ///If true, then send the 1st element if the list is not empty
    bool singleElement = false,
  }) {
    if (pickedMediaList.isNotEmpty) {
      emit(
        state.copyWith(
          mediaPickerModel: MediaPickerModel(
            pickedFiles:
                singleElement ? [pickedMediaList.first] : pickedMediaList,
          ),
        ),
      );
      return;
    } else {
      emit(state.copyWith(
          mediaPickerModel: const MediaPickerModel(pickedFiles: [])));
      return;
    }
  }

  Future<List<ImageFileMediaModel>> _compressImages(
      List<MediaFileModel> rawImages) async {
    try {
      final List<ImageFileMediaModel> compressedImages = [];

      for (var rawImage in rawImages) {
        if (rawImage is! ImageFileMediaModel) {
          throw MediaPickerException("Unsupported image format");
        }

        Directory appDir = await getTemporaryDirectory();
        final tempFileName = rawImage.imageFile.path.split("/").last;
        await FlutterImageCompress.compressWithList(
          await compute(
            fileToUint8List,
            rawImage.imageFile,
          ),
          format: CompressFormat.jpeg,
          quality: 30,
          minHeight: 1080,
          minWidth: 1080,
        ).then(
          (result) async {
            String targetDirectoryPath =
                "${appDir.path}/compressed_$tempFileName";

            final fileImage = await uint8ListToFile(
              result,
              targetDirectoryPath,
            );

            compressedImages.add(ImageFileMediaModel(imageFile: fileImage));
          },
        );
      }

      return compressedImages;
    } catch (e) {
      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (e is CompressError) {
        throw MediaPickerException(e.message.toString());
      } else {
        rethrow;
      }
    }
  }

  Future<bool> _isFileSizeGreaterThan10MB(File file) async {
    int fileSizeInBytes = await file.length();
    int maxSizeInBytes = 10 * 1024 * 1024; // 10MB in bytes
    return fileSizeInBytes > maxSizeInBytes;
  }

  //Trim video
  Future<void> showPermanentMediaDeniedHandlerDialog(
      BuildContext context) async {
    await showPermanentPermissionDeniedHandlerDialog(
      context,
      message:
          "Permission has been permanently denied. Please open the settings to grant the necessary permission.",
    );
  }

  ///This will return true if the space is available to pick the media
  bool _mediaPickValidator({
    required List<MediaFileModel> pickedFiles,
    required int maxPickLimit,
  }) {
    //1st check how many space is left to pick the media
    final int availableSpace = _allowedMediaPickCount ??
        maxPickLimit - state.mediaPickerModel.pickedFiles.length;

    //If the picked media is less than or equal to the available space then proceed
    if (pickedFiles.length <= availableSpace) {
      return true;
    } else {
      //Show the error message that, only this number of media left to pick
      ThemeToast.errorToast("Only $availableSpace media left to pick.");
      return false;
    }
  }

  Future<File?> trimFirst60Seconds(File videoFile) async {
    try {
      // 1. Load a video file
      await _videoTrimmer.loadVideo(videoFile.path);

      // 3. Trim the video (first 60 seconds)
      final trimmedPath = await _videoTrimmer.trimVideo(
        startTimeMs: 0,
        endTimeMs: 60000,
      );
      print('Video trimmed to: $trimmedPath');

      if(trimmedPath!=null) {
        return File(trimmedPath);
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;

  }

  // Future<File?> _trimFirst60Seconds(File videoFile) async {
  //   String outputPath =
  //       '${videoFile.parent.path}/trimmed_${videoFile.path.split('/').last}';
  //
  //   // FFmpeg command to trim the first 60 seconds
  //   String ffmpegCommand =
  //       '-i ${videoFile.path} -ss 0 -t 60 -c copy $outputPath';
  //
  //   return await FFmpegKit.execute(ffmpegCommand).then((session) async {
  //     final returnCode = await session.getReturnCode();
  //     if (ReturnCode.isSuccess(returnCode)) {
  //       return File(outputPath);
  //     } else {
  //       return null;
  //     }
  //   });
  // }

  //Handle video file
  Future<VideoFileMediaModel> _handleVideoFiles(
    MediaFileModel videoFile, {
    VideoCompressor? videoCompressor,
    bool enable60SecsTrim = true,
  }) async {
    try {
      if (videoFile is! VideoFileMediaModel) {
        throw MediaPickerException("Unsupported video format");
      }

      File processedVideo = (videoFile).videoFile;

      if (enable60SecsTrim) {
        //1. trim the video file to 60 seconds
        final trimmedVideoFile = await trimFirst60Seconds(videoFile.videoFile);

        if (trimmedVideoFile == null) {
          throw MediaPickerException("Failed to trim the video file");
        } else {
          processedVideo = trimmedVideoFile;
        }
      }

      if (videoCompressor != null) {
        // 2. compress the video file
        final compressedVideoFile =
            await videoCompressor.getCompressVideo(processedVideo);

        if (compressedVideoFile != null) {
          //3. Check the file size
          if (await _isFileSizeGreaterThan10MB(compressedVideoFile)) {
            throw MediaPickerException(
                "${compressedVideoFile.path.split("/").last} size exceeds 10MB. Please choose a file that is 10MB or smaller.");
          }
          //4. return the compressed video file
          return VideoFileMediaModel(
            videoFile: compressedVideoFile,
            thumbnailFile: videoFile.thumbnailFile,
          );
        } else {
          throw MediaPickerException("Failed to compress the video file");
        }
      } else {
        return VideoFileMediaModel(
          videoFile: processedVideo,
          thumbnailFile: videoFile.thumbnailFile,
        );
      }
    } catch (e) {
      // if (e is MediaPickerException) {
      // }
      rethrow;
    }
  }

  Future<void> pickGalleryMedia(
    BuildContext context, {
    bool allowMultiple = false,
    required FileType type,

    ///If the limit is set then it will compare the picked media with the limit
    ///and the available space to pick the media
    int? maxMediaPickLimit,
  }) async {
    bool showErrorToast = true;
    try {
      print("|||||||||||||||||||||||||||||||||||||||||||MediaPicked|||||||||||||||||||||");
      //from sdk 33 storage permission is not required
      if (await allowMediaPick(context: context)) {
        print("|||||||||||||||||||||||||||||||||||||||||||MediaAllowed|||||||||||||||||||||");
        //if platform is android and sdk is 29 (Android 10) then use image picker
        List<MediaFileModel> rawFiles = [];

        late PickMediaImpl mediaPicker;
        // if (Platform.isAndroid && await _getAndroidSdkVersion() <= 29) {
        //   mediaPicker = PickMediaByImagePicker();
        // } else {
        //   mediaPicker = PickMediaByFilePicker();
        // }
        mediaPicker = PickMediaByImagePicker();
        print("|||||||||||||||||||||||||||||||||||||||||||MediaPickedDone|||||||||||||||||||||");
        rawFiles = await mediaPicker
            .pickGalleryMedia(type: type, allowMultiple: allowMultiple)
            .then((value) => Future.wait(
                value.map((e) async => await _fromFileExtension(e)).toList()));
        print("|||||||||||||||||||||||||||||||||||||||||||MediaThumb|||||||||||||||||||||");
        if (rawFiles.isNotEmpty) {
          print("|||||||||||||||||||||||||||||||||||||||||||MediaExist|||||||||||||||||||||");
          bool proceed = true;
          //Check the media pick limit if the limit is set
          if (maxMediaPickLimit != null) {
            proceed = _mediaPickValidator(
              pickedFiles: rawFiles,
              maxPickLimit: maxMediaPickLimit,
            );
          }
          print("|||||||||||||||||||||||||||||||||||||||||||MediaMax|||||||||||||||||||||");


          if (proceed) {
            print("|||||||||||||||||||||||||||||||||||||||||||MediaProcessed|||||||||||||||||||||");
            //Emit the state to show the loading indicator
            emit(state.copyWith(dataLoading: true));

            //Picked files handling
            List<MediaFileModel> files = [];

            //For multiple media
            if (type == FileType.media) {
              for (var file in rawFiles) {
                if (file is ImageFileMediaModel) {
                  files.addAll(await _compressImages([file]));
                } else if (file is VideoFileMediaModel) {
                  files.add(await _handleVideoFiles(file));
                } else {
                  throw MediaPickerException("Unsupported media format");
                }
              }
            }
            //For single media
            else if (type == FileType.image) {
              files = await _compressImages(rawFiles);
            } else if (type == FileType.video) {
              // final result = await _handleVideoFiles(rawFiles);
              // files = result;
              for (var file in rawFiles) {
                files.add(await _handleVideoFiles(file));
              }
            } else if (type == FileType.audio) {
              files = rawFiles;
            } else {
              throw MediaPickerException("Unsupported media format");
            }

            if (allowMultiple) {
              late List<MediaFileModel> pickedMediaList;
              if (state.mediaPickerModel.pickedFiles.isNotEmpty) {
                //add the new images with the previous images.
                state.mediaPickerModel.pickedFiles.addAll(files);
                pickedMediaList = state.mediaPickerModel.pickedFiles;
              } else {
                pickedMediaList = files;
              }
              //Send multiple media
              _emitPickedMedia(pickedMediaList);
            } else {
              //Send single media
              _emitPickedMedia(files, singleElement: true);
            }

            return;
          }
        }
        else {
          print("|||||||||||||||||||||||||||||||||||||||||||MediaNull|||||||||||||||||||||");
          throw MediaPickerException("No file selected");
        }
        return;
      } else {
        throw ("Permission denied");
      }
    } catch (e) {
      if (e is MediaPickerException) {
        _mediaPickCancelled(error: e.message);
        return;
      }

      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      if (showErrorToast) {
        ThemeToast.errorToast(e.toString());
      }
    }
  }

  Future<void> pickFiles({List<String>? allowedExtensions}) async {
    try {
      if (await allowMediaPick()) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: allowedExtensions,
        );

        if (result != null) {
          emit(state.copyWith(dataLoading: true));
          List<File> files = result.paths.map((path) => File(path!)).toList();

          emit(
            state.copyWith(
              mediaPickerModel: MediaPickerModel(
                pickedFiles: [GeneralFileMediaModel(generalFile: files.first)],
              ),
            ),
          );

          return;
        } else {
          throw MediaPickerException("No file selected");
        }
      } else {
        throw ("Permission denied");
      }
    } catch (e) {
      if (e is MediaPickerException) {
        _mediaPickCancelled(error: e.message);
        return;
      }

      // Record the error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
    }
  }


  Future<void> clickImage(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? xFileResult = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (xFileResult == null) {
        _mediaPickCancelled(error: "No image captured.");
        return;
      }

      emit(state.copyWith(dataLoading: true));

      final compressedImage = await _compressImages([
        ImageFileMediaModel(imageFile: File(xFileResult.path))
      ]).then((value) => value.first);

      final newFiles = [
        ...state.mediaPickerModel.pickedFiles,
        compressedImage
      ];

      emit(state.copyWith(
        mediaPickerModel: MediaPickerModel(pickedFiles: newFiles),
        dataLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(dataLoading: false));
      FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
      ThemeToast.errorToast(e.toString());
      _mediaPickCancelled();
    }
  }

  // Future<void> clickImage(BuildContext context) async {
  //   try {
  //     XFile? xFileResult = await SMImagePicker().captureImage(context);
  //     if (xFileResult == null) {
  //       return;
  //     }
  //     emit(state.copyWith(dataLoading: true));
  //
  //     final compressedImage = await _compressImages(
  //       [ImageFileMediaModel(imageFile: File(xFileResult.path))],
  //     ).then((value) => value.first);
  //
  //     late List<MediaFileModel> pickedImages;
  //     if (state.mediaPickerModel.pickedFiles.isNotEmpty) {
  //       //add the new images with the previous images.
  //       state.mediaPickerModel.pickedFiles.add(compressedImage);
  //       pickedImages = state.mediaPickerModel.pickedFiles;
  //     } else {
  //       pickedImages = [compressedImage];
  //     }
  //
  //     emit(state.copyWith(
  //       mediaPickerModel: MediaPickerModel(pickedFiles: pickedImages),
  //     ));
  //
  //     return;
  //   } catch (e) {
  //     // Record the error in Firebase Crashlytics
  //     FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
  //     ThemeToast.errorToast(e.toString());
  //     // User canceled the picker
  //     _mediaPickCancelled();
  //   }
  // }

  Future<void> removeMedia({required MediaFileModel selectedFile}) async {
    if (state.mediaPickerModel.pickedFiles.isNotEmpty) {
      emit(state.copyWith(dataLoading: true));

      state.mediaPickerModel.pickedFiles
          .removeWhere((media) => media == selectedFile);

      emit(state.copyWith(
          mediaPickerModel: MediaPickerModel(
        pickedFiles: state.mediaPickerModel.pickedFiles,
      )));
    }
  }

  Future<void> clearMedia() async {
    emit(
      state.copyWith(
        mediaPickerModel: const MediaPickerModel(pickedFiles: []),
      ),
    );
  }

  //File media model from file extension
  Future<MediaFileModel> _fromFileExtension(File file) async {
    print("|||||||||||||||||||||||||||||||||||||||||||MediaFileExtension|||||||||||||||||||||");
    final fileExtension = FileExtensionChecker.extractExtension(file.path);
    switch (fileExtension) {
      case FileExtension.image:
        return ImageFileMediaModel(imageFile: file);
      case FileExtension.video:
        return VideoFileMediaModel(
          videoFile: file,
          thumbnailFile:
              await FFmpegThumbnailGenerator().getThumbnail(file),
        );
      default:
        return GeneralFileMediaModel(generalFile: file);
    }
  }
}
