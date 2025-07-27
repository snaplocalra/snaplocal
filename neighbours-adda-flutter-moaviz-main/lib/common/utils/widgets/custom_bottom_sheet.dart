import 'package:flutter/material.dart';

class CustomBottomSheet extends StatelessWidget {
  const CustomBottomSheet({
    super.key,
    required this.child,
    this.maxHeight,
  });

  final Widget child;
  final double? maxHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      //add the bottom to expand on keyboard open
      padding: EdgeInsets.fromLTRB(
        8,
        8,
        8,
        MediaQuery.of(context).viewInsets.bottom * 0.6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
          ),
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxHeight ?? MediaQuery.sizeOf(context).height * 0.6,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
