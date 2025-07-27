// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'rating_builder_cubit.dart';

class RatingBuilderState extends Equatable {
  final double givenRating;
  const RatingBuilderState({this.givenRating = 0.0});

  @override
  List<Object> get props => [givenRating];

  RatingBuilderState copyWith({double? givenRating}) {
    return RatingBuilderState(givenRating: givenRating ?? this.givenRating);
  }
}
