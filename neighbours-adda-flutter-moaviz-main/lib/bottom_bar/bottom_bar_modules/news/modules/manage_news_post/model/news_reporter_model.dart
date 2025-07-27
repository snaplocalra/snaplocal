import 'dart:convert';

import 'package:equatable/equatable.dart';

class NewsReporter extends Equatable {
  final String name;
  final bool visibility;

  const NewsReporter({
    required this.name,
    required this.visibility,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'visibility': visibility,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory NewsReporter.fromMap(Map<String, dynamic> map) {
    return NewsReporter(
      name: map['name'],
      visibility: map['visibility'],
    );
  }

  //copy with
  NewsReporter copyWith({
    String? name,
    bool? visibility,
  }) {
    return NewsReporter(
      name: name ?? this.name,
      visibility: visibility ?? this.visibility,
    );
  }

  @override
  List<Object?> get props => [name, visibility];
}
