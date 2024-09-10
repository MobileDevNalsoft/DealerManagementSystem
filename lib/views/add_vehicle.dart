import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';

class AddVehicle extends StatefulWidget {
  const AddVehicle({super.key});

  @override
  State<AddVehicle> createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> with ConnectivityMixin {
  // TextEditing Controllers

  TextEditingController locTypeAheadController = TextEditingController();

  TextEditingController vehicleRegNumberController = TextEditingController();

  TextEditingController customerContactNumberController = TextEditingController();

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

  TextEditingController insuranceCompanyTypeAheadController = TextEditingController();

  TextEditingController financialDetailsController = TextEditingController();

  // Scroll Controller

  ScrollController scrollController = ScrollController();

  // FocusNodes

  FocusNode locFocus = FocusNode();

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

  // misc variables
  int index = 0;

  // drop down dynamic icon variables
  bool dropDownUp = false;
  bool makeDropDownUp = false;
  bool insuranceCompanyDropDownUp = false;
  late Size size;

  // bloc variables
  late MultiBloc _multiBloc;
  late VehicleBloc _vehicleBloc;
  late ServiceBloc _serviceBloc;

  // navigator service
  NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();
    // Get references to Blocs using context.read
    _multiBloc = context.read<MultiBloc>();
    _vehicleBloc = context.read<VehicleBloc>();
    _serviceBloc = context.read<ServiceBloc>();

    // Fetching locations if not already fetched.
    if (_serviceBloc.state.locations == null) {
      _serviceBloc.add(GetSBRequirements());
    }

    _multiBloc.state.year = DateTime.now().year;
    mfgYearController.text = DateTime.now().year.toString();

    // If vehicle registration number exists in VehicleBloc state, set it in the text field controller
    if (_vehicleBloc.state.registrationNo != null) {
      vehicleRegNumberController.text = _vehicleBloc.state.registrationNo!;
    }
    vehicleRegNumberFocus.addListener(_onRegNoFocusChange);
    _vehicleBloc.state.status = VehicleStatus.initial;

    locFocus.addListener(() {
      dropDownUp = !dropDownUp;
      _serviceBloc.add(DropDownOpen());
    });

    makeFocus.addListener(() {
      makeDropDownUp = !makeDropDownUp;
      _serviceBloc.add(DropDownOpen());
    });

    insuranceCompanyFocus.addListener(() {
      insuranceCompanyDropDownUp = !insuranceCompanyDropDownUp;
      _serviceBloc.add(DropDownOpen());
    });
  }

