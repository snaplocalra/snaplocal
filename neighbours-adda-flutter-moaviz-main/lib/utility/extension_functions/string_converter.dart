extension StringExtension on String {
  /// If the text is "true", then it will return true as boolean,
  /// otherwise, it will return false (including the case when the text is null).
  bool toBool() => toLowerCase() == 'true';

  ///Return double on valid string, for invalid return 0
  double toDouble() => double.tryParse(this) ?? 0;

  String removeBlankSpace() => replaceAll(RegExp(r'\n\n\n+'), '\n');
}
