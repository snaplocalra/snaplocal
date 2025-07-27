part of 'read_more_controller_cubit.dart';

class ReadMoreControllerState extends Equatable {
  final bool enableReadMore;
  final int? maxLine;
  final TextOverflow textOverflow;
  const ReadMoreControllerState({
    this.enableReadMore = false,
    this.maxLine = 4,
    this.textOverflow = TextOverflow.visible,
  });

  @override
  List<Object?> get props => [enableReadMore, maxLine, textOverflow];

  ReadMoreControllerState copyWith({
    bool? enableReadMore,
    int? maxLine,
    TextOverflow? textOverflow,
  }) {
    return ReadMoreControllerState(
      enableReadMore: enableReadMore ?? this.enableReadMore,
      maxLine: maxLine,
      textOverflow: textOverflow ?? this.textOverflow,
    );
  }
}
