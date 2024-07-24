import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/customer/customer_bloc.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/service_history.dart';
import 'package:flutter/material.dart';
import 'package:customs/src.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
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

  // year picker controller

  late FixedExtentScrollController yearPickerController;

  int index = 0;

  @override
  void initState() {
    super.initState();
    yearPickerController = FixedExtentScrollController(initialItem: index);
    vehicleRegNumberFocus.addListener(_onRegNoFocusChange);
    customerContactNumberFocus.addListener(_onCustomerContactNoFocusChange);
  }

  @override
  void dispose() {
    yearPickerController.dispose();
    super.dispose();
  }

  void _onRegNoFocusChange() {
    if (!vehicleRegNumberFocus.hasFocus &&
        vehicleRegNumberController.text.isNotEmpty) {
      context
          .read<VehicleBloc>()
          .add(VehicleCheck(registrationNo: vehicleRegNumberController.text));
    }
  }

  void _onCustomerContactNoFocusChange() {
    if (!customerContactNumberFocus.hasFocus &&
        customerContactNumberController.text.isNotEmpty) {
      context.read<VehicleBloc>().add(CustomerCheck(
          customerContactNo: customerContactNumberController.text));
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
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: const Color.fromARGB(255, 145, 19, 19),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
              title: const Text(
                "Add Vehicle",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              centerTitle: true,
            ),
            body: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 241, 193, 193),
                      Color.fromARGB(255, 235, 136, 136),
                      Color.fromARGB(255, 226, 174, 174)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.01, 0.35, 1]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(
                    size.height * 0.05,
                  ),
                  SizedBox(
                    height: isMobile ? size.height * 0.62 : size.height * 0.5,
                    width: fieldWidth,
                    child: GridView(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom == 0
                              ? 0
                              : size.height * 0.2),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                        // DMSCustomWidgets.SearchableDropDown(
                        //   size: size,
                        //   hint: "Vehicle type",
                        //   items: ["sedan", "SUV", "XUV"],
                        //   focus: vehicleTypeFocus,
                        //   textcontroller: vehicleTypeController,
                        //   isMobile: isMobile,
                        //   scrollController: scrollController,
                        //   icon: const Icon(Icons.arrow_drop_down),
                        // ),
                        DMSCustomWidgets.CustomDataCard(
                            focusNode: customerContactNumberFocus,
                            keyboardType: const TextInputType.numberWithOptions(
                                signed: true),
                            size: size,
                            // onChange: (p0) {
                            //   if (p0!.length > 7) {
                            //     context.read<CustomerBloc>().add(
                            //         CustomerIdOnChangeEvent(
                            //             customerPhoneNumber: p0));
                            //   }
                            // },
                            suffixIcon:
                                BlocConsumer<CustomerBloc, CustomerState>(
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
                                if (state.status == CustomerStatus.success) {
                                  // customerNumberController.text =
                                  //     state.customer!.customerId ?? "";
                                  customerAddressController.text =
                                      state.customer!.customerAddress ?? "";
                                }
                              },
                              builder: (context, state) {
                                switch (state.status) {
                                  case CustomerStatus.loading:
                                    return Transform(
                                        transform:
                                            Matrix4.translationValues(0, 16, 0),
                                        child: const CircularProgressIndicator(
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
                                            Matrix4.translationValues(0, 16, 0),
                                        child: Lottie.asset(
                                            "assets/lottie/success.json",
                                            repeat: false));
                                  default:
                                    return const SizedBox();
                                }
                              },
                            ),
                            hint: "Customer Contact No.",
                            isMobile: isMobile,
                            textcontroller: customerContactNumberController,
                            scrollController: scrollController,
                            context: context),
                        DMSCustomWidgets.CustomDataCard(
                            focusNode: chassisNumberFocus,
                            size: size,
                            hint: "Chassis No.",
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
                        BlocConsumer<VehicleBloc, VehicleState>(
                          listener: (context, state) {
                            if (state.status == VehicleStatus.customerExists) {
                              customerNameController.text =
                                  state.vehicle!.customerName!;
                            }
                          },
                          builder: (context, state) {
                            return DMSCustomWidgets.CustomDataCard(
                                focusNode: customerNameFocus,
                                size: size,
                                hint: "Customer Name",
                                isMobile: isMobile,
                                scrollController: scrollController,
                                textcontroller: customerNameController,
                                context: context);
                          },
                        ),
                        BlocConsumer<VehicleBloc, VehicleState>(
                          listener: (context, state) {
                            if (state.status == VehicleStatus.customerExists) {
                              customerAddressController.text =
                                  state.vehicle!.customerAddress!;
                            }
                          },
                          builder: (context, state) {
                            return DMSCustomWidgets.CustomDataCard(
                                focusNode: customerAddressFocus,
                                size: size,
                                hint: "Customer Address",
                                isMobile: isMobile,
                                scrollController: scrollController,
                                textcontroller: customerAddressController,
                                context: context);
                          },
                        ),
                        // DMSCustomWidgets.SearchableDropDown(
                        //   size: size,
                        //   hint: "Make",
                        //   items: ["1", "2", "3", "4", "5", "6"],
                        //   focus: makeFocus,
                        //   textcontroller: makeController,
                        //   isMobile: isMobile,
                        //   scrollController: scrollController,
                        //   icon: const Icon(Icons.arrow_drop_down),
                        // ),
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
                        BlocBuilder<MultiBloc, MultiBlocState>(
                          builder: (context, state) {
                            return DMSCustomWidgets.CustomYearPicker(
                                size: size,
                                isMobile: isMobile,
                                context: context,
                                yearPickerController: yearPickerController,
                                year: state.year);
                          },
                        ),
                        // DMSCustomWidgets.SearchableDropDown(
                        //   size: size,
                        //   hint: "Insurance Company",
                        //   items: ["abc", "xyz", "pqr"],
                        //   focus: insuranceCompanyFocus,
                        //   textcontroller: insuranceCompanyController,
                        //   isMobile: isMobile,
                        //   scrollController: scrollController,
                        //   icon: const Icon(Icons.arrow_drop_down),
                        // ),
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
                    height: isMobile ? size.height * 0.02 : size.height * 0.05,
                  ),
                  BlocConsumer<VehicleBloc, VehicleState>(
                      listener: (context, state) {
                    switch (state.status) {
                      case VehicleStatus.success:
                        vehicleRegNumberController.clear();
                        vehicleTypeController.clear();
                        customerContactNumberController.clear();
                        chassisNumberController.clear();
                        engineNumberController.clear();
                        customerNameController.clear();
                        customerAddressController.clear();
                        makeController.clear();
                        modelController.clear();
                        variantController.clear();
                        colorController.clear();
                        kmsController.clear();
                        mfgYearController.clear();
                        insuranceCompanyController.clear();
                        financialDetailsController.clear();
                        Flushbar(
                          backgroundColor: Colors.green,
                          blockBackgroundInteraction: true,
                          message: "Vehicle Added Successfully",
                          flushbarPosition: FlushbarPosition.TOP,
                          duration: const Duration(seconds: 2),
                          borderRadius: BorderRadius.circular(12),
                          margin: EdgeInsets.only(
                              top: 24,
                              left: isMobile ? 10 : size.width * 0.8,
                              right: 10),
                        ).show(context);
                        break;
                      case VehicleStatus.failure:
                        Flushbar(
                          backgroundColor: Colors.red,
                          blockBackgroundInteraction: true,
                          message: "Some Error has occured",
                          flushbarPosition: FlushbarPosition.TOP,
                          duration: const Duration(seconds: 2),
                          borderRadius: BorderRadius.circular(12),
                          margin: EdgeInsets.only(
                              top: 24,
                              left: isMobile ? 10 : size.width * 0.8,
                              right: 10),
                        ).show(context);
                      case VehicleStatus.vehicleAlreadyAdded:
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => PopScope(
                            canPop: false,
                            child: AlertDialog(
                              contentPadding: const EdgeInsets.all(8),
                              buttonPadding: EdgeInsets.zero,
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    style: TextButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(
                                            255, 145, 19, 19)),
                                    child: const Text('Exit')),
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      vehicleRegNumberFocus.requestFocus();
                                    },
                                    style: TextButton.styleFrom(
                                        foregroundColor: const Color.fromARGB(
                                            255, 145, 19, 19)),
                                    child: const Text('Retry')),
                              ],
                              actionsPadding: EdgeInsets.zero,
                              backgroundColor: Colors.white,
                              content: Container(
                                padding: EdgeInsets.only(
                                    left: size.width * 0.03,
                                    top: size.height * 0.01),
                                height: size.height * 0.05,
                                width: size.width * 0.8,
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: const Text('Vehicle Already Registered'),
                              ),
                            ),
                          ),
                        );
                        break;
                      default:
                        break;
                    }
                  }, builder: (context, state) {
                    switch (state.status) {
                      case VehicleStatus.success || VehicleStatus.initial:
                        return ElevatedButton(
                          onPressed: () {
                            // ignore: prefer_if_null_operators
                            String? message = _vehicleRegistrationNoValidator(
                                        vehicleRegNumberController.text) !=
                                    null
                                ? _vehicleRegistrationNoValidator(
                                    vehicleRegNumberController.text)
                                : vehicleTypeController.text.isEmpty
                                    ? "Vehicle Type cannot be empty"
                                    // ignore: prefer_if_null_operators
                                    : _customerContactNoValidation(
                                                customerContactNumberController
                                                    .text) !=
                                            null
                                        ? _customerContactNoValidation(
                                            customerContactNumberController
                                                .text)
                                        // ignore: prefer_if_null_operators
                                        : _chassisNoValidation(customerNameController.text) !=
                                                null
                                            ? _chassisNoValidation(
                                                customerNameController.text)
                                            // ignore: prefer_if_null_operators
                                            : _engineNoValidation(engineNumberController.text) !=
                                                    null
                                                ? _engineNoValidation(
                                                    engineNumberController.text)
                                                // ignore: prefer_if_null_operators
                                                : _nameValidation(customerNameController.text) !=
                                                        null
                                                    ? _nameValidation(
                                                        customerNameController.text)
                                                    : customerAddressController.text.isEmpty
                                                        ? "Customer Address cannot be empty"
                                                        : makeController.text.isEmpty
                                                            ? "Make cannot be empty"
                                                            : modelController.text.isEmpty
                                                                ? "Model cannot be empty"
                                                                : variantController.text.isEmpty
                                                                    ? "Variant cannot be empty"
                                                                    : colorController.text.isEmpty
                                                                        ? "Color cannot be empty"
                                                                        : kmsController.text.isEmpty
                                                                            ? "KMS cannot be empty"
                                                                            : mfgYearController.text.isEmpty
                                                                                ? "Mfg Year cannot be empty"
                                                                                : insuranceCompanyController.text.isEmpty
                                                                                    ? "Insurance Company cannot be empty"
                                                                                    : financialDetailsController.text.isEmpty
                                                                                        ? "Finacial Details cannot be empty"
                                                                                        : null;
                            if (message != null) {
                              Flushbar(
                                backgroundColor: Colors.red,
                                blockBackgroundInteraction: true,
                                message: message,
                                flushbarPosition: FlushbarPosition.TOP,
                                duration: const Duration(seconds: 2),
                                borderRadius: BorderRadius.circular(12),
                                margin: EdgeInsets.only(
                                    top: 10,
                                    left: isMobile ? 10 : size.width * 0.8,
                                    right: 10),
                              ).show(context);
                            } else {
                              Vehicle vehicle = Vehicle(
                                  vehicleRegNumber:
                                      vehicleRegNumberController.text,
                                  vehicleType: vehicleTypeController.text,
                                  chassisNumber: chassisNumberController.text,
                                  engineNumber: engineNumberController.text,
                                  make: makeController.text,
                                  varient: variantController.text,
                                  color: colorController.text,
                                  mfgYear: mfgYearController.text.isNotEmpty
                                      ? int.parse(mfgYearController.text)
                                      : 0,
                                  kms: kmsController.text.isNotEmpty
                                      ? int.parse(kmsController.text)
                                      : 0,
                                  financialDetails:
                                      financialDetailsController.text,
                                  model: modelController.text,
                                  insuranceCompany:
                                      insuranceCompanyController.text,
                                  customerContactNo:
                                      customerContactNumberController.text,
                                  customerName: customerNameController.text,
                                  customerAddress:
                                      customerAddressController.text);
                              context
                                  .read<VehicleBloc>()
                                  .add(AddVehicleEvent(vehicle: vehicle));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              minimumSize: const Size(10, 36),
                              backgroundColor:
                                  const Color.fromARGB(255, 145, 19, 19),
                              foregroundColor: Colors.white),
                          child: const Text("Submit"),
                        );
                      case VehicleStatus.loading:
                        return const CircularProgressIndicator();
                      default:
                        return const SizedBox();
                    }
                  }),
                ],
              ),
            )),
      ),
    );
  }
}

