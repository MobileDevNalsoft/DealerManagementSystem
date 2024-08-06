import 'package:another_flushbar/flushbar.dart';
import 'package:customs/src.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/add_vehicle.dart';
import 'package:dms/views/inspection_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:shimmer/shimmer.dart';
import '../inits/init.dart';
import '../logger/logger.dart';

class ServiceMain extends StatefulWidget {
  PageController? pageController;
  ServiceMain({Key? key, this.pageController}) : super(key: key);

  @override
  State<ServiceMain> createState() => _ServiceMain();
}

class _ServiceMain extends State<ServiceMain> with ConnectivityMixin {
  //page 1
  // focusnodes
  FocusNode locFocus = FocusNode();
  FocusNode vehRegNumFocus = FocusNode();
  FocusNode customerFocus = FocusNode();
  FocusNode kmsFocus = FocusNode();

  // controllers
  TextEditingController locTypeAheadController = TextEditingController();
  TextEditingController vehRegNumController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController kmsController = TextEditingController();

  PageController pageController = PageController();

  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  GlobalKey targetKey = GlobalKey();

  ScrollController page1ScrollController = ScrollController();

  late ServiceBloc _serviceBloc;
  late VehicleBloc _vehicleBloc;
  late MultiBloc _multiBloc;
  late Size size;
  bool dropDownUp = false;

  //page 2
  FocusNode bookingFocus = FocusNode();
  FocusNode altContFocus = FocusNode();
  FocusNode altContPhoneNoFocus = FocusNode();
  FocusNode spFocus = FocusNode();
  FocusNode bayFocus = FocusNode();
  FocusNode jobTypeFocus = FocusNode();
  FocusNode custConcernsFocus = FocusNode();
  FocusNode remarksFocus = FocusNode();

  TextEditingController bookingTypeAheadController = TextEditingController();
  TextEditingController altContController = TextEditingController();
  TextEditingController altContPhoneNoController = TextEditingController();
  TextEditingController spTypeAheadController = TextEditingController();
  TextEditingController bayTypeAheadController = TextEditingController();
  TextEditingController jobTypeTypeAheadController = TextEditingController();
  TextEditingController custConcernsController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  SuggestionsController suggestionsController = SuggestionsController();

  ScrollController page2ScrollController = ScrollController();

  bool bookingSourceDropDownUp = false;
  bool salesPersonDropDownUp = false;
  bool bayDropDownUp = false;
  bool jobTypeDropDownUp = false;

  List<String> jobTypeList = [
    'Oil change and oil filter replacement',
    'Fuel filter change (diesel vehicles)',
    'Spark plug replacement (petrol vehicles)',
    'Air filter change',
    'Brake inspection and maintenance',
    'Wheel bearing and shock absorber inspection',
    'Electrical component testing (battery, alternator, starter motor)',
    'Air conditioning system inspection',
    'Radiator and coolant hose inspection',
    'Cabin air filter replacement',
    'Brake fluid exchange',
    'Timing belt replacement (if applicable)',
    'Tire rotation',
    'Wheel alignment',
    'Wiper blade replacement'
  ];

  List<String> bayList = [
    "Service Bay",
    "Express Maintenance Bay",
    "Body Repair Bay",
    "Tire Service Bays",
    "Diagnostic Bay",
    "Wash Bay"
  ];

  @override
  void initState() {
    super.initState();
    //page 1
    clearFields();
    vehRegNumFocus.addListener(_onVehRegNumUnfocused);

    _serviceBloc = context.read<ServiceBloc>();
    _vehicleBloc = context.read<VehicleBloc>();
    _multiBloc = context.read<MultiBloc>();

    _vehicleBloc.state.status = VehicleStatus.initial;

    if (_serviceBloc.state.serviceLocationsStatus !=
        GetServiceLocationsStatus.success) {
      _serviceBloc.add(GetServiceLocations());
    }
    _multiBloc.state.date = null;

    locFocus.addListener(() {
      dropDownUp = !dropDownUp;
      _serviceBloc.add(DropDownOpen());
    });

    //page 2
    _serviceBloc.state.serviceUploadStatus = ServiceUploadStatus.initial;

    bookingFocus.addListener(() {
      bookingSourceDropDownUp = !bookingSourceDropDownUp;
      _serviceBloc.add(DropDownOpen());
    });

    spFocus.addListener(() {
      salesPersonDropDownUp = !salesPersonDropDownUp;
      _serviceBloc.add(DropDownOpen());
    });

    bayFocus.addListener(() {
      bayDropDownUp = !bayDropDownUp;
      _serviceBloc.add(DropDownOpen());
    });

    jobTypeFocus.addListener(() {
      jobTypeDropDownUp = !jobTypeDropDownUp;
      _serviceBloc.add(DropDownOpen());
    });
  }

