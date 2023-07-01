import 'package:flutter/material.dart';

import '../consts/value_consts.dart';

@immutable
class TimeRecord{
  final String startDateTimeString;
  final String endDateTimeString;
  final String category;
  final String content;

  const TimeRecord._({this.startDateTimeString=ValueConsts.invalidDateTime,this.endDateTimeString=ValueConsts.invalidDateTime,this.category='',this.content=''});

  factory TimeRecord.init({DateTime? startDateTime, DateTime? endDateTime, String category='', String content=''}){
    return TimeRecord._(
      startDateTimeString: startDateTime?.toString()??ValueConsts.invalidDateTime,
      endDateTimeString: endDateTime?.toString()??ValueConsts.invalidDateTime,
      category: category,
      content: content,
    );
  }

  DateTime? get startDateTime{
    if(startDateTimeString==ValueConsts.invalidDateTime){
      return null;
    }
    return DateTime.parse(startDateTimeString);
  }

  DateTime? get endDateTime{
    if(endDateTimeString==ValueConsts.invalidDateTime){
      return null;
    }
    return DateTime.parse(endDateTimeString);
  }
  
  String get formattedStartDateTime{
    return _formatDateTime(startDateTime);
  }
  
  String get formattedEndDateTime{
    return _formatDateTime(endDateTime);
  }
  
  String get formattedSpanHour{
    var span = _span;
    if(span==null){
      return '';
    }
    if(Duration.zero.compareTo(span)>=0){
      return 'ERROR';
    }
    return (span.inMinutes/60).toStringAsFixed(2);
  }
  
  Duration? get _span{
    if(startDateTimeString==ValueConsts.invalidDateTime||endDateTimeString==ValueConsts.invalidDateTime){
      return null;
    }
    return endDateTime!.difference(startDateTime!);
  }
  
  String _formatDateTime(DateTime? dateTime){
    if(dateTime==null){return '';}
    return '${dateTime.hour.toString().padLeft(2)}:${dateTime.minute.toString().padLeft(2,'0')}';
  }
  
  TimeRecord copyWith({DateTime? startDateTime, DateTime? endDateTime, String? category, String? content}){
    return TimeRecord._(
      startDateTimeString: startDateTime?.toString()??startDateTimeString,
      endDateTimeString: endDateTime?.toString()??endDateTimeString,
      category: category??this.category,
      content: content??this.content,
    );
  }
}