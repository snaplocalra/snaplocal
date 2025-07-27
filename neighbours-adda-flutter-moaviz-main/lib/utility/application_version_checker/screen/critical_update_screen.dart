import 'package:flutter/material.dart';
import 'package:snap_local/utility/application_version_checker/widget/update_application_widget.dart';

class CriticalUpdateScreen extends StatelessWidget {
  final String applicationDownloadLink;
  const CriticalUpdateScreen({
    super.key,
    required this.applicationDownloadLink,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: UpdateApplicationWidget(
              applicationDownloadLink: applicationDownloadLink,
              showSkipButton: false,
            ),
          ),
        ),
      ),
    );
  }
}
