import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/models/business_discount_option_model.dart';

part 'manage_discount_state.dart';

class ManageDiscountOptionCubit extends Cubit<ManageDiscountOptionState> {
  ManageDiscountOptionCubit()
      : super(ManageDiscountOptionState(
          businessDiscountOptionList: BusinessDiscountOptionList(data: [
            //Add the default empty option
            BusinessDiscountOptionModel.empty,
          ]),
        ));

  void addInitialData(List<BusinessDiscountOptionModel> discountOptions) {
    emit(state.copyWith(
      businessDiscountOptionList:
          BusinessDiscountOptionList(data: discountOptions),
    ));
  }

  void addOption() {
    final existingOptionList = List<BusinessDiscountOptionModel>.from(
        state.businessDiscountOptionList.data);
    emit(state.copyWith(dataLoading: true));
    //The default id will send as 0, to insert in server database
    existingOptionList.add(BusinessDiscountOptionModel.empty);
    emit(
      state.copyWith(
        businessDiscountOptionList:
            BusinessDiscountOptionList(data: existingOptionList),
      ),
    );
  }

  void removeOption(int optionIndex) {
    emit(state.copyWith(dataLoading: true));
    state.businessDiscountOptionList.data.removeAt(optionIndex);
    emit(state.copyWith());

    emit(state.copyWith(
      businessDiscountOptionList: BusinessDiscountOptionList(
        data: List.from(state.businessDiscountOptionList.data),
      ),
    ));
  }

//Add discount value in option
  void addDiscountValue(String text, int optionIndex) {
    final existingOptionList = state.businessDiscountOptionList.data;

    //Update the discount value text
    existingOptionList[optionIndex] =
        existingOptionList[optionIndex].copyWith(value: text);
  }

  //Add discount on in option
  void addDiscountOn(String text, int optionIndex) {
    final existingOptionList = state.businessDiscountOptionList.data;

    //Update the discount on text
    existingOptionList[optionIndex] =
        existingOptionList[optionIndex].copyWith(discountOn: text);
  }
}
