import 'package:flutter/material.dart';

class SeeAllButton extends StatelessWidget {
  final VoidCallback? onTap;

  const SeeAllButton({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.pink,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'See All',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
} 