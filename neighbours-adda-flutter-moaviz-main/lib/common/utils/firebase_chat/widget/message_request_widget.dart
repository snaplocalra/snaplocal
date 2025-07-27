import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class MessageRequestWidget extends StatelessWidget {
  final String receiverName;

  final void Function() onAccept;
  final void Function() onBlock;
  final void Function() onReport;
  final void Function() onChatPrivacySettings;

  const MessageRequestWidget({
    super.key,
    required this.receiverName,
    required this.onAccept,
    required this.onBlock,
    required this.onReport,
    required this.onChatPrivacySettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "New Message Request from $receiverName",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "If you accept, the user will be able to chat with you and see when you've read their messages. Please choose an option below.",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          //Divider
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),

          //Accept
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: onAccept,
              child: const Text(
                "Accept",
                style: TextStyle(
                  color: Colors.green,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          //Block
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: onBlock,
              child: Text(
                "Block",
                style: TextStyle(
                  color: ApplicationColours.themePinkColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          //Report
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: onReport,
              child: Text(
                "Report",
                style: TextStyle(
                  color: ApplicationColours.themePinkColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          //Chat privacy settings
         Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: GestureDetector(
              onTap: onChatPrivacySettings,
              child: Text(
                "Chat privacy settings",
                style: TextStyle(
                  color: ApplicationColours.themePinkColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
