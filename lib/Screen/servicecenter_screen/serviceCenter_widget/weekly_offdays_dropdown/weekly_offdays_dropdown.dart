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

  @override
  void initState() {
    super.initState();
    _selectedDays = List<String>.from(widget.initialSelectedDays);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<String>(
      isExpanded: true,
      customButton: Builder(
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(
              left: 12,
              right: 8,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade400),
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
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
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
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          day,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
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
