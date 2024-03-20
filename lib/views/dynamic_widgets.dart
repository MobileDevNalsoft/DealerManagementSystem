import 'package:dms/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DynamicWidgets extends StatefulWidget {
  @override
  _DynamicWidgets createState() => _DynamicWidgets();
}

class _DynamicWidgets extends State<DynamicWidgets> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                  Provider.of<HomeProvider>(context, listen: false)
                      .apiWidgets
                      .length,
                  (index) => Provider.of<HomeProvider>(context, listen: false)
                          .localWidgets[
                      Provider.of<HomeProvider>(context, listen: false)
                          .apiWidgets[index]]!)),
        ),
      ),
    );
  }
}
