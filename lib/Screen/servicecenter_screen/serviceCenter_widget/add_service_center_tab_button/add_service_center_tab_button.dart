import 'package:flutter/material.dart';
import 'package:SerialMan/utils/color.dart';

class CustomTab extends StatefulWidget {
  final TextEditingController? tabbarController;
  final Function(String selectedPolicy) onPolicyChanged;
  final String? initialPolicy;

  const CustomTab({
    super.key,
    this.tabbarController,
    required this.onPolicyChanged,
    this.initialPolicy,
  });

  @override
  State<CustomTab> createState() => _CustomTabState();
}

class _CustomTabState extends State<CustomTab> {
  int _selectedIndex = -1;
  final List<String> _policies = ['C', 'S'];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.initialPolicy != null) {
      _selectedIndex = _policies.indexOf(widget.initialPolicy!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        children: [
          // "Combined" Button
          _buildTabItem(
            0,
            'Combined',
            const BorderRadius.only(
              topLeft: Radius.circular(4.0),
              bottomLeft: Radius.circular(4.0),
            ),
          ),
          Container(width: 1, color: Colors.grey.shade400),
          // "Service type wise" Button
          _buildTabItem(
            1,
            'Service type wise',
            const BorderRadius.only(
              topRight: Radius.circular(4.0),
              bottomRight: Radius.circular(4.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String text, BorderRadius borderRadius) {
    bool isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          widget.onPolicyChanged(_policies[index]);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? AppColor().primariColor : Colors.white,
            borderRadius: index == 0
                ? const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
