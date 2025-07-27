import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/helpline_numbers/model/helpline_number_model.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class HelplineNumberWidget extends StatelessWidget {
  final HelplineNumberModel helplineNumber;
  const HelplineNumberWidget({
    super.key,
    required this.helplineNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: helplineNumber.imageUrl,
            fit: BoxFit.cover,
            width: 40,
            height: 40,
          ),

          // Helpline number details
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Helpline number contact
                  Text(
                    helplineNumber.contactNumber,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Helpline number name
                  Text(
                    helplineNumber.contactName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Helpline number call button
          CircleAvatar(
            backgroundColor: ApplicationColours.themeBlueColor,
            radius: 18,
            child: GestureDetector(
              child: const Icon(
                Icons.call,
                color: Colors.white,
                size: 20,
              ),
              onTap: () {
                //call helpline number
                UrlLauncher().makeCall(helplineNumber.contactNumber);
              },
            ),
          ),
        ],
      ),
    );
  }
}
