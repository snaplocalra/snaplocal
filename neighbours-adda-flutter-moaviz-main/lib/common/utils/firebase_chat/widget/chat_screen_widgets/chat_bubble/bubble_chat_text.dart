import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/widgets/selectable_linkify_text.dart';

class BubbleChatText extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final String text;
  final String? timeStampText;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final TextStyle timeStampStyle;

  const BubbleChatText({
    super.key,
    required this.text,
    this.timeStampText,
    this.bubbleRadius = 16,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.textStyle = const TextStyle(
      color: Colors.black87,
      fontSize: 16,
    ),
    this.timeStampStyle = const TextStyle(
      color: Color.fromRGBO(164, 169, 172, 1),
      fontSize: 12,
    ),
  });

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    bool stateTick = false;
    Icon? stateIcon;
    if (sent) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (delivered) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF97AD8E),
      );
    }
    if (seen) {
      stateTick = true;
      stateIcon = const Icon(
        Icons.done_all,
        size: 18,
        color: Color(0xFF92DEDA),
      );
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Container(
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(bubbleRadius),
              topRight: Radius.circular(bubbleRadius),
              bottomLeft: Radius.circular(tail
                  ? isSender
                      ? bubbleRadius
                      : 0
                  : 16),
              bottomRight: Radius.circular(tail
                  ? isSender
                      ? 0
                      : bubbleRadius
                  : 16),
            ),
          ),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            alignment: WrapAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                child: SelectableLinkifyText(
                  text: text,
                  textStyle: textStyle,
                ),
              ),
              if (timeStampText != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                  child: Text(
                    timeStampText!,
                    style: timeStampStyle,
                  ),
                ),
              if (stateIcon != null && stateTick)
                Padding(
                  padding: const EdgeInsets.fromLTRB(1, 0, 6, 6),
                  child: stateIcon,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
