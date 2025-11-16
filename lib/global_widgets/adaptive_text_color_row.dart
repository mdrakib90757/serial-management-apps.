import 'package:flutter/material.dart';

class AdaptiveTextRow extends StatefulWidget {
  final String label;
  final String value;
  final double blueBackgroundHeight;

  const AdaptiveTextRow({
    Key? key,
    required this.label,
    required this.value,
    required this.blueBackgroundHeight,
  }) : super(key: key);

  @override
  _AdaptiveTextRowState createState() => _AdaptiveTextRowState();
}

class _AdaptiveTextRowState extends State<AdaptiveTextRow> {
  final GlobalKey _widgetKey = GlobalKey();
  Color _textColor = Colors.black;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateColor();
    });
  }

  void _updateColor() {
    if (!mounted || _widgetKey.currentContext == null) return;

    final RenderBox renderBox =
        _widgetKey.currentContext!.findRenderObject() as RenderBox;

    final position = renderBox.localToGlobal(Offset.zero);

    final widgetCenterY = position.dy + (renderBox.size.height / 2.0);

    if (widgetCenterY < widget.blueBackgroundHeight) {
      if (_textColor != Colors.white) {
        setState(() {
          _textColor = Colors.white;
        });
      }
    } else {
      if (_textColor != Colors.black) {
        setState(() {
          _textColor = Colors.black;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _updateColor();
        return false;
      },
      child: Row(
        key: _widgetKey,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              color: _textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.value,
            style: TextStyle(
              color: _textColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
