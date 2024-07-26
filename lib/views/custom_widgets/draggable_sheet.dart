import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DraggableSheet extends StatefulWidget {
  final Widget child;
  const DraggableSheet({super.key, required this.child});

  @override
  State<DraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends State<DraggableSheet> {
  final sheet = GlobalKey();
  final contoller = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DraggableScrollableSheet(
          controller: contoller,
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.95,
          expand: true,
          builder: (context, scrollController) {
            return const DecoratedBox(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow,
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      )
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22))));
          },
        );
      },
    );
  }
}
