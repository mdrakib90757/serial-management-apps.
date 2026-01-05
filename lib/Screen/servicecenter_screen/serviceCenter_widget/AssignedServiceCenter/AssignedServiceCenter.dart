import 'package:SerialMan/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../../model/serviceCenter_model.dart';

class AssignedServiceCentersDropdown extends StatefulWidget {
  final List<ServiceCenterModel> availableServiceCenters;
  final Function(List<ServiceCenterModel> selectedCenters) onSelectionChanged;
  final List<ServiceCenterModel> initialSelectedCenters;

  const AssignedServiceCentersDropdown({
    Key? key,
    required this.availableServiceCenters,
    required this.onSelectionChanged,
    this.initialSelectedCenters = const [],
  }) : super(key: key);

  @override
  _AssignedServiceCentersDropdownState createState() =>
      _AssignedServiceCentersDropdownState();
}

class _AssignedServiceCentersDropdownState
    extends State<AssignedServiceCentersDropdown> {
  late List<ServiceCenterModel> _selectedCenters;
  final GlobalKey _buttonKey = GlobalKey();
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    _selectedCenters = List<ServiceCenterModel>.from(
      widget.initialSelectedCenters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<ServiceCenterModel>(
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
            key: _buttonKey,
            padding: const EdgeInsets.only(
              left: 12,
              right: 8,
              top: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: _isDropdownOpen
                    ? AppColor().primariColor
                    : Colors.grey.shade400,
                width: _isDropdownOpen ? 2 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _selectedCenters.isEmpty
                      ? Text(
                          'Select service centers',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        )
                      : Wrap(
                          spacing: 2.0,
                          runSpacing: 2.0,
                          children: _selectedCenters.map((center) {
                            return Chip(
                              label: Text(
                                center.name ?? 'N/A',
                                style: const TextStyle(fontSize: 10),
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
                                  _selectedCenters.remove(center);
                                  widget.onSelectionChanged(_selectedCenters);
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
                      : Colors.grey,
                ),
              ],
            ),
          );
        },
      ),
      items: widget.availableServiceCenters.map((center) {
        return DropdownMenuItem<ServiceCenterModel>(
          value: center,
          enabled: false,
          child: StatefulBuilder(
            builder: (context, menuSetState) {
              final isSelected = _selectedCenters.contains(center);
              return InkWell(
                onTap: () {
                  if (isSelected) {
                    _selectedCenters.remove(center);
                  } else {
                    _selectedCenters.add(center);
                  }
                  widget.onSelectionChanged(_selectedCenters);

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
                    center.name ?? 'N/A',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
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
        maxHeight: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
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
