import 'package:dms/providers/home_provider.dart';
import 'package:dms/views/dynamic_widgets.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:customs/src.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:math' as math;

class HomeProceedView extends StatefulWidget {
  @override
  State<HomeProceedView> createState() => _HomeProceedView();
}

class _HomeProceedView extends State<HomeProceedView> {
  FocusNode bookingFocus = FocusNode();
  FocusNode altContFocus = FocusNode();
  FocusNode spFocus = FocusNode();
  FocusNode bayFocus = FocusNode();
  FocusNode jobTypeFocus = FocusNode();
  FocusNode custConcernsFocus = FocusNode();
  FocusNode remarksFocus = FocusNode();
  TextEditingController bookingController = TextEditingController();
  TextEditingController altContController = TextEditingController();
  TextEditingController spController = TextEditingController();
  TextEditingController bayController = TextEditingController();
  TextEditingController jobTypeController = TextEditingController();
  TextEditingController custConcernsController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    // Set preferred orientations based on device type
    if (!isMobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          child: ListView(
            controller: scrollController,
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Spacer(
                    flex: (size.width * 0.01).round(),
                  ),
                  IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                      )),
                  Spacer(
                    flex: (size.width * (isMobile ? 0.6 : 0.88)).round(),
                  ),
                  Text(
                    "Home",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Spacer(
                    flex: size.width.round(),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: size.height * (0.05),
                  ),
                  Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomDataCard(
                              size: size,
                              hint: 'Booking Source',
                              isMobile: isMobile,
                              focusNode: bookingFocus,
                              txcontroller: bookingController),
                          SizedBox(
                            height: size.height * (isMobile ? 0.005 : 0.015),
                          ),
                          CustomDataCard(
                              size: size,
                              hint: 'Alternate Contact Person',
                              isMobile: isMobile,
                              focusNode: altContFocus,
                              txcontroller: altContController),
                          SizedBox(
                            height: size.height * (isMobile ? 0.005 : 0.015),
                          ),
                          CustomDataCard(
                              size: size,
                              hint: 'Sales Person',
                              isMobile: isMobile,
                              focusNode: spFocus,
                              txcontroller: spController),
                          SizedBox(
                            height: size.height * (isMobile ? 0.005 : 0.015),
                          ),
                          CustomDataCard(
                              size: size,
                              hint: 'Bay',
                              isMobile: isMobile,
                              focusNode: bayFocus,
                              txcontroller: bayController),
                          SizedBox(
                            height: size.height * (isMobile ? 0.005 : 0.015),
                          ),
                          SearchableDropDown(
                              size: size,
                              hint: 'Job Type',
                              items: [
                                'Type 1',
                                'Type 2',
                                'Type 3',
                                'Type 4',
                                'Type 5'
                              ],
                              focus: jobTypeFocus,
                              txcontroller: jobTypeController,
                              provider: provider,
                              isMobile: isMobile),
                          SizedBox(
                            height: size.height * (isMobile ? 0.005 : 0.015),
                          ),
                          CustomTextFieldCard(
                              size: size,
                              hint: 'Customer Concerns',
                              isMobile: isMobile,
                              focusNode: custConcernsFocus,
                              txcontroller: custConcernsController),
                          SizedBox(
                            height: size.height * (isMobile ? 0.005 : 0.015),
                          ),
                          CustomTextFieldCard(
                              size: size,
                              hint: 'Remarks',
                              isMobile: isMobile,
                              focusNode: remarksFocus,
                              txcontroller: remarksController),
                          SizedBox(
                            height: size.height * (isMobile ? 0.05 : 0.015),
                          ),
                        ],
                      );
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        bookingFocus.unfocus();
                        altContFocus.unfocus();
                        spFocus.unfocus();
                        bayFocus.unfocus();
                        jobTypeFocus.unfocus();
                        custConcernsFocus.unfocus();
                        remarksFocus.unfocus();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => DynamicWidgets()));
                      },
                      child: Text(
                        'proceed to recieve',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(140.0, 35.0),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)))),
                  if (MediaQuery.of(context).viewInsets.bottom != 0)
                    SizedBox(
                      height: size.height * (isMobile ? 0.4 : 0.5),
                    ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: EdgeInsets.only(
                    right: isMobile ? 5 : 40, bottom: isMobile ? 15 : 25),
                child: CustomWidgets.CustomExpandableFAB(
                    horizontalAlignment: isMobile ? -17 : -38,
                    verticalAlignment: -15,
                    rotational: false,
                    angle: 90,
                    distance: isMobile ? 50 : 70,
                    color: Colors.black,
                    iconColor: Colors.white,
                    children: [
                      SizedBox(
                        height: size.height * 0.08,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/car.png',
                                color: Colors.white,
                                fit: BoxFit.cover,
                                scale: isMobile ? 22 : 15,
                              ),
                              Text(
                                'Add Vehicle',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 11 : 14),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.09,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: isMobile ? 28 : 40,
                                color: Colors.white,
                              ),
                              Text(
                                'History',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 11 : 14),
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
      required HomeProvider provider,
      required bool isMobile}) {
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
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
                  return Padding(
                    padding:
                        EdgeInsets.only(left: 11, top: isMobile ? 16.5 : 1),
                    child: TextFormField(
                      cursorColor: Colors.black,
                      style: TextStyle(fontSize: isMobile ? 13 : 14),
                      onTap: () {
                        Provider.of<HomeProvider>(context, listen: false)
                            .setFocusNode(focusNode, scrollController, context);
                      },
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.normal),
                        border: InputBorder.none, // Removes all borders
                      ),
                      controller: txcontroller,
                      focusNode: focus,
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
                  title: Text(
                    suggestion,
                    style: TextStyle(fontSize: isMobile ? 13 : 14),
                  ),
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
      FocusNode? focusNode,
      Widget? icon,
      required bool isMobile}) {
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        child: TextFormField(
          onTap: () {
            Provider.of<HomeProvider>(context, listen: false)
                .setFocusNode(focusNode!, scrollController, context);
          },
          style: TextStyle(fontSize: isMobile ? 13 : 14),
          cursorColor: Colors.black,
          controller: txcontroller,
          focusNode: focusNode,
          maxLength: 25,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(left: 12, bottom: isMobile ? 10 : 12),
              counterText: "",
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.normal),
              suffixIcon: icon,
              suffixIconColor: Colors.green),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }

  Widget CustomTextFieldCard(
      {required Size size,
      required String hint,
      TextEditingController? txcontroller,
      FocusNode? focusNode,
      Widget? icon,
      required bool isMobile}) {
    return SizedBox(
      height: isMobile ? size.height * 0.1 : size.height * 0.13,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        child: TextFormField(
          onTap: () {
            Provider.of<HomeProvider>(context, listen: false)
                .setFocusNode(focusNode!, scrollController, context);
          },
          cursorColor: Colors.black,
          style: TextStyle(fontSize: isMobile ? 13 : 14),
          controller: txcontroller,
          focusNode: focusNode,
          minLines: 1,
          maxLines: 5,
          maxLength: 200,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: EdgeInsets.only(left: 12, top: 8),
            border: InputBorder.none,
            hintText: hint,
            hintStyle:
                TextStyle(color: Colors.black45, fontWeight: FontWeight.normal),
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
