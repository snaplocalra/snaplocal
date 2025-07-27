import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_offers_response.dart';

class LocalOffersState extends Equatable {
  final bool dataLoading;
  final List<LocalOffer> offers;
  final String? error;

  const LocalOffersState({
    required this.dataLoading,
    required this.offers,
    this.error,
  });

  LocalOffersState copyWith({
    bool? dataLoading,
    List<LocalOffer>? offers,
    String? error,
  }) {
    return LocalOffersState(
      dataLoading: dataLoading ?? this.dataLoading,
      offers: offers ?? this.offers,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dataLoading': dataLoading,
      'offers': offers.map((x) => x.toMap()).toList(),
      'error': error,
    };
  }

  factory LocalOffersState.fromMap(Map<String, dynamic> map) {
    return LocalOffersState(
      dataLoading: map['dataLoading'] ?? false,
      offers: List<LocalOffer>.from(
        (map['offers'] ?? []).map((x) => LocalOffer.fromMap(x)),
      ),
      error: map['error'],
    );
  }

  @override
  List<Object?> get props => [dataLoading, offers, error];
} 