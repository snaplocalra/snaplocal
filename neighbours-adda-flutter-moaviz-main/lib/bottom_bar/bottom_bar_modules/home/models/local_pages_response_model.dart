import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_page_model.dart';

class LocalPagesResponseModel extends Equatable {
  final String status;
  final String message;
  final List<LocalPageModel> data;

  const LocalPagesResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });


  factory LocalPagesResponseModel.fromJson(Map<String, dynamic> json) {
    return LocalPagesResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((page) => LocalPageModel.fromJson(page as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((page) => page.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, message, data];
} 