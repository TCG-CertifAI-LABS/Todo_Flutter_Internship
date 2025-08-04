import 'package:flutter/material.dart';

class CheckboxComponent extends StatelessWidget {
  final bool value;
  final void Function(bool state) onChanged;
  final Widget widget;
  const CheckboxComponent({
    super.key,
    required this.value,
    required this.onChanged,
    required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (currentState) {
            if (currentState == null) {
              return;
            }

            onChanged(currentState);
          },
        ),
        Expanded(child: widget),
      ],
    );
  }
}
