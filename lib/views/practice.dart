import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            InkWell(
              child: Container(
                decoration: const BoxDecoration(color: Colors.blue),
                height: 200,
                width: 200,
              ),
            ),
            InkWell(
              child: Container(
                decoration: const BoxDecoration(color: Colors.red),
                height: 100,
                width: 100,
              ),
            )
          ],
        ),
      ],
    );
  }
}
