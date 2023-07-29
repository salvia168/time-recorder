import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../consts/value_consts.dart';
import '../util/date_time_util.dart';

@immutable
class TimeRecord {
  static final DateFormat _dateFormat =
      DateFormat(ValueConsts.dateFormatPattern);

  final String startDateTimeString;
  final String endDateTimeString;
  final int categoryId;
  final int subcategoryId;
  final String category;
  final String content;
  final bool isRecording;

  const TimeRecord._(
      {this.startDateTimeString = ValueConsts.invalidDateTime,
      this.endDateTimeString = ValueConsts.invalidDateTime,
      this.categoryId = -1,
      this.subcategoryId = -1,
      this.category = '',
      this.content = '',
      this.isRecording = false});

  factory TimeRecord.fromDateTime({
    DateTime? startDateTime,
    DateTime? endDateTime,
    int categoryId = -1,
    int subcategoryId = -1,
    String category = '',
    String content = '',
    bool isRecording = false,
  }) {
    return TimeRecord._(
      startDateTimeString:
          startDateTime?.toString() ?? ValueConsts.invalidDateTime,
      endDateTimeString: endDateTime?.toString() ?? ValueConsts.invalidDateTime,
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      category: category,
      content: content,
      isRecording: isRecording,
    );
  }

  factory TimeRecord.fromString({
    String startDateTime = ValueConsts.invalidDateTime,
    String endDateTime = ValueConsts.invalidDateTime,
    int categoryId = -1,
    int subcategoryId = -1,
    String category = '',
    String content = '',
    bool isRecording = false,
  }) {
    return TimeRecord.fromDateTime(
      startDateTime: _convertDateTime(startDateTime),
      endDateTime: _convertDateTime(endDateTime),
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      category: category,
      content: content,
      isRecording: isRecording,
    );
  }

  factory TimeRecord.fromHmString({
    DateTime? startDate,
    String startTimeString = ValueConsts.invalidDateTime,
    DateTime? endDate,
    String endTimeString = ValueConsts.invalidDateTime,
    int categoryId = -1,
    int subcategoryId = -1,
    String category = '',
    String content = '',
    bool isRecording = false,
  }) {
    var startDateTime = _convertHm(startDate, startTimeString);
    var endDateTime = _convertHm(endDate, endTimeString);
    return TimeRecord._(
      startDateTimeString:
          startDateTime?.toString() ?? ValueConsts.invalidDateTime,
      endDateTimeString: endDateTime?.toString() ?? ValueConsts.invalidDateTime,
      categoryId: categoryId,
      subcategoryId: subcategoryId,
      category: category,
      content: content,
      isRecording: isRecording,
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
    if (Duration.zero.compareTo(span) > 0) {
      return ValueConsts.errorString;
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
    return ValueConsts.hmFormat.format(dateTime);
  }

  static DateTime? _convertDateTime(String string) {
    if (string == ValueConsts.invalidDateTime) {
      return null;
    }
    var dateTime = DateTime.parse(string);
    return DateTimeUtil.copy(
        source: dateTime, second: 0, millisecond: 0, microsecond: 0);
  }

  static DateTime? _convertHm(DateTime? date, String time) {
    if (date == null) {
      return null;
    }
    if (!RegExp(ValueConsts.hhColonMmPattern).hasMatch(time)) {
      return null;
    }
    var timeArray = time.split(':');
    return DateTimeUtil.copy(
        source: date,
        hour: int.parse(timeArray[0]),
        minute: int.parse(timeArray[1]));
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return _dateFormat.format(dateTime);
  }

  TimeRecord copyWith(
      {DateTime? startDateTime,
      DateTime? endDateTime,
      int? categoryId = -1,
      int? subcategoryId = -1,
      String? category,
      String? content,
      bool? isRecording}) {
    return TimeRecord.fromDateTime(
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      category: category ?? this.category,
      content: content ?? this.content,
      isRecording: isRecording ?? this.isRecording,
    );
  }

  TimeRecord copyWithHm({
    DateTime? startDate,
    String? startTimeString,
    DateTime? endDate,
    String? endTimeString,
    int? categoryId = -1,
    int? subcategoryId = -1,
    String? category,
    String? content,
    bool? isRecording,
  }) {
    return TimeRecord.fromHmString(
      startDate: startDate ?? startDateTime,
      startTimeString: startTimeString ?? formattedStartTime,
      endDate: endDate ?? endDateTime,
      endTimeString: endTimeString ?? formattedEndTime,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      category: category ?? this.category,
      content: content ?? this.content,
      isRecording: isRecording ?? this.isRecording,
    );
  }
}