  void _onVehRegNumUnfocused() {
    if (isConnected()) {
      if (!vehRegNumFocus.hasFocus && vehRegNumController.text.isNotEmpty) {
        _vehicleBloc.state.status = VehicleStatus.initial;
        context.read<VehicleBloc>().add(
            FetchVehicleCustomer(registrationNo: vehRegNumController.text));
      }
    } else {
      DMSCustomWidgets.DMSFlushbar(size, context,
          message: 'Please check the internet connectivity',
          icon: Icon(Icons.error));
    }
  }

  void clearFields() {
    vehRegNumController.clear();
    customerController.clear();
    locTypeAheadController.clear();
    kmsController.clear();
    context.read<MultiBloc>().add(DateChanged(date: null));
    bookingTypeAheadController.clear();
    altContController.clear();
    altContPhoneNoController.clear();
    spTypeAheadController.clear();
    bayTypeAheadController.clear();
    jobTypeTypeAheadController.clear();
    custConcernsController.clear();
    remarksController.clear();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;

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

    return SizedBox(
      height: size.height,
      width: size.width,
      child: PageView.builder(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: PopScope(
              canPop: false,
              onPopInvoked: (didPop) async {
                print('tried');
                if (index == 1) {
                  pageController.animateToPage(0,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease);
                } else {
                  Navigator.of(context).pop();
                }
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
                            if (index == 0) {
                              Navigator.pop(context);
                            } else {
                              pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            }
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
                      child: Text(
                        textAlign: TextAlign.center,
                        'Service Booking',
                        style: const TextStyle(
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
                              colors: [
                                Colors.black45,
                                Colors.black26,
                                Colors.black45
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              stops: [0.1, 0.5, 1]),
                        ),
                        child: index == 0
                            ? BlocBuilder<ServiceBloc, ServiceState>(
                                builder: (context, state) {
                                switch (state.serviceLocationsStatus) {
                                  case GetServiceLocationsStatus.loading:
                                    return Transform(
                                      transform:
                                          Matrix4.translationValues(0, -40, 0),
                                      child: Center(
                                        child: Lottie.asset(
                                            'assets/lottie/car_loading.json',
                                            height: size.height * 0.5,
                                            width: size.width * 0.6),
                                      ),
                                    );
                                  case GetServiceLocationsStatus.success:
                                    return ListView(
                                      controller: page1ScrollController,
                                      children: [
                                        Column(
                                          children: [
                                            Gap(size.height * 0.13),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                DMSCustomWidgets.SearchableDropDown(
                                                    size: size,
                                                    hint: 'Location',
                                                    items: state.locations!,
                                                    icon: dropDownUp
                                                        ? const Icon(
                                                            Icons.arrow_drop_up)
                                                        : const Icon(Icons
                                                            .arrow_drop_down),
                                                    focus: locFocus,
                                                    typeAheadController:
                                                        locTypeAheadController,
                                                    scrollController:
                                                        page1ScrollController,
                                                    isMobile: isMobile),
                                                Gap(size.height *
                                                    (isMobile ? 0.01 : 0.03)),
                                                BlocConsumer<VehicleBloc,
                                                    VehicleState>(
                                                  listener: (context, state) {
                                                    if (state.status ==
                                                        VehicleStatus
                                                            .vehicleAlreadyAdded) {
                                                      customerController.text =
                                                          state.vehicle!
                                                              .cusotmerName!;
                                                    } else if (state.status ==
                                                        VehicleStatus
                                                            .newVehicle) {
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();

                                                      showRegistrationDialog(
                                                          size: size,
                                                          state: state);
                                                    } else if (state.status ==
                                                        VehicleStatus.failure) {
                                                      Flushbar(
                                                        backgroundColor:
                                                            Colors.red,
                                                        blockBackgroundInteraction:
                                                            true,
                                                        message:
                                                            "Server Failure Please check the internet connectivity",
                                                        flushbarPosition:
                                                            FlushbarPosition
                                                                .TOP,
                                                        duration:
                                                            const Duration(
                                                                seconds: 2),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        margin: EdgeInsets.only(
                                                            top: size.height *
                                                                0.01,
                                                            left: isMobile
                                                                ? 10
                                                                : size.width *
                                                                    0.8,
                                                            right: size.width *
                                                                0.03),
                                                      ).show(context);
                                                    }
                                                  },
                                                  builder: (context, state) {
                                                    return DMSCustomWidgets.CustomDataCard(
                                                        context: context,
                                                        size: size,
                                                        hint:
                                                            'Vehicle Registration Number',
                                                        inputFormatters: [
                                                          UpperCaseTextFormatter()
                                                        ],
                                                        icon: state.status ==
                                                                VehicleStatus
                                                                    .vehicleAlreadyAdded
                                                            ? const Icon(Icons
                                                                .check_circle_rounded)
                                                            : null,
                                                        isMobile: isMobile,
                                                        textcontroller:
                                                            vehRegNumController,
                                                        focusNode:
                                                            vehRegNumFocus,
                                                        scrollController:
                                                            page1ScrollController);
                                                  },
                                                ),
                                                Gap(size.height *
                                                    (isMobile ? 0.01 : 0.03)),
                                                BlocBuilder<VehicleBloc,
                                                    VehicleState>(
                                                  builder: (context, state) {
                                                    return DMSCustomWidgets
                                                        .CustomDataCard(
                                                            context: context,
                                                            size: size,
                                                            hint:
                                                                'Customer Name',
                                                            isMobile: isMobile,
                                                            textcontroller:
                                                                customerController,
                                                            onChange: (p0) {
                                                              customerController
                                                                      .text =
                                                                  state.vehicle!
                                                                      .cusotmerName!;
                                                            },
                                                            focusNode:
                                                                customerFocus,
                                                            scrollController:
                                                                page1ScrollController);
                                                  },
                                                ),
                                                Gap(size.height *
                                                    (isMobile ? 0.01 : 0.03)),
                                                BlocBuilder<MultiBloc,
                                                    MultiBlocState>(
                                                  builder: (context, state) {
                                                    return DMSCustomWidgets
                                                        .ScheduleDateCalendar(
                                                      context: context,
                                                      date: state.date,
                                                      size: size,
                                                      isMobile: isMobile,
                                                    );
                                                  },
                                                ),
                                                Gap(size.height *
                                                    (isMobile ? 0.01 : 0.03)),
                                                DMSCustomWidgets.CustomDataCard(
                                                    context: context,
                                                    key: targetKey,
                                                    size: size,
                                                    hint: 'KMS',
                                                    isMobile: isMobile,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: [
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                    ],
                                                    textcontroller:
                                                        kmsController,
                                                    focusNode: kmsFocus,
                                                    scrollController:
                                                        page1ScrollController),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Gap(isMobile
                                                    ? (size.width * 0.7)
                                                    : (size.width * 0.595)),
                                                BlocBuilder<VehicleBloc,
                                                    VehicleState>(
                                                  builder: (context, state) {
                                                    if (state.status ==
                                                        VehicleStatus
                                                            .vehicleAlreadyAdded) {
                                                      return ElevatedButton(
                                                          onPressed: () {
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            CustomWidgets
                                                                .CustomDialogBox(
                                                                    context:
                                                                        context,
                                                                    contentPadding: EdgeInsets.symmetric(
                                                                        vertical: isMobile
                                                                            ? 20
                                                                            : 40,
                                                                        horizontal: isMobile
                                                                            ? 12
                                                                            : 40),
                                                                    child: DMSCustomWidgets
                                                                        .CustomDataFields(
                                                                      context:
                                                                          context,
                                                                      propertyList: [
                                                                        "Chassis no.",
                                                                        "Make",
                                                                        "Model",
                                                                        "Varient",
                                                                        "Color"
                                                                      ],
                                                                      valueList: [
                                                                        state.vehicle!.chassisNumber ??
                                                                            "",
                                                                        state.vehicle!.make ??
                                                                            "",
                                                                        state.vehicle!.model ??
                                                                            "",
                                                                        state.vehicle!.varient ??
                                                                            "",
                                                                        state.vehicle!.color ??
                                                                            ""
                                                                      ],
                                                                      propertyFontStyle: TextStyle(
                                                                          fontSize: isMobile
                                                                              ? 16
                                                                              : 18,
                                                                          fontFamily:
                                                                              'Montserrat',
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                      valueFontStyle: TextStyle(
                                                                          fontSize: isMobile
                                                                              ? 16
                                                                              : 18,
                                                                          fontFamily:
                                                                              'Roboto'),
                                                                    ));
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              minimumSize: isMobile
                                                                  ? const Size(
                                                                      65, 10)
                                                                  : const Size(
                                                                      80.0,
                                                                      20.0),
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5))),
                                                          child: Text(
                                                            'view more',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 14),
                                                          ));
                                                    } else {
                                                      return SizedBox(
                                                        height:
                                                            size.height * 0.05,
                                                      );
                                                    }
                                                  },
                                                ),
                                                Spacer(
                                                  flex: isMobile
                                                      ? (size.width * 0.1)
                                                          .round()
                                                      : (size.width * 0.3)
                                                          .round(),
                                                )
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (!isConnected()) {
                                                  DMSCustomWidgets.DMSFlushbar(
                                                      size, context,
                                                      message:
                                                          'Please check the internet connectivity',
                                                      icon: Icon(Icons.error));
                                                  return;
                                                }
                                                FocusManager
                                                    .instance.primaryFocus
                                                    ?.unfocus();

                                                String? message = _locationValidator(
                                                        locTypeAheadController
                                                            .text) ??
                                                    (vehRegNumController
                                                            .text.isEmpty
                                                        ? "vehicle registration number cannot be empty"
                                                        : null) ??
                                                    (context
                                                                .read<
                                                                    MultiBloc>()
                                                                .state
                                                                .date ==
                                                            null
                                                        ? "schedule date cannot be empty"
                                                        : null) ??
                                                    (kmsController.text.isEmpty
                                                        ? "lms cannot be empty"
                                                        : null);

                                                if (message != null) {
                                                  Flushbar(
                                                    backgroundColor: Colors.red,
                                                    blockBackgroundInteraction:
                                                        true,
                                                    message: message,
                                                    flushbarPosition:
                                                        FlushbarPosition.TOP,
                                                    duration: const Duration(
                                                        seconds: 2),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    margin: EdgeInsets.only(
                                                        top: size.height * 0.01,
                                                        left: isMobile
                                                            ? 10
                                                            : size.width * 0.8,
                                                        right:
                                                            size.width * 0.03),
                                                  ).show(context);
                                                  return;
                                                } else {
                                                  pageController.animateToPage(
                                                      1,
                                                      duration: const Duration(
                                                          milliseconds: 500),
                                                      curve: Curves.ease);
                                                }
                                              },
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  height: size.height * 0.045,
                                                  width: size.width * 0.2,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.black,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            blurRadius: 10,
                                                            blurStyle:
                                                                BlurStyle.outer,
                                                            spreadRadius: 0,
                                                            color: Colors.orange
                                                                .shade200,
                                                            offset:
                                                                const Offset(
                                                                    0, 0))
                                                      ]),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    'next',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16),
                                                  )),
                                            ),
                                            if (MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom !=
                                                0)
                                              Gap(size.height *
                                                  (isMobile ? 0.4 : 0.5)),
                                          ],
                                        ),
                                      ],
                                    );
                                  default:
                                    return const Center(
                                      child: Text('Error'),
                                    );
                                }
                              })
                            : ListView(
                                controller: page2ScrollController,
                                children: [
                                  Column(
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: size.height * (0.05),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              DMSCustomWidgets.SearchableDropDown(
                                                  items: ["Online", "Walk-in"],
                                                  size: size,
                                                  hint: 'Booking Source',
                                                  isMobile: isMobile,
                                                  focus: bookingFocus,
                                                  typeAheadController:
                                                      bookingTypeAheadController,
                                                  icon: bookingSourceDropDownUp
                                                      ? const Icon(
                                                          Icons.arrow_drop_up)
                                                      : const Icon(Icons
                                                          .arrow_drop_down),
                                                  scrollController:
                                                      page2ScrollController),
                                              SizedBox(
                                                height: size.height *
                                                    (isMobile ? 0.005 : 0.015),
                                              ),
                                              DMSCustomWidgets.CustomDataCard(
                                                  context: context,
                                                  size: size,
                                                  hint:
                                                      'Alternate Contact Person',
                                                  inputFormatters: [
                                                    InitCapCaseTextFormatter()
                                                  ],
                                                  isMobile: isMobile,
                                                  focusNode: altContFocus,
                                                  textcontroller:
                                                      altContController,
                                                  scrollController:
                                                      page2ScrollController),
                                              SizedBox(
                                                height: size.height *
                                                    (isMobile ? 0.005 : 0.015),
                                              ),
                                              DMSCustomWidgets.CustomDataCard(
                                                  context: context,
                                                  size: size,
                                                  hint:
                                                      'Alternate Person Contact No.',
                                                  isMobile: isMobile,
                                                  focusNode:
                                                      altContPhoneNoFocus,
                                                  textcontroller:
                                                      altContPhoneNoController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        10)
                                                  ],
                                                  scrollController:
                                                      page2ScrollController),
                                              SizedBox(
                                                height: size.height *
                                                    (isMobile ? 0.005 : 0.015),
                                              ),
                                              BlocBuilder<MultiBloc,
                                                  MultiBlocState>(
                                                builder: (context, state) {
                                                  return DMSCustomWidgets
                                                      .SearchableDropDown(
                                                          onChanged: (p0) {
                                                            if (!isConnected()) {
                                                              DMSCustomWidgets
                                                                  .DMSFlushbar(
                                                                      size,
                                                                      context,
                                                                      message:
                                                                          'Please check the internet connectivity',
                                                                      icon: Icon(
                                                                          Icons
                                                                              .error));
                                                              return;
                                                            }
                                                            spTypeAheadController
                                                                .text = p0;
                                                            if (p0.length >=
                                                                3) {
                                                              context
                                                                  .read<
                                                                      MultiBloc>()
                                                                  .add(GetSalesPersons(
                                                                      searchText:
                                                                          p0));
                                                            } else {
                                                              context
                                                                  .read<
                                                                      MultiBloc>()
                                                                  .state
                                                                  .salesPersons = null;
                                                            }
                                                          },
                                                          size: size,
                                                          items: state.salesPersons ==
                                                                  null
                                                              ? []
                                                              : state
                                                                  .salesPersons!
                                                                  .map((e) =>
                                                                      "${e.empName}-${e.empId}")
                                                                  .toList(),
                                                          hint: 'Sales Person',
                                                          icon: salesPersonDropDownUp
                                                              ? const Icon(Icons
                                                                  .arrow_drop_up)
                                                              : const Icon(Icons
                                                                  .arrow_drop_down),
                                                          isMobile: isMobile,
                                                          isLoading: state
                                                                      .status ==
                                                                  MultiStateStatus
                                                                      .loading
                                                              ? true
                                                              : false,
                                                          focus: spFocus,
                                                          typeAheadController:
                                                              spTypeAheadController,
                                                          suggestionsController:
                                                              suggestionsController,
                                                          scrollController:
                                                              page2ScrollController);
                                                },
                                              ),
                                              SizedBox(
                                                height: size.height *
                                                    (isMobile ? 0.005 : 0.015),
                                              ),
                                              DMSCustomWidgets.SearchableDropDown(
                                                  items: bayList,
                                                  size: size,
                                                  hint: 'Bay',
                                                  isMobile: isMobile,
                                                  icon: bayDropDownUp
                                                      ? const Icon(
                                                          Icons.arrow_drop_up)
                                                      : const Icon(Icons
                                                          .arrow_drop_down),
                                                  focus: bayFocus,
                                                  typeAheadController:
                                                      bayTypeAheadController,
                                                  scrollController:
                                                      page2ScrollController),
                                              SizedBox(
                                                height: size.height *
                                                    (isMobile ? 0.005 : 0.015),
                                              ),
                                              DMSCustomWidgets.SearchableDropDown(
                                                  size: size,
                                                  hint: 'Job Type',
                                                  items: jobTypeList,
                                                  icon: jobTypeDropDownUp
                                                      ? const Icon(
                                                          Icons.arrow_drop_up)
                                                      : const Icon(Icons
                                                          .arrow_drop_down),
                                                  focus: jobTypeFocus,
                                                  typeAheadController:
                                                      jobTypeTypeAheadController,
                                                  isMobile: isMobile,
                                                  scrollController:
                                                      page2ScrollController),
                                              SizedBox(
                                                height: size.height *
                                                    (isMobile ? 0.005 : 0.015),
                                              ),
                                              DMSCustomWidgets
                                                  .CustomTextFieldCard(
                                                      size: size,
                                                      hint: 'Customer Concerns',
                                                      context: context,
                                                      scrollController:
                                                          page2ScrollController,
                                                      isMobile: isMobile,
                                                      focusNode:
                                                          custConcernsFocus,
                                                      textcontroller:
                                                          custConcernsController),
                                              SizedBox(
                                                height: size.height *
                                                    (isMobile ? 0.005 : 0.015),
                                              ),
                                              DMSCustomWidgets
                                                  .CustomTextFieldCard(
                                                      size: size,
                                                      hint: 'Remarks',
                                                      context: context,
                                                      scrollController:
                                                          page2ScrollController,
                                                      isMobile: isMobile,
                                                      focusNode: remarksFocus,
                                                      textcontroller:
                                                          remarksController),
                                              SizedBox(
                                                height: size.height *
                                                    (isMobile ? 0.05 : 0.015),
                                              ),
                                            ],
                                          ),
                                          BlocConsumer<ServiceBloc,
                                              ServiceState>(
                                            listener: (context, state) {
                                              switch (
                                                  state.serviceUploadStatus) {
                                                case ServiceUploadStatus
                                                      .success:
                                                  Flushbar(
                                                          flushbarPosition:
                                                              FlushbarPosition
                                                                  .TOP,
                                                          backgroundColor:
                                                              Colors.green,
                                                          message:
                                                              'Service Added Successfully',
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          margin: EdgeInsets.only(
                                                              top: 24,
                                                              left: isMobile
                                                                  ? 10
                                                                  : size.width *
                                                                      0.8,
                                                              right: 10))
                                                      .show(context);
                                                  context
                                                      .read<MultiBloc>()
                                                      .state
                                                      .date = null;
                                                  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              const InspectionView()));
                                                  clearFields();
                                                case ServiceUploadStatus
                                                      .failure:
                                                  Flushbar(
                                                          flushbarPosition:
                                                              FlushbarPosition
                                                                  .TOP,
                                                          backgroundColor:
                                                              Colors.red,
                                                          message:
                                                              'Some error occured',
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          margin: EdgeInsets.only(
                                                              top: 24,
                                                              left: isMobile
                                                                  ? 10
                                                                  : size.width *
                                                                      0.8,
                                                              right: 10))
                                                      .show(context);

                                                default:
                                                  null;
                                              }
                                            },
                                            builder: (context, state) {
                                              return BlocBuilder<MultiBloc,
                                                  MultiBlocState>(
                                                builder: (context, state) {
                                                  return CustomSliderButton(
                                                    context: context,
                                                    size: size,
                                                    resetPosition:
                                                        state.status ==
                                                                MultiStateStatus
                                                                    .failure ||
                                                            state.status ==
                                                                MultiStateStatus
                                                                    .initial,
                                                    sliderStatus: context
                                                        .watch<ServiceBloc>()
                                                        .state
                                                        .serviceUploadStatus!,
                                                    label: const Text(
                                                      "Proceed to receive",
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff4a4a4a),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 17),
                                                    ),
                                                    icon: const Icon(
                                                      Icons
                                                          .arrow_forward_ios_rounded,
                                                      color: Colors.white,
                                                    ),
                                                    onDismissed: () async {
                                                      if (!isConnected()) {
                                                        DMSCustomWidgets
                                                            .DMSFlushbar(
                                                                size, context,
                                                                message:
                                                                    'Please check the internet connectivity',
                                                                icon: Icon(Icons
                                                                    .error));
                                                        return;
                                                      }
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();

                                                      _vehicleBloc
                                                              .state.status =
                                                          VehicleStatus.initial;

                                                      String? message = _bookingSourceValidator(bookingTypeAheadController.text) ??
                                                          _altPersonContactNoValidation(
                                                              altContPhoneNoController
                                                                  .text) ??
                                                          _salesPersonValidator(
                                                              spTypeAheadController
                                                                  .text,
                                                              (state.salesPersons ??
                                                                      [])
                                                                  .map((e) =>
                                                                      e.empName)
                                                                  .toList()) ??
                                                          _bayValidator(
                                                              bayTypeAheadController
                                                                  .text,
                                                              bayList) ??
                                                          _jobTypeValidator(
                                                              jobTypeTypeAheadController
                                                                  .text,
                                                              jobTypeList);

                                                      if (message != null) {
                                                        Flushbar(
                                                          flushbarPosition:
                                                              FlushbarPosition
                                                                  .TOP,
                                                          backgroundColor:
                                                              Colors.red,
                                                          message: message,
                                                          duration:
                                                              const Duration(
                                                                  seconds: 2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          margin: EdgeInsets.only(
                                                              top: size.height *
                                                                  0.01,
                                                              left: isMobile
                                                                  ? 10
                                                                  : size.width *
                                                                      0.8,
                                                              right:
                                                                  size.width *
                                                                      0.03),
                                                        ).show(context);
                                                      } else {
                                                        Service service = Service(
                                                            registrationNo:
                                                                vehRegNumController
                                                                    .text,
                                                            location: locTypeAheadController
                                                                .text,
                                                            customerName:
                                                                customerController
                                                                    .text,
                                                            scheduledDate: state.date
                                                                .toString()
                                                                .substring(
                                                                    0, 10),
                                                            kms: int.parse(kmsController
                                                                .text),
                                                            bookingSource:
                                                                bookingTypeAheadController
                                                                    .text,
                                                            alternateContactPerson:
                                                                altContController
                                                                    .text,
                                                            alternatePersonContactNo:
                                                                altContPhoneNoController.text.isNotEmpty
                                                                    ? int.parse(altContPhoneNoController.text)
                                                                    : null,
                                                            salesPerson: spTypeAheadController.text.split('-')[0],
                                                            bay: bayTypeAheadController.text,
                                                            jobType: jobTypeTypeAheadController.text,
                                                            jobCardNo: 'JC-${locTypeAheadController.text.substring(0, 3).toUpperCase()}-${DateTime.now().millisecondsSinceEpoch.toString().substring(DateTime.now().millisecondsSinceEpoch.toString().length - 3, DateTime.now().millisecondsSinceEpoch.toString().length - 1)}',
                                                            customerConcerns: custConcernsController.text,
                                                            remarks: remarksController.text);
                                                        _serviceBloc.state
                                                                .jobCardNo =
                                                            service.jobCardNo!;

                                                        Log.d(service.toJson());
                                                        context
                                                            .read<ServiceBloc>()
                                                            .add(ServiceAdded(
                                                                service:
                                                                    service));
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                          if (MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom !=
                                              0)
                                            SizedBox(
                                              height: size.height *
                                                  (isMobile ? 0.4 : 0.5),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                    if (context.watch<VehicleBloc>().state.status ==
                            VehicleStatus.loading ||
                        context
                                .watch<ServiceBloc>()
                                .state
                                .serviceUploadStatus ==
                            ServiceUploadStatus.loading)
                      Container(
                        color: Colors.black54,
                        child: Center(
                            child: Lottie.asset(
                                'assets/lottie/car_loading.json',
                                height: size.height * 0.5,
                                width: size.width * 0.6)),
                      )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String? _locationValidator(String value) {
    if (value.isEmpty) {
      return "location cannot be empty";
    } else if (!_serviceBloc.state.locations!
        .contains(locTypeAheadController.text)) {
      return "please select a valid location";
    }
    return null;
  }

  String? _bookingSourceValidator(String value) {
    if (value.isEmpty) {
      return "Booking Source cannot be empty";
    } else if (!["Online", "Walk-in"].contains(value)) {
      return "Invalid Booking Source";
    }
    return null;
  }

  String? _altPersonContactNoValidation(String value) {
    RegExp contactNoRegex = RegExp(r'^\d{10}$');
    if (value.isNotEmpty && !contactNoRegex.hasMatch(value)) {
      return "Invalid Contact Number";
    }
    return null;
  }

  String? _salesPersonValidator(String value, List<String?> salesPersons) {
    print(salesPersons);
    if (value.isEmpty) {
      return "Sales Person cannot be empty";
    } else if (!salesPersons.contains(value.split('-')[0])) {
      return "Invalid Sales Person";
    }
    return null;
  }

  String? _bayValidator(String value, List<String> bayList) {
    if (value.isEmpty) {
      return "Bay cannot be empty";
    } else if (!bayList.contains(value)) {
      return "Invalid Bay";
    }
    return null;
  }

  String? _jobTypeValidator(String value, List<String> jobTypeList) {
    if (value.isEmpty) {
      return "Job Type cannot be empty";
    } else if (!jobTypeList.contains(value)) {
      return "Invalid Jpb Type";
    }
    return null;
  }

  void showRegistrationDialog(
      {required Size size, required VehicleState state}) {
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
                    child: const Text(
                      'Oops! This Vehicle not registered with us.',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                            onPressed: () {
                              Navigator.pop(context);
                              vehRegNumFocus.requestFocus();
                            },
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'retry',
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          thickness: 0.5,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              state.status = VehicleStatus.initial;
                              Navigator.pop(context);
                              Navigator.popAndPushNamed(context, '/addVehicle');
                            },
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
                            child: const Text(
                              'register Now',
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

class CustomSliderButton extends StatefulWidget {
  final Size size;
  final BuildContext context;
  final Widget label;
  final Widget icon;
  final onDismissed;
  final resetPosition;
  ServiceUploadStatus sliderStatus;
  CustomSliderButton(
      {Key? key,
      required this.size,
      required this.context,
      required this.label,
      required this.icon,
      required this.onDismissed,
      required this.resetPosition,
      this.sliderStatus = ServiceUploadStatus.initial})
      : super(key: key);

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  late double _position;
  late double _startPosition;
  late double _endPosition;

  @override
  void initState() {
    super.initState();
    print(
        "stattus from init ${context.read<ServiceBloc>().state.serviceUploadStatus}");
    _position = widget.size.width * 0.22;
    _startPosition = widget.size.width * 0.22;
    _endPosition = widget.size.width * 0.68;
  }

  void _onPanStart(DragStartDetails details) {
    // setState(() {
    //   _isSliding = true;
    // });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _position = details.localPosition.dx;
      if (_position > _endPosition) {
        _position = _endPosition;
      } else if (_position < _startPosition) {
        _position = _startPosition;
      }
    });
  }

  void _onPanEnd(DragEndDetails details) async {
    if (_position <= widget.size.width / 2) {
      setState(() {
        _position = _startPosition;
      });
      return;
    }
    await widget.onDismissed();
    setState(() {
      print(
          "status from state ${context.read<ServiceBloc>().state.serviceUploadStatus}");
      if (context.read<ServiceBloc>().state.serviceUploadStatus ==
          ServiceUploadStatus.initial) {
        _position = _startPosition;
      } else if (context.read<ServiceBloc>().state.serviceUploadStatus ==
          ServiceUploadStatus.loading) {
        _position = _endPosition;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("status ${widget.sliderStatus}");
    if (widget.resetPosition == true) {
      _position = _startPosition;
    }
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white60,
              ),
              width: widget.size.width * 0.58,
              height: 45,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Shimmer.fromColors(
                      baseColor: Colors.black,
                      highlightColor: Colors.grey.shade100,
                      enabled: true,
                      child: widget.label),
                ),
              ),
            ),
          ),
          Positioned(
            left: _position,
            top: 1.5,
            child: Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: Center(
                  child: Center(
                      child: (context
                                      .watch<ServiceBloc>()
                                      .state
                                      .serviceUploadStatus ==
                                  ServiceUploadStatus.success &&
                              _position == _endPosition)
                          ? Lottie.asset("assets/lottie/success.json",
                              repeat: false)
                          : widget.icon)),
            ),
          ),
        ],
      ),
    );
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                .animate(animation),
            child: child,
          ),
        );
}

class ScaleRoute extends PageRouteBuilder {
  final Widget page;
  ScaleRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              ScaleTransition(
            scale: Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
                parent: animation, curve: Curves.fastOutSlowIn)),
            child: child,
          ),
        );
}

class RotationRoute extends PageRouteBuilder {
  final Widget page;
  RotationRoute({required this.page})
      : super(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionDuration: const Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation,
                    child) =>
                RotationTransition(
                  turns: Tween<double>(begin: -0.5, end: 0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.linear)),
                  child: child,
                ));
}
