import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/logic/dynamic_field_controller/dynamic_field_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_data_model/dynamic_category_data_model.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field_type.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_field_category_value_model.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';

class RadioButtonDynamicField extends DynamicCategoryField {
  final List<DynamicCategoryFieldValue> values;

  RadioButtonDynamicField({
    required super.fieldId,
    required super.fieldName,
    required this.values,
    required super.isOptional,
  });

  //from Map
  factory RadioButtonDynamicField.fromMap(Map<String, dynamic> map) {
    return RadioButtonDynamicField(
      fieldId: map['field_id'],
      fieldName: map['field_name'],
      isOptional: map['is_optional'],
      values: List<DynamicCategoryFieldValue>.from(
        map['values'].map(
          (x) => DynamicCategoryFieldValue.fromMap(x),
        ),
      ),
    );
  }

  @override
  DynamicCategoryDataModel? toDataModel() {
    if (_groupValue == null) {
      return null;
    }

    return RadioButtonDynamicFieldDataModel(
      fieldId: fieldId,
      fieldType: DynamicCategoryFieldType.radioButtonDynamicCategoryField,
      fieldValueId: _groupValue!.id,
    );
  }

  @override
  String? validate() {
    if (isOptional) {
      return null;
    } else if (values.any((element) => element.isSelected)) {
      return null;
    } else {
      return "Please select any option from $fieldName";
    }
  }

  DynamicCategoryFieldValue? _groupValue;

  @override
  Widget build(BuildContext context) {
    return TextFieldWithHeading(
      textFieldHeading: fieldName,
      showOptional: isOptional,
      child: ListView.builder(
        itemCount: values.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final e = values[index];
          return RadioListTile(
            title: Text(
              e.value,
              style: const TextStyle(fontSize: 14), // Reduced text size
            ),
            value: e.id,
            groupValue: _groupValue?.id,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              // Handle the change

              // Deselect the previous selected value and select the new value
              for (var element in values) {
                element.isSelected = element.id == value;

                if (element.isSelected) {
                  _groupValue = element;
                }
              }

              // Refresh the UI
              context
                  .read<DynamicCategoryFieldControllerCubit>()
                  .refreshState();
            },
            controlAffinity: ListTileControlAffinity.leading,
            visualDensity: VisualDensity.compact, // Reduced radio size
          );
        },
      ),
    );
  }

  @override
  void setPreSelectedData(DynamicCategoryDataModel preSelectedData) {
    if (preSelectedData is RadioButtonDynamicFieldDataModel) {
      for (var element in values) {
        element.isSelected = element.id == preSelectedData.fieldValueId;

        if (element.isSelected) {
          _groupValue = element;
        }
      }
    }
  }
}
