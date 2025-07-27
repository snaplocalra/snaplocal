import 'package:flutter/material.dart';

class AnimatedHideWidget extends StatelessWidget {
  final bool visible;
  final Widget child;
  const AnimatedHideWidget({
    super.key,
    this.visible = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        opacity: visible ? 1.0 : 0.0,
        child: Visibility(
          visible: visible,
          child: child,
        ),
      ),
    );
  }
}
