part of 'manage_discount_cubit.dart';

class ManageDiscountOptionState extends Equatable {
  final bool dataLoading;
  final BusinessDiscountOptionList businessDiscountOptionList;
  const ManageDiscountOptionState({
    this.dataLoading = false,
    required this.businessDiscountOptionList,
  });

  @override
  List<Object> get props => [dataLoading, businessDiscountOptionList];

  ManageDiscountOptionState copyWith({
    bool? dataLoading,
    BusinessDiscountOptionList? businessDiscountOptionList,
  }) {
    return ManageDiscountOptionState(
      dataLoading: dataLoading ?? false,
      businessDiscountOptionList:
          businessDiscountOptionList ?? this.businessDiscountOptionList,
    );
  }
}
