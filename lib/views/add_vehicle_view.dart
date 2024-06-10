import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/models/customer.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/service_history_view.dart';
import 'package:flutter/material.dart';
import 'package:customs/src.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class AddVehicleView extends StatefulWidget {
  const AddVehicleView({super.key});

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  // TextEditing Controllers

  TextEditingController vehicleRegNumberController = TextEditingController();

  TextEditingController customerContactNumberController =
      TextEditingController();

  TextEditingController customerNameController = TextEditingController();

  TextEditingController customerAddressController = TextEditingController();

  TextEditingController chassisNumberController = TextEditingController();

  TextEditingController engineNumberController = TextEditingController();

  TextEditingController vehicleTypeController = TextEditingController();

  TextEditingController makeController = TextEditingController();

  TextEditingController modelController = TextEditingController();

  TextEditingController variantController = TextEditingController();

  TextEditingController colorController = TextEditingController();

  TextEditingController kmsController = TextEditingController();

  TextEditingController mfgYearController = TextEditingController();

  TextEditingController insuranceCompanyController = TextEditingController();

  TextEditingController financialDetailsController = TextEditingController();

  // Scroll Controller

  ScrollController scrollController = ScrollController();

  // FocusNodes

  FocusNode vehicleRegNumberFocus = FocusNode();

  FocusNode vehicleTypeFocus = FocusNode();

  FocusNode customerContactNumberFocus = FocusNode();

  FocusNode customerNameFocus = FocusNode();

  FocusNode customerAddressFocus = FocusNode();

  FocusNode chassisNumberFocus = FocusNode();

  FocusNode engineNumberFocus = FocusNode();

  FocusNode makeFocus = FocusNode();

  FocusNode modelFocus = FocusNode();

  FocusNode variantFocus = FocusNode();

  FocusNode colorFocus = FocusNode();

  FocusNode kmsFocus = FocusNode();

  FocusNode mfgYearFocus = FocusNode();

  FocusNode insuranceCompanyFocus = FocusNode();

  FocusNode financialDetailsFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    vehicleRegNumberFocus.addListener(_onRegNoFocusChange);
  }

  void _onRegNoFocusChange() {
    Size size = MediaQuery.of(context).size;

    context
        .read<VehicleBloc>()
        .add(VehicleCheck(registrationNo: vehicleRegNumberController.text));

    if (!vehicleRegNumberFocus.hasFocus) {
      BlocListener<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state.status! == VehicleStatus.vehicleAlreadyAdded) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => PopScope(
                canPop: false,
                child: AlertDialog(
                  contentPadding: EdgeInsets.all(8),
                  backgroundColor: Colors.white,
                  content: Container(
                    padding: EdgeInsets.only(
                        left: size.width * 0.03, top: size.height * 0.01),
                    height: size.height * 0.1,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Vehicle Already Registered'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text('Back')),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      );
    }
  }

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
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
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
                        color: const Color.fromARGB(255, 145, 19, 19),
                        iconColor: Colors.white,
                        children: [
                          // SizedBox(
                          //   height: size.height * 0.08,
                          //   width: size.width * (isMobile ? 0.24 : 0.1),
                          //   child: GestureDetector(
                          //     onTap: () {
                          //       Navigator.of(context).push(MaterialPageRoute(
                          //           builder: (_) => AddCustomerView()));
                          //     },
                          //     child: Column(
                          //       children: [
                          //         Image.asset(
                          //           'assets/images/add_user.png',
                          //           color: Colors.white,
                          //           fit: BoxFit.cover,
                          //           scale: isMobile ? 22 : 15,
                          //         ),
                          //         Text(
                          //           'Add Customer',
                          //           style: TextStyle(
                          //               color: Colors.white,
                          //               fontSize: isMobile ? 11 : 14),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
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
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
              title: const Text(
                "Add Vehicle",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
            ),
            body: Container(
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
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          SizedBox(
                            height: isMobile
                                ? MediaQuery.of(context).viewInsets.bottom == 0
                                    ? size.height * 0.62
                                    : size.height * 0.5
                                : MediaQuery.of(context).viewInsets.bottom == 0
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
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: vehicleRegNumberFocus,
                                    size: size,
                                    hint: "Vehicle Reg. No.",
                                    isMobile: isMobile,
                                    scrollController: scrollController,
                                    textcontroller: vehicleRegNumberController,
                                    context: context),
                                DMSCustomWidgets.SearchableDropDown(
                                  size: size,
                                  hint: "Vehicle type",
                                  items: ["sedan", "SUV", "XUV"],
                                  focus: vehicleTypeFocus,
                                  textcontroller: vehicleTypeController,
                                  isMobile: isMobile,
                                  onChange: (p0) {
                                    print(p0);
                                  },
                                  scrollController: scrollController,
                                  icon: const Icon(Icons.arrow_drop_down),
                                ),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: customerContactNumberFocus,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            signed: true),
                                    size: size,
                                    onChange: (p0) {
                                      if (p0!.length > 7) {
                                        context.read<CustomerBloc>().add(
                                            CustomerIdOnChangeEvent(
                                                customerPhoneNumber: p0));
                                      }
                                    },
                                    suffixIcon: BlocConsumer<CustomerBloc,
                                        CustomerState>(
                                      listener: (context, state) {
                                        //showing error snackbar if no customer found

                                        // if (state.status ==
                                        //     CustomerStatus.failure) {
                                        //   Flushbar(
                                        //     backgroundColor: Colors.red,
                                        //     message:
                                        //         "Customer not found.\nPlease add customer",
                                        //     flushbarPosition:
                                        //         FlushbarPosition.TOP,
                                        //     duration: Duration(seconds: 2),
                                        //     borderRadius:
                                        //         BorderRadius.circular(12),
                                        //     margin: EdgeInsets.only(
                                        //         top: 24,
                                        //         left: isMobile
                                        //             ? 10
                                        //             : size.width * 0.8,
                                        //         right: 10),
                                        //   ).show(context);
                                        // }
                                        // else
                                        if (state.status ==
                                            CustomerStatus.success) {
                                          // customerNumberController.text =
                                          //     state.customer!.customerId ?? "";
                                          customerAddressController.text =
                                              state.customer!.customerAddress ??
                                                  "";
                                        }
                                      },
                                      builder: (context, state) {
                                        switch (state.status) {
                                          case CustomerStatus.loading:
                                            return Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        0, 16, 0),
                                                child:
                                                    const CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                ));

                                          //error lottie for no customer

                                          // case CustomerStatus.failure:
                                          //   return Transform(
                                          //       transform:
                                          //           Matrix4.translationValues(
                                          //               0, 16, 0),
                                          //       child: Lottie.asset(
                                          //           "assets/lottie/error.json"));
                                          case CustomerStatus.success:
                                            return Transform(
                                                transform:
                                                    Matrix4.translationValues(
                                                        0, 16, 0),
                                                child: Lottie.asset(
                                                    "assets/lottie/success.json",
                                                    repeat: false));
                                          default:
                                            return SizedBox();
                                        }
                                      },
                                    ),
                                    hint: "Customer Contact No.",
                                    isMobile: isMobile,
                                    textcontroller:
                                        customerContactNumberController,
                                    scrollController: scrollController,
                                    context: context),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: customerNameFocus,
                                    size: size,
                                    hint: "Customer Name",
                                    isMobile: isMobile,
                                    scrollController: scrollController,
                                    textcontroller: customerNameController,
                                    context: context),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: customerAddressFocus,
                                    size: size,
                                    hint: "Customer Address",
                                    isMobile: isMobile,
                                    scrollController: scrollController,
                                    textcontroller: customerAddressController,
                                    context: context),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: chassisNumberFocus,
                                    size: size,
                                    hint: "Chassis no.",
                                    isMobile: isMobile,
                                    scrollController: scrollController,
                                    textcontroller: chassisNumberController,
                                    context: context),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: engineNumberFocus,
                                    size: size,
                                    hint: "Engine No.",
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
                                    focusNode: modelFocus,
                                    size: size,
                                    hint: "Model",
                                    isMobile: isMobile,
                                    textcontroller: modelController,
                                    scrollController: scrollController,
                                    context: context),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: variantFocus,
                                    size: size,
                                    hint: "Variant",
                                    isMobile: isMobile,
                                    textcontroller: variantController,
                                    scrollController: scrollController,
                                    context: context),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: colorFocus,
                                    size: size,
                                    hint: "Color",
                                    isMobile: isMobile,
                                    textcontroller: colorController,
                                    scrollController: scrollController,
                                    context: context),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: kmsFocus,
                                    size: size,
                                    hint: "KMS",
                                    isMobile: isMobile,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textcontroller: kmsController,
                                    scrollController: scrollController,
                                    context: context),
                                DMSCustomWidgets.CustomDataCard(
                                    focusNode: mfgYearFocus,
                                    size: size,
                                    hint: "MFG Year",
                                    isMobile: isMobile,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    textcontroller: mfgYearController,
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
                                    focusNode: financialDetailsFocus,
                                    size: size,
                                    hint: "Financial details",
                                    isMobile: isMobile,
                                    textcontroller: financialDetailsController,
                                    scrollController: scrollController,
                                    context: context)
                              ],
                            ),
                          ),
                          SizedBox(
                            height: isMobile
                                ? size.height * 0.02
                                : size.height * 0.05,
                          ),
                          BlocConsumer<VehicleBloc, VehicleState>(
                              listener: (context, state) {
                            switch (state.status) {
                              case VehicleStatus.success:
                                Flushbar(
                                  flushbarPosition: FlushbarPosition.TOP,
                                  backgroundColor: Colors.green,
                                  message: "Vehicle Added Successfully",
                                ).show(context);
                                break;
                              case VehicleStatus.failure:
                                Flushbar(
                                  flushbarPosition: FlushbarPosition.TOP,
                                  backgroundColor: Colors.red,
                                  message: "Some Error has occured",
                                ).show(context);
                                break;
                              default:
                                break;
                            }
                          }, builder: (context, state) {
                            switch (state.status) {
                              case VehicleStatus.success ||
                                    VehicleStatus.initial:
                                return ElevatedButton(
                                  onPressed: () {
                                    if (vehicleRegNumberController
                                        .text.isEmpty) {
                                      Flushbar(
                                        backgroundColor: Colors.red,
                                        blockBackgroundInteraction: true,
                                        message:
                                            "Vehicle Registration number cannot be empty",
                                        flushbarPosition: FlushbarPosition.TOP,
                                        duration: Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10),
                                      ).show(context);
                                      return;
                                    }
                                    if (chassisNumberController.text.isEmpty) {
                                      Flushbar(
                                        backgroundColor: Colors.red,
                                        message:
                                            "Chassis number cannot be empty",
                                        flushbarPosition: FlushbarPosition.TOP,
                                        duration: Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10),
                                      ).show(context);
                                      return;
                                    }
                                    if (customerContactNumberController
                                        .text.isEmpty) {
                                      Flushbar(
                                        backgroundColor: Colors.red,
                                        message:
                                            "Customer number cannot be empty",
                                        flushbarPosition: FlushbarPosition.TOP,
                                        duration: Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10),
                                      ).show(context);
                                      return;
                                    }
                                    if (vehicleTypeController.text.isEmpty) {
                                      print(
                                          " vehicle type${vehicleTypeController.text}");
                                      Flushbar(
                                        backgroundColor: Colors.red,
                                        message: "Vehicle type cannot be empty",
                                        flushbarPosition: FlushbarPosition.TOP,
                                        duration: Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10),
                                      ).show(context);
                                      return;
                                    }
                                    // if (kmsController.text.isEmpty) {
                                    //   Flushbar(
                                    //     backgroundColor: Colors.red,
                                    //     message: "KMS number cannot be empty",
                                    //     flushbarPosition: FlushbarPosition.TOP,
                                    //     duration: Duration(seconds: 2),
                                    //     borderRadius: BorderRadius.circular(12),
                                    //     margin: EdgeInsets.only(
                                    //         top: 24,
                                    //         left:
                                    //             isMobile ? 10 : size.width * 0.8,
                                    //         right: 10),
                                    //   ).show(context);
                                    //   return;
                                    // }
                                    // if (insuranceCompanyController
                                    //     .text.isEmpty) {
                                    //   Flushbar(
                                    //     backgroundColor: Colors.red,
                                    //     message:
                                    //         "insurance company cannot be empty",
                                    //     flushbarPosition: FlushbarPosition.TOP,
                                    //     duration: Duration(seconds: 2),
                                    //     borderRadius: BorderRadius.circular(12),
                                    //     margin: EdgeInsets.only(
                                    //         top: 24,
                                    //         left: isMobile
                                    //             ? 10
                                    //             : size.width * 0.8,
                                    //         right: 10),
                                    //   ).show(context);
                                    //   return;
                                    // }
                                    if (engineNumberController.text.isEmpty) {
                                      Flushbar(
                                        backgroundColor: Colors.red,
                                        message:
                                            "Engine number cannot be empty",
                                        flushbarPosition: FlushbarPosition.TOP,
                                        duration: Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10),
                                      ).show(context);
                                      return;
                                    }
                                    if (mfgYearController.text.isEmpty) {
                                      Flushbar(
                                        backgroundColor: Colors.red,
                                        message:
                                            "Manufactured year cannot be empty",
                                        flushbarPosition: FlushbarPosition.TOP,
                                        duration: Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10),
                                      ).show(context);
                                      return;
                                    }
                                    Vehicle vehicle = Vehicle(
                                        vehicleRegNumber:
                                            vehicleRegNumberController.text,
                                        vehicleType: vehicleTypeController.text,
                                        chassisNumber:
                                            chassisNumberController.text,
                                        engineNumber:
                                            engineNumberController.text,
                                        mfgYear:
                                            int.parse(mfgYearController.text),
                                        kms: int.parse(kmsController.text),
                                        financialDetails:
                                            financialDetailsController.text,
                                        model: modelController.text,
                                        insuranceCompany:
                                            insuranceCompanyController.text,
                                        customerContactNo: int.parse(
                                            customerContactNumberController
                                                .text),
                                        customerName:
                                            customerNameController.text,
                                        customerAddress:
                                            customerAddressController.text);
                                    context
                                        .read<VehicleBloc>()
                                        .add(AddVehicleEvent(vehicle: vehicle));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      minimumSize: const Size(10, 36),
                                      backgroundColor: const Color.fromARGB(
                                          255, 145, 19, 19),
                                      foregroundColor: Colors.white),
                                  child: const Text("Submit"),
                                );
                              case VehicleStatus.loading:
                                return CircularProgressIndicator();
                              default:
                                return SizedBox();
                            }
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
