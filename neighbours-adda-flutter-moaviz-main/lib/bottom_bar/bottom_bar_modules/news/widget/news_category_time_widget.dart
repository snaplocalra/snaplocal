import 'package:flutter/material.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class NewsCategoryTimeWidget extends StatelessWidget {
  const NewsCategoryTimeWidget({
    super.key,
    required this.category,
    required this.createdAt,
  });

  final String category;
  final DateTime createdAt;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Category and the created date in a row
        Row(
          children: [
            // category
            Text(
              category,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            // created date
            Text(
              FormatDate.timeAgoSinceDate(createdAt),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
