import 'package:flutter/material.dart';
import 'package:time_recorder/consts/value_consts.dart';
import 'package:time_recorder/data/time_record.dart';
import 'package:time_recorder/ui/parts/time_text_field.dart';

import '../../consts/style_consts.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog(
      {super.key, required this.timeRecord});


  final TimeRecord timeRecord;

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _spanController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    _startTimeController.text = widget.timeRecord.formattedStartTime;
    _endTimeController.text = widget.timeRecord.formattedEndTime;
    _spanController.text = widget.timeRecord.formattedSpanHour;
    _categoryController.text = widget.timeRecord.category;
    _contentController.text = widget.timeRecord.content;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
          padding: StyleConsts.padding32,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: StyleConsts.value128,
                        child: TimeTextField(
                          context: context,
                          controller: _startTimeController,
                          labelText: '開始',
                          dateTime: widget.timeRecord.startDateTime,
                          onChanged: (_) {
                            _updateSpan();
                          },
                        ),
                      ),
                      StyleConsts.sizedBoxW16,
                      SizedBox(
                        width: StyleConsts.value128,
                        child: TimeTextField(
                          context: context,
                          controller: _endTimeController,
                          labelText: '終了',
                          dateTime: widget.timeRecord.endDateTime,
                          onChanged: (_) {
                            _updateSpan();
                          },
                        ),
                      ),
                      StyleConsts.sizedBoxW16,
                      SizedBox(
                        width: StyleConsts.value80,
                        child: TextField(
                          enabled: false,
                          controller: _spanController,
                          style: TextStyle(
                              color: _spanController.text ==
                                      ValueConsts.errorString
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.onSurface,),
                          decoration: const InputDecoration(
                            labelText: '時間',
                          ),
                        ),
                      ),
                    ],
                  ),
                  StyleConsts.sizedBoxH32,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: StyleConsts.value208,
                        child: TextField(
                          controller: _categoryController,
                          decoration: const InputDecoration(labelText: 'カテゴリ'),
                        ),
                      ),
                      StyleConsts.sizedBoxW16,
                      SizedBox(
                        width: StyleConsts.value208,
                        child: TextField(
                          controller: _contentController,
                          decoration: const InputDecoration(labelText: '内容'),
                        ),
                      ),
                    ],
                  ),
                  StyleConsts.sizedBoxH48,
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('キャンセル'),
                  ),
                  StyleConsts.sizedBoxW16,
                  TextButton(
                    onPressed: _spanController.text == ValueConsts.errorString
                        ? null
                        : () {
                            var newTimeRecord = widget.timeRecord.copyWithHm(
                                startDate: widget.timeRecord.startDateTime ??
                                    DateTime.now(),
                                startTimeString: _startTimeController.text,
                                endDate: widget.timeRecord.endDateTime ??
                                    DateTime.now(),
                                endTimeString: _endTimeController.text,
                                category: _categoryController.text,
                                content: _contentController.text);
                            if (newTimeRecord.formattedSpanHour ==
                                ValueConsts.errorString) {
                              return;
                            }
                            Navigator.pop(context,newTimeRecord);
                          },
                    child: const Text('編集'),
                  ),
                ],
              ),
            ],
          )),
    );
  }

  void _updateSpan() {
    var newTimeRecord = widget.timeRecord.copyWithHm(
      startDate: widget.timeRecord.startDateTime ?? DateTime.now(),
      startTimeString: _startTimeController.text,
      endDate: widget.timeRecord.endDateTime ?? DateTime.now(),
      endTimeString: _endTimeController.text,
    );
    var span = newTimeRecord.formattedSpanHour;
    setState((){
      _spanController.text = span.isEmpty ? ValueConsts.errorString : span;
    });
  }
}
