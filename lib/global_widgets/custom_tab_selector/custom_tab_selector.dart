// lib/global_widgets/custom_tab_selector.dart
import 'package:flutter/material.dart';

import '../../utils/color.dart';

class CustomTabSelector<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final void Function(T) onChanged;
  final String Function(T) itemTitleBuilder;
  final IconData? selectedIcon; // Optional icon for the selected tab

  const CustomTabSelector({
    Key? key,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    required this.itemTitleBuilder,
    this.selectedIcon, // Added this
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
        ), // Background color for the tab group
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          bool isSelected = (item == selectedValue);
          return GestureDetector(
            onTap: () => onChanged(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor().primariColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(5.0),
                // No border for unselected, a subtle border for selected
                border: isSelected
                    ? Border.all(color: AppColor().primariColor)
                    : null,
              ),
              child: Row(
                // Use Row to place icon and text
                children: [
                  if (isSelected && selectedIcon != null)
                    Icon(selectedIcon, color: Colors.white, size: 18),
                  if (isSelected && selectedIcon != null)
                    const SizedBox(width: 8), // Space between icon and text
                  Text(
                    itemTitleBuilder(item),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.black.withOpacity(0.8),
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
