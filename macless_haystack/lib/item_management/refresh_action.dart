import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RefreshAction extends StatefulWidget {
  final AsyncCallback callback;

  /// A new accessory can be created or an existing one imported manually.
  const RefreshAction({super.key, required this.callback});

  @override
  State<StatefulWidget> createState() {
    return _RefreshingWidgetState();
  }
}

class _RefreshingWidgetState extends State<RefreshAction> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        heroTag: null,
        onPressed: () {
          widget.callback.call();
        },
        tooltip: '刷新',
        child: const Icon(Icons.refresh));
  }
}