  void _onRegNoFocusChange() {
    // Check internet connectivity
    if (isConnected()) {
      // If focus is lost and vehicle reg no. text field is not empty, customer name text field is empty, trigger vehicle check with Bloc
      if (!vehicleRegNumberFocus.hasFocus && vehicleRegNumberController.text.isNotEmpty && customerNameController.text.isEmpty) {
        _vehicleBloc.state.status = VehicleStatus.initial;
        _vehicleBloc.add(VehicleCheck(
            registrationNo: vehicleRegNumberController.text)); // manage this api with customer check in service booking so that this api is no more required.
      }
    } else {
      // Show an error message if offline
      DMSCustomWidgets.DMSFlushbar(size, context,
          message: 'Looks like you'
              're offline. Please check your connection and try again.',
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ));
    }
  }

  // this method can be used to clear all the textfield at once
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

  // this method is used to dispose all the controllers and focus nodes at once
  void disposeFields() {
    vehicleRegNumberController.dispose();
    vehicleTypeController.dispose();
    customerContactNumberController.dispose();
    chassisNumberController.dispose();
    engineNumberController.dispose();
    customerNameController.dispose();
    customerAddressController.dispose();
    makeTypeAheadController.dispose();
    modelController.dispose();
    variantController.dispose();
    colorController.dispose();
    kmsController.dispose();
    mfgYearController.dispose();
    insuranceCompanyTypeAheadController.dispose();
    financialDetailsController.dispose();
    vehicleRegNumberFocus.dispose();
    vehicleTypeFocus.dispose();
    customerContactNumberFocus.dispose();
    customerNameFocus.dispose();
    customerAddressFocus.dispose();
    chassisNumberFocus.dispose();
    engineNumberFocus.dispose();
    makeFocus.dispose();
    modelFocus.dispose();
    variantFocus.dispose();
    colorFocus.dispose();
    kmsFocus.dispose();
    mfgYearFocus.dispose();
    insuranceCompanyFocus.dispose();
    financialDetailsFocus.dispose();
  }

  @override
  void dispose() {
    _vehicleBloc.state.registrationNo = null;
    disposeFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // It guarantees that an instance of WidgetsBinding exists, which is crucial for the Flutter framework to function correctly.
    WidgetsFlutterBinding.ensureInitialized();

    // dynamic size according the device dimensions.
    size = MediaQuery.of(context).size;
    bool isMobile = size.width < 650;

    return GestureDetector(
      onTap: () {
        // unfocuses all the widgets that are in focus.
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Hero(
        tag: 'addVehicle',
        child: Scaffold(
            // restricts resizing of widget when keyboard is visible.
            resizeToAvoidBottomInset: false,
            // restricts extension of the scaffold body behind the appbar
            extendBodyBehindAppBar: false,
            appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Add Vehicle'),
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
                    mainAxisSize: MainAxisSize.min, // Ensures children are packed tightly
                    children: [
                      Gap(
                        size.height * 0.05,
                      ),
                      Expanded(
                        flex: 9,
                        child: SizedBox(
                            width: size.width * (isMobile ? 0.8 : 0.6),
                            child: SingleChildScrollView(
                              controller: scrollController, // Allows scrolling if the form content exceeds the available height.
                              child: StaggeredGrid.count(
                                // staggered grid allows developer to give different field heights to the children.
                                // Creates a grid layout for form fields, adapting to different screen sizes.
                                crossAxisCount: 1,
                                mainAxisSpacing: 8,
                                crossAxisSpacing: 16,
                                children: [
                                  // List of form fields using custom widgets.
                                  BlocBuilder<ServiceBloc, ServiceState>(
                                    builder: (context, state) {
                                      return DMSCustomWidgets.SearchableDropDown(
                                          size: size,
                                          hint: '*Location',
                                          items: state.getSBRequirementsStatus == GetSBRequirementsStatus.success ? state.locations! : [],
                                          icon: dropDownUp
                                              ? Icon(
                                                  Icons.arrow_drop_up,
                                                  size: size.height * 0.03,
                                                )
                                              : Icon(Icons.arrow_drop_down, size: size.height * 0.03),
                                          focus: locFocus,
                                          typeAheadController: locTypeAheadController,
                                          scrollController: scrollController,
                                          isMobile: isMobile);
                                    },
                                  ),
                                  DMSCustomWidgets.CustomDataCard(
                                      focusNode: vehicleRegNumberFocus,
                                      size: size,
                                      hint: "*Vehicle Reg. No.",
                                      isMobile: isMobile,
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      scrollController: scrollController,
                                      textcontroller: vehicleRegNumberController,
                                      context: context),
                                  DMSCustomWidgets.CustomDataCard(
                                      focusNode: chassisNumberFocus,
                                      size: size,
                                      hint: "*Chassis No.",
                                      isMobile: isMobile,
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      scrollController: scrollController,
                                      textcontroller: chassisNumberController,
                                      context: context),
                                  DMSCustomWidgets.CustomDataCard(
                                      focusNode: engineNumberFocus,
                                      size: size,
                                      hint: "*Engine No.",
                                      inputFormatters: [UpperCaseTextFormatter()],
                                      isMobile: isMobile,
                                      textcontroller: engineNumberController,
                                      scrollController: scrollController,
                                      context: context),
                                  DMSCustomWidgets.SearchableDropDown(
                                    size: size,
                                    hint: "*Make",
                                    items: ["Maruthi Suzuki", "Tata", "Mercedes", "Hyundai", "Kia", "Ford", "Toyota"],
                                    focus: makeFocus,
                                    typeAheadController: makeTypeAheadController,
                                    isMobile: isMobile,
                                    scrollController: scrollController,
                                    icon: makeDropDownUp
                                        ? Icon(
                                            Icons.arrow_drop_up,
                                            size: size.height * (0.03),
                                          )
                                        : Icon(Icons.arrow_drop_down, size: size.height * (0.03)),
                                  ),
                                  DMSCustomWidgets.CustomDataCard(
                                      focusNode: modelFocus,
                                      size: size,
                                      inputFormatters: [
                                        InitCapCaseTextFormatter() // forces the text entered in the text field to be init cap case
                                      ],
                                      hint: "*Model",
                                      isMobile: isMobile,
                                      textcontroller: modelController,
                                      scrollController: scrollController,
                                      context: context),
                                  DMSCustomWidgets.CustomDataCard(
                                      focusNode: variantFocus,
                                      size: size,
                                      hint: "Variant",
                                      inputFormatters: [
                                        InitCapCaseTextFormatter() // forces the text entered in the text field to be init cap case
                                      ],
                                      isMobile: isMobile,
                                      textcontroller: variantController,
                                      scrollController: scrollController,
                                      context: context),
                                  DMSCustomWidgets.CustomDataCard(
                                      focusNode: colorFocus,
                                      size: size,
                                      hint: "Color",
                                      inputFormatters: [
                                        UpperCaseTextFormatter() // forces the text entered in the text field to be upper case,
                                      ],
                                      isMobile: isMobile,
                                      textcontroller: colorController,
                                      scrollController: scrollController,
                                      context: context),
                                  DMSCustomWidgets.CustomDataCard(
                                      focusNode: kmsFocus,
                                      size: size,
                                      hint: "*KMS",
                                      isMobile: isMobile,
                                      keyboardType: TextInputType.number, // opens only num keypad
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly, // allows only numbers entry in to the text field
                                      ],
                                      textcontroller: kmsController,
                                      scrollController: scrollController,
                                      context: context),
                                  BlocBuilder<MultiBloc, MultiBlocState>(
                                    builder: (context, state) {
                                      return DMSCustomWidgets.CustomYearPicker(
                                          size: size, isMobile: isMobile, context: context, mfgYearController: mfgYearController, year: state.year);
                                    },
                                  ),
                                  DMSCustomWidgets.SearchableDropDown(
                                    size: size,
                                    hint: "Insurance Company",
                                    items: ["abc", "xyz", "pqr"],
                                    focus: insuranceCompanyFocus,
                                    typeAheadController: insuranceCompanyTypeAheadController,
                                    isMobile: isMobile,
                                    scrollController: scrollController,
                                    icon: insuranceCompanyDropDownUp
                                        ? Icon(Icons.arrow_drop_up, size: size.height * (0.03))
                                        : Icon(Icons.arrow_drop_down, size: size.height * (0.03)),
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
                                      hint: "*Customer Name",
                                      inputFormatters: [
                                        InitCapCaseTextFormatter() // forces the text entered in the text field to be init cap case
                                      ],
                                      isMobile: isMobile,
                                      scrollController: scrollController,
                                      textcontroller: customerNameController,
                                      context: context),
                                  DMSCustomWidgets.CustomDataCard(
                                      focusNode: customerContactNumberFocus,
                                      keyboardType: const TextInputType.numberWithOptions(signed: true),
                                      size: size,
                                      hint: "*Customer Contact No.",
                                      isMobile: isMobile,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly, // allows only numbers entry in to the text field
                                        LengthLimitingTextInputFormatter(10) // restricts the text field content length to 10
                                      ],
                                      textcontroller: customerContactNumberController,
                                      scrollController: scrollController,
                                      context: context),
                                  StaggeredGridTile.extent(
                                    crossAxisCellCount: 1,
                                    mainAxisExtent: size.height * (isMobile ? 0.06 : 0.06) * 2,
                                    child: DMSCustomWidgets.CustomTextFieldCard(
                                        focusNode: customerAddressFocus,
                                        size: size,
                                        hint: "*Customer Address",
                                        inputFormatters: [
                                          InitCapCaseTextFormatter() // forces the text entered in the text field to be init cap case
                                        ],
                                        isMobile: isMobile,
                                        scrollController: scrollController,
                                        textcontroller: customerAddressController,
                                        context: context),
                                  ),
                                  // adds sized box if key board is opened to scroll text fields to a visible position
                                  if (MediaQuery.viewInsetsOf(context).bottom != 0)
                                    StaggeredGridTile.extent(
                                      crossAxisCellCount: 1,
                                      mainAxisExtent: size.height * (isMobile ? 0.06 : 0.06) * 3,
                                      child: const SizedBox(),
                                    )
                                ],
                              ),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: BlocListener<VehicleBloc, VehicleState>(
                            listener: (context, state) {
                              switch (state.status) {
                                case VehicleStatus.success:
                                  if (navigator.navigatorkey.currentState!.mounted) {
                                    // checks if this page is in the stack.
                                    // shows registration dialog if the vehicle registration is successful.
                                    showRegistrationDialog(
                                        size: size,
                                        state: state,
                                        statusWidget: Container(
                                            alignment: Alignment.centerLeft,
                                            width: size.width * 0.88,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                            child: Row(
                                              children: [
                                                Lottie.asset("assets/lottie/success.json", repeat: false, width: size.width * 0.08),
                                                const Gap(4),
                                                const Text(
                                                  'Vehicle Registration is Successful',
                                                  style: TextStyle(color: Colors.black87),
                                                ),
                                              ],
                                            )),
                                        text: 'Do you want to book service ?',
                                        acceptText: 'book now',
                                        rejectText: 'later',
                                        onAccept: () {
                                          state.status = VehicleStatus.initial;
                                          // on accept navigate to the servicebooking page with registration number filled pre filled.
                                          state.registrationNo = vehicleRegNumberController.text;
                                          navigator.pushAndRemoveUntil('/serviceBooking', '/home');
                                          clearFields();
                                        },
                                        onReject: () {
                                          state.status = VehicleStatus.initial;
                                          navigator.popUntil('/home');
                                        });
                                  }

                                case VehicleStatus.vehicleAlreadyAdded:
                                  if (navigator.navigatorkey.currentState!.mounted) {
                                    // checks if this page is in the stack.
                                    // shows registration dialog if the vehicle registration is already done.
                                    showRegistrationDialog(
                                      size: size,
                                      state: state,
                                      statusWidget: Container(
                                          alignment: Alignment.centerLeft,
                                          width: size.width * 0.88,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Lottie.asset("assets/lottie/success.json", repeat: false, width: size.width * 0.08),
                                              const Gap(4),
                                              SizedBox(
                                                width: size.width * 0.58,
                                                child: const Text(
                                                  'Oops! This Vehicle is already registered with us',
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black87),
                                                ),
                                              ),
                                            ],
                                          )),
                                      text: 'Do you want to book service ?',
                                      acceptText: 'book now',
                                      rejectText: 'retry',
                                      onAccept: () {
                                        state.status = VehicleStatus.initial;
                                        // on accept navigate to the servicebooking page with registration number filled pre filled.
                                        state.registrationNo = vehicleRegNumberController.text;
                                        navigator.pushAndRemoveUntil('/serviceBooking', '/home');
                                        clearFields();
                                      },
                                      onReject: () {
                                        state.status = VehicleStatus.initial;

                                        // on reject user can retype the vehicle registration number if previous one is wrong.
                                        navigator.pop();
                                        vehicleRegNumberFocus.requestFocus();
                                      },
                                    );
                                  }
                                  break;
                                case VehicleStatus.failure:
                                  DMSCustomWidgets.DMSFlushbar(size, context,
                                      message: 'Something went wrong',
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ));
                                default:
                                  break;
                              }
                            },
                            child: GestureDetector(
                              onTap: () {
                                FocusManager.instance.primaryFocus?.unfocus();

                                // message is assigned with a String according to the validations.
                                String? message = _locationValidator(locTypeAheadController.text) ??
                                    _vehicleRegistrationNoValidator(vehicleRegNumberController.text) ??
                                    _chassisNoValidation(chassisNumberController.text) ??
                                    _engineNoValidation(engineNumberController.text) ??
                                    (makeTypeAheadController.text.isEmpty ? 'Make cannot be empty' : null) ??
                                    (kmsController.text.isEmpty ? 'KMS cannot be empty' : null) ??
                                    _nameValidation(customerNameController.text) ??
                                    (customerContactNumberController.text.isEmpty
                                        ? _customerContactNoValidation(customerContactNumberController.text)
                                        : null) ??
                                    (customerAddressController.text.isEmpty ? 'Please fill the address details' : null);

                                // shows a snackbar with the message if message variable is not null.
                                if (message != null) {
                                  DMSCustomWidgets.DMSFlushbar(size, context,
                                      message: message,
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ));
                                } else {
                                  // populate the vehicle object with all the required details to be pushed to db
                                  Vehicle vehicle = Vehicle(
                                      location: locTypeAheadController.text,
                                      vehicleRegNumber: vehicleRegNumberController.text,
                                      chassisNumber: chassisNumberController.text,
                                      engineNumber: engineNumberController.text,
                                      make: makeTypeAheadController.text,
                                      varient: variantController.text,
                                      color: colorController.text,
                                      mfgYear: int.parse(mfgYearController.text),
                                      kms: kmsController.text.isNotEmpty ? int.parse(kmsController.text) : 0,
                                      financialDetails: financialDetailsController.text,
                                      model: modelController.text,
                                      insuranceCompany: insuranceCompanyTypeAheadController.text,
                                      customerName: customerNameController.text,
                                      customerContactNo: customerContactNumberController.text,
                                      customerAddress: customerAddressController.text);

                                  // trigger event with the vehicle object as parameter which triggers the repo method to push data to the db
                                  _vehicleBloc.add(AddVehicleEvent(vehicle: vehicle));
                                }
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(top: size.height * 0.03),
                                  width: size.width * (isMobile ? 0.22 : 0.13),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                                    BoxShadow(
                                        blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                                  ]),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    'submit',
                                    style: TextStyle(color: Colors.white, fontSize: (isMobile ? 16 : 18)),
                                  )),
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: Gap(size.height * 0.15),
                      )
                    ],
                  ),
                ),
                if (context.watch<VehicleBloc>().state.status == VehicleStatus.loading ||
                    context.watch<ServiceBloc>().state.getSBRequirementsStatus == GetSBRequirementsStatus.loading)
                  // shows the loading animation according to the vehicle status in vehicle bloc.
                  Container(
                    color: Colors.black54,
                    child: Center(
                        child: Lottie.asset('assets/lottie/car_loading.json',
                            height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32)),
                  )
              ],
            )),
      ),
    );
  }

  void showRegistrationDialog(
      {required Size size,
      required VehicleState state,
      required String text,
      required String acceptText,
      required String rejectText,
      Widget? statusWidget,
      required void Function()? onAccept,
      required void Function()? onReject}) {
    FocusManager.instance.primaryFocus?.unfocus();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopScope(
            canPop: false,
            child: AlertDialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.only(top: size.height * 0.01),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size.width * 0.03),
                      child: Column(
                        children: [
                          statusWidget ?? const SizedBox(),
                          if (statusWidget != null) const Gap(8),
                          Text(
                            text,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Gap(size.height * 0.01),
                    Container(
                      height: size.height * 0.05,
                      margin: EdgeInsets.all(size.height * 0.001),
                      decoration: const BoxDecoration(
                          color: Colors.black, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: onReject,
                              style: TextButton.styleFrom(fixedSize: Size(size.width * 0.3, size.height * 0.1), foregroundColor: Colors.white),
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
                              style: TextButton.styleFrom(fixedSize: Size(size.width * 0.3, size.height * 0.1), foregroundColor: Colors.white),
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
                buttonPadding: EdgeInsets.zero),
          );
        });
  }

  String? _locationValidator(String value) {
    if (value.isEmpty) {
      return "location cannot be empty";
    } else if (!_serviceBloc.state.locations!.contains(locTypeAheadController.text)) {
      return "please select a valid location";
    }
    return null;
  }

// validates vehicle registration number according to the conditions and regex used.
  String? _vehicleRegistrationNoValidator(String value) {
    if (value.isEmpty) {
      return "Vehicle Registration No. can't be empty";
    } else if (value.length < 10) {
      return "Vehicle Registration No. should contain 10 characters";
    }
    return null;
  }

// validates customer contact number according to the conditions and regex used.
  String? _customerContactNoValidation(String value) {
    RegExp contactNoRegex = RegExp(r'^\d{10}$');
    if (value.isEmpty) {
      return "Contact Number can't be empty";
    } else if (!contactNoRegex.hasMatch(value)) {
      return "Invalid Contact Number";
    }
    return null;
  }

// validates chassis number according to the conditions and regex used.
  String? _chassisNoValidation(String value) {
    // RegExp chassisNoRegex = RegExp(r'^[A-Z]{2}\d{4}$');
    if (value.isEmpty) {
      return "Chassis No. can't be empty";
    } else if (value.length > 17) {
      return "Invalid Chassis No.";
    }
    //  else if (!chassisNoRegex.hasMatch(value)) {
    //   return "Invalid Chassis No.";
    // }
    return null;
  }

// validates engine number according to the conditions and regex used.
  String? _engineNoValidation(String value) {
    RegExp engineNoRegex = RegExp(r'^[A-Z]{2}\d{4}$');
    if (value.isEmpty) {
      return "Engine No. can't be empty";
    }
    // else if (!engineNoRegex.hasMatch(value)) {
    //   return "Invalid Engine No.";
    // }
    return null;
  }

// validates name according to the conditions and regex used.
  String? _nameValidation(String value) {
    RegExp customerNameRegex = RegExp(r'^[A-Za-z ]*$');
    if (value.isEmpty) {
      return "Customer Name can't be empty!";
    } else if (!customerNameRegex.hasMatch(value)) {
      return "Invalid Customer Name";
    }
    return null;
  }
}
