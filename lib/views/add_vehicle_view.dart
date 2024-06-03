import 'dart:ui';

import 'package:dms/providers/home_provider.dart';
import 'package:dms/views/service_history_view.dart';
import 'package:flutter/material.dart';
import 'package:custom_widgets/src.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Montserrat-Regular', useMaterial3: true),
    home: AddVehicleView(),
  ));
}

class AddVehicleView extends StatefulWidget {
  const AddVehicleView({super.key});

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  TextEditingController vehicleTypeController = TextEditingController();
  TextEditingController chassisNumberController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController kmsController = TextEditingController();
  TextEditingController customerNumberController = TextEditingController();
  TextEditingController customerPhoneNumberController = TextEditingController();
  TextEditingController vehicleRegNumberController = TextEditingController();
  TextEditingController mfgYearController = TextEditingController();
  TextEditingController financialDetailsController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();

  ScrollController scrollController = ScrollController();
  FocusNode vehicleTypeFocus = FocusNode();
  FocusNode chassisNumberFocus = FocusNode();
  FocusNode modelFocus = FocusNode();
  FocusNode kmsFocus = FocusNode();
  FocusNode customerNumberFocus = FocusNode();
  FocusNode customerPhoneNumberFocus = FocusNode();
  FocusNode vehicleRegNumberFocus = FocusNode();
  FocusNode engineNumberFocus = FocusNode();
  FocusNode mfgYearFocus = FocusNode();
  FocusNode financialDetailsFocus = FocusNode();
  FocusNode customerAddressFocus = FocusNode();
  FocusNode insuranceCompanyFocus = FocusNode();
  FocusNode makeFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    var size = MediaQuery.of(context).size;
    double fieldWidth;
    double fieldHeight;
    double fieldFontSize;
    double fieldDropDownwidth;

