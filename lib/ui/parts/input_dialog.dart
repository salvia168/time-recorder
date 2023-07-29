import 'package:flutter/material.dart';

import '../../consts/style_consts.dart';

class InputDialog extends StatefulWidget {
  const InputDialog({super.key, required this.okButtonLabel, this.defaultValue = ''});

  final String okButtonLabel;

  final String defaultValue;

  @override
  State<InputDialog> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialog> {
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    controller.text = widget.defaultValue;
    super.initState();
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
            SizedBox(
              width: StyleConsts.value208,
              child: TextField(
                controller: controller,
              ),
            ),
            StyleConsts.sizedBoxH16,
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
                  onPressed: () {
                    Navigator.pop(context,controller.text);
                  },
                  child: Text(widget.okButtonLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
