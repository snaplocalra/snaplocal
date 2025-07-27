import 'package:flutter/widgets.dart';

class ChatDate extends StatelessWidget {
  final String date;
  const ChatDate({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromRGBO(238, 237, 238, 1),
      ),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color.fromRGBO(138, 135, 135, 1),
        ),
      ),
    );
  }
}
