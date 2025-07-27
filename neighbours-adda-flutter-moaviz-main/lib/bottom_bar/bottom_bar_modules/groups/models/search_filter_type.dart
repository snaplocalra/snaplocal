enum SearchFilterTypeEnum {
  yourGroups(
    displayName: 'Your Groups',
    jsonValue: 'your_groups',
  ),
  yourPages(
    displayName: 'Your Pages',
    jsonValue: 'your_pages',
  ),
  suggested(
    displayName: 'Suggested',
    jsonValue: 'suggested',
  ),
  favorite(
    displayName: 'Favorite',
    jsonValue: 'favorite',
  );

  final String displayName;
  final String jsonValue;

  const SearchFilterTypeEnum({
    required this.displayName,
    required this.jsonValue,
  });

  factory SearchFilterTypeEnum.fromJson(String jsonValue) {
    switch (jsonValue) {
      case 'your_groups':
        return yourGroups;
      case 'your_pages':
        return yourPages;
      case 'suggested':
        return suggested;
      case 'favorite':
        return favorite;
      default:
        throw Exception('Invalid GroupSearchType');
    }
  }
}

class SearchFilterTypeCategory {
  final SearchFilterTypeEnum type;
  bool isSelected;

  SearchFilterTypeCategory({
    required this.type,
    this.isSelected = false,
  });
}

abstract class SearchFilterType {
  final List<SearchFilterTypeCategory> data;

  SearchFilterType({required this.data});
}

class GroupSearchFilter implements SearchFilterType {
  @override
  late final List<SearchFilterTypeCategory> data = [
    SearchFilterTypeCategory(type: SearchFilterTypeEnum.yourGroups),
    SearchFilterTypeCategory(type: SearchFilterTypeEnum.suggested),
    SearchFilterTypeCategory(type: SearchFilterTypeEnum.favorite),
  ];
}

class PageSearchFilter implements SearchFilterType {
  @override
  late final List<SearchFilterTypeCategory> data = [
    SearchFilterTypeCategory(type: SearchFilterTypeEnum.yourPages),
    SearchFilterTypeCategory(type: SearchFilterTypeEnum.suggested),
    SearchFilterTypeCategory(type: SearchFilterTypeEnum.favorite),
  ];
}
