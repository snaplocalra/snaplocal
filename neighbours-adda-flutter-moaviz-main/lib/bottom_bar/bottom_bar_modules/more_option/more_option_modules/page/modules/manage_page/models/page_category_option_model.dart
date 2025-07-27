// import 'package:equatable/equatable.dart';

// class PageCategoryOptionListModel extends Equatable {
//   final List<PageCategoryOptionModel> data;

//   const PageCategoryOptionListModel({required this.data});

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'data': data.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory PageCategoryOptionListModel.fromMap(Map<String, dynamic> map) {
//     return PageCategoryOptionListModel(
//       data: List<PageCategoryOptionModel>.from(
//         (map['data']).map<PageCategoryOptionModel>(
//           (x) => PageCategoryOptionModel.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//     );
//   }

//   @override
//   List<Object> get props => [data];
// }

// class PageCategoryOptionModel {
//   final String id;
//   final String name;
//   final String image;
//   bool isSelected = false;

//   PageCategoryOptionModel({
//     required this.id,
//     required this.name,
//     this.image = "",
//     this.isSelected = false,
//   });

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'id': id,
//       'name': name,
//       'image': image,
//       'isSelected': isSelected,
//     };
//   }

//   factory PageCategoryOptionModel.fromMap(Map<String, dynamic> map) {
//     return PageCategoryOptionModel(
//       id: map['id'] as String,
//       name: map['name'] as String,
//       image: map['image'] ?? "",
//     );
//   }
// }
