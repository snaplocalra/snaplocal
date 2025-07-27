// // ignore_for_file: use_build_context_synchronously

// import 'dart:io';

// import 'package:designer/utility/theme_toast.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:snap_local/utility/helper/permanent_permission_denied_dialog.dart';
// import 'package:snap_local/utility/media_player/tools/player_time_formatter.dart';
// import 'package:uuid/uuid.dart';

// class AudioRecorder extends StatefulWidget {
//   const AudioRecorder({super.key});

//   @override
//   State<AudioRecorder> createState() => _AudioRecorderState();
// }

// class _AudioRecorderState extends State<AudioRecorder> {
//   final recorder = FlutterSoundRecorder();

//   bool isRecorderReady = false;

//   @override
//   void initState() {
//     super.initState();
//     initRecorder();
//   }

//   initRecorder() async {
//     await recorder.openRecorder();
//     isRecorderReady = true;
//     await recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
//   }

//   record() async {
//     if (!isRecorderReady) return;

//     await recorder.startRecorder(
//         toFile: 'audio_record_${const Uuid().v4()}.aac');
//   }

//   stop() async {
//     if (!isRecorderReady) return;
//     final path = await recorder.stopRecorder();
//     if (path != null) {
//       final audioFile = File(path);
//       Navigator.pop(context, audioFile);
//     } else {
//       ThemeToast.errorToast("Unable to generate the file");
//       return;
//     }
//   }

//   togglePlay() async {
//     if (recorder.isRecording) {
//       await stop();
//     } else {
//       await record();
//     }
//   }

//   @override
//   void dispose() {
//     recorder.closeRecorder();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         StreamBuilder<RecordingDisposition>(
//           stream: recorder.onProgress,
//           builder: (context, snapshot) {
//             final duration =
//                 snapshot.hasData ? snapshot.data!.duration : Duration.zero;
//             return Text(
//               formatPlayerTime(duration),
//               style: const TextStyle(fontSize: 24),
//             );
//           },
//         ),
//         StatefulBuilder(builder: (context, buttonState) {
//           return Padding(
//             padding: const EdgeInsets.symmetric(vertical: 10),
//             child: GestureDetector(
//               onTap: () async {
//                 await togglePlay();
//                 buttonState(() {});
//               },
//               child: CircleAvatar(
//                 radius: 35,
//                 child: Icon(
//                   recorder.isRecording ? Icons.stop : Icons.mic,
//                   size: 35,
//                 ),
//               ),
//             ),
//           );
//         })
//       ],
//     );
//   }
// }

// Future<File?> openRecorderDialog(BuildContext context) async {
//   final status = await Permission.microphone.request();

//   if (status == PermissionStatus.denied) {
//     ThemeToast.errorToast("Microphone permission not granted");
//     return null;
//   } else if (status == PermissionStatus.permanentlyDenied) {
//     await showPermanentPermissionDeniedHandlerDialog(
//       context,
//       message:
//           "Mic permission has been permanently denied. Please open the settings to grant the necessary permission.",
//     );
//   } else if (status == PermissionStatus.granted) {
//     return showDialog<File?>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => const Dialog(
//         child: Padding(
//           padding: EdgeInsets.symmetric(vertical: 10),
//           child: AudioRecorder(),
//         ),
//       ),
//     );
//   }
//   return null;
// }
