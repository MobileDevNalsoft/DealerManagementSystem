import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

  TextEditingController makeTypeAheadController = TextEditingController();

  TextEditingController modelController = TextEditingController();

  TextEditingController variantController = TextEditingController();

  TextEditingController colorController = TextEditingController();

  TextEditingController kmsController = TextEditingController();

  TextEditingController mfgYearController = TextEditingController();

  TextEditingController insuranceCompanyTypeAheadController =
      TextEditingController();

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

  bool makeDropDownUp = false;
  bool insuranceCompanyDropDownUp = false;
  late MultiBloc _multiBloc;
  late VehicleBloc _vehicleBloc;
  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();
    clearFields();
    _multiBloc = context.read<MultiBloc>();
    _vehicleBloc = context.read<VehicleBloc>();
    _serviceBloc = context.read<ServiceBloc>();

    _multiBloc.state.year = null;
    yearPickerController = FixedExtentScrollController(initialItem: index);
    vehicleRegNumberFocus.addListener(_onRegNoFocusChange);
    customerContactNumberFocus.addListener(_onCustomerContactNoFocusChange);
    _vehicleBloc.state.status = VehicleStatus.initial;

    makeFocus.addListener(() {
      makeDropDownUp = !makeDropDownUp;
      _serviceBloc.add(DropDownOpen());
    });

    insuranceCompanyFocus.addListener(() {
      insuranceCompanyDropDownUp = !insuranceCompanyDropDownUp;
      _serviceBloc.add(DropDownOpen());
    });
  }

  void clearFields() {
    vehicleRegNumberController.clear();
    vehicleTypeController.clear();
    customerContactNumberController.clear();
    chassisNumberController.clear();
    engineNumberController.clear();
    customerNameController.clear();
    customerAddressController.clear();
    makeTypeAheadController.clear();
    modelController.clear();
    variantController.clear();
    colorController.clear();
    kmsController.clear();
    mfgYearController.clear();
    insuranceCompanyTypeAheadController.clear();
    financialDetailsController.clear();
  }

  @override
  void dispose() {
    yearPickerController.dispose();
    super.dispose();
  }

  void _onRegNoFocusChange() {
    if (!vehicleRegNumberFocus.hasFocus &&
        vehicleRegNumberController.text.isNotEmpty) {
      _vehicleBloc.add(VehicleCheck(
          registrationNo: vehicleRegNumberController
              .text)); // manage this api with customer check in service booking so that this api is no more required.
    }
  }

  void _onCustomerContactNoFocusChange() {
    if (!customerContactNumberFocus.hasFocus &&
        customerContactNumberController.text.isNotEmpty) {
      _vehicleBloc.add(CustomerCheck(
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

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            backgroundColor: Colors.black45,
            leadingWidth: size.width * 0.14,
            leading: Container(
              margin: EdgeInsets.only(left: size.width * 0.045),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10,
                        blurStyle: BlurStyle.outer,
                        spreadRadius: 0,
                        color: Colors.orange.shade200,
                        offset: const Offset(0, 0))
                  ]),
              child: Transform(
                transform: Matrix4.translationValues(-3, 0, 0),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white)),
              ),
            ),
            title: Container(
                alignment: Alignment.center,
                height: size.height * 0.05,
                width: size.width * 0.45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10,
                          blurStyle: BlurStyle.outer,
                          spreadRadius: 0,
                          color: Colors.orange.shade200,
                          offset: const Offset(0, 0))
                    ]),
                child: const Text(
                  textAlign: TextAlign.center,
                  'Add Vehicle',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16),
                )),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black45, Colors.black26, Colors.black45],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.5, 1]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gap(
                      size.height * 0.05,
                    ),
                    SizedBox(
                        height:
                            isMobile ? size.height * 0.62 : size.height * 0.5,
                        width: fieldWidth,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: StaggeredGrid.count(
                            crossAxisCount: isMobile ? 1 : 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 16,
                            children: [
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: vehicleRegNumberFocus,
                                  size: size,
                                  hint: "Vehicle Reg. No.",
                                  isMobile: isMobile,
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  scrollController: scrollController,
                                  textcontroller: vehicleRegNumberController,
                                  context: context),
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: chassisNumberFocus,
                                  size: size,
                                  hint: "Chassis No.",
                                  isMobile: isMobile,
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  scrollController: scrollController,
                                  textcontroller: chassisNumberController,
                                  context: context),
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: engineNumberFocus,
                                  size: size,
                                  hint: "Engine No.",
                                  inputFormatters: [UpperCaseTextFormatter()],
                                  isMobile: isMobile,
                                  textcontroller: engineNumberController,
                                  scrollController: scrollController,
                                  context: context),
                              DMSCustomWidgets.SearchableDropDown(
                                size: size,
                                hint: "Make",
                                items: [
                                  "Maruthi Suzuki",
                                  "Tata",
                                  "Mercedes",
                                  "Hyundai",
                                  "Kia",
                                  "Ford",
                                  "Toyota"
                                ],
                                focus: makeFocus,
                                typeAheadController: makeTypeAheadController,
                                isMobile: isMobile,
                                scrollController: scrollController,
                                icon: makeDropDownUp
                                    ? const Icon(Icons.arrow_drop_up)
                                    : const Icon(Icons.arrow_drop_down),
                              ),
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: modelFocus,
                                  size: size,
                                  inputFormatters: [InitCapCaseTextFormatter()],
                                  hint: "Model",
                                  isMobile: isMobile,
                                  textcontroller: modelController,
                                  scrollController: scrollController,
                                  context: context),
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: variantFocus,
                                  size: size,
                                  hint: "Variant",
                                  inputFormatters: [InitCapCaseTextFormatter()],
                                  isMobile: isMobile,
                                  textcontroller: variantController,
                                  scrollController: scrollController,
                                  context: context),
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: colorFocus,
                                  size: size,
                                  hint: "Color",
                                  inputFormatters: [UpperCaseTextFormatter()],
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
                                      yearPickerController:
                                          yearPickerController,
                                      year: state.year);
                                },
                              ),
                              DMSCustomWidgets.SearchableDropDown(
                                size: size,
                                hint: "Insurance Company",
                                items: ["abc", "xyz", "pqr"],
                                focus: insuranceCompanyFocus,
                                typeAheadController:
                                    insuranceCompanyTypeAheadController,
                                isMobile: isMobile,
                                scrollController: scrollController,
                                icon: insuranceCompanyDropDownUp
                                    ? const Icon(Icons.arrow_drop_up)
                                    : const Icon(Icons.arrow_drop_down),
                              ),
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: financialDetailsFocus,
                                  size: size,
                                  hint: "Financial details",
                                  isMobile: isMobile,
                                  textcontroller: financialDetailsController,
                                  scrollController: scrollController,
                                  context: context),
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: customerNameFocus,
                                  size: size,
                                  hint: "Customer Name",
                                  inputFormatters: [InitCapCaseTextFormatter()],
                                  isMobile: isMobile,
                                  scrollController: scrollController,
                                  textcontroller: customerNameController,
                                  context: context),
                              DMSCustomWidgets.CustomDataCard(
                                  focusNode: customerContactNumberFocus,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          signed: true),
                                  size: size,
                                  hint: "Customer Contact No.",
                                  isMobile: isMobile,
                                  textcontroller:
                                      customerContactNumberController,
                                  scrollController: scrollController,
                                  context: context),
                              StaggeredGridTile.extent(
                                crossAxisCellCount: 1,
                                mainAxisExtent: fieldHeight * 2,
                                child: DMSCustomWidgets.CustomTextFieldCard(
                                    focusNode: customerAddressFocus,
                                    size: size,
                                    hint: "Customer Address",
                                    inputFormatters: [
                                      InitCapCaseTextFormatter()
                                    ],
                                    isMobile: isMobile,
                                    scrollController: scrollController,
                                    textcontroller: customerAddressController,
                                    context: context),
                              ),
                              if (MediaQuery.viewInsetsOf(context).bottom != 0)
                                StaggeredGridTile.extent(
                                  crossAxisCellCount: 1,
                                  mainAxisExtent: fieldHeight * 3,
                                  child: const SizedBox(),
                                )
                            ],
                          ),
                        )),
                    BlocListener<VehicleBloc, VehicleState>(
                        listener: (context, state) {
                          switch (state.status) {
                            case VehicleStatus.success:
                              clearFields();
                              showRegistrationDialog(
                                  size: size,
                                  state: state,
                                  text:
                                      'Vehicle Registration is Successful.\nDo you want to book service ?',
                                  acceptText: 'book now',
                                  rejectText: 'later',
                                  onAccept: () {
                                    state.status = VehicleStatus.initial;
                                    Navigator.pop(context);
                                    Navigator.popAndPushNamed(
                                        context, '/serviceBooking');
                                  },
                                  onReject: () {
                                    state.status = VehicleStatus.initial;
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
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
                              showRegistrationDialog(
                                size: size,
                                state: state,
                                text:
                                    'Oops! This Vehicle is already registered with us.\nDo you want to book service ?',
                                acceptText: 'book now',
                                rejectText: 'later',
                                onAccept: () {
                                  state.status = VehicleStatus.initial;
                                  Navigator.pop(context);
                                  Navigator.popAndPushNamed(
                                      context, '/serviceBooking');
                                },
                                onReject: () {
                                  state.status = VehicleStatus.initial;
                                  Navigator.pop(context);
                                  vehicleRegNumberFocus.requestFocus();
                                },
                              );
                              break;
                            default:
                              break;
                          }
                        },
                        child: GestureDetector(
                          onTap: () {
                            // ignore: prefer_if_null_operators
                            String? message = _vehicleRegistrationNoValidator(
                                    vehicleRegNumberController.text) ??
                                _chassisNoValidation(
                                    chassisNumberController.text) ??
                                _engineNoValidation(
                                    engineNumberController.text) ??
                                (makeTypeAheadController.text.isEmpty
                                    ? 'make cannot be empty'
                                    : null) ??
                                (kmsController.text.isEmpty
                                    ? 'kms cannot be empty'
                                    : null) ??
                                _nameValidation(customerNameController.text) ??
                                (customerContactNumberController.text.isEmpty
                                    ? 'customer contact no. cannot be empty'
                                    : null);

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
                                  chassisNumber: chassisNumberController.text,
                                  engineNumber: engineNumberController.text,
                                  make: makeTypeAheadController.text,
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
                                      insuranceCompanyTypeAheadController.text,
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
                          child: Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: size.height * 0.03),
                              height: size.height * 0.045,
                              width: size.width * 0.2,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10,
                                        blurStyle: BlurStyle.outer,
                                        spreadRadius: 0,
                                        color: Colors.orange.shade200,
                                        offset: const Offset(0, 0))
                                  ]),
                              child: const Text(
                                textAlign: TextAlign.center,
                                'submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                        )),
                  ],
                ),
              ),
              if (context.watch<VehicleBloc>().state.status ==
                  VehicleStatus.loading)
                Container(
                  color: Colors.black54,
                  child: Center(
                      child: Lottie.asset('assets/lottie/car_loading.json',
                          height: size.height * 0.5, width: size.width * 0.6)),
                )
            ],
          )),
    );
  }

  void showRegistrationDialog(
      {required Size size,
      required VehicleState state,
      required String text,
      required String acceptText,
      required String rejectText,
      required void Function()? onAccept,
      required void Function()? onReject}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.only(top: size.height * 0.01),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Gap(size.height * 0.01),
                  Container(
                    height: size.height * 0.05,
                    margin: EdgeInsets.all(size.height * 0.001),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: onReject,
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: Text(
                              rejectText,
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          thickness: 0.5,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: onAccept,
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: Text(
                              acceptText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero);
        });
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
  RegExp chassisNoRegex = RegExp(r'^[A-Z]{2}\d{4}$');
  if (value.isEmpty) {
    return "Chassis No. can't be empty!";
  } else if (!chassisNoRegex.hasMatch(value)) {
    return "Invalid Chassis No.";
  }
  return null;
}

String? _engineNoValidation(String value) {
  RegExp engineNoRegex = RegExp(r'^[A-Z]{2}\d{4}$');
  if (value.isEmpty) {
    return "Engine No. can't be empty!";
  } else if (!engineNoRegex.hasMatch(value)) {
    return "Invalid Engine No.";
  }
  return null;
}

String? _nameValidation(String value) {
  RegExp customerNameRegex = RegExp(r'^[A-Za-z ]*$');
  if (value.isEmpty) {
    return "Customer Name can't be empty!";
  } else if (!customerNameRegex.hasMatch(value)) {
    return "Invalid Customer Name";
  }
  return null;
}
