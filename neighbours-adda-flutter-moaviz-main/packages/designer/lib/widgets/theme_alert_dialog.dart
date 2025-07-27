import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeAlertDialog extends StatelessWidget {
  final void Function() onAcceptPressed;
  final void Function()? onRejectPressed;
  final String title;
  final String? agreeButtonText;
  final String? cancelButtonText;
  const ThemeAlertDialog({
    super.key,
    required this.title,
    this.agreeButtonText,
    this.cancelButtonText,
    required this.onAcceptPressed,
    this.onRejectPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        margin: const EdgeInsets.symmetric(
          vertical: 0,
          horizontal: 0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            30,
          ),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    onAcceptPressed.call();
                    return;
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
                  child: Text(agreeButtonText ?? "Yes"),
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    //Close the top dialog box
                    Navigator.pop(context);
                    if (onRejectPressed != null) {
                      onRejectPressed!.call();
                    }
                    return;
                  },
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(Colors.white),
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromRGBO(108, 117, 126, 1)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    cancelButtonText ?? "No",
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showThemeAlertDialog({
  required BuildContext context,
  required void Function() onAcceptPressed,
  required String title,
  String? agreeButtonText,
  String? cancelButtonText,
  void Function()? onRejectPressed,
}) async {
  HapticFeedback.mediumImpact();
  await showDialog(
    context: context,
    useSafeArea: true,
    builder: (context) => ThemeAlertDialog(
      title: title,
      agreeButtonText: agreeButtonText,
      cancelButtonText: cancelButtonText,
      onAcceptPressed: onAcceptPressed,
      onRejectPressed: onRejectPressed,
    ),
  );
}
