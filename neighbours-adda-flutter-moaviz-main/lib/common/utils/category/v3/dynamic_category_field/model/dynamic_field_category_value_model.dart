// Data class for dropdown/radio button values
class DynamicCategoryFieldValue {
  final String id;
  final String value;
  bool isSelected;

  DynamicCategoryFieldValue({
    required this.id,
    required this.value,
    this.isSelected = false,
  });

  //from Map
  factory DynamicCategoryFieldValue.fromMap(Map<String, dynamic> map) {
    return DynamicCategoryFieldValue(
      id: map['id'],
      value: map['value'],
    );
  }

  //to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
    };
  }

  //to string
  @override
  String toString() {
    return 'DynamicCategoryFieldValue{id: $id, value: $value, isSelected: $isSelected}';
  }
}
