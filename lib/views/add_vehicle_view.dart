import 'package:flutter/material.dart';
import 'package:custom_widgets/src.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

void main() {
  runApp(MaterialApp(
    home: AddVehicleView(),
  ));
}

class AddVehicleView extends StatefulWidget {
  const AddVehicleView({super.key});

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  bool isFloatingButtonOpen=false;
  @override
  Widget build(BuildContext context) {
    TextEditingController vehicleTypeController = TextEditingController();
    FocusNode focus = FocusNode();
    
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton: CustomWidgets.CustomExpandableFAB(children: [],distance: size.height*0.1),
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
                fit: BoxFit.fill),
          ),
          child: ListView(
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
                            txcontroller: vehicleTypeController),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(size: size, hint: "Chassis. no."),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(size: size, hint: "Model"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(size: size, hint: "KMS"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: SearchableDropDown(
                            size: size,
                            hint: "Insurance Company",
                            items: ["abc", "xyz", "pqr"],
                            focus: focus,
                            txcontroller: vehicleTypeController),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(size: size, hint: "Customer no."),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: CustomDataCard(
                            size: size, hint: "customer phone no."),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CustomDataCard(
                            size: size, hint: "Vehicle Reg. no."),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CustomDataCard(size: size, hint: "Engine no."),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SearchableDropDown(
                            size: size,
                            hint: "Make",
                            items: ["1", "2", "3"],
                            focus: focus,
                            txcontroller: vehicleTypeController),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CustomDataCard(size: size, hint: "MFG Year"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CustomDataCard(
                            size: size, hint: "Financial details"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: CustomDataCard(
                            size: size, hint: "Customer address"),
                      ),
                      SizedBox(
                        height: size.height * 0.06,
                        width: size.width * 0.3,
                      )
                    ],
                  ),
                  SizedBox(
                    width: size.width * 0.02,
                  ),
                ],
              ),
              SizedBox(height: size.height*0.02,),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [ElevatedButton(
                  onPressed: () {},
                  child: Text("Submit"),
                  style: ElevatedButton.styleFrom(minimumSize: Size(10, 10)),
                )],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget SearchableDropDown({
    required size,
    required hint,
    required List<String> items,
    required FocusNode focus,
    required TextEditingController txcontroller,
  }) {
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
                        // suffixIcon: Icon(Icons.arrow_drop_down_rounded),

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
