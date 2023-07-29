import 'package:flutter/material.dart';
import 'package:time_recorder/data/record_category.dart';

@immutable
class RecordSubcategory extends RecordCategory {
  final int parentId;

  const RecordSubcategory({this.parentId = -1, super.id = -1, super.name = ''});

  @override
  RecordSubcategory copyWith({int? parentId, int? id, String? name}){
    return RecordSubcategory(
      parentId: parentId ?? this.parentId,
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}