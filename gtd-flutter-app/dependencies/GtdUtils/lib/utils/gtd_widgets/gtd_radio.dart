import 'package:flutter/material.dart';

class GtdRadio<T> extends StatelessWidget {
  final Widget? selectedIcon;
  final Widget? unselectedIcon;
  final Widget? disableIcon;
  final EdgeInsets? padding;
  final T? groupValue;
  final T value;
  final ValueChanged<T>? onChanged;
  const GtdRadio({
    Key? key,
    this.selectedIcon = const Icon(Icons.radio_button_checked),
    this.unselectedIcon = const Icon(Icons.radio_button_off),
    this.padding,
    this.disableIcon,
    this.groupValue,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;
    return InkWell(
        onTap: onChanged == null
            ? null
            : () {
                onChanged?.call(value);
                // if (value != groupValue) {
                //   onChanged(value);
                // }
              },
        child: Padding(
          padding: padding ?? const EdgeInsets.all(0),
          child: isSelected ? selectedIcon : unselectedIcon,
        ));
  }
}
