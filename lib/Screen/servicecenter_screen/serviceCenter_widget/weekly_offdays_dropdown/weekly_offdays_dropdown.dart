import 'package:SerialMan/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class WeeklyOff_daysDropdown extends StatefulWidget {
  final List<String> availableDays;
  final Function(List<String> selectedDays) onSelectionChanged;
  final List<String> initialSelectedDays;

  const WeeklyOff_daysDropdown({
    Key? key,
    required this.availableDays,
    required this.onSelectionChanged,
    this.initialSelectedDays = const [],
  }) : super(key: key);

  @override
  _WeeklyOff_daysDropdownState createState() => _WeeklyOff_daysDropdownState();
}

class _WeeklyOff_daysDropdownState extends State<WeeklyOff_daysDropdown> {
  late List<String> _selectedDays;
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedDays = List<String>.from(widget.initialSelectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<String>(
      isDense: true,
      isExpanded: true,
      onMenuStateChange: (isOpen) {
        setState(() {
          _isDropdownOpen = isOpen;
        });
      },
      underline: Container(),
      customButton: Builder(
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(
              left: 5,
              right: 5,
              top: 8,
              bottom: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: _isDropdownOpen
                    ? AppColor().primariColor
                    : Colors.grey.shade400, // Change color when open
                width: _isDropdownOpen
                    ? 1.5
                    : 1.0, // Optionally make the border thicker
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _selectedDays.isEmpty
                      ? Text(
                          'Select day(s)',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        )
                      : Wrap(
                          spacing: 3.0,
                          runSpacing: 3.0,
                          children: _selectedDays.map((day) {
                            return Chip(
                              label: Text(
                                day,
                                style: const TextStyle(fontSize: 12),
                              ),
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              backgroundColor: Colors.grey.shade200,
                              deleteIconColor: Colors.grey.shade700,
                              onDeleted: () {
                                setState(() {
                                  _selectedDays.remove(day);
                                  widget.onSelectionChanged(_selectedDays);
                                });
                              },
                            );
                          }).toList(),
                        ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: _isDropdownOpen
                      ? AppColor().primariColor
                      : Colors.grey, // Change color when open
                ),
              ],
            ),
          );
        },
      ),
      items: widget.availableDays.map((day) {
        return DropdownMenuItem<String>(
          value: day,
          enabled: false,
          child: StatefulBuilder(
            builder: (context, menuSetState) {
              final isSelected = _selectedDays.contains(day);
              return InkWell(
                onTap: () {
                  if (isSelected) {
                    _selectedDays.remove(day);
                  } else {
                    _selectedDays.add(day);
                  }
                  widget.onSelectionChanged(_selectedDays);

                  menuSetState(() {});

                  setState(() {});
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor().primariColor.withOpacity(0.25)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
      onChanged: (value) {},
      dropdownStyleData: DropdownStyleData(
        maxHeight: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        offset: const Offset(0, -5),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.zero,
        height: 40,
      ),
    );
  }
}
