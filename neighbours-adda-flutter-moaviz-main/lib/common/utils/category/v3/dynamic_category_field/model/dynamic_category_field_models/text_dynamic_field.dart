import 'package:designer/widgets/theme_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_data_model/dynamic_category_data_model.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field_type.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';

class TextDynamicField extends DynamicCategoryField {
  final DynamicTextInputType textInputType;
  TextDynamicField({
    required super.fieldId,
    required super.fieldName,
    required super.isOptional,
    required this.textInputType,
  });

  //from Map
  factory TextDynamicField.fromMap(Map<String, dynamic> map) {
    return TextDynamicField(
      fieldId: map['field_id'],
      textInputType:
          DynamicTextInputType.fromString(map['text_field_keyboard_type']),
      fieldName: map['field_name'],
      isOptional: map['is_optional'],
    );
  }

  @override
  DynamicCategoryDataModel? toDataModel() {
    if (userValue.trim().isEmpty) {
      return null;
    }

    return TextDynamicFieldDataModel(
      fieldId: fieldId,
      fieldType: DynamicCategoryFieldType.textDynamicCategoryField,
      fieldValue: userValue,
    );
  }

  String userValue = '';

  @override
  String? validate() {
    if (isOptional) {
      return null;
    } else if (userValue.trim().isNotEmpty) {
      return null;
    } else {
      return "Please enter $fieldName";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldWithHeading(
      textFieldHeading: fieldName,
      showOptional: isOptional,
      child: ThemeTextFormField(
        initialValue: userValue.isNotEmpty ? userValue : null,
        hint: "Enter $fieldName",
        hintStyle: const TextStyle(fontSize: 12),
        style: const TextStyle(fontSize: 14),
        onChanged: (value) {
          userValue = value;
        },
        keyboardType: textInputType.keyboardType,
        //validation
        validator: (value) {
          return validate();
        },
      ),
    );
  }

  @override
  void setPreSelectedData(DynamicCategoryDataModel preSelectedData) {
    if (preSelectedData is TextDynamicFieldDataModel) {
      userValue = preSelectedData.fieldValue;
    }
  }
}

enum DynamicTextInputType {
  text(TextInputType.text),
  number(TextInputType.number);

  final TextInputType keyboardType;
  const DynamicTextInputType(this.keyboardType);

  //from string
  static DynamicTextInputType fromString(String value) {
    switch (value) {
      case 'text':
        return text;
      case 'number':
        return number;
      default:
        throw Exception('Invalid DynamicTextInputType');
    }
  }
}
