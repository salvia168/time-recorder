import 'package:flutter/material.dart';
import 'package:time_recorder/consts/style_consts.dart';

import '../../data/record_category.dart';

class CategoryDropdown<T extends RecordCategory> extends StatefulWidget {
  const CategoryDropdown(
      {super.key,
      this.width = StyleConsts.value208, this.label = 'カテゴリー',
      required this.selectedCategory,
      required this.categoryList,
      this.onChanged});

  final double width;
  final String label;
  final T? selectedCategory;
  final List<T> categoryList;
  final Function(T?)? onChanged;

  @override
  State<CategoryDropdown<T>> createState() => _CategoryDropdownState<T>();
}

class _CategoryDropdownState<T extends RecordCategory> extends State<CategoryDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: DropdownButton<T>(
        itemHeight: StyleConsts.value72,
        hint: Text(widget.label),
        value: widget.selectedCategory,
        items: widget.categoryList
            .map<DropdownMenuItem<T>>((T category) =>
                DropdownMenuItem<T>(
                    value: category, child: Text(category.name)))
            .toList(),
        onChanged: widget.onChanged,
        isExpanded: true,
      ),
    );
  }
}