    bool isMobile = size.width < 650;
    if (isMobile) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      fieldWidth = size.width * 0.8;
      fieldHeight = size.height * 0.06;
      fieldDropDownwidth = size.width * 0.75;
      fieldFontSize = 13;
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      fieldWidth = size.width * 0.3;
      fieldHeight = size.height * 0.063;
      fieldDropDownwidth = size.width * 0.285;
      fieldFontSize = 14;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: EdgeInsets.only(
                    right: isMobile ? 5 : 40, bottom: isMobile ? 15 : 25),
                child: CustomWidgets.CustomExpandableFAB(
                    horizontalAlignment: isMobile ? -17 : -40,
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
                                'assets/images/add_user.png',
                                color: Colors.black,
                                fit: BoxFit.cover,
                                scale: isMobile ? 22 : 15,
                              ),
                              Text(
                                'Add Customer',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: isMobile ? 11 : 14),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.085,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ServiceHistoryView()));
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: isMobile ? 28 : 40,
                              ),
                              Text(
                                'History',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: isMobile ? 11 : 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
              )
            : SizedBox(),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back_rounded, color: Colors.white)),
          title: Text(
            "Add Vehicle",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
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
          child: SafeArea(
            child: ListView(
              controller: scrollController,
              children: [
                SizedBox(
                  height: size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SearchableDropDown(
                              size: size,
                              hint: "Vehicle type",
                              items: ["sedan", "SUV", "XUV"],
                              focus: vehicleTypeFocus,
                              txcontroller: vehicleTypeController,
                              height: fieldHeight,
                              width: fieldWidth,
                              fieldDropDownwidth: fieldDropDownwidth,
                              fieldFontSize: fieldFontSize),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CustomDataCard(
                              focusNode: chassisNumberFocus,
                              size: size,
                              hint: "Chassis. no.",
                              maxLength: 10,
                              width: fieldWidth,
                              height: fieldHeight,
                              fieldFontSize: fieldFontSize),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CustomDataCard(
                              focusNode: modelFocus,
                              size: size,
                              hint: "Model",
                              maxLength: 10,
                              width: fieldWidth,
                              height: fieldHeight,
                              fieldFontSize: fieldFontSize),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CustomDataCard(
                              focusNode: kmsFocus,
                              size: size,
                              hint: "KMS",
                              maxLength: 10,
                              width: fieldWidth,
                              height: fieldHeight,
                              fieldFontSize: fieldFontSize),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: SearchableDropDown(
                              size: size,
                              hint: "Insurance Company",
                              items: ["abc", "xyz", "pqr"],
                              focus: insuranceCompanyFocus,
                              txcontroller: vehicleTypeController,
                              width: fieldWidth,
                              height: fieldHeight,
                              fieldDropDownwidth: fieldDropDownwidth,
                              fieldFontSize: fieldFontSize),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CustomDataCard(
                              focusNode: customerNumberFocus,
                              size: size,
                              hint: "Customer no.",
                              width: fieldWidth,
                              height: fieldHeight,
                              fieldFontSize: fieldFontSize),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: CustomDataCard(
                              focusNode: customerPhoneNumberFocus,
                              size: size,
                              hint: "customer phone no.",
                              width: fieldWidth,
                              height: fieldHeight,
                              fieldFontSize: fieldFontSize),
                        ),
                        size.width < 700
                            ? fields(context, size, fieldHeight, fieldWidth,
                                fieldDropDownwidth, fieldFontSize)
                            : SizedBox()
                      ],
                    ),
                    if (size.width >= 700)
                      fields(context, size, fieldHeight, fieldWidth,
                          fieldDropDownwidth, fieldFontSize),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      child: Text("Submit"),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          minimumSize: Size(10, 32),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white),
                    )
                  ],
                ),
                MediaQuery.of(context).viewInsets.bottom == 0
                    ? SizedBox(
                        height: size.height * 0.1,
                      )
                    : SizedBox(
                        height: size.height * 0.5,
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fields(context, size, fieldHeight, fieldWidth, fieldDropDownwidth,
      fieldFontSize) {
    TextEditingController vehicleTypeController = TextEditingController();
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                focusNode: vehicleRegNumberFocus,
                size: size,
                hint: "Vehicle Reg. no.",
                maxLength: 10,
                height: fieldHeight,
                width: fieldWidth,
                fieldFontSize: fieldFontSize),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                focusNode: engineNumberFocus,
                size: size,
                hint: "Engine no.",
                height: fieldHeight,
                width: fieldWidth,
                fieldFontSize: fieldFontSize),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SearchableDropDown(
                size: size,
                hint: "Make",
                items: ["1", "2", "3"],
                focus: makeFocus,
                txcontroller: vehicleTypeController,
                height: fieldHeight,
                width: fieldWidth,
                fieldDropDownwidth: fieldDropDownwidth,
                fieldFontSize: fieldFontSize),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                focusNode: mfgYearFocus,
                size: size,
                hint: "MFG Year",
                maxLength: 4,
                height: fieldHeight,
                width: fieldWidth,
                fieldFontSize: fieldFontSize),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                focusNode: financialDetailsFocus,
                size: size,
                hint: "Financial details",
                height: fieldHeight,
                width: fieldWidth,
                fieldFontSize: fieldFontSize),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                focusNode: customerAddressFocus,
                size: size,
                hint: "Customer address",
                height: fieldHeight,
                width: fieldWidth,
                fieldFontSize: fieldFontSize),
          ),
          SizedBox(
            height: size.height * 0.06,
            width: size.width * 0.3,
          )
        ],
      ),
    );
  }

  Widget SearchableDropDown(
      {required size,
      required hint,
      required List<String> items,
      required FocusNode focus,
      required TextEditingController txcontroller,
      double? height,
      double? width,
      double? fieldDropDownwidth,
      double? fieldFontSize}) {
    return SizedBox(
      height: height ?? size.height * 0.01,
      width: width ?? size.width * 0.75,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Row(
          children: [
            SizedBox(
              height: size.height * 0.05,
              width: fieldDropDownwidth ?? size.width * 0.285,
              child: TypeAheadField(
                builder: (context, controller, focusNode) {
                  focus = focusNode;
                  txcontroller = controller;
                  return TextFormField(
                    onTap: () {
                      Provider.of<HomeProvider>(context, listen: false)
                          .setFocusNode(focusNode, scrollController, context);
                    },
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      hintText: hint,
                      hintStyle: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                      border: InputBorder.none, // Removes all borders
                    ),
                    controller: controller,
                    focusNode: focusNode,
                    style: TextStyle(fontSize: fieldFontSize),
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
                    style: TextStyle(fontSize: fieldFontSize),
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
      required FocusNode focusNode,
      int? maxLength,
      TextEditingController? txcontroller,
      double? width,
      double? height,
      double? verticalPadding,
      double? horizontalPadding,
      double? fieldFontSize}) {
    return SizedBox(
      height: height ?? size.height * 0.07,
      width: width ?? size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        child: TextFormField(
          focusNode: focusNode,
          onTap: () {
            Provider.of<HomeProvider>(context, listen: false)
                .setFocusNode(focusNode, scrollController, context);
          },
          maxLength: maxLength,
          maxLengthEnforcement: maxLength == null
              ? MaxLengthEnforcement.none
              : MaxLengthEnforcement.enforced,
          controller: txcontroller,
          decoration: InputDecoration(
              counterText: "",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.normal)),
          style: TextStyle(fontSize: fieldFontSize),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
