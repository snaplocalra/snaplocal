part of 'dynamic_field_controller_cubit.dart';

sealed class DynamicCategoryFieldControllerState extends Equatable {
  const DynamicCategoryFieldControllerState();

  @override
  List<Object> get props => [];
}

final class DynamicCategoryFieldControllerInitial
    extends DynamicCategoryFieldControllerState {}

final class DynamicCategoryFieldControllerLoading
    extends DynamicCategoryFieldControllerState {}

final class DynamicCategoryFieldControllerLoaded
    extends DynamicCategoryFieldControllerState {
  final List<DynamicCategoryField> dynamicFields;

  const DynamicCategoryFieldControllerLoaded(this.dynamicFields);

  @override
  List<Object> get props => [dynamicFields];
}

final class DynamicCategoryFieldControllerError
    extends DynamicCategoryFieldControllerState {
  final String error;

  const DynamicCategoryFieldControllerError(this.error);

  @override
  List<Object> get props => [error];
}
