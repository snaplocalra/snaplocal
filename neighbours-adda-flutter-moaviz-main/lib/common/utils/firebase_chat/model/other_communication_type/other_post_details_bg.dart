import 'package:flutter/material.dart';

class OtherPostDetailsBG extends StatelessWidget {
  final Widget child;
  const OtherPostDetailsBG({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      margin: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      padding: const EdgeInsets.all(8),
      child: child,
    );
  }
}
