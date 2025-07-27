enum ShareType {
  general(param: 'general'),
  deepLink(param: 'deeplink');

  final String param;

  const ShareType({required this.param});

  factory ShareType.fromString(String param) {
    switch (param) {
      case 'general':
        return ShareType.general;
      case 'deeplink':
        return ShareType.deepLink;
      default:
        throw Exception("Invalid ShareType");
    }
  }
}
