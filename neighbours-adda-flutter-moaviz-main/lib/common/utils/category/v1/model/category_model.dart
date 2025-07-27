import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:snap_local/utility/localization/translation/locale_keys.g.dart';

import '../../../../../utility/constant/errors.dart';

class CategoryListModel extends Equatable {
  final List<CategoryModel> data;

  const CategoryListModel({required this.data});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryListModel.emptyModel() {
    return const CategoryListModel(data: []);
  }
  factory CategoryListModel.fromMap(Map<String, dynamic> map) {
    return CategoryListModel(
      //use for storing main data
      data: List<CategoryModel>.from(
        (map['data']).map<CategoryModel>(
            (x) => CategoryModel.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  @override
  List<Object?> get props => [data];

  CategoryListModel copyWith({List<CategoryModel>? data}) {
    return CategoryListModel(data: data ?? this.data);
  }

  //Selected data list of category
  List<CategoryModel> get selectedData =>
      data.where((element) => element.isSelected).toList();

  //Selected 1st data of category
  CategoryModel? get selectedFirstData =>
      data.firstWhereOrNull((element) => element.isSelected);
}

class CategoryModel {
  final String id;
  final String name;
  final String? imageUrl;
  bool isSelected = false;

  CategoryModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.isSelected = false,
  });

  factory CategoryModel.allType() =>
      CategoryModel(id: 'all', name: LocaleKeys.all);

  bool get isOtherCategory =>
      name.trim().toLowerCase() == 'others' ||
      name.trim().toLowerCase() == 'other';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'image': imageUrl,
      'isSelected': isSelected,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    if (isDebug) {
      try {
        return _buildCategory(map);
      } on TypeError {
        throw ErrorConstants.nullPointer;
      } catch (_) {
        throw ErrorConstants.nullPointer;
      }
    } else {
      return _buildCategory(map);
    }
  }

  static CategoryModel _buildCategory(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  //copy with method
  CategoryModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    bool? isSelected,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
