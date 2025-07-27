import 'dart:io';

// import 'package:ffmpeg_kit_flutter_minimal/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_minimal/return_code.dart';
import 'package:snap_local/utility/tools/video_compressor/video_compressor.dart';
import 'package:video_compress/video_compress.dart';

class FFmpegVideoCompressor implements VideoCompressor {
  // @override
  // Future<File?> compressVideo(File rawVideo) async {
  //   try {
  //     // Output video path
  //     final outputPath =
  //         '${rawVideo.parent.path}/compressed_${rawVideo.path.split('/').last}';
  //
  //     // Input video path
  //     final inputPath = rawVideo.path;
  //
  //     // FFmpeg command to compress the video while maintaining quality
  //     String command =
  //         // '-i $inputPath -vcodec libx264 -crf 20 -preset slow $outputPath';
  //         "-i $inputPath -vf scale=-1,720 -preset veryfast $outputPath";
  //
  //     // Execute the FFmpeg command
  //     return await FFmpegKit.execute(command).then((session) async {
  //       // Return the compressed video file if the compression was successful
  //       return ReturnCode.isSuccess(await session.getReturnCode())
  //           ? File(outputPath)
  //           : null;
  //     });
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  @override
  Future<File?> getCompressVideo(File rawVideo) async {
    try {
      // // Output video path
      // final outputPath =
      //     '${rawVideo.parent.path}/compressed_${rawVideo.path.split('/').last}';
      //
      // // Input video path
      // final inputPath = rawVideo.path;
      MediaInfo? mediaInfo = await VideoCompress.compressVideo(
        rawVideo.path,
        quality: VideoQuality.DefaultQuality,
      );
      return mediaInfo?.file;

      // FFmpeg command to compress the video while maintaining quality
      // String command =
      //     // '-i $inputPath -vcodec libx264 -crf 20 -preset slow $outputPath';
      //     "-i $inputPath -vf scale=-1,720 -preset veryfast $outputPath";
      //
      // // Execute the FFmpeg command
      // return await FFmpegKit.execute(command).then((session) async {
      //   // Return the compressed video file if the compression was successful
      //   return ReturnCode.isSuccess(await session.getReturnCode())
      //       ? File(outputPath)
      //       : null;
      // });
    } catch (e) {
      rethrow;
    }
  }
}
