class BankDetailsModel {
  final String id;
  final String userId;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  bool isDefault;

  BankDetailsModel({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    this.isDefault = false,
  });

  factory BankDetailsModel.fromJson(Map<String, dynamic> json) {
    return BankDetailsModel(
      id: json['id'],
      userId: json['user_id'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      bankName: json['bank_name'],
      //TODO: Need to remove after API update
      isDefault: json['is_default'] ?? false,
    );
  }
}
