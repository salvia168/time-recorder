import 'package:flutter/services.dart';

class HmFormatter extends TextInputFormatter {

  final _hmExpression = RegExp(r'(^((([01]?\d|2[0-3]):?)|(([01]?\d|2[0-3]):[0-5]?\d))$)');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if(newValue.text.isEmpty){return newValue;}
    if(_hmExpression.hasMatch(newValue.text)){ return newValue; }
    return oldValue;
  }
}