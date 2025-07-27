// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'fetch_address_suggestions_by_query_cubit.dart';

class FetchAddressSuggestionsByQueryState extends Equatable {
  final List<LocationByAddressModel> addressSugegstions;
  final bool isLoading;
  final bool showBlankScreen;
  const FetchAddressSuggestionsByQueryState({
    this.addressSugegstions = const [],
    this.isLoading = false,
    this.showBlankScreen = true,
  });

  @override
  List<Object> get props => [addressSugegstions, isLoading, showBlankScreen];

  FetchAddressSuggestionsByQueryState copyWith({
    List<LocationByAddressModel>? addressSugegstions,
    bool? isLoading,
    bool? showBlankScreen,
  }) {
    return FetchAddressSuggestionsByQueryState(
      addressSugegstions: addressSugegstions ?? this.addressSugegstions,
      isLoading: isLoading ?? false,
      showBlankScreen: showBlankScreen ?? false,
    );
  }
}
