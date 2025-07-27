// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';



class PostIndexModel {
  final String postType;
  final String displayIndex;

  PostIndexModel({
    required this.postType,
    required this.displayIndex,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'post_type': postType.toString(),
      'display_index': displayIndex,
    };
  }

  factory PostIndexModel.fromMap(Map<String, dynamic> map) {
    return PostIndexModel(
      postType: map['post_type'],
      displayIndex: map['display_index'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PostIndexModel.fromJson(String source) =>
      PostIndexModel.fromMap(json.decode(source) as Map<String, dynamic>);

  PostIndexModel copyWith({
    String? postType,
    String? displayIndex,
  }) {
    return PostIndexModel(
      postType: postType ?? this.postType,
      displayIndex: displayIndex ?? this.displayIndex,
    );
  }
} 