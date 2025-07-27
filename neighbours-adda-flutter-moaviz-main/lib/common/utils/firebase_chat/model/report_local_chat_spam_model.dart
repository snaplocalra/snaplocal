import 'package:equatable/equatable.dart';

class ReportLocalChatSpamReasonList extends Equatable {
  final List<ReportLocalChatSpamReasonModel> data;
  final ReportLocalChatSpamReasonModel? selectedData;

  const ReportLocalChatSpamReasonList({
    this.data = const [],
    this.selectedData,
  });

  factory ReportLocalChatSpamReasonList.fromMap(Map<String, dynamic> map) {
    return ReportLocalChatSpamReasonList(
      data: List<ReportLocalChatSpamReasonModel>.from(
        (map['data']).map<ReportLocalChatSpamReasonModel>(
          (x) => ReportLocalChatSpamReasonModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [data, selectedData];

  ReportLocalChatSpamReasonList copyWith({
    List<ReportLocalChatSpamReasonModel>? data,
    ReportLocalChatSpamReasonModel? selectedData,
  }) {
    return ReportLocalChatSpamReasonList(
      data: data ?? this.data,
      selectedData: selectedData ?? this.selectedData,
    );
  }
}

class ReportLocalChatSpamReasonModel {
  final String id;
  final String reason;
  bool isSelected = false;

  ReportLocalChatSpamReasonModel({
    required this.id,
    required this.reason,
    this.isSelected = false,
  });

  factory ReportLocalChatSpamReasonModel.fromMap(Map<String, dynamic> map) {
    return ReportLocalChatSpamReasonModel(
      id: map['id'] as String,
      reason: map['reason'] as String,
    );
  }
} 