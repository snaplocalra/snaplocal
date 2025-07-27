part of 'search_cubit.dart';

class SearchState extends Equatable {
  final String? query;
  const SearchState({this.query});

  @override
  List<Object?> get props => [query];

  SearchState copyWith({String? query}) {
    return SearchState(query: query);
  }
}
