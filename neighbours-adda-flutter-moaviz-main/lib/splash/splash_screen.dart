// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snap_local/utility/constant/assets_images.dart';

class SplashScreen extends StatelessWidget {
  final bool isRegularOpen;
  const SplashScreen({
    super.key,
    required this.isRegularOpen,
  });
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(
                isRegularOpen ? GIFAssetsImages.splashGIF2Sec : GIFAssetsImages.splashGIF9Sec,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
