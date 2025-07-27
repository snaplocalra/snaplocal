enum DynamicCategoryFieldType {
  textDynamicCategoryField("text_field"),
  radioButtonDynamicCategoryField("radio_button_field"),
  dropDownDynamicCategoryField("dropdown_field"),
  typeAheadDynamicCategoryField("type_ahead_field");

  final String jsonValue;

  const DynamicCategoryFieldType(this.jsonValue);

  factory DynamicCategoryFieldType.fromString(String value) {
    switch (value) {
      case 'text_field':
        return DynamicCategoryFieldType.textDynamicCategoryField;
      case 'radio_button_field':
        return DynamicCategoryFieldType.radioButtonDynamicCategoryField;
      case 'dropdown_field':
        return DynamicCategoryFieldType.dropDownDynamicCategoryField;
      case 'type_ahead_field':
        return DynamicCategoryFieldType.typeAheadDynamicCategoryField;
      default:
        throw Exception('Invalid dynamic category field type');
    }
  }
}
