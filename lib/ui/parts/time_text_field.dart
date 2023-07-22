import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../util/hm_formatter.dart';

class TimeTextField extends TextField {
  TimeTextField(
      {Key? key, required BuildContext context,
      required TextEditingController controller,
      required String labelText,
      required DateTime? dateTime,
      Function(String)? onChanged})
      : super(key: key,
          controller: controller,
          inputFormatters: [HmFormatter()],
          decoration: InputDecoration(
            labelText: labelText,
            hintText:
                dateTime == null ? 'hh:mm' : DateFormat.Hm().format(dateTime),
            suffixIcon: IconButton(
              icon: const Icon(Icons.schedule_outlined),
              onPressed: () async {
                var time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: dateTime?.hour ?? 0,
                    minute: dateTime?.minute ?? 0,
                  ),
                );
                if (time != null) {
                  controller.text = DateFormat.Hm()
                      .format(DateTime(1, 1, 1, time.hour, time.minute));
                  onChanged?.call(controller.text);
                }
              },
            ),
          ),
          onChanged: onChanged,
        );
}
