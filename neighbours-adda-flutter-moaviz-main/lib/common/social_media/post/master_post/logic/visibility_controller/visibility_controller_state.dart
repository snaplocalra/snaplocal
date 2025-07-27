// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'visibility_controller_cubit.dart';

class VisibilityControllerState extends Equatable {
  final bool isVisible;
  const VisibilityControllerState({this.isVisible = true});

  @override
  List<Object> get props => [isVisible];

  VisibilityControllerState copyWith({bool? isVisible}) {
    return VisibilityControllerState(
      isVisible: isVisible ?? this.isVisible,
    );
  }
}
