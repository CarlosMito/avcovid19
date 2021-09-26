import 'package:flutter/material.dart';

class RadioIconButton extends StatelessWidget {
  const RadioIconButton(
      {Key? key,
      required this.value,
      required this.groupValue,
      required this.onChanged,
      required this.icon,
      this.label,
      this.color})
      : super(key: key);

  final Function()? onChanged;
  final Icon icon;
  final value;
  final groupValue;
  final label;
  final color;

  final defaultColor = Colors.grey;

  get isSelected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: isSelected ? color : defaultColor),
            shape: BoxShape.circle,
            color: isSelected ? color : Colors.transparent,
          ),
          child: IconButton(
            icon: icon,
            color: isSelected ? Colors.white : defaultColor,
            onPressed: onChanged,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: isSelected ? color : defaultColor),
        ),
      ],
    );
  }
}
