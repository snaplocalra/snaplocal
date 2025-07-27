import 'package:designer/utility/theme_toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_data_model/dynamic_category_data_model.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_field_models/dynamic_category_field.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_post_from.dart';
import 'package:snap_local/common/utils/category/v3/dynamic_category_field/repository/dynamic_category_field_repository.dart';

part 'dynamic_field_controller_state.dart';

class DynamicCategoryFieldControllerCubit
    extends Cubit<DynamicCategoryFieldControllerState> {
  final DynamicCategoryFieldRepository repository;

  DynamicCategoryFieldControllerCubit(this.repository)
      : super(DynamicCategoryFieldControllerInitial());

  //Fetch dynamic field
  Future<void> fetchDynamicField({
    required String categoryId,
    required DynamicCategoryPostFrom dynamicCategoryPostFrom,
    List<DynamicCategoryDataModel>? preSelectedData,
  }) async {
    try {
      emit(DynamicCategoryFieldControllerLoading());
      final dynamicCategoryFields = await repository.fetchDynamicCategoryFields(
        categoryId: categoryId,
        dynamicCategoryPostFrom: dynamicCategoryPostFrom,
      );

      //Set the pre selected data
      if (preSelectedData != null) {
        //create the map of pre selected data
        final preSelectedDataMap =
            Map<String, DynamicCategoryDataModel>.fromEntries(
          preSelectedData.map((e) => MapEntry(e.fieldId, e)),
        );

        //Set the pre selected data, if available in the dynamic fields
        for (var dynamicField in dynamicCategoryFields) {
          final preSelectedData = preSelectedDataMap[dynamicField.fieldId];
          if (preSelectedData != null) {
            dynamicField.setPreSelectedData(preSelectedData);
          }
        }
      }

      emit(DynamicCategoryFieldControllerLoaded(dynamicCategoryFields));
    } catch (e) {
      emit(DynamicCategoryFieldControllerError(e.toString()));
    }
  }

  //Refresh state
  void refreshState() {
    if (state is DynamicCategoryFieldControllerLoaded) {
      final loadedState = state as DynamicCategoryFieldControllerLoaded;

      //emit loading state
      emit(DynamicCategoryFieldControllerLoading());
      emit(DynamicCategoryFieldControllerLoaded(loadedState.dynamicFields));
    }
  }

  bool validateDynamicFieldsData() {
    //check the dynamic fields validation
    final dynamicFieldState = state;
    if (dynamicFieldState is DynamicCategoryFieldControllerLoaded) {
      for (var dynamicField in dynamicFieldState.dynamicFields) {
        final validation = dynamicField.validate();
        if (validation != null) {
          ThemeToast.errorToast(validation);
          return false;
        }
      }
      return true;
    }
    return false;
  }

  List<DynamicCategoryDataModel> getDynamicFieldsData() {
    final dynamicFieldState = state;
    List<DynamicCategoryDataModel> dynamicFields = [];
    if (dynamicFieldState is DynamicCategoryFieldControllerLoaded) {
      for (var dynamicField in dynamicFieldState.dynamicFields) {
        if (dynamicField.toDataModel() != null) {
          dynamicFields.add(dynamicField.toDataModel()!);
        }
      }
    }
    return dynamicFields;
  }
}
