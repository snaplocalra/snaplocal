class ManageBankDetailsModel {
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String mobile;

  ManageBankDetailsModel(
      {required this.accountHolderName,
      required this.accountNumber,
      required this.ifscCode,
      required this.bankName,
      required this.mobile});

  //toMap method
  Map<String, dynamic> toMap() {
    return {
      'name': accountHolderName,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'bank_name': bankName,
      'mobile': mobile,
    };
  }
}


