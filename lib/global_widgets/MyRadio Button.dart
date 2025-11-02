import 'package:flutter/material.dart';

import '../utils/color.dart';

class CustomRadioGroup<T> extends StatelessWidget {
  final T? groupValue;

  final List<T> items;

  final void Function(T?) onChanged;
  final String Function(T) itemTitleBuilder;

  const CustomRadioGroup({
    Key? key,
    required this.groupValue,
    required this.items,
    required this.onChanged,
    required this.itemTitleBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          bool isSelected = (item == groupValue);
          return GestureDetector(
            onTap: () => onChanged(item),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Icon(
                    isSelected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: isSelected ? AppColor().primariColor : Colors.grey,
                    size: 19,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    itemTitleBuilder(item),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.black.withOpacity(0.8)
                          : Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
