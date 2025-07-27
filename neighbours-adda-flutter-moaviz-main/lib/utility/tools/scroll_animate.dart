import 'package:flutter/material.dart';

Future<void> scrollAnimateTo({
  required ScrollController scrollController,

  ///Offset 0 for start and maxScrollExtent for end
  required double offset,
}) async {
  await scrollController.animateTo(
    // The offset of the position you want to scroll to
    offset,
    // The duration of the scroll animation
    duration: const Duration(milliseconds: 500),
    curve: Curves.ease, // The curve for the scroll animation
  );
}

Future<void> scrollToEnd(ScrollController scrollController) async {
  // Ensure the ScrollController is attached to a scroll view
  if (scrollController.hasClients) {
    await scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration:
          const Duration(milliseconds: 500), // Adjust the duration as needed
      curve: Curves.easeInOut, // Adjust the curve as needed
    );
  }
}

Future<void> scrollToStart(ScrollController scrollController) async {
  await scrollController.animateTo(
    0,
    duration:
        const Duration(milliseconds: 500), // Adjust the duration as needed
    curve: Curves.easeInOut, // Adjust the curve as needed
  );
}
