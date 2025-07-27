import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

CustomTransitionPage animatedPageRoute({
  required LocalKey pageKey,
  required Widget child,
  NavigationDirection navigationDirection = NavigationDirection.right,
}) {
  return CustomTransitionPage(
    key: pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 150),
    reverseTransitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
          position: Tween<Offset>(
            begin: _navigateDirectionOffset(navigationDirection),
            end: Offset.zero,
          ).animate(animation),
          child: child);
    },
  );
}

enum NavigationDirection { left, right, top, bottom }

Offset _navigateDirectionOffset(NavigationDirection direction) {
  double xOffset = 0.0;
  double yOffset = 0.0;

  switch (direction) {
    case NavigationDirection.left:
      xOffset = -1.0;
      break;
    case NavigationDirection.right:
      xOffset = 1.0;
      break;
    case NavigationDirection.top:
      yOffset = -1.0;
      break;
    case NavigationDirection.bottom:
      yOffset = 1.0;
      break;
  }
  return Offset(xOffset, yOffset);
}
