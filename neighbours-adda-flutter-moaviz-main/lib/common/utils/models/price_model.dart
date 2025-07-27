import 'package:snap_local/utility/extension_functions/number_formatter.dart';

class PriceModel {
  final double amount;
  final String currencySign;

  PriceModel({
    required this.amount,
    required this.currencySign,
  });

  String get formattedPrice {
    final formattedPrice = amount.formatPrice();
    return "$currencySign $formattedPrice";
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'currency': currencySign,
    };
  }

  factory PriceModel.fromMap(Map<String, dynamic> map) {
    return PriceModel(
      amount: map['amount'].toDouble(),
      currencySign: map['currency'],
    );
  }
}
