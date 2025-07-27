import 'package:snap_local/common/utils/category/v2/model/category_v2_selection_strategy.dart';

abstract class CategoryType {
  final String title;

  final CategoryV2SelectStrategy categorySelectStrategy;

  final String apiEndPoint;

  CategoryType({
    required this.title,
    required this.categorySelectStrategy,
    required this.apiEndPoint,
  });
}

//Job category
class JobCategory implements CategoryType {
  @override
  final CategoryV2SelectStrategy categorySelectStrategy;

  @override
  final String title = 'Select Job Category';

  @override
  final String apiEndPoint = "jobs/job_categories";

  JobCategory(CategoryV2SelectStrategy strategy)
      : categorySelectStrategy = strategy;
}

//Business category
class BusinessCategory implements CategoryType {
  @override
  final CategoryV2SelectStrategy categorySelectStrategy;

  @override
  final String title = 'Select Business Category';

  @override
  final String apiEndPoint = "business/business_page_categories";

  BusinessCategory(CategoryV2SelectStrategy strategy)
      : categorySelectStrategy = strategy;
}

//Buy and Sell category
class BuyAndSellCategory implements CategoryType {
  @override
  final CategoryV2SelectStrategy categorySelectStrategy;

  @override
  final String title = 'Select Buy and Sell Category';

  @override
  final String apiEndPoint = "v2/market/sales_categories";

  BuyAndSellCategory(CategoryV2SelectStrategy strategy)
      : categorySelectStrategy = strategy;
}

//Group category
class GroupCategory implements CategoryType {
  @override
  final CategoryV2SelectStrategy categorySelectStrategy;

  @override
  final String title = 'Select Group Category';

  @override
  final String apiEndPoint = "groups/group_categories_list";

  GroupCategory(CategoryV2SelectStrategy strategy)
      : categorySelectStrategy = strategy;
}

//Page category
class PageCategory implements CategoryType {
  @override
  final CategoryV2SelectStrategy categorySelectStrategy;

  @override
  final String title = 'Select Page Category';

  @override
  final String apiEndPoint = "pages/page_create_categories";

  PageCategory(CategoryV2SelectStrategy strategy)
      : categorySelectStrategy = strategy;
}

//Poll category
class PollCategory implements CategoryType {
  @override
  final CategoryV2SelectStrategy categorySelectStrategy;

  @override
  final String title = 'Select Poll Category';

  @override
  final String apiEndPoint = "v2/polls/polls/categories_list";

  PollCategory(CategoryV2SelectStrategy strategy)
      : categorySelectStrategy = strategy;
}
