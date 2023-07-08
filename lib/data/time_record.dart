import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../consts/value_consts.dart';

@immutable
class TimeRecord {
  static final DateFormat _timeFormat = DateFormat.Hm();
  static final DateFormat _dateFormat = DateFormat('yyyy/MM/dd');

  final String startDateTimeString;
  final String endDateTimeString;
  final String category;
  final String content;

  const TimeRecord._(
      {this.startDateTimeString = ValueConsts.invalidDateTime,
      this.endDateTimeString = ValueConsts.invalidDateTime,
      this.category = '',
      this.content = ''});

  factory TimeRecord.fromDateTime(
      {DateTime? startDateTime,
      DateTime? endDateTime,
      String category = '',
      String content = ''}) {
    return TimeRecord._(
      startDateTimeString:
          startDateTime?.toString() ?? ValueConsts.invalidDateTime,
      endDateTimeString: endDateTime?.toString() ?? ValueConsts.invalidDateTime,
      category: category,
      content: content,
    );
  }

  factory TimeRecord.fromString(
      {String startDateTime = ValueConsts.invalidDateTime,
      String endDateTime = ValueConsts.invalidDateTime,
      String category = '',
      String content = ''}) {
    return TimeRecord.fromDateTime(
      startDateTime: _convertDateTime(startDateTime),
      endDateTime: _convertDateTime(endDateTime),
      category: category,
      content: content,
    );
  }

  DateTime? get startDateTime {
    if (startDateTimeString == ValueConsts.invalidDateTime) {
      return null;
    }
    return DateTime.parse(startDateTimeString);
  }

  DateTime? get endDateTime {
    if (endDateTimeString == ValueConsts.invalidDateTime) {
      return null;
    }
    return DateTime.parse(endDateTimeString);
  }

  String get formattedStartDate {
    return _formatDate(startDateTime);
  }

  String get formattedEndDate {
    return _formatDate(endDateTime);
  }

  String get formattedStartTime {
    return _formatTime(startDateTime);
  }

  String get formattedEndTime {
    return _formatTime(endDateTime);
  }

  String get formattedSpanHour {
    var span = _span;
    if (span == null) {
      return '';
    }
    if (Duration.zero.compareTo(span) >= 0) {
      return 'ERROR';
    }
    return (span.inMinutes / 60).toStringAsFixed(2);
  }

  Duration? get _span {
    if (startDateTimeString == ValueConsts.invalidDateTime ||
        endDateTimeString == ValueConsts.invalidDateTime) {
      return null;
    }
    return endDateTime!.difference(startDateTime!);
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return _timeFormat.format(dateTime);
  }

  static DateTime? _convertDateTime(String string) {
    if (string == ValueConsts.invalidDateTime) {
      return null;
    }
    return DateTime.parse(string);
  }

  String _formatDate(DateTime? dateTime){
    if (dateTime == null) {
      return '';
    }
    return _dateFormat.format(dateTime);
  }

  TimeRecord copyWith(
      {DateTime? startDateTime,
      DateTime? endDateTime,
      String? category,
      String? content}) {
    return TimeRecord._(
      startDateTimeString: startDateTime?.toString() ?? startDateTimeString,
      endDateTimeString: endDateTime?.toString() ?? endDateTimeString,
      category: category ?? this.category,
      content: content ?? this.content,
    );
  }
}
