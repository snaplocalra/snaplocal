part of 'home_local_pages_cubit.dart';

class HomeLocalPagesState extends Equatable {
  final bool dataLoading;
  final List<LocalPageModel> localPages;
  final String? error;

  const HomeLocalPagesState({
    required this.dataLoading,
    required this.localPages,
    this.error,
  });

  HomeLocalPagesState copyWith({
    bool? dataLoading,
    List<LocalPageModel>? localPages,
    String? error,
  }) {
    return HomeLocalPagesState(
      dataLoading: dataLoading ?? this.dataLoading,
      localPages: localPages ?? this.localPages,
      error: error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dataLoading': dataLoading,
      'localPages': localPages.map((page) => page.toJson()).toList(),
      'error': error,
    };
  }

  factory HomeLocalPagesState.fromMap(Map<String, dynamic> map) {
    return HomeLocalPagesState(
      dataLoading: map['dataLoading'] as bool,
      localPages: (map['localPages'] as List)
          .map((page) => LocalPageModel.fromJson(page as Map<String, dynamic>))
          .toList(),
      error: map['error'] as String?,
    );
  }

  @override
  List<Object?> get props => [dataLoading, localPages, error];
} 