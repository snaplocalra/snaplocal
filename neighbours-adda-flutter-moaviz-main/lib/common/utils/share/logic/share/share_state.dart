part of 'share_cubit.dart';

class ShareState extends Equatable {
  final bool requestLoading;
  const ShareState({this.requestLoading = false});

  @override
  List<Object> get props => [requestLoading];

  ShareState copyWith({bool? requestLoading}) {
    return ShareState(requestLoading: requestLoading ?? false);
  }
}
