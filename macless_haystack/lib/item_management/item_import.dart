import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:macless_haystack/accessory/accessory_model.dart';
import 'package:macless_haystack/accessory/accessory_registry.dart';
import 'package:macless_haystack/findMy/find_my_controller.dart';
import 'package:macless_haystack/item_management/accessory_color_input.dart';
import 'package:macless_haystack/item_management/accessory_icon_input.dart';
import 'package:macless_haystack/item_management/accessory_id_input.dart';
import 'package:macless_haystack/item_management/accessory_name_input.dart';
import 'package:macless_haystack/item_management/accessory_pk_input.dart';

class AccessoryImport extends StatefulWidget {
  /// Displays an input form to manually import an accessory.
  const AccessoryImport({super.key});

  @override
  State<AccessoryImport> createState() => _AccessoryImportState();
}

class _AccessoryImportState extends State<AccessoryImport> {
  /// Stores the properties of the accessory to import.
  Accessory newAccessory = Accessory(
      id: '',
      name: '',
      hashedPublicKey: '',
      datePublished: DateTime.now(),
      additionalKeys: List.empty());
  String privateKey = '';

  final _formKey = GlobalKey<FormState>();

  /// Imports the private key to the key store.
  Future<void> importKey(BuildContext context) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        try {
          var keyPair = await FindMyController.importKeyPair(privateKey);
          newAccessory.hashedPublicKey = keyPair.hashedPublicKey;
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('密钥导入失败。检查私钥是否正确。'),
            ),
          );
        }
        var keyPair = await FindMyController.importKeyPair(privateKey);
        newAccessory.hashedPublicKey = keyPair.hashedPublicKey;

        if (mounted) {
          AccessoryRegistry accessoryRegistry =
              Provider.of<AccessoryRegistry>(context, listen: false);
          accessoryRegistry.addAccessory(newAccessory);
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('导入设备'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const ListTile(
                title: Text(
                    '请输入设备参数。它们可在导出的设备的文件中找到。'),
              ),
              AccessoryIdInput(
                changeListener: (id) => setState(() {
                  newAccessory.id = id!;
                }),
              ),
              AccessoryNameInput(
                onSaved: (name) => setState(() {
                  newAccessory.name = name!;
                }),
              ),
              AccessoryIconInput(
                initialIcon: newAccessory.icon,
                iconString: newAccessory.rawIcon,
                color: newAccessory.color,
                changeListener: (String? selectedIcon) {
                  if (selectedIcon != null) {
                    setState(() {
                      newAccessory.setIcon(selectedIcon);
                    });
                  }
                },
              ),
              AccessoryColorInput(
                color: newAccessory.color,
                changeListener: (Color? selectedColor) {
                  if (selectedColor != null) {
                    setState(() {
                      newAccessory.color = selectedColor;
                    });
                  }
                },
              ),
              AccessoryPrivateKeyInput(
                changeListener: (String? privateKeyVal) async {
                  if (privateKeyVal != null) {
                    setState(() {
                      privateKey = privateKeyVal;
                    });
                  }
                },
              ),
              SwitchListTile(
                value: newAccessory.isActive,
                title: const Text('正活跃'),
                onChanged: (checked) {
                  setState(() {
                    newAccessory.isActive = checked;
                  });
                },
              ),
              SwitchListTile(
                value: newAccessory.isDeployed,
                title: const Text('已部署'),
                onChanged: (checked) {
                  setState(() {
                    newAccessory.isDeployed = checked;
                  });
                },
              ),
              ListTile(
                title: ElevatedButton(
                  child: const Text('导入'),
                  onPressed: () => importKey(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
