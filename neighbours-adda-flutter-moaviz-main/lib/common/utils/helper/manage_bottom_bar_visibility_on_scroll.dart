import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/logic/bottom_bar_visibility/bottom_bar_visibility_cubit.dart';

class ManageBottomBarVisibilityOnScroll {
  final BuildContext context;

  ManageBottomBarVisibilityOnScroll(this.context);

  DateTime? previousEventTime;
  double previousScrollOffset = 0;

  DateTime? scrollStartTime;

  static const scrollDurationThreshold =
      Duration(seconds: 2); // Duration threshold

  void init(ScrollController? scrollController) {
    if (scrollController == null) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.position.isScrollingNotifier.addListener(() {
          final currentScrollOffset = scrollController.position.pixels;
          final currentTime = DateTime.now();

          if (previousEventTime != null) {
            final scrollDistance =
                (currentScrollOffset - previousScrollOffset).abs();
            final timeDifference =
                currentTime.difference(previousEventTime!).inMicroseconds;

            final scrollSpeed = scrollDistance / timeDifference;

            if (scrollController.position.userScrollDirection ==
                ScrollDirection.reverse) {
              scrollStartTime ??= currentTime;

              // Check if the user has been scrolling continuously for the threshold duration
              if (currentTime.difference(scrollStartTime!) >=
                  scrollDurationThreshold) {
                context.read<BottomBarVisibilityCubit>().hideBottomBar();
              }
            } else if (scrollSpeed < 1 &&
                scrollController.position.userScrollDirection ==
                    ScrollDirection.forward) {
              context.read<BottomBarVisibilityCubit>().showBottomBar();
              scrollStartTime = null; // Reset scroll start time
            }
          } else {
            scrollStartTime =
                null; // Reset scroll start time if no previous event
          }
          previousEventTime = currentTime;
          previousScrollOffset = currentScrollOffset;
        });
      }
    });
  }
}
