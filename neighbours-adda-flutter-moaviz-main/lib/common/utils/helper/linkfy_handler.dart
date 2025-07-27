import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:snap_local/utility/api_manager/config/env/env.dart';
import 'package:snap_local/utility/common/url_launcher/url_launcher.dart';

class LinkfyHandler {
  void onLinkTap(BuildContext context, {required String url}) {
    try {
      //condition to check if the link is a deep link
      if (url.startsWith(deepLinkURL)) {
        //parse the link
        final parsedLink = Uri.parse(url);

        //extracting screen path and id from the link
        final screenPath = parsedLink.pathSegments[0];
        final id =
            parsedLink.queryParameters['id'] ?? parsedLink.pathSegments[1];

        //pushing the screen with the id
        GoRouter.of(context).pushNamed(
          screenPath,
          queryParameters: {'id': id},
        );
      } else {
        UrlLauncher().openWebsite(url);
      }
    } catch (e) {
      return;
    }
  }
}
