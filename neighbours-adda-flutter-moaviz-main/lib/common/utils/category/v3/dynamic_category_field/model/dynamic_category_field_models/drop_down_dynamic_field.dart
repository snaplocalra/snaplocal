import 'package:designer/widgets/theme_text_form_field_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/logic/dynamic_field_controller/dynamic_field_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_data_model/dynamic_category_data_model.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field_type.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_field_category_value_model.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class DropDownDynamicField extends DynamicCategoryField {
  final List<DynamicCategoryFieldValue> values;

  DropDownDynamicField({
    required super.fieldId,
    required super.fieldName,
    required this.values,
    required super.isOptional,
  });

  //from Map
  factory DropDownDynamicField.fromMap(Map<String, dynamic> map) {
    return DropDownDynamicField(
      fieldId: map['field_id'],
      fieldName: map['field_name'],
      isOptional: map['is_optional'],
      values: List<DynamicCategoryFieldValue>.from(
        map['values'].map((x) => DynamicCategoryFieldValue.fromMap(x)),
      ),
    );
  }

  @override
  DynamicCategoryDataModel? toDataModel() {
    if (_dropdownValue == null) {
      return null;
    }
    return DropdownDynamicFieldDataModel(
      fieldId: fieldId,
      fieldType: DynamicCategoryFieldType.dropDownDynamicCategoryField,
      fieldValueId: _dropdownValue!.id,
    );
  }

  @override
  String? validate({String? value}) {
    if (isOptional) {
      return null;
    } else if (values.any((element) => element.isSelected)) {
      return null;
    } else {
      return "Please select any option from $fieldName";
    }
  }

  DynamicCategoryFieldValue? _dropdownValue;

  @override
  Widget build(BuildContext context) {
    return TextFieldWithHeading(
      textFieldHeading: fieldName,
      showOptional: isOptional,
      child: ThemeTextFormFieldDropDown<DynamicCategoryFieldValue>(
        hint: "Select $fieldName",
        hintStyle: const TextStyle(fontSize: 12),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        value: _dropdownValue,
        onChanged: (DynamicCategoryFieldValue? newValue) {
          if (newValue != null) {
            //     //deselect the previous selected value and select the new value
            for (var element in values) {
              element.isSelected = element.id == newValue.id;

              if (element.isSelected) {
                _dropdownValue = element;
              }
            }
            context.read<DynamicCategoryFieldControllerCubit>().refreshState();
          }
        },
        textInputAction: TextInputAction.next,
        items:
            values.map((DynamicCategoryFieldValue dynamicCategoryFieldValue) {
          return DropdownMenuItem(
            value: dynamicCategoryFieldValue,
            child: Text(
              dynamicCategoryFieldValue.value,
              style: TextStyle(
                fontSize: 14,
                color: ApplicationColours.themeBlueColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }).toList(),
        validator: (value) {
          return validate();
        },
      ),
    );
  }

  @override
  void setPreSelectedData(DynamicCategoryDataModel preSelectedData) {
    if (preSelectedData is DropdownDynamicFieldDataModel) {
      for (var element in values) {
        element.isSelected = element.id == preSelectedData.fieldValueId;

        if (element.isSelected) {
          _dropdownValue = element;
        }
      }
    }
  }
}
