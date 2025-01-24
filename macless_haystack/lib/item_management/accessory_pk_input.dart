import 'dart:convert';

import 'package:flutter/material.dart';

class AccessoryPrivateKeyInput extends StatelessWidget {
  final ValueChanged<String?> changeListener;

  /// Displays an input field with validation for a Base64 encoded accessory private key.
  const AccessoryPrivateKeyInput({
    super.key,
    required this.changeListener,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'SGVsbG8gV29ybGQhCg==',
          labelText: '私钥（Base64）',
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '必须提供私钥。';
          }
          try {
            var removeEscaping = value
              .replaceAll('\\', '').replaceAll('\n', '');
            base64Decode(removeEscaping);
          } catch (e) {
            return '值必须是有效的 Base64 值。';
          }
          return null;
        },
        onSaved: (newValue) =>
          changeListener(newValue?.replaceAll('\\', '').replaceAll('\n', '')),
      ),
    );
  }
}
