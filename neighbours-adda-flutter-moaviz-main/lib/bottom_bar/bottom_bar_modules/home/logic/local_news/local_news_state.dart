import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_news_model.dart';

class LocalNewsState extends Equatable {
  final bool dataLoading;
  final List<LocalNewsModel> news;
  final String? error;

  const LocalNewsState({
    required this.dataLoading,
    required this.news,
    this.error,
  });

  LocalNewsState copyWith({
    bool? dataLoading,
    List<LocalNewsModel>? news,
    String? error,
  }) {
    return LocalNewsState(
      dataLoading: dataLoading ?? this.dataLoading,
      news: news ?? this.news,
      error: error ?? this.error,
    );
  }

  factory LocalNewsState.fromMap(Map<String, dynamic> map) {
    return LocalNewsState(
      dataLoading: map['dataLoading'] ?? false,
      news: List<LocalNewsModel>.from(
        (map['news'] ?? []).map((x) => LocalNewsModel.fromMap(x)),
      ),
      error: map['error'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dataLoading': dataLoading,
      'news': news.map((x) => x.toMap()).toList(),
      'error': error,
    };
  }

  @override
  List<Object?> get props => [dataLoading, news, error];
} 