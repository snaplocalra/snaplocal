import 'package:snap_local/common/utils/category/v1/model/category_v1_selection_strategy.dart';

class CategoryV1Type {
  final String apiEndPoint;

  final CategoryV1SelectStrategy categorySelectStrategy;

  CategoryV1Type({
    required this.apiEndPoint,
    required this.categorySelectStrategy,
  });
}

class PollCategoryTypeV1 implements CategoryV1Type {
  @override
  final String apiEndPoint = "v2/polls/polls/categories";

  @override
  final CategoryV1SelectStrategy categorySelectStrategy;

  PollCategoryTypeV1(this.categorySelectStrategy);
}

class NewsCategoryTypeV1 implements CategoryV1Type {
  @override
  final String apiEndPoint = "channels/news_categories";

  @override
  final CategoryV1SelectStrategy categorySelectStrategy;

  NewsCategoryTypeV1(this.categorySelectStrategy);
}
