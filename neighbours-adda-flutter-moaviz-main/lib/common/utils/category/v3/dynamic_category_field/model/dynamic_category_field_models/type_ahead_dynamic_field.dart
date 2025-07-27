import 'package:designer/widgets/theme_type_ahed_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/logic/dynamic_field_controller/dynamic_field_controller_cubit.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_data_model/dynamic_category_data_model.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field_type.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_field_category_value_model.dart';
import 'package:snap_local/utility/common/widgets/text_field_with_heading.dart';
import 'package:snap_local/utility/constant/application_colours.dart';

class TypeAhedDynamicField extends DynamicCategoryField {
  final List<DynamicCategoryFieldValue> values;

  TypeAhedDynamicField({
    required super.fieldId,
    required super.fieldName,
    required this.values,
    required super.isOptional,
  });

  //from Map
  factory TypeAhedDynamicField.fromMap(Map<String, dynamic> map) {
    return TypeAhedDynamicField(
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
    if (selectedValue == null) {
      return null;
    }

    return TypeAheadDynamicFieldDataModel(
      fieldId: fieldId,
      fieldType: DynamicCategoryFieldType.typeAheadDynamicCategoryField,
      fieldValueId: selectedValue!.id,
    );
  }

  /// Validates the selected value against the list of available values.
  ///
  /// If a value is selected and it matches an element in the list where
  /// `isSelected` is true and the `id` matches the `selectedValue`'s `id`,
  /// but the trimmed text in the controller does not match the `selectedValue`'s `value`,
  /// it returns an error message indicating an invalid value selection for the field.
  @override
  String? validate() {
    if (selectedValue != null &&
        values.any((element) {
          if (element.isSelected && element.id == selectedValue!.id) {
            if (_controller.text.trim() != selectedValue!.value) {
              return true;
            }
          }
          return false;
        })) {
      return "Invalid value selected for $fieldName";
    }

    //regular validation
    if (isOptional) {
      return null;
    } else if (values.any((element) => element.isSelected)) {
      return null;
    } else {
      return "Please select any option from $fieldName";
    }
  }

  DynamicCategoryFieldValue? selectedValue;

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextFieldWithHeading(
      textFieldHeading: fieldName,
      showOptional: isOptional,
      child: ThemeTypeAheadFormField<DynamicCategoryFieldValue>(
        controller: _controller,
        hint: "Select $fieldName",
        hintStyle: const TextStyle(fontSize: 12),
        style: const TextStyle(fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        suggestionsCallback: (query) async {
          return values
              .where((element) =>
                  element.value.toLowerCase().contains(query.toLowerCase()))
              .toList();
        },
        onSuggestionSelected: (DynamicCategoryFieldValue? suggestion) {
          if (suggestion != null) {
            //deselect the previous selected value and select the new value
            for (var element in values) {
              //Select the element in parent list
              element.isSelected = element.id == suggestion.id;

              //if the element is selected
              if (element.isSelected) {
                //set the local selected value
                selectedValue = element;

                //set the value in the controller
                _controller.text = element.value;
              }
            }
            context.read<DynamicCategoryFieldControllerCubit>().refreshState();
          }
        },
        validator: (_) {
          return validate();
        },
        textInputAction: TextInputAction.next,
        itemBuilder: (context, snapshot) {
          return ListTile(
            title: Text(
              snapshot!.value,
              style: TextStyle(
                fontSize: 14,
                color: ApplicationColours.themeBlueColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        },
        noItemsFoundBuilder: (context) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "No item found",
              style: TextStyle(fontSize: 14),
            ),
          );
        },
      ),
    );
  }

  @override
  void setPreSelectedData(DynamicCategoryDataModel preSelectedData) {
    if (preSelectedData is TypeAheadDynamicFieldDataModel) {
      for (var element in values) {
        element.isSelected = element.id == preSelectedData.fieldValueId;

        if (element.isSelected) {
          selectedValue = element;
          _controller.text = element.value;
        }
      }
    }
  }
}
