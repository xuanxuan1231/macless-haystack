import 'package:flutter/material.dart';

class AccessoryNameInput extends StatelessWidget {
  final ValueChanged<String?>? onSaved;
  final ValueChanged<String>? onChanged;
  /// The initial accessory name
  final String? initialValue;

  /// Displays an input field with validation for an accessory name.
  const AccessoryNameInput({
    super.key,
    this.onSaved,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        decoration: const InputDecoration(
          labelText: '名称',
        ),
        validator: (value) {
          if (value == null) {
            return '必须提供名称。';
          }
          if (value.isEmpty || value.length > 30) {
            return '名称必须是一个非空字符串，最大长度为 30。';
          }
          return null;
        },
        onSaved: onSaved,
        onChanged: onChanged,
        initialValue: initialValue,
      ),
    );
  }
}
