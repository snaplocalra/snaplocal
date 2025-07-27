import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_news_model.dart';

class LocalNewsResponse extends Equatable {
  final String status;
  final String message;
  final List<LocalNewsModel> data;

  const LocalNewsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory LocalNewsResponse.fromMap(Map<String, dynamic> map) {
    return LocalNewsResponse(
      status: map['status'] ?? '',
      message: map['message'] ?? '',
      data: List<LocalNewsModel>.from(
        (map['data'] ?? []).map((x) => LocalNewsModel.fromMap(x as Map<String, dynamic>)),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'message': message,
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, message, data];
} 