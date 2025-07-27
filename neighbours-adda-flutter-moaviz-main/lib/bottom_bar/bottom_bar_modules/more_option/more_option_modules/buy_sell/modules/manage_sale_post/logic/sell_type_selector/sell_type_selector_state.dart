part of 'sell_type_selector_cubit.dart';

class SellTypeSelectorState extends Equatable {
  final SellType sellType;
  const SellTypeSelectorState(this.sellType);

  @override
  List<Object> get props => [sellType];

  SellTypeSelectorState copyWith({SellType? sellType}) {
    return SellTypeSelectorState(sellType ?? this.sellType);
  }
}
