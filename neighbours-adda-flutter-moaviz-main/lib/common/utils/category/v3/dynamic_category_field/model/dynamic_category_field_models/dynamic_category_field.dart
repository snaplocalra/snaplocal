import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_data_model/dynamic_category_data_model.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/drop_down_dynamic_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field_type.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/radio_button_dynamic_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/text_dynamic_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/type_ahead_dynamic_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_field_composition.dart';

abstract class DynamicCategoryField implements RenderWidget, InputValidation {
  final String fieldId;
  final String fieldName;
  final bool isOptional;
  DynamicCategoryField({
    required this.fieldId,
    required this.fieldName,
    required this.isOptional,
  });

  //from Type
  factory DynamicCategoryField.fromType(Map<String, dynamic> map) {
    final fieldType = DynamicCategoryFieldType.fromString(map['field_type']);

    switch (fieldType) {
      case DynamicCategoryFieldType.textDynamicCategoryField:
        return TextDynamicField.fromMap(map);
      case DynamicCategoryFieldType.radioButtonDynamicCategoryField:
        return RadioButtonDynamicField.fromMap(map);
      case DynamicCategoryFieldType.dropDownDynamicCategoryField:
        return DropDownDynamicField.fromMap(map);
      case DynamicCategoryFieldType.typeAheadDynamicCategoryField:
        return TypeAhedDynamicField.fromMap(map);
      default:
        throw Exception('Invalid dynamic category field ');
    }
  }

  //To Data Model
  DynamicCategoryDataModel? toDataModel();

  //Set Pre Selected Data
  void setPreSelectedData(DynamicCategoryDataModel preSelectedData);
}
