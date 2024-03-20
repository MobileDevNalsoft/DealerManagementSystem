import 'package:flutter/material.dart';
import 'package:custom_widgets/src.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {

  runApp(MaterialApp(
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
   
  @override
  Widget build(BuildContext context) {
     WidgetsFlutterBinding.ensureInitialized();
    TextEditingController vehicleTypeController = TextEditingController();
    FocusNode focus = FocusNode();
    var size = MediaQuery.of(context).size;
    late double fieldWidth;
    late double fieldHeight;
    double fieldDropDownwidth;
    double contentWidth = size.width;
    if (contentWidth < 650) {
       SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      fieldWidth = size.width * 0.75;
      fieldHeight = size.height * 0.07;
      fieldDropDownwidth = size.width * 0.7;
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight,]);
      fieldWidth = size.width * 0.3;
      fieldHeight = size.height * 0.063;
      fieldDropDownwidth = size.width * 0.285;
    }

    return SafeArea(
      child: Scaffold(
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: const EdgeInsets.only(right: 12, bottom: 25),
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
                          onTap: () {},
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
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Add Vehicle"),
          centerTitle: true,
          backgroundColor: Color.fromRGBO(241, 255, 242, 100),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), BlendMode.darken),
                image: AssetImage(
                  'assets/images/dms_bg.jpg',
                ),
                fit: BoxFit.cover),
          ),
          child: ListView(
            physics: ScrollPhysics(),
            children: [
              SizedBox(
                height: size.height * 0.125,
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
                          focus: focus,
                          txcontroller: vehicleTypeController,
                          height: fieldHeight,
                          width: fieldWidth,
                          fieldDropDownwidth: fieldDropDownwidth,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(
                          size: size,
                          hint: "Chassis. no.",
                          maxLength: 10,
                          width: fieldWidth,
                          height: fieldHeight,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(
                          size: size,
                          hint: "Model",
                          maxLength: 10,
                          width: fieldWidth,
                          height: fieldHeight,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(
                          size: size,
                          hint: "KMS",
                          maxLength: 10,
                          width: fieldWidth,
                          height: fieldHeight,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SearchableDropDown(
                            size: size,
                            hint: "Insurance Company",
                            items: ["abc", "xyz", "pqr"],
                            focus: focus,
                            txcontroller: vehicleTypeController,
                            width: fieldWidth,
                            height: fieldHeight,
                            fieldDropDownwidth: fieldDropDownwidth),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(
                          size: size,
                          hint: "Customer no.",
                          width: fieldWidth,
                          height: fieldHeight,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(
                            size: size,
                            hint: "customer phone no.",
                            width: fieldWidth,
                            height: fieldHeight),
                      ),
                      size.width < 700
                          ? fields(context, size, focus, fieldHeight,
                              fieldWidth, fieldDropDownwidth)
                          : SizedBox()
                    ],
                  ),
                  if (size.width >= 700)
                    fields(context, size, focus, fieldHeight, fieldWidth,
                        fieldDropDownwidth),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      CustomWidgets.CustomSnackBar(
                        context,
                        "test scaffold",
                        Colors.green,
                      );
                    },
                    child: Text("Submit"),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(10, 32),
                        backgroundColor: Color.fromRGBO(40, 83, 235, 100),
                        foregroundColor: Colors.white),
                  )
                ],
              ),
             MediaQuery.of(context).viewInsets.bottom == 0?SizedBox(height: size.height*0.1,):SizedBox(height: size.height*0.5,)
            ],
          ),
        ),
      ),
    );
  }

  Widget fields(
      context, size, focus, fieldHeight, fieldWidth, fieldDropDownwidth) {
    TextEditingController vehicleTypeController = TextEditingController();
    return SizedBox(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                size: size,
                hint: "Vehicle Reg. no.",
                maxLength: 10,
                height: fieldHeight,
                width: fieldWidth),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                size: size,
                hint: "Engine no.",
                height: fieldHeight,
                width: fieldWidth),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SearchableDropDown(
              size: size,
              hint: "Make",
              items: ["1", "2", "3"],
              focus: focus,
              txcontroller: vehicleTypeController,
              height: fieldHeight,
              width: fieldWidth,
              fieldDropDownwidth: fieldDropDownwidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
              size: size,
              hint: "MFG Year",
              maxLength: 4,
              height: fieldHeight,
              width: fieldWidth,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                size: size,
                hint: "Financial details",
                height: fieldHeight,
                width: fieldWidth),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: CustomDataCard(
                size: size,
                hint: "Customer address",
                height: fieldHeight,
                width: fieldWidth),
          ),
          SizedBox(
            height: size.height * 0.06,
            width: size.width * 0.3,
          )
        ],
      ),
    );
  }

  Widget SearchableDropDown({
    required size,
    required hint,
    required List<String> items,
    required FocusNode focus,
    required TextEditingController txcontroller,
    double? height,
    double? width,
    double? fieldDropDownwidth,
  }) {
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
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.arrow_drop_down),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      hintText: hint,
                      hintStyle: TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.normal),
                      border: InputBorder.none, // Removes all borders
                    ),
                    controller: controller,
                    focusNode: focusNode,
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
      int? maxLength,
      TextEditingController? txcontroller,
      double? width,
      double? height,
      double? verticalPadding,
      double? horizontalPadding}) {
    return SizedBox(
      height: height ?? size.height * 0.07,
      width: width ?? size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        child: TextFormField(
          maxLength: maxLength,
          maxLengthEnforcement: maxLength == null
              ? MaxLengthEnforcement.none
              : MaxLengthEnforcement.enforced,
          controller: txcontroller,
          decoration: InputDecoration(
              counterText: "",
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                  color: Colors.black54, fontWeight: FontWeight.normal)),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }
}
