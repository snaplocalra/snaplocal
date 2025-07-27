part of 'bool_enable_option_cubit.dart';

class BoolEnableOptionState extends Equatable {
  final bool isEnable;
  const BoolEnableOptionState({required this.isEnable});

  @override
  List<Object> get props => [isEnable];

  BoolEnableOptionState copyWith({bool? isEnable}) {
    return BoolEnableOptionState(isEnable: isEnable ?? false);
  }
}
