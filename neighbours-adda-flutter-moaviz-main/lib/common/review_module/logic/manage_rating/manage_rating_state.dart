// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'manage_rating_cubit.dart';

class ManageRatingState extends Equatable {
  final bool requestLoading;
  final bool requestSuccess;
  final bool deleteRequestSuccess;
  const ManageRatingState({
    this.requestLoading = false,
    this.requestSuccess = false,
    this.deleteRequestSuccess = false,
  });

  @override
  List<Object> get props => [
        requestLoading,
        requestSuccess,
        deleteRequestSuccess,
      ];

  ManageRatingState copyWith({
    bool? requestLoading,
    bool? requestSuccess,
    bool? deleteRequestSuccess,
  }) {
    return ManageRatingState(
      requestLoading: requestLoading ?? false,
      requestSuccess: requestSuccess ?? false,
      deleteRequestSuccess: deleteRequestSuccess ?? false,
    );
  }
}
