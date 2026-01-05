import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:SerialMan/utils/color.dart';

class CustomDropdown<T> extends StatefulWidget {
  final Widget? child;
  final List<T> items;
  final T? value;
  final T? selectedItem;
  final ValueChanged<T> onChanged;
  final String Function(T item) itemAsString;
  final double popupHeight;
  final String? Function(T? value)? validator;
  final String? hinText;
  final bool isLoading;
  final Widget? suffixIcon;

  const CustomDropdown({
    Key? key,
    this.child,
    required this.items,
    this.value,
    required this.onChanged,
    required this.itemAsString,
    this.popupHeight = 200.0,
    this.selectedItem,
    this.validator,
    this.hinText,
    this.isLoading = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _CustomDropdownState<T> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey<FormFieldState> _formFieldKey = GlobalKey<FormFieldState>();
  bool get _isPopupOpen => _overlayEntry != null;
  late FocusNode _focusNode;
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _overlayEntry?.remove();
    _scrollController.dispose();
    super.dispose();
  }

  // handle focus change
  void _handleFocusChange() {
    if (!_focusNode.hasFocus && _isPopupOpen) {
      _closePopup();
    }
    if (mounted) {
      setState(() {});
    }
  }

  // toggle popup
  void _togglePopup() {
    if (_isPopupOpen) {
      _closePopup();
    } else {
      _openPopup();
      _focusNode.requestFocus();
    }
  }

  // popup
  void _openPopup() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {});
  }

  void _closePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _formFieldKey.currentState?.validate();
    _focusNode.unfocus();
    setState(() {});
  }

  // create overlay entry
  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox =
        _formFieldKey.currentContext!.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    var screenHeight = MediaQuery.of(context).size.height;
    var fieldBottomY = offset.dy + size.height;

    bool hasSpaceBelow =
        (screenHeight - fieldBottomY) > (widget.popupHeight + 10);
    var yOffset = hasSpaceBelow ? size.height : -widget.popupHeight;
    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _closePopup,
                behavior: HitTestBehavior.translucent,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, yOffset),
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  borderRadius: BorderRadius.circular(5.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: widget.popupHeight),
                    child: Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      radius: Radius.circular(8.0),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final T? currentValue =
                              _formFieldKey.currentState?.value;
                          final bool isSelected = item == currentValue;
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3.0,
                              //vertical: 5
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColor().primariColor.withOpacity(0.3)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _formFieldKey.currentState!.didChange(item);
                                widget.onChanged(item);
                                _closePopup();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10,
                                  right: 5,
                                  top: 5,
                                  bottom: 5,
                                ),
                                child: Text(
                                  widget.itemAsString(item),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FormField<T>(
        key: _formFieldKey,
        initialValue: widget.value,
        validator: widget.validator,
        builder: (FormFieldState<T> state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.value != widget.selectedItem) {
              state.didChange(widget.selectedItem);
            }
          });

          bool isActive = _focusNode.hasFocus || _isPopupOpen;
          Color iconColor = isActive
              ? AppColor().primariColor
              : Colors.grey.shade600;

          return GestureDetector(
            //onTap: widget.isLoading ? null : _togglePopup,
            onTap: _togglePopup,
            child: Focus(
              focusNode: _focusNode,
              autofocus: false,
              onFocusChange: (hasFocus) {
                if (!hasFocus && _isPopupOpen) {
                  _closePopup();
                }
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: state.value == null ? widget.hinText : null,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColor().primariColor,
                      width: 2,
                    ),
                  ),
                  suffixIcon:
                      widget.suffixIcon ??
                      Icon(Icons.arrow_drop_down, color: iconColor),
                  errorText: state.errorText,
                  suffixIconConstraints: BoxConstraints(
                    minWidth: 30,
                    minHeight: 20,
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 30,
                    minHeight: 20,
                  ),
                ),
                isEmpty: state.value == null,
                //isEmpty: state.value == null && state.errorText == null,
                isFocused: _focusNode.hasFocus || _isPopupOpen,
                child: Text(
                  state.value == null ? '' : widget.itemAsString(state.value!),
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          );
        },
        autovalidateMode: AutovalidateMode.disabled,
      ),
    );
  }
}
