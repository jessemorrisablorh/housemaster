import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[50]
          : Colors.grey[900],
      body: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: SizedBox(
          height: 0.030 * height,
          width: 0.065 * width,
          child: CircularProgressIndicator(strokeWidth: 3, color: Colors.amber),
        ),
      ),
    );
  }
}
