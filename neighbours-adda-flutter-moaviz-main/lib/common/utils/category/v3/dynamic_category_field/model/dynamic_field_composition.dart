import 'package:flutter/material.dart';

abstract class RenderWidget {
  Widget build(BuildContext context);
}

abstract class InputValidation {
  String? validate();
}

abstract class Selectable {
  void select();
}
