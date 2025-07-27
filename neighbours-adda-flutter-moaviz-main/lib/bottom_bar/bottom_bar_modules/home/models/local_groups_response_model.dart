import 'package:equatable/equatable.dart';
import 'local_group_model.dart';

class LocalGroupsResponseModel extends Equatable {
  final String status;
  final String message;
  final List<LocalGroupModel> data;

  const LocalGroupsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LocalGroupsResponseModel.fromJson(Map<String, dynamic> json) {
    return LocalGroupsResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((group) => LocalGroupModel.fromJson(group))
          .toList(),
    );
  }

  factory LocalGroupsResponseModel.fromMap(Map<String, dynamic> map) {
    return LocalGroupsResponseModel(
      status: map['status'] as String,
      message: map['message'] as String,
      data: (map['data'] as List)
          .map((group) => LocalGroupModel.fromJson(group as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((group) => group.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, message, data];
} 