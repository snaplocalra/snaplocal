class BusinessDiscountOptionList {
  final List<BusinessDiscountOptionModel> data;
  BusinessDiscountOptionList({this.data = const []});

//Check for empty options where one of the option is available and another is empty
  bool get partialEmptyOption =>
      data.any((element) => element.isOneOptionAvailable);

//All options are empty
  bool get allEmptyOption => data.every((element) => element.isEmpty);

  //Filter empty options
  BusinessDiscountOptionList filterEmptyOptions() {
    return BusinessDiscountOptionList(
      data: data.where((x) => !x.isEmpty).toList(),
    );
  }
}

class BusinessDiscountOptionModel {
  final String value;
  final String discountOn;

  BusinessDiscountOptionModel({
    required this.value,
    required this.discountOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'discount_on': discountOn,
    };
  }

  factory BusinessDiscountOptionModel.fromMap(Map<String, dynamic> map) {
    return BusinessDiscountOptionModel(
      value: map['value'],
      discountOn: map['discount_on'],
    );
  }

//copyWith method
  BusinessDiscountOptionModel copyWith({
    String? value,
    String? discountOn,
  }) {
    return BusinessDiscountOptionModel(
      value: value ?? this.value,
      discountOn: discountOn ?? this.discountOn,
    );
  }

  //Check for one of the option is available and another is empty
  bool get isOneOptionAvailable =>
      value.trim().isNotEmpty && discountOn.trim().isEmpty ||
      value.trim().isEmpty && discountOn.trim().isNotEmpty;

  //check for empty option
  bool get isEmpty => value.trim().isEmpty && discountOn.trim().isEmpty;

  //empty object
  static BusinessDiscountOptionModel get empty =>
      BusinessDiscountOptionModel(value: "", discountOn: "");
}
