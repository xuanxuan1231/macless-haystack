
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:macless_haystack/item_management/item_creation.dart';
import 'package:macless_haystack/item_management/item_file_import.dart';
import 'package:macless_haystack/item_management/item_import.dart';
import 'dart:io';

class NewKeyAction extends StatelessWidget {
  /// If the action button is small.
  final bool mini;

  /// Displays a floating button used to access the accessory creation menu.
  ///
  /// A new accessory can be created or an existing one imported manually.
  const NewKeyAction({
    super.key,
    this.mini = false,
  });

  /// Display a bottom sheet with creation options.
  void showCreationSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('导入设备'),
                  leading: const Icon(Icons.import_export),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccessoryImport()),
                    );
                  },
                ),
                ListTile(
                  title: const Text('从 JSON 文件导入'),
                  leading: const Icon(Icons.description),
                  onTap: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: false,
                      type: FileType.custom,
                      allowedExtensions: ['json'],
                      dialogTitle: '选择设备配置',
                    );

                    if (result != null) {
                      var uploadfile = result.files.single.bytes;
                      if (uploadfile != null && context.mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ItemFileImport(bytes: uploadfile),
                            ));
                      } else if (result.paths.isNotEmpty) {
                        String? filePath = result.paths[0];
                        if (filePath != null) {
                          var fileAsBytes = await File(filePath).readAsBytes();
                          if (context.mounted) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ItemFileImport(bytes: fileAsBytes),
                                ));
                          }
                        }
                      }
                    }
                  },
                ),
                ListTile(
                  title: const Text('创建新设备'),
                  leading: const Icon(Icons.add_box),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AccessoryGeneration()),
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      mini: mini,
      heroTag: null,
      onPressed: () {
        showCreationSheet(context);
      },
      tooltip: 'Create',
      child: const Icon(Icons.add),
    );
  }
}
