import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:schedule_meetings/constants/color.dart';

class DropdownCustom extends StatefulWidget {
  const DropdownCustom({
    super.key,
    this.hint,
    required this.items,
    required this.onSelected,
    this.buttonStyleData,
    this.menuItemStyleData,
    this.dropdownStyleData,
    this.textStyle,
    this.icon,
    this.borderRadius,
    this.initValue,
  });

  final String? hint;
  final List<String> items;
  final Function(int?) onSelected;
  final ButtonStyleData? buttonStyleData;
  final MenuItemStyleData? menuItemStyleData;
  final DropdownStyleData? dropdownStyleData;
  final TextStyle? textStyle;
  final Widget? icon;
  final double? borderRadius;
  final String? initValue;

  @override
  State<DropdownCustom> createState() => _DropdownCustomState();
}

class _DropdownCustomState extends State<DropdownCustom> {
  String? selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    if (widget.initValue != null) {
      selectedValue = widget.initValue;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          widget.hint ?? "",
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: widget.items
            .map((String item) => DropdownMenuItem<String>(
          value: item,
          child: Tooltip(
            message: item,
            child: Text(
              item,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: widget.textStyle ??
                  const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ))
            .toList(),
        value: selectedValue,
        onChanged: (String? value) {
          setState(() {
            selectedValue = value;
            widget.onSelected(widget.items.indexOf(value ?? '0'));
          });
        },
        iconStyleData: IconStyleData(
          icon: Container(
            decoration: BoxDecoration(
              color: AppColor.bgHind,
              borderRadius: BorderRadius.circular(4),
            ),
            child: widget.icon ??
                const Icon(
                  Icons.arrow_drop_down,
                  color: AppColor.hind,
                ),
          ),
          iconSize: 20,
        ),
        buttonStyleData: widget.buttonStyleData ??
            ButtonStyleData(
                padding: const EdgeInsets.only(
                    top: 8, right: 12, bottom: 8, left: 16),
                height: 40,
                width: 140,
                decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(widget.borderRadius ?? 8),
                    border: Border.all(color: AppColor.border))),
        dropdownStyleData: widget.dropdownStyleData ??
            const DropdownStyleData(
              maxHeight: 200,
            ),
        // menuItemStyleData: widget.menuItemStyleData ??
        //     const MenuItemStyleData(
        //       height: 36,
        //     ),
      ),
    );
  }
}
