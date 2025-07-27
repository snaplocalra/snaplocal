import 'package:flutter/material.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class ManagePostActionButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  final Color? backgroundColor;

  const ManagePostActionButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: backgroundColor ?? ApplicationColours.themePinkColor,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
