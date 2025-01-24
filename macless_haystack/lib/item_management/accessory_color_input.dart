import 'package:flutter/material.dart';
import 'package:macless_haystack/accessory/accessory_color_selector.dart';

class AccessoryColorInput extends StatelessWidget {
  /// The inititial color value
  final Color color;
  /// Callback called when the color is changed. Parameter is null
  /// if color did not change
  final ValueChanged<Color?> changeListener;

  /// Displays a color selection input that previews the current selection.
  const AccessoryColorInput({
    super.key,
    required this.color,
    required this.changeListener,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          const Text('颜色'),
          Icon(
            Icons.circle,
            color: color,
          ),
          const Spacer(),
          OutlinedButton(
            child: const Text('修改'),
            onPressed: () async {
              Color? selectedColor = await AccessoryColorSelector
                .showColorSelection(context, color);
              changeListener(selectedColor);
            },
          ),
        ],
      ),
    );
  }
}
