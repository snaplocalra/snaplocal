// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:designer/widgets/theme_spinner.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String? waitingText;
  const LoadingScreen({
    super.key,
    this.waitingText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ThemeSpinner(),
            if (waitingText != null)
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Text(
                  waitingText!,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
