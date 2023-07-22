class DateTimeUtil{
  static DateTime copy({required DateTime source,int? year, int? month, int? day, int? hour, int? minute, int? second, int? millisecond, int? microsecond}) {
    return DateTime(
      year ?? source.year,
      month ?? source.month,
      day ?? source.day,
      hour ?? source.hour,
      minute ?? source.minute,
      second ?? source.second,
      millisecond ?? source.millisecond,
      microsecond ?? source.microsecond
    );
  }
}