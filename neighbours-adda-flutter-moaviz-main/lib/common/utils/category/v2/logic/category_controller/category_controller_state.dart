part of 'category_controller_cubit.dart';

sealed class CategoryControllerState extends Equatable {
  const CategoryControllerState();

  @override
  List<Object> get props => [];
}

final class CategoryControllerInitial extends CategoryControllerState {}

final class CategoryControllerDataLoading extends CategoryControllerState {}

final class CategoryControllerDataLoaded extends CategoryControllerState {
  final CategoryListModelV2 categories;
  final bool isFirstLoad;
  const CategoryControllerDataLoaded({
    required this.categories,
    this.isFirstLoad = false,
  });

  @override
  List<Object> get props => [categories, isFirstLoad];
}

final class CategoryControllerDataError extends CategoryControllerState {
  final String error;
  const CategoryControllerDataError(this.error);

  @override
  List<Object> get props => [error];
}
