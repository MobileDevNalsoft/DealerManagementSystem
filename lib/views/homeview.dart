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
  FocusNode focus = FocusNode();
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SearchableDropDown(
                          size: size,
                          hint: 'Location',
                          items: [
                            'Location 1',
                            'Location 2',
                            'Location 3',
                            'Location 4',
                            'Location 5'
                          ],
                          focus: focus,
                          txcontroller: txcontroller,
                          provider: provider),
                      CustomDataCard(
                          size: size, hint: 'Vehicle Registration Number'),
                      SearchableDropDown(
                          size: size,
                          hint: 'Customer',
                          items: [
                            'Customer 1',
                            'Customer 2',
                            'Customer 3',
                            'Customer 4',
                            'Customer 5'
                          ],
                          focus: focus,
                          txcontroller: txcontroller,
                          provider: provider),
                      CustomDataCard(size: size, hint: 'Schedule Date'),
                      CustomDataCard(size: size, hint: 'KMS'),
                    ],
                  );
                },
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * 0.583,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'view more',
                        style: TextStyle(color: Color.fromRGBO(40, 83, 235, 1)),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(80.0, 20.0),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))))
                ],
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'next',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(70.0, 35.0),
                      padding: EdgeInsets.zero,
                      backgroundColor: Color.fromRGBO(40, 83, 235, 1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))))
            ],
          ),
        ),
      ),
    );
  }

  Widget SearchableDropDown(
      {required size,
      required hint,
      required List<String> items,
      required FocusNode focus,
      required TextEditingController txcontroller,
      required HomeProvider provider}) {
    return SizedBox(
      height: size.height * 0.063,
      width: size.width * 0.3,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            SizedBox(
              height: size.height * 0.05,
              width: size.width * 0.25,
              child: TypeAheadField(
                builder: (context, controller, focusNode) {
                  focus = focusNode;
                  txcontroller = controller;
                  return Padding(
                    padding: const EdgeInsets.only(left: 14, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal),
                        border: InputBorder.none, // Removes all borders
                      ),
                      controller: controller,
                      focusNode: focusNode,
                    ),
                  );
                },
                suggestionsCallback: (pattern) {
                  return items
                      .where((item) =>
                          item.toLowerCase().contains(pattern.toLowerCase()))
                      .toList();
                },
                itemBuilder: (context, suggestion) => ListTile(
                  title: Text(suggestion),
                ),
                onSelected: (suggestion) {
                  txcontroller.text = suggestion;
                  focus.unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget CustomDataCard(
      {required Size size,
      required String hint,
      TextEditingController? txcontroller}) {
    return SizedBox(
      height: size.height * 0.06,
      width: size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 13,
            ),
            child: TextFormField(
              controller: txcontroller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                      color: Colors.black54, fontWeight: FontWeight.normal)),
            )),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
