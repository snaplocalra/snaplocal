import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///Pass the correct route name to check the current route
///example: checkRoute(context, EventScreen.routeName)
bool checkRoute(BuildContext context, String routeName) {
  return GoRouter.of(context)
          .routerDelegate
          .currentConfiguration
          .matches
          .map((e) => e.matchedLocation)
          .last ==
      routeName;
}
