String formatPlayerTime(Duration playerDuration) {
  final twoDigitMinutes =
      playerDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final twoDigitSeconds =
      playerDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
  return "$twoDigitMinutes:$twoDigitSeconds";
}
