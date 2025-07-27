// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quiz_banners_cubit.dart';

class QuizBannersState extends Equatable {
  final bool dataLoading;
  final String? bannerImage;
  final String? error;
  const QuizBannersState({
    this.dataLoading = false,
    this.bannerImage,
    this.error,
  });

  @override
  List<Object?> get props => [dataLoading, bannerImage, error];

  QuizBannersState copyWith({
    bool? dataLoading,
    String? bannerImage,
    String? error,
  }) {
    return QuizBannersState(
      dataLoading: dataLoading ?? false,
      bannerImage: bannerImage ?? this.bannerImage,
      error: error
    );
  }
}
