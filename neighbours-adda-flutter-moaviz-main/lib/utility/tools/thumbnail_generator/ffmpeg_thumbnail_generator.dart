import 'dart:io';

// import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_minimal/return_code.dart';
import 'package:snap_local/utility/tools/thumbnail_generator/thumbnail_generator.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FFmpegThumbnailGenerator implements ThumbnailGenerator {
  // @override
  // Future<File> generateThumbnail(File videoFile) async {
  //   try {
  //     final videoFilePath = videoFile.path;
  //     final directoryPath =
  //         videoFilePath.substring(0, videoFilePath.lastIndexOf('/'));
  //     final thumbnailFileName =
  //         'thumbnail_${videoFilePath.split('/').last.split('.').first}.jpg';
  //     final thumbnailFilePath = '$directoryPath/$thumbnailFileName';
  //
  //     // Determine the timestamp for the thumbnail
  //     String timestamp = '00:00:00.008';
  //
  //     // FFmpeg command to extract a frame at the determined timestamp
  //     String ffmpegCommand =
  //         '-i $videoFilePath -ss $timestamp -vframes 1 $thumbnailFilePath';
  //
  //     // Execute the FFmpeg command to generate the thumbnail
  //     return FFmpegKit.execute(ffmpegCommand).then((session) async {
  //       // Return the thumbnail file if the generation was successful
  //       if (ReturnCode.isSuccess(await session.getReturnCode())) {
  //         return File(thumbnailFilePath);
  //       } else {
  //         throw Exception("Error in generating thumbnail");
  //       }
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  @override
  Future<File> getThumbnail(File videoFile) async {
    try {
      final videoFilePath = videoFile.path;
      final directoryPath =
          videoFilePath.substring(0, videoFilePath.lastIndexOf('/'));
      final thumbnailFileName =
          'thumbnail_${videoFilePath.split('/').last.split('.').first}.png';
      final thumbnailFilePath = '$directoryPath/$thumbnailFileName';
        final fileName = await VideoThumbnail.thumbnailFile(
          video: videoFilePath,
          thumbnailPath: thumbnailFilePath,
          imageFormat: ImageFormat.PNG,
        );
      return File(fileName!);
      // // Determine the timestamp for the thumbnail
      // String timestamp = '00:00:00.008';
      //
      // // FFmpeg command to extract a frame at the determined timestamp
      // String ffmpegCommand =
      //     '-i $videoFilePath -ss $timestamp -vframes 1 $thumbnailFilePath';
      //
      // // Execute the FFmpeg command to generate the thumbnail
      // return FFmpegKit.execute(ffmpegCommand).then((session) async {
      //   // Return the thumbnail file if the generation was successful
      //   if (ReturnCode.isSuccess(await session.getReturnCode())) {
      //     return File(thumbnailFilePath);
      //   } else {
      //     throw Exception("Error in generating thumbnail");
      //   }
      // });
      // return;
    } catch (e) {
      rethrow;
    }
  }
}
