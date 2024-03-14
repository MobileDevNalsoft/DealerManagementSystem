import 'package:dms/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';
import 'package:custom_widgets/src.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  TextEditingController txcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Home'),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(229, 255, 231, 0.612),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/dms_bg.png',
                ),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: SizedBox(
              width: size.width * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        children: [
                          TypeAheadField(
                            builder: (context, controller, focusNode) {
                              txcontroller = controller;
                              return SizedBox(
                                height: size.height * 0.063,
                                child: Card(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5.0, left: 14),
                                      child: TextFormField(
                                        style: TextStyle(color: Colors.black54),
                                        decoration: InputDecoration(
                                          border: InputBorder
                                              .none, // Removes all borders
                                        ),
                                        controller: controller,
                                        focusNode: focusNode,
                                        autofocus: true,
                                        validator: (value) => value!.isEmpty
                                            ? 'Please select a value'
                                            : [
                                                'Location 1',
                                                'Location 2',
                                                'Location 3',
                                                'Location 4',
                                                'Location 5'
                                              ].any((element) =>
                                                    element.toLowerCase() ==
                                                    value.toLowerCase())
                                                ? null
                                                : 'Please select a valid location',
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            suggestionsCallback: (pattern) {
                              return [
                                'Location 1',
                                'Location 2',
                                'Location 3',
                                'Location 4',
                                'Location 5'
                              ]
                                  .where((item) => item
                                      .toLowerCase()
                                      .contains(pattern.toLowerCase()))
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) => ListTile(
                              title: Text(suggestion),
                            ),
                            onSelected: (suggestion) {
                              txcontroller.text = suggestion;
                            },
                          ),
                          CustomDataCard(size: size, content: 'AP09AS1234'),
                          CustomDataCard(size: size, content: 'Schedule Date'),
                          CustomDataCard(size: size, content: 'KMS'),
                        ],
                      );
                    },
                  ),
                  Row(
                    children: [
                      Expanded(child: SizedBox()),
                      ElevatedButton(onPressed: () {}, child: Text('view more'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget CustomDataCard({required Size size, required String content}) {
    return SizedBox(
      height: size.height * 0.06,
      width: size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 14),
          child: Text(
            content,
            style:
                TextStyle(fontWeight: FontWeight.normal, color: Colors.black54),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
