import 'package:flutter/material.dart';
import 'package:snap_local/utility/api_manager/pagination/models/pagination_model.dart';

class NewsWalletTransactionsModel {
  final String transactionId;
  final String paymentInfo;
  final DateTime timestamp;
  final num amount;
  final WalletTransactionStatus transactionStatus;

  NewsWalletTransactionsModel({
    required this.transactionId,
    required this.paymentInfo,
    required this.timestamp,
    required this.amount,
    required this.transactionStatus,
  });

  factory NewsWalletTransactionsModel.fromMap(Map<String, dynamic> map) {
    return NewsWalletTransactionsModel(
      transactionId: map['transaction_id'],
      paymentInfo: map['payment_info'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['created_date']),
      amount: map['amount'] as num,
      transactionStatus:
          WalletTransactionStatus.fromString(map['transaction_status']),
    );
  }
}

enum WalletTransactionStatus {
  received(
    foregroundColor: Color.fromRGBO(226, 151, 0, 1),
    backgroundColor: Color.fromRGBO(251, 251, 201, 1),
  ),
  transferred(
    foregroundColor: Color.fromRGBO(165, 13, 29, 1),
    backgroundColor: Color.fromRGBO(250, 226, 234, 1),
  );

  final Color foregroundColor;
  final Color backgroundColor;

  const WalletTransactionStatus({
    required this.foregroundColor,
    required this.backgroundColor,
  });

  //from string
  static WalletTransactionStatus fromString(String type) {
    switch (type) {
      case 'received':
        return received;
      case 'transferred':
        return transferred;
      default:
        throw Exception('Invalid type');
    }
  }
}

class NewsWalletTransactionsList {
  List<NewsWalletTransactionsModel> data;
  PaginationModel paginationModel;

  NewsWalletTransactionsList({
    required this.data,
    required this.paginationModel,
  });

  factory NewsWalletTransactionsList.emptyModel() => NewsWalletTransactionsList(
      data: [], paginationModel: PaginationModel.initial());

  factory NewsWalletTransactionsList.fromMap(Map<String, dynamic> map) {
    return NewsWalletTransactionsList(
      data: List<NewsWalletTransactionsModel>.from((map['data'])
          .map<NewsWalletTransactionsModel>(
              (x) => NewsWalletTransactionsModel.fromMap(x))),
      paginationModel: PaginationModel.fromMap(map),
    );
  }

  //Use for pagination
  NewsWalletTransactionsList paginationCopyWith(
      {required NewsWalletTransactionsList newData}) {
    data.addAll(newData.data);
    paginationModel = newData.paginationModel;
    return NewsWalletTransactionsList(
      data: data,
      paginationModel: paginationModel,
    );
  }
}
