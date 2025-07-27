import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

class SearchBoxWidget extends StatelessWidget {
  const SearchBoxWidget(
      {super.key,
      required this.searchHint,
      required this.onSearchTap,
      this.backColor});

  final String searchHint;
  final Color? backColor;
  final void Function() onSearchTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSearchTap,
      child: Container(
        decoration: BoxDecoration(
          color: backColor ?? Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(FeatherIcons.search, color: Colors.grey),
            const SizedBox(width: 5),
            Text(
              searchHint,
              style: const TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
