import 'dart:convert';

import 'package:snap_local/common/utils/category/v3/dynamic_category_field/model/dynamic_category_data_model/dynamic_category_data_model.dart';
import 'package:snap_local/common/utils/category/v2/model/category_model_v2.dart';

class CategoryModelV3 {
  final String id;
  final String name;
  final SubCategoryModel subCategory;
  final List<DynamicCategoryDataModel> dynamicFields;

  CategoryModelV3({
    required this.id,
    required this.name,
    required this.subCategory,
    required this.dynamicFields,
  });

  //from Map
  factory CategoryModelV3.fromMap(Map<String, dynamic> map) {
    return CategoryModelV3(
      id: map['id'],
      name: map['name'],
      subCategory: SubCategoryModel.fromMap(map['sub_category']),
      dynamicFields: List<DynamicCategoryDataModel>.from(
        map['dynamic_category'].map(
          (x) => DynamicCategoryDataModel.fromMap(x),
        ),
      ),
    );
  }

  //to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sub_category': subCategory.toMap(),
      'dynamic_category': dynamicFields.map((x) => x.toMap()).toList(),
    };
  }

  //toJson
  String toJson() => json.encode(toMap());
}