String? _vehicleRegistrationNoValidator(String value) {
  if (value.isEmpty) {
    return "Vehicle Registration No. can't be empty!";
  } else if (value.length < 10) {
    return "Vehicle Registration No. should contain 10 characters";
  }
  return null;
}

String? _customerContactNoValidation(String value) {
  RegExp contactNoRegex = RegExp(r'^\d{10}$');
  if (value.isEmpty) {
    return "Contact Number can't be empty!";
  } else if (!contactNoRegex.hasMatch(value)) {
    return "Invalid Contact Number";
  }
  return null;
}

String? _chassisNoValidation(String value) {
  RegExp chassisNoRegex = RegExp(r'^[A-Za-z]{2}\d{4}$');
  if (value.isEmpty) {
    return "Chassis No. can't be empty!";
  } else if (!chassisNoRegex.hasMatch(value)) {
    return "Invalid Chassis No.";
  }
  return null;
}

String? _engineNoValidation(String value) {
  RegExp engineNoRegex = RegExp(r'^[A-Za-z]{2}\d{4}$');
  if (value.isEmpty) {
    return "Chassis No. can't be empty!";
  } else if (!engineNoRegex.hasMatch(value)) {
    return "Invalid Chassis No.";
  }
  return null;
}

String? _nameValidation(String value) {
  RegExp customerNameRegex = RegExp(r'^[A-Za-z]*$');
  if (value.isEmpty) {
    return "Customer Name can't be empty!";
  } else if (!customerNameRegex.hasMatch(value)) {
    return "Invalid Customer Name";
  }
  return null;
}
