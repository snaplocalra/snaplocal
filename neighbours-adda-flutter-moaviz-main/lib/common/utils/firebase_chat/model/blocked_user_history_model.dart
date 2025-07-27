class BlockedUserHistoryModel {
  final String blockedAt;
  final String blockedUserId;
  final String? unblockedAt;

  BlockedUserHistoryModel({
    required this.blockedAt,
    required this.blockedUserId,
    this.unblockedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'blockedAt': blockedAt,
      'blockedUserId': blockedUserId,
      'unblockedAt': unblockedAt,
    };
  }

  factory BlockedUserHistoryModel.fromMap(Map<String, dynamic> map) {
    return BlockedUserHistoryModel(
      blockedAt: map['blockedAt'],
      blockedUserId: map['blockedUserId'],
      unblockedAt: map['unblockedAt'],
    );
  }
}


