import 'package:flutter/material.dart';
import 'package:snap_local/utility/common/media_picker/model/network_media_model.dart';
import 'package:snap_local/utility/tools/time_formatter.dart';

class EventShortDetailsModel {
  final String title;
  final String description;
  final String eventCategoryId;
  final String eventCategoryName;
  final String distance;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final bool isAttending;
  final bool isCancelled;
  final bool isClosed;
  final List<NetworkMediaModel> media;

  EventShortDetailsModel({
    required this.title,
    required this.description,
    required this.eventCategoryId,
    required this.eventCategoryName,
    required this.distance,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.isAttending,
    required this.isCancelled,
    required this.isClosed,
    required this.media,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'distance': distance,
      'topic_id': eventCategoryId,
      'topic_name': eventCategoryName,
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate.millisecondsSinceEpoch,
      'start_time':
          FormatDate.timeOfTheDayToDateTime(startTime).millisecondsSinceEpoch,
      'end_time':
          FormatDate.timeOfTheDayToDateTime(endTime).millisecondsSinceEpoch,
      'is_attending': isAttending,
      'is_cancelled': isCancelled,
      'is_closed': isClosed,
      'media': media.map((x) => x.toMap()).toList(),
    };
  }

  factory EventShortDetailsModel.fromMap(Map<String, dynamic> map) {
    return EventShortDetailsModel(
      title: map['title'] as String,
      description: map['description'],
      eventCategoryId: map['topic_id'],
      eventCategoryName: map['topic_name'],
      distance: map['distance'],
      startDate: DateTime.fromMillisecondsSinceEpoch(map['start_date']),
      endDate: DateTime.fromMillisecondsSinceEpoch(map['end_date']),
      startTime: TimeOfDay.fromDateTime(
          DateTime.fromMillisecondsSinceEpoch(map['start_time'])),
      endTime: TimeOfDay.fromDateTime(
          DateTime.fromMillisecondsSinceEpoch(map['end_time'])),
      isAttending: map['is_attending'],
      isCancelled: map['is_cancelled'],
      isClosed: map['is_closed'],
      media: List<NetworkMediaModel>.from(
          (map['media'] ?? []).map((x) => NetworkMediaModel.fromMap(x))),
    );
  }

  EventShortDetailsModel copyWith({
    String? title,
    String? description,
    String? eventCategoryId,
    String? eventCategoryName,
    String? distance,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    bool? isAttending,
    bool? isCancelled,
    bool? isClosed,
    List<NetworkMediaModel>? media,
  }) {
    return EventShortDetailsModel(
      title: title ?? this.title,
      description: description ?? this.description,
      eventCategoryId: eventCategoryId ?? this.eventCategoryId,
      eventCategoryName: eventCategoryName ?? this.eventCategoryName,
      distance: distance ?? this.distance,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isAttending: isAttending ?? this.isAttending,
      isCancelled: isCancelled ?? this.isCancelled,
      isClosed: isClosed ?? this.isClosed,
      media: media ?? this.media,
    );
  }
}
