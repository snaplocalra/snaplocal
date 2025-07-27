import 'package:flutter/material.dart';

class MessageDeletedBubble extends StatelessWidget {
  final String text;
  final double bubbleRadius;
  final bool isSender;
  final Color color;
  final bool tail;

  const MessageDeletedBubble({
    super.key,
    required this.text,
    this.bubbleRadius = 16,
    this.isSender = true,
    this.color = Colors.white70,
    this.tail = false,
  });

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
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
              bottomLeft: Radius.circular(
                tail
                    ? isSender
                        ? bubbleRadius
                        : 0
                    : 16,
              ),
              bottomRight: Radius.circular(
                tail
                    ? isSender
                        ? 0
                        : bubbleRadius
                    : 16,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
