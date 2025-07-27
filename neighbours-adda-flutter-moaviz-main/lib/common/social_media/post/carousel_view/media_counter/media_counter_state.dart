// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'media_counter_cubit.dart';

class MediaCounterState extends Equatable {
  final int curentMediaIndex;
  const MediaCounterState({required this.curentMediaIndex});

  @override
  List<Object> get props => [curentMediaIndex];

  MediaCounterState copyWith({int? curentMediaIndex}) {
    return MediaCounterState(
      curentMediaIndex: curentMediaIndex ?? this.curentMediaIndex,
    );
  }
}
