import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/home/models/local_buy_sell_model.dart';



class LocalBuyAndSellState extends Equatable {
  final bool dataLoading;
  final List<BuyAndSellItem> buyAndSellItems;
  final String? error;

  const LocalBuyAndSellState({
    required this.dataLoading,
    required this.buyAndSellItems,
    this.error,
  });

  LocalBuyAndSellState copyWith({
    bool? dataLoading,
    List<BuyAndSellItem>? buyAndSellItems,
    String? error,
  }) {
    return LocalBuyAndSellState(
      dataLoading: dataLoading ?? this.dataLoading,
      buyAndSellItems: buyAndSellItems ?? this.buyAndSellItems,
      error: error ?? this.error,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dataLoading': dataLoading,
      'buyAndSellItems': buyAndSellItems.map((x) => x.toMap()).toList(),
      'error': error,
    };
  }

  factory LocalBuyAndSellState.fromMap(Map<String, dynamic> map) {
    return LocalBuyAndSellState(
      dataLoading: map['dataLoading'] ?? false,
      buyAndSellItems: List<BuyAndSellItem>.from(
        (map['buyAndSellItems'] ?? []).map((x) => BuyAndSellItem.fromMap(x)),
      ),
      error: map['error'],
    );
  }

  @override
  List<Object?> get props => [dataLoading, buyAndSellItems, error];
} 