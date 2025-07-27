// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ScaffoldErrorTextWidget extends StatelessWidget {
  final String error;
  final double? fontSize;
  const ScaffoldErrorTextWidget({
    super.key,
    this.error = '',
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    //Scalffold widget used if the widget called before the scaffold widget in the screen
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            error,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}

class ErrorTextWidget extends StatelessWidget {
  final String error;
  final double? fontSize;
  const ErrorTextWidget({
    super.key,
    this.error = '',
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    //Scalffold widget used if the widget called before the scaffold widget in the screen
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          error,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
