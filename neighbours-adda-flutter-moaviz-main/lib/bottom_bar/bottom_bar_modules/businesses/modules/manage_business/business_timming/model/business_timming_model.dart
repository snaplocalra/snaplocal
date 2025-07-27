import 'dart:convert';

class BusinessWeekDayModel {
  final bool isClosed;
  final String weekDay;
  final BusinessTimmingModel? businessTimmingModel;

  BusinessWeekDayModel({
    required this.isClosed,
    required this.weekDay,
    required this.businessTimmingModel,
  });

  BusinessWeekDayModel copyWith({
    bool? isClosed,
    String? weekDay,
    BusinessTimmingModel? businessTimmingModel,
  }) {
    return BusinessWeekDayModel(
      isClosed: isClosed ?? this.isClosed,
      weekDay: weekDay ?? this.weekDay,
      businessTimmingModel: businessTimmingModel ?? this.businessTimmingModel,
    );
  }

  //FromMap
  factory BusinessWeekDayModel.fromMap(Map<String, dynamic> map) {
    return BusinessWeekDayModel(
      isClosed: map['is_closed'],
      weekDay: map['week_day'],
      businessTimmingModel: map['timings'] == null
          ? null
          : BusinessTimmingModel.fromMap(map['timings']),
    );
  }

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      'is_closed': isClosed,
      'week_day': weekDay,
      'timings': businessTimmingModel?.toMap(),
    };
  }
}

class BusinessTimmingModel {
  final DateTime firstHalfOpeningTime;
  final DateTime firstHalfClosingTime;
  final DateTime? secondHalfOpeningTime;
  final DateTime? secondHalfClosingTime;

  BusinessTimmingModel({
    required this.firstHalfOpeningTime,
    required this.firstHalfClosingTime,
    this.secondHalfOpeningTime,
    this.secondHalfClosingTime,
  });

  //Check the 2nd half time availability
  bool get isSecondHalfTimeAvailable =>
      secondHalfOpeningTime != null && secondHalfClosingTime != null;

  BusinessTimmingModel copyWith({
    DateTime? firstHalfOpeningTime,
    DateTime? firstHalfClosingTime,
    DateTime? secondHalfOpeningTime,
    DateTime? secondHalfClosingTime,
  }) {
    return BusinessTimmingModel(
      firstHalfOpeningTime: firstHalfOpeningTime ?? this.firstHalfOpeningTime,
      firstHalfClosingTime: firstHalfClosingTime ?? this.firstHalfClosingTime,
      secondHalfOpeningTime:
          secondHalfOpeningTime ?? this.secondHalfOpeningTime,
      secondHalfClosingTime:
          secondHalfClosingTime ?? this.secondHalfClosingTime,
    );
  }

//make secondHalfOpeningTime and secondHalfClosingTime null
  BusinessTimmingModel makeSecondHalfTimeNull() {
    return BusinessTimmingModel(
      firstHalfOpeningTime: firstHalfOpeningTime,
      firstHalfClosingTime: firstHalfClosingTime,
      secondHalfOpeningTime: null,
      secondHalfClosingTime: null,
    );
  }

  //FromMap
  factory BusinessTimmingModel.fromMap(Map<String, dynamic> map) {
    return BusinessTimmingModel(
      firstHalfOpeningTime:
          DateTime.fromMillisecondsSinceEpoch(map['first_half_opening_time']),
      firstHalfClosingTime:
          DateTime.fromMillisecondsSinceEpoch(map['first_half_closing_time']),
      secondHalfOpeningTime: map['second_half_opening_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['second_half_opening_time'])
          : null,
      secondHalfClosingTime: map['second_half_closing_time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['second_half_closing_time'])
          : null,
    );
  }

  //ToMap
  Map<String, dynamic> toMap() {
    return {
      'first_half_opening_time': firstHalfOpeningTime.millisecondsSinceEpoch,
      'first_half_closing_time': firstHalfClosingTime.millisecondsSinceEpoch,
      'second_half_opening_time': secondHalfOpeningTime?.millisecondsSinceEpoch,
      'second_half_closing_time': secondHalfClosingTime?.millisecondsSinceEpoch,
    };
  }

  //toJson
  String toJson() => json.encode(toMap());
}
