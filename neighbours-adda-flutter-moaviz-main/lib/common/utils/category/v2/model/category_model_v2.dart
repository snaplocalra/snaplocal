import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:snap_local/common/utils/category/v2/model/category_v2_preselection_strategy.dart';

import '../../../../../utility/constant/errors.dart';

class CategoryListModelV2 extends Equatable {
  final List<CategoryModelV2> data;

  const CategoryListModelV2({required this.data});

  factory CategoryListModelV2.fromMap(List<dynamic> dataList) {
    return CategoryListModelV2(
      //use for storing main data
      data: List<CategoryModelV2>.from(
        dataList.map<CategoryModelV2>(
          (x) => CategoryModelV2.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [data];

  //Check if there are no sub categories selected
  bool get isNoSubCategorySelected => selectedCategories.isEmpty;

  //Selected category list
  List<CategoryModelV2> get selectedCategories => data
      .where((category) =>
          category.subCategories.any((subCategory) => subCategory.isSelected))
      .toList();

  //Selected data map
  List<Map<String, dynamic>> get selectedDataMap => selectedCategories
      .map((category) => category.selectedSubCategoryMap())
      .toList();

  //json string for the selected data map
  String selectedDataJson() => json.encode(selectedDataMap);

  //clear all the sub categories selection
  void clearAllSelection() {
    for (var categoryIndex = 0; categoryIndex < data.length; categoryIndex++) {
      for (var subCategoryIndex = 0;
          subCategoryIndex < data[categoryIndex].subCategories.length;
          subCategoryIndex++) {
        data[categoryIndex].subCategories[subCategoryIndex] =
            data[categoryIndex]
                .subCategories[subCategoryIndex]
                .copyWith(isSelected: false);
      }
    }
  }

  //Selected sub category String
  String selectedSubCategoryString() {
    return selectedCategories
        .expand((category) => category.subCategories)
        .where((subCategory) => subCategory.isSelected)
        .map((subCategory) => subCategory.name)
        .join(", ");
  }

  //Sub category string
  String subCategoryString() {
    return data
        .expand((category) => category.subCategories)
        .map((subCategory) => subCategory.name)
        .join(", ");
  }

  // Assign pre selected categories, based on the provided pre selected categories
  // this will update the selected sub categories in data list
  CategoryListModelV2 assignPreSelectedCategories(
      CategoryV2PreselectionStrategy preselectionStrategy) {
    return preselectionStrategy.preselectCategories(data);
  }

  //Add other type sub category with the every category
  void addOtherTypeSubCategory() {
    for (var i = 0; i < data.length; i++) {
      data[i].subCategories.add(SubCategoryModel.otherType());
    }
    return;
  }
}

class CategoryModelV2 {
  final String id;
  final String name;
  final List<SubCategoryModel> subCategories;

  CategoryModelV2({
    required this.id,
    required this.name,
    required this.subCategories,
  });

  //from map
  factory CategoryModelV2.fromMap(Map<String, dynamic> map) {
    final subCategories = map['sub_categories'];
    return CategoryModelV2(
      id: map['id'] as String,
      name: map['name'] as String,
      subCategories: subCategories == null
          ? []
          : List<SubCategoryModel>.from(
              subCategories.map<SubCategoryModel>(
                  (x) => SubCategoryModel.fromMap(x as Map<String, dynamic>)),
            ),
    );
  }

  SubCategoryModel? get selectedSubCategory {
    return subCategories.firstWhereOrNull(
      (subCategory) => subCategory.isSelected,
    );
  }

  String selectedSubCategoryString() {
    return subCategories
        .where((subCategory) => subCategory.isSelected)
        .map((subCategory) => subCategory.name)
        .join(", ");
  }

  //Sub category string
  String subCategoryString() {
    return subCategories.map((subCategory) => subCategory.name).join(", ");
  }

  //copy with method
  CategoryModelV2 copyWith({
    String? id,
    String? name,
    List<SubCategoryModel>? subCategories,
  }) {
    return CategoryModelV2(
      id: id ?? this.id,
      name: name ?? this.name,
      subCategories: subCategories ?? this.subCategories,
    );
  }

  //Selected category map
  Map<String, dynamic> selectedSubCategoryMap({
    bool ignoreOtherCategoryName = false,
  }) =>
      {
        'category_id': id,
        'sub_category_ids': subCategories
            .where((subCategory) => subCategory.isSelected)
            .map((subCategory) => subCategory.id)
            .join(','),
        if (!ignoreOtherCategoryName)
          //This will be only used for other type category
          'other_sub_category_custom_name': subCategories.any((subCategory) =>
                  //check for if the sub category is other type and selected
                  subCategory.isOtherType && subCategory.isSelected)
              ? subCategories
                  .firstWhere((subCategory) => subCategory.isOtherType)
                  .name
              : null,
      };

  //to map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'sub_categories': subCategories.map((x) => x.toMap()).toList(),
    };
  }
}

class SubCategoryModel {
  final String id;
  String name;
  bool isSelected = false;

  SubCategoryModel({
    required this.id,
    required this.name,
    this.isSelected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory SubCategoryModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildSubCategory(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildSubCategory(map);
    }
  }

  static SubCategoryModel _buildSubCategory(Map<String, dynamic> map) {
    return SubCategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }

  static const String otherName = "Other";

  //other type
  factory SubCategoryModel.otherType() {
    return SubCategoryModel(
      id: '0',
      name: otherName,
    );
  }

  bool get isOtherType => id == '0';

  String toJson() => json.encode(toMap());

  factory SubCategoryModel.fromJson(String source) =>
      SubCategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  //copy with method
  SubCategoryModel copyWith({
    String? id,
    String? name,
    bool? isSelected,
  }) {
    return SubCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
