import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field_type.dart';

abstract class DynamicCategoryDataModel {
  final String fieldId;
  final DynamicCategoryFieldType fieldType;

  DynamicCategoryDataModel({
    required this.fieldId,
    required this.fieldType,
  });

  //to Map
  Map<String, dynamic> toMap();

  //from Map
  factory DynamicCategoryDataModel.fromMap(Map<String, dynamic> map) {
    final fieldType = DynamicCategoryFieldType.fromString(map['field_type']);
    switch (fieldType) {
      case DynamicCategoryFieldType.textDynamicCategoryField:
        return TextDynamicFieldDataModel.fromMap(map);
      case DynamicCategoryFieldType.radioButtonDynamicCategoryField:
        return RadioButtonDynamicFieldDataModel.fromMap(map);
      case DynamicCategoryFieldType.dropDownDynamicCategoryField:
        return DropdownDynamicFieldDataModel.fromMap(map);
      case DynamicCategoryFieldType.typeAheadDynamicCategoryField:
        return TypeAheadDynamicFieldDataModel.fromMap(map);
      default:
        throw Exception('Invalid dynamic category field ');
    }
  }
}

//text field
class TextDynamicFieldDataModel extends DynamicCategoryDataModel {
  final String fieldValue;

  TextDynamicFieldDataModel({
    required super.fieldId,
    required super.fieldType,
    required this.fieldValue,
  });

  //from Map
  factory TextDynamicFieldDataModel.fromMap(Map<String, dynamic> map) {
    return TextDynamicFieldDataModel(
      fieldId: map['field_id'],
      fieldType: DynamicCategoryFieldType.fromString(map['field_type']),
      fieldValue: map['field_value'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'field_id': fieldId,
      'field_type': fieldType.jsonValue,
      'field_value': fieldValue,
    };
  }
}

//dropdown field
class DropdownDynamicFieldDataModel extends DynamicCategoryDataModel {
  final String fieldValueId;

  DropdownDynamicFieldDataModel({
    required super.fieldId,
    required super.fieldType,
    required this.fieldValueId,
  });

  //from Map
  factory DropdownDynamicFieldDataModel.fromMap(Map<String, dynamic> map) {
    return DropdownDynamicFieldDataModel(
      fieldId: map['field_id'],
      fieldType: DynamicCategoryFieldType.fromString(map['field_type']),
      fieldValueId: map['field_value_id'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'field_id': fieldId,
      'field_type': fieldType.jsonValue,
      'field_value_id': fieldValueId,
    };
  }
}

//radio button field
class RadioButtonDynamicFieldDataModel extends DynamicCategoryDataModel {
  final String fieldValueId;

  RadioButtonDynamicFieldDataModel({
    required super.fieldId,
    required super.fieldType,
    required this.fieldValueId,
  });

  //from Map
  factory RadioButtonDynamicFieldDataModel.fromMap(Map<String, dynamic> map) {
    return RadioButtonDynamicFieldDataModel(
      fieldId: map['field_id'],
      fieldType: DynamicCategoryFieldType.fromString(map['field_type']),
      fieldValueId: map['field_value_id'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'field_id': fieldId,
      'field_type': fieldType.jsonValue,
      'field_value_id': fieldValueId,
    };
  }
}

//type ahead field
class TypeAheadDynamicFieldDataModel extends DynamicCategoryDataModel {
  final String fieldValueId;

  TypeAheadDynamicFieldDataModel({
    required super.fieldId,
    required super.fieldType,
    required this.fieldValueId,
  });

  //from Map
  factory TypeAheadDynamicFieldDataModel.fromMap(Map<String, dynamic> map) {
    return TypeAheadDynamicFieldDataModel(
      fieldId: map['field_id'],
      fieldType: DynamicCategoryFieldType.fromString(map['field_type']),
      fieldValueId: map['field_value_id'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'field_id': fieldId,
      'field_type': fieldType.jsonValue,
      'field_value_id': fieldValueId,
    };
  }
}
