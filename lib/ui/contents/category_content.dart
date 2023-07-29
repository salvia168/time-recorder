import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_recorder/consts/style_consts.dart';
import 'package:time_recorder/consts/value_consts.dart';
import 'package:time_recorder/data/time_record.dart';
import 'package:time_recorder/data/record_subcategory.dart';
import 'package:time_recorder/ui/parts/input_dialog.dart';

import '../../data/record_category.dart';
import '../../logic/record_data.dart';

class CategoryContent extends StatefulWidget {
  const CategoryContent({super.key, required this.futureRead});

  final Future<List<TimeRecord>> futureRead;

  @override
  State<CategoryContent> createState() => _CategoryContentState();
}

class _CategoryContentState extends State<CategoryContent> {
  final RecordData _recordData = RecordData();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () async {
              String? categoryName = await showDialog<String>(
                  context: context,
                  builder: (BuildContext context) =>
                      InputDialog(okButtonLabel: '追加'));
              if (categoryName != null) {
                setState(() {
                  _recordData.categoryList.add(RecordCategory(
                      id: _recordData.categoryList.length, name: categoryName));
                });
              }
            },
            child: Text('カテゴリを追加')),
        StyleConsts.sizedBoxH16,
        FutureBuilder<List<TimeRecord>>(
          future: widget.futureRead,
          builder: (context, snapshot) {
            return Column(
                children: createTiles(
                    _recordData.categoryList, _recordData.subcategoryList));
          },
        ),
      ],
    );
  }

  List<ExpansionTile> createTiles(
      List<RecordCategory> parents, List<RecordSubcategory> children) {
    return parents.map<ExpansionTile>((parent) {
      return ExpansionTile(
        title: Text(parent.name),
        controlAffinity: ListTileControlAffinity.leading,
        trailing: Wrap(
          children: [
            IconButton(
              icon: Icon(Icons.edit_outlined),
              onPressed: () async {
                String? categoryName = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context)=>InputDialog(okButtonLabel: '編集',defaultValue: parent.name,));
                if(categoryName!=null){
                  setState((){
                    int index = _recordData.categoryList.indexOf(parent);
                    _recordData.categoryList.remove(parent);
                    _recordData.categoryList.insert(index, parent.copyWith(name: categoryName));
                  });
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                String? subcategoryName = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context)=>InputDialog(okButtonLabel: '追加'));
                if(subcategoryName!=null){
                  setState((){
                    _recordData.subcategoryList.add(RecordSubcategory(parentId: parent.id,id: children
                        .where((child) => child.parentId == parent.id).length,name: subcategoryName));
                  });
                }
              },
            ),
          ],
        ),
        children: children
            .where((child) => child.parentId == parent.id)
            .map<ListTile>((child) {
          return ListTile(
            title: Text(child.name),
            trailing: Wrap(
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: () async {
                    String? subcategoryName = await showDialog<String>(
                        context: context,
                        builder: (BuildContext context)=>InputDialog(okButtonLabel: '編集',defaultValue: child.name,));
                    if(subcategoryName!=null){
                      setState((){
                        int index = _recordData.subcategoryList.indexOf(child);
                        _recordData.subcategoryList.remove(child);
                        _recordData.subcategoryList.insert(index, child.copyWith(name: subcategoryName));
                      });
                    }
                  },
                ),
              ],
            ),
          );
        }).toList(),
      );
    }).toList();
  }
}
