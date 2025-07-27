part of 'interested_topics_cubit.dart';

class InterestedTopicsCategoryState extends Equatable {
  final bool dataLoading;
  final String? error;
  final CategoryListModel interestedTopicListModel;
  const InterestedTopicsCategoryState({
    this.dataLoading = false,
    this.error,
    required this.interestedTopicListModel,
  });

  @override
  List<Object?> get props => [interestedTopicListModel, dataLoading, error];

  InterestedTopicsCategoryState copyWith({
    bool? dataLoading,
    String? error,
    CategoryListModel? interestedTopicListModel,
  }) {
    return InterestedTopicsCategoryState(
      dataLoading: dataLoading ?? false,
      error: error,
      interestedTopicListModel:
          interestedTopicListModel ?? this.interestedTopicListModel,
    );
  }
}
