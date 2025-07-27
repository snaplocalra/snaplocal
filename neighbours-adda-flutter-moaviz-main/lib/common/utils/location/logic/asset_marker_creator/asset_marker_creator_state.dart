// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'asset_marker_creator_cubit.dart';

class AssetMarkerCreatorState extends Equatable {
  final bool loading;
  final Set<Marker> markers;
  const AssetMarkerCreatorState({
    this.loading = false,
    this.markers = const {},
  });

  @override
  List<Object> get props => [loading, markers];

  AssetMarkerCreatorState copyWith({
    bool? loading,
    Set<Marker>? markers,
  }) {
    return AssetMarkerCreatorState(
      loading: loading ?? false,
      markers: markers ?? this.markers,
    );
  }
}
