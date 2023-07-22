import 'package:intl/intl.dart';

class ValueConsts{

  ValueConsts._();
  static const String invalidDateTime = 'Null';
  static const String errorString = 'ERROR';
  static const String dateFormatPattern = 'yyyy/MM/dd';
  static const String hhColonMmPattern = r'^([01]?\d|2[0-3]):[0-5]?\d$';

  static const String dbFileName = 'Db.csv';

  static final DateFormat hmFormat = DateFormat.Hm();
}