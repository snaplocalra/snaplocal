import 'package:equatable/equatable.dart';
import 'package:snap_local/bottom_bar/bottom_bar_modules/businesses/modules/manage_business/business_timming/model/business_timming_model.dart';

class BusinessHoursModel extends Equatable {
  final bool alwaysOpen;
  final List<BusinessWeekDayModel> businessWeekDayModel;

  const BusinessHoursModel({
    required this.alwaysOpen,
    required this.businessWeekDayModel,
  });

  BusinessHoursModel copyWith({
    bool? alwaysOpen,
    List<BusinessWeekDayModel>? businessWeekDayModel,
  }) {
    return BusinessHoursModel(
      alwaysOpen: alwaysOpen ?? this.alwaysOpen,
      businessWeekDayModel: businessWeekDayModel ?? this.businessWeekDayModel,
    );
  }

  //FromMap
  factory BusinessHoursModel.fromMap(Map<String, dynamic> map) {
    return BusinessHoursModel(
      alwaysOpen: map['always_open'],
      businessWeekDayModel: List<BusinessWeekDayModel>.from(
        map['selected_hours'].map((x) => BusinessWeekDayModel.fromMap(x)),
      ),
    );
  }

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      'always_open': alwaysOpen,
      'selected_hours': businessWeekDayModel.map((x) => x.toMap()).toList(),
    };
  }

  @override
  List<Object?> get props => [alwaysOpen, businessWeekDayModel];
}
