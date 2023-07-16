import 'package:flutter/services.dart';

class HmFormatter extends TextInputFormatter {

  final _expression1 = RegExp(r'(^([01]?\d|2[0-3]):?$)');
  final _expression2 = RegExp(r'(^([01]?\d|2[0-3]):[0-5]?\d$)');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if(newValue.text.isEmpty){return newValue;}
    if(_expression1.hasMatch(newValue.text)||_expression2.hasMatch(newValue.text)){ return newValue; }
    return oldValue;
  }
}