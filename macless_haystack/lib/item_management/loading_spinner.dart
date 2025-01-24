import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {

  /// Displays a centered loading spinner.
  const LoadingSpinner({ super.key });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Padding(
        padding: const EdgeInsets.only(top: 20),
        child: CircularProgressIndicator(
          color: Theme.of(context).primaryColor,
          semanticsLabel: '加载中。请坐和放宽。',
        ),
      )],
    );
  }
}
