import 'package:flutter/material.dart';

class BubbleChatPdf extends StatelessWidget {
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final String text;
  final String pdfName;
  final String? timeStampText;
  final bool tail;
  final bool sent;
  final bool delivered;
  final bool seen;
  final TextStyle textStyle;
  final TextStyle timeStampStyle;
  final void Function()? onDownloadClicked;
  const BubbleChatPdf({
    super.key,
    required this.text,
    required this.pdfName,
    this.timeStampText,
    this.bubbleRadius = 16,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = true,
    this.sent = false,
    this.delivered = false,
    this.seen = false,
    this.onDownloadClicked,
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
          padding: const EdgeInsets.all(2),
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
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(bubbleRadius),
                      color: isSender
                          ? const Color.fromRGBO(2, 81, 68, 0.6)
                          : const Color.fromRGBO(29, 40, 47, 0.8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            pdfName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (onDownloadClicked != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                                onTap: onDownloadClicked,
                                child: const Icon(
                                  Icons.download,
                                  color: Colors.white,
                                )),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: <Widget>[
                  Visibility(
                    visible: text.isNotEmpty,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 5, 12, 0),
                      child: Text(
                        text,
                        style: textStyle,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (timeStampText != null)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            6,
                            text.isNotEmpty ? 0 : 6,
                            stateTick ? 2 : 6,
                            6,
                          ),
                          child: Text(
                            timeStampText!,
                            style: timeStampStyle,
                          ),
                        ),
                      if (stateIcon != null && stateTick)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(2, 6, 6, 6),
                          child: stateIcon,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
