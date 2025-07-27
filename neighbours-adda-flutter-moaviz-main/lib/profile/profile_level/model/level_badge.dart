enum LevelBadgeType {
  silver(title: "Silver"),
  golden(title: "Golden"),
  diamond(title: "Diamond"),
  prime(title: "Prime"),
  verified(title: "Verified");

  final String title;
  const LevelBadgeType({required this.title});

  factory LevelBadgeType.fromString(String value) {
    switch (value) {
      case 'silver':
        return silver;
      case 'golden':
      case 'gold':
        return golden;
      case 'diamond':
        return diamond;
      case 'prime':
        return prime;
      case 'Verified':
        return verified;
      default:
        throw Exception('Invalid Level Badge');
    }
  }
}
