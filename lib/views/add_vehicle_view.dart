import 'package:dms/models/vehicle_model.dart';
import 'package:dms/bloc/vehicle_bloc/vehicle_bloc.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/service_history_view.dart';
import 'package:flutter/material.dart';
import 'package:customs/src.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Montserrat-Regular', useMaterial3: true),
    home: AddVehicleView(),
  ));
}

class AddVehicleView extends StatelessWidget {
  AddVehicleView({super.key});

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
  TextEditingController insuranceCompanyController = TextEditingController();
  TextEditingController engineNumberController = TextEditingController();
  TextEditingController makeController = TextEditingController();
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

    bool isMobile = size.width < 650;
    if (isMobile) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      fieldWidth = size.width * 0.8;
      fieldHeight = size.height * 0.06;
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      fieldWidth = size.width * 0.6;
      fieldHeight = size.height * 0.063;
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
                                color: Colors.white,
                                fit: BoxFit.cover,
                                scale: isMobile ? 22 : 15,
                              ),
                              Text(
                                'Add Customer',
                                style: TextStyle(
                                    color: Colors.white,
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
                                color: Colors.white,
                                size: isMobile ? 28 : 40,
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
            : const SizedBox(),
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
        body: BlocConsumer<VehicleBloc, VehicleState>(
          listener: (context, state) {
            print("listening");
            if (state.isVehicleAdded == true) {
              CustomWidgets.CustomSnackBar(
                  context, "Vehicle Successfully added", Colors.green);
            }
          },
          builder: (context, state) {
            {
              print("built again");
              return Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/dms_bg.png',
                      ),
                      fit: BoxFit.cover),
                ),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Center(
                        child: FocusScope(
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              SizedBox(
                                height: isMobile
                                    ? MediaQuery.of(context).viewInsets.bottom ==
                                            0
                                        ? size.height * 0.62
                                        : size.height * 0.5
                                    : MediaQuery.of(context).viewInsets.bottom ==
                                            0
                                        ? size.height * 0.5
                                        : size.height * 0.4,
                                width: fieldWidth,
                                child: GridView(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: isMobile ? 1 : 2,
                                    mainAxisExtent: fieldHeight,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 16,
                                  ),
                                  controller: scrollController,
                                  children: [
                                    DMSCustomWidgets.SearchableDropDown(
                                      size: size,
                                      hint: "Vehicle type",
                                      items: ["sedan", "SUV", "XUV"],
                                      focus: vehicleTypeFocus,
                                      textcontroller: vehicleTypeController,
                                      isMobile: isMobile,
                                      scrollController: scrollController,
                                      icon: Icon(Icons.arrow_drop_down),
                                    ),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: chassisNumberFocus,
                                        size: size,
                                        hint: "Chassis. no.",
                                        isMobile: isMobile,
                                        scrollController: scrollController,
                                        textcontroller: chassisNumberController,
                                        context: context),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: modelFocus,
                                        size: size,
                                        hint: "Model",
                                        isMobile: isMobile,
                                        textcontroller: modelController,
                                        scrollController: scrollController,
                                        context: context),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: kmsFocus,
                                        size: size,
                                        hint: "KMS",
                                        isMobile: isMobile,
                                        textcontroller: kmsController,
                                        scrollController: scrollController,
                                        context: context),
                                    DMSCustomWidgets.SearchableDropDown(
                                      size: size,
                                      hint: "Insurance Company",
                                      items: ["abc", "xyz", "pqr"],
                                      focus: insuranceCompanyFocus,
                                      textcontroller: insuranceCompanyController,
                                      isMobile: isMobile,
                                      scrollController: scrollController,
                                      icon: Icon(Icons.arrow_drop_down),
                                    ),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: customerNumberFocus,
                                        size: size,
                                        hint: "Customer no.",
                                        isMobile: isMobile,
                                        textcontroller: customerNumberController,
                                        scrollController: scrollController,
                                        context: context),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: customerPhoneNumberFocus,
                                        size: size,
                                        hint: "customer phone no.",
                                        isMobile: isMobile,
                                        textcontroller:
                                            customerPhoneNumberController,
                                        scrollController: scrollController,
                                        context: context),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: vehicleRegNumberFocus,
                                        size: size,
                                        hint: "Vehicle Reg. no.",
                                        isMobile: isMobile,
                                        scrollController: scrollController,
                                        textcontroller:
                                            vehicleRegNumberController,
                                        context: context),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: engineNumberFocus,
                                        size: size,
                                        hint: "Engine no.",
                                        isMobile: isMobile,
                                        textcontroller: engineNumberController,
                                        scrollController: scrollController,
                                        context: context),
                                    DMSCustomWidgets.SearchableDropDown(
                                      size: size,
                                      hint: "Make",
                                      items: ["1", "2", "3", "4", "5", "6"],
                                      focus: makeFocus,
                                      textcontroller: makeController,
                                      isMobile: isMobile,
                                      scrollController: scrollController,
                                      icon: Icon(Icons.arrow_drop_down),
                                    ),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: mfgYearFocus,
                                        size: size,
                                        hint: "MFG Year",
                                        isMobile: isMobile,
                                        textcontroller: mfgYearController,
                                        scrollController: scrollController,
                                        context: context),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: financialDetailsFocus,
                                        size: size,
                                        hint: "Financial details",
                                        isMobile: isMobile,
                                        textcontroller:
                                            financialDetailsController,
                                        scrollController: scrollController,
                                        context: context),
                                    DMSCustomWidgets.CustomDataCard(
                                        focusNode: customerAddressFocus,
                                        size: size,
                                        hint: "Customer address",
                                        isMobile: isMobile,
                                        textcontroller: customerAddressController,
                                        scrollController: scrollController,
                                        context: context),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: isMobile
                                    ? size.height * 0.02
                                    : size.height * 0.05,
                              ),
                              if (MediaQuery.of(context).viewInsets.bottom == 0)
                                (state.isLoading==false)?ElevatedButton(
                                  onPressed: () {
                                    print(engineNumberController.text);
                                    Vehicle vehicle = Vehicle(
                                        chassisNumber:
                                            chassisNumberController.text,
                                        customerAddress:
                                            customerAddressController.text,
                                        customerNumber:
                                            customerNumberController.text,
                                        engineNumber: engineNumberController.text,
                                        // customerPhoneNumber:
                                        //     customerPhoneNumberController.text,
                                        kms: int.parse(kmsController.text),
                                        mfgYear:
                                            int.parse(mfgYearController.text),
                                        financialDetails:
                                            financialDetailsController.text,
                                        model: modelController.text,
                                        vehicleRegNumber:
                                            vehicleRegNumberController.text,
                                        vehicleType: vehicleTypeController.text,
                                        insuranceCompany:
                                            insuranceCompanyController.text);
                                    context
                                        .read<VehicleBloc>()
                                        .add(AddVehicleEvent(vehicle: vehicle));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4)),
                                      minimumSize: const Size(10, 36),
                                      backgroundColor: Colors.black,
                                      foregroundColor: Colors.white),
                                  child: const Text("Submit"),
                                ):CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                    
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
