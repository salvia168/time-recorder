import 'package:flutter/material.dart';

@immutable
class RecordCategory{
  final int id;
  final String name;

  const RecordCategory({this.id=-1,this.name=''});

  RecordCategory copyWith({int? id,String? name}){
    return RecordCategory(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}