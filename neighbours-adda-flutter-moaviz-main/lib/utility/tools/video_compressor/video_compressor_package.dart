// import 'dart:io';
//
// import 'package:snap_local/utility/tools/video_compressor/video_compressor.dart';
// import 'package:video_compress/video_compress.dart';
//
// class VideoCompressorPackage implements VideoCompressor {
//   @override
//   Future<File?> compressVideo(File rawVideo) async {
//     await VideoCompress.compressVideo(
//       rawVideo.path,
//       quality: VideoQuality.LowQuality,
//       deleteOrigin: false, // It's false by default
//       includeAudio: false,
//     ).then((mediaInfo) {
//       if (mediaInfo != null) {
//         return mediaInfo.file!;
//       } else {
//         //Video compress cancelled
//         return null;
//       }
//     });
//     return null;
//   }
// }
