part of 'give_reaction_cubit.dart';

class GiveReactionState extends Equatable {
  final bool isRequestLoading;
  const GiveReactionState({this.isRequestLoading = false});

  @override
  List<Object> get props => [isRequestLoading];

  GiveReactionState copyWith({bool? isRequestLoading}) {
    return GiveReactionState(isRequestLoading: isRequestLoading ?? false);
  }
}
