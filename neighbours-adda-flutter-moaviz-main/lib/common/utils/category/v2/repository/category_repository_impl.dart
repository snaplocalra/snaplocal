import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';

abstract class CategoryRepositoryImpl {
  //Fetch categories from the server
  Future<CategoryListModelV2> fetchCategories(String apiEndpoint);
}
