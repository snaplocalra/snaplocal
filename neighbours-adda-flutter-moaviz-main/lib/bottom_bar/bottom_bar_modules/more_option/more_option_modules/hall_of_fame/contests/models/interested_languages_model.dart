// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:snap_local/utility/localization/model/language_model.dart';

class InterestedLanguagesModel extends Equatable {
  final List<LanguageModel> data;
  final List<LanguageModel> multiSelectedData;

  const InterestedLanguagesModel({
    required this.data,
    this.multiSelectedData = const [],
  });

  @override
  List<Object> get props => [data, multiSelectedData];

  InterestedLanguagesModel copyWith({
    List<LanguageModel>? data,
    List<LanguageModel>? multiSelectedData,
  }) {
    return InterestedLanguagesModel(
      data: data ?? this.data,
      multiSelectedData: multiSelectedData ?? this.multiSelectedData,
    );
  }
}
