import 'package:snap_local/bottom_bar/bottom_bar_modules/more_option/more_option_modules/polls/content_filter_tab/logic/content_filter_tab/content_filter_tab_cubit.dart';

abstract class ContentFilterModel {
  List<ContentFilterTabCategory> get viewFilters;
}

//PollsContentFilterModel
class PollsContentFilterModel implements ContentFilterModel {
  @override
  List<ContentFilterTabCategory> get viewFilters => [
        ContentFilterTabCategory(viewFilterType: ContentFilterTabType.all),
        ContentFilterTabCategory(viewFilterType: ContentFilterTabType.local),
        ContentFilterTabCategory(viewFilterType: ContentFilterTabType.trending),
        ContentFilterTabCategory(
          viewFilterType: ContentFilterTabType.categories,
        ),
      ];
}

//NewsContentFilterModel
class NewsContentFilterModel implements ContentFilterModel {
  @override
  List<ContentFilterTabCategory> get viewFilters => [
        ContentFilterTabCategory(viewFilterType: ContentFilterTabType.all),
        ContentFilterTabCategory(viewFilterType: ContentFilterTabType.local),
        ContentFilterTabCategory(viewFilterType: ContentFilterTabType.trending),
        ContentFilterTabCategory(viewFilterType: ContentFilterTabType.state),
        ContentFilterTabCategory(viewFilterType: ContentFilterTabType.national),
        ContentFilterTabCategory(
            viewFilterType: ContentFilterTabType.international),
        ContentFilterTabCategory(
          viewFilterType: ContentFilterTabType.categories,
        ),
      ];
}
