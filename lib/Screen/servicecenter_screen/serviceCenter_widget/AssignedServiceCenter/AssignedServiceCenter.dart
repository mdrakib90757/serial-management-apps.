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
              border: Border.all(color: Colors.grey.shade400),
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
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
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
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          center.name ?? 'N/A',
                          style: const TextStyle(fontSize: 14),
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
