// import 'package:flutter/material.dart';
// import 'package:snap_local/utility/media_player/audio/audio_player_widget.dart';

// class BubbleChatAudio extends StatelessWidget {
//   final String audioUrl;
//   final double bubbleRadius;
//   final bool isSender;
//   final Color color;
//   final Color loadCircleColor;
//   final String text;
//   final String? timeStampText;
//   final bool tail;
//   final bool sent;
//   final bool delivered;
//   final bool seen;

//   final TextStyle timeStampStyle;
//   final TextStyle textStyle;

//   const BubbleChatAudio({
//     super.key,
//     required this.audioUrl,
//     required this.text,
//     this.timeStampText,
//     this.bubbleRadius = 16,
//     this.isSender = true,
//     this.color = Colors.white70,
//     this.loadCircleColor = Colors.white,
//     this.tail = true,
//     this.sent = false,
//     this.delivered = false,
//     this.seen = false,
//     this.textStyle = const TextStyle(
//       color: Colors.black87,
//       fontSize: 16,
//     ),
//     this.timeStampStyle = const TextStyle(
//       color: Color.fromRGBO(164, 169, 172, 1),
//       fontSize: 12,
//     ),
//   });

//   ///chat bubble builder method
//   @override
//   Widget build(BuildContext context) {
//     bool stateTick = false;
//     Icon? stateIcon;
//     if (sent) {
//       stateTick = true;
//       stateIcon = const Icon(
//         Icons.done,
//         size: 18,
//         color: Color(0xFF97AD8E),
//       );
//     }
//     if (delivered) {
//       stateTick = true;
//       stateIcon = const Icon(
//         Icons.done_all,
//         size: 18,
//         color: Color(0xFF97AD8E),
//       );
//     }
//     if (seen) {
//       stateTick = true;
//       stateIcon = const Icon(
//         Icons.done_all,
//         size: 18,
//         color: Color(0xFF92DEDA),
//       );
//     }

//     return Align(
//       alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
//         child: Container(
//           padding: const EdgeInsets.all(2),
//           constraints:
//               BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(bubbleRadius),
//               topRight: Radius.circular(bubbleRadius),
//               bottomLeft: Radius.circular(
//                 tail
//                     ? isSender
//                         ? bubbleRadius
//                         : 0
//                     : 16,
//               ),
//               bottomRight: Radius.circular(
//                 tail
//                     ? isSender
//                         ? 0
//                         : bubbleRadius
//                     : 16,
//               ),
//             ),
//           ),
//           child: Column(
//             children: [
//               //Audio player
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(bubbleRadius),
//                   color: isSender
//                       ? const Color.fromRGBO(2, 81, 68, 0.6)
//                       : const Color.fromRGBO(29, 40, 47, 0.8),
//                 ),
//                 padding: const EdgeInsets.all(8),
//                 margin: const EdgeInsets.only(bottom: 4),
//                 child: AudioPlayerWidget(
//                   key: key,
//                   audioUrl: audioUrl,
//                   iconColor: Colors.white,
//                   textColor: Colors.white,
//                 ),
//               ),
//               Wrap(
//                 alignment: WrapAlignment.spaceBetween,
//                 crossAxisAlignment: WrapCrossAlignment.end,
//                 children: <Widget>[
//                   Visibility(
//                     visible: text.isNotEmpty,
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 12),
//                       child: Text(
//                         text,
//                         style: textStyle,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       if (timeStampText != null)
//                         Padding(
//                           padding: EdgeInsets.fromLTRB(
//                             6,
//                             text.isNotEmpty ? 0 : 6,
//                             stateTick ? 2 : 6,
//                             6,
//                           ),
//                           child: Text(
//                             timeStampText!,
//                             style: timeStampStyle,
//                           ),
//                         ),
//                       if (stateIcon != null && stateTick)
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(2, 6, 6, 6),
//                           child: stateIcon,
//                         ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
