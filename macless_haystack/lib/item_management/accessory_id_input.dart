import 'package:flutter/material.dart';

class AccessoryIdInput extends StatelessWidget {
 final  ValueChanged<String?> changeListener;

  /// Displays an input field with validation for an accessory ID.
  const AccessoryIdInput({
    super.key,
    required this.changeListener,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: 'ID',
        ),
        validator: (value) {
          if (value == null) {
            return 'I必须提供 ID。';
          }
          int? parsed = int.tryParse(value);
          if (parsed == null) {
            return 'ID 必须为整数。';
          }
          return null;
        },
        onSaved: changeListener,
      ),
    );
  }
}
