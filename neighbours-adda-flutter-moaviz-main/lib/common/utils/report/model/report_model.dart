import 'package:equatable/equatable.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReportReasonList extends Equatable {
  final List<ReportReasonModel> data;
  final ReportReasonModel? selectedData;

  const ReportReasonList({
    this.data = const [],
    this.selectedData,
  });

  factory ReportReasonList.fromMap(Map<String, dynamic> map) {
    return ReportReasonList(
      data: List<ReportReasonModel>.from(
        (map['data']).map<ReportReasonModel>(
          (x) => ReportReasonModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  List<Object?> get props => [data, selectedData];

  ReportReasonList copyWith({
    List<ReportReasonModel>? data,
    ReportReasonModel? selectedData,
  }) {
    return ReportReasonList(
      data: data ?? this.data,
      selectedData: selectedData ?? this.selectedData,
    );
  }
}

class ReportReasonModel {
  final String id;
  final String reason;
  bool isSelected = false;

  ReportReasonModel({
    required this.id,
    required this.reason,
    this.isSelected = false,
  });

  factory ReportReasonModel.fromMap(Map<String, dynamic> map) {
    return ReportReasonModel(
      id: map['id'] as String,
      reason: map['reason'] as String,
    );
  }
}
