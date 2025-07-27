// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AuthHeaderText extends StatelessWidget {
  final String header1;
  final String? header2;
  final double? header1FontSize;
  final double? header2FontSize;
  const AuthHeaderText({
    super.key,
    required this.header1,
    this.header2,
    this.header1FontSize,
    this.header2FontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header1,
          style: TextStyle(
            fontSize: header1FontSize ?? 25,
            color: const Color.fromRGBO(5, 18, 66, 1),
          ),
        ),
        if (header2 != null)
          Text(
            header2!,
            style: TextStyle(
              fontSize: header2FontSize ?? 18,
              color: const Color.fromRGBO(162, 167, 185, 1),
            ),
          ),
      ],
    );
  }
}
