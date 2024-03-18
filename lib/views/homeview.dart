import 'package:dms/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:provider/provider.dart';
import 'package:custom_widgets/src.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:math' as math;

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  double _keyboardHeight = 0.0;
  FocusNode focus = FocusNode();
  TextEditingController txcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
          _keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        }));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
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
                  'assets/images/dms_bg.jpg',
                ),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: _keyboardHeight),
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
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          CustomDataCard(
                              size: size,
                              hint: 'Vehicle Registration Number',
                              icon: Icon(Icons.check_circle_rounded)),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
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
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          CustomDataCard(size: size, hint: 'Schedule Date'),
                          SizedBox(
                            height: size.height * 0.03,
                          ),
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
                          onPressed: () {
                            CustomWidgets.CustomDialogBox(
                              context: context,
                              child: SizedBox(
                                height: size.height * 0.18,
                                width: size.width * 0.35,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Chassis no.'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Make'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Model'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Variant'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Color'),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('  :  '),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('  :  '),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('  :  '),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('  :  '),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('  :  '),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('ABCDEFG12345'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Suzuki'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Dzire'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('ZXI'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Blue'),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Customer Name'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Contact Person'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Contact Person'),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('  :  '),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('  :  '),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('  :  '),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('Prappan'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('Jack'),
                                                SizedBox(
                                                    height: size.height * 0.01),
                                                Text('1234567890'),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'view more',
                            style: TextStyle(
                                color: Color.fromRGBO(40, 83, 235, 1)),
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
        ),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: const EdgeInsets.only(right: 40, bottom: 25),
                child: CustomWidgets.CustomExpandableFAB(
                    horizontalAlignment: -38,
                    rotational: false,
                    angle: 90,
                    distance: 70,
                    color: Color.fromRGBO(229, 255, 231, 1),
                    children: [
                      SizedBox(
                        height: size.height * 0.08,
                        width: size.width * 0.1,
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/add_user.png',
                                color: Color.fromRGBO(229, 255, 231, 1),
                                fit: BoxFit.cover,
                                scale: 15,
                              ),
                              Text(
                                'Add Customer',
                                style: TextStyle(
                                    color: Color.fromRGBO(229, 255, 231, 1)),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.08,
                        width: size.width * 0.1,
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/car.png',
                                color: Color.fromRGBO(229, 255, 231, 1),
                                fit: BoxFit.cover,
                                scale: 15,
                              ),
                              Text(
                                'Add Vehicle',
                                style: TextStyle(
                                    color: Color.fromRGBO(229, 255, 231, 1)),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.09,
                        width: size.width * 0.1,
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: 40,
                                color: Color.fromRGBO(229, 255, 231, 1),
                              ),
                              Text(
                                'History',
                                style: TextStyle(
                                    color: Color.fromRGBO(229, 255, 231, 1)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
              )
            : SizedBox(),
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
      TextEditingController? txcontroller,
      Widget? icon}) {
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
            child: Row(
              children: [
                TextFormField(
                  controller: txcontroller,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                      hintStyle: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                      suffixIcon: icon,
                      suffixIconColor: Colors.green),
                ),
              ],
            )),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
