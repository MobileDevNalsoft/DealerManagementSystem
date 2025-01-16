import 'package:customs/src.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../inits/init.dart';
import '../navigations/navigator_service.dart';

class ServiceBooking extends StatefulWidget {
  const ServiceBooking({super.key});

  @override
  State<ServiceBooking> createState() => _ServiceBooking();
}

class _ServiceBooking extends State<ServiceBooking> with ConnectivityMixin {
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
  ServiceBookingSliderButtonController sliderButtonController =
      ServiceBookingSliderButtonController();

  final NavigatorService navigator = getIt<NavigatorService>();

  bool bookingSourceDropDownUp = false;
  bool salesPersonDropDownUp = false;
  bool bayDropDownUp = false;
  bool jobTypeDropDownUp = false;

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
    vehRegNumFocus.addListener(_onVehRegNumUnfocused);
    _serviceBloc = context.read<ServiceBloc>();
    _vehicleBloc = context.read<VehicleBloc>();
    _multiBloc = context.read<MultiBloc>();
    //Fetching sales persons with names statring from 'ab'
    _multiBloc.add(GetSalesPersons(searchText: "ab"));
    _vehicleBloc.state.status = VehicleStatus.initial;

    // Fetching locations if not already fetched.
    if (_serviceBloc.state.locations == null) {
      _serviceBloc.add(GetSBRequirements());
    }

    if (_vehicleBloc.state.registrationNo != null) {
      vehRegNumController.text = _vehicleBloc.state.registrationNo!;
      _vehicleBloc.state.status = VehicleStatus.initial;
      _vehicleBloc
          .add(FetchVehicleCustomer(registrationNo: vehRegNumController.text));
    } else {
      Future.delayed(const Duration(milliseconds: 500), () {
        vehRegNumFocus.requestFocus();
      });
    }

    _multiBloc.state.date = null;
    locTypeAheadController.text =
        sharedPreferences.getStringList('locations')!.first;

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
        _vehicleBloc.add(
            FetchVehicleCustomer(registrationNo: vehRegNumController.text));
      }
    } else {
      DMSCustomWidgets.DMSFlushbar(size, context,
          message: 'Looks like you'
              're offline. Please check your connection and try again.',
          icon: const Icon(
            Icons.error,
            color: Colors.white,
          ));
    }
  }

  //To clear all the text fields once the service data is uploaded.
  void clearFields() {
    vehRegNumController.clear();
    customerController.clear();
    locTypeAheadController.clear();
    kmsController.clear();
    bookingTypeAheadController.clear();
    altContController.clear();
    altContPhoneNoController.clear();
    spTypeAheadController.clear();
    bayTypeAheadController.clear();
    jobTypeTypeAheadController.clear();
    custConcernsController.clear();
    remarksController.clear();
  }

// removing focus for all the fields when needed.
  void unFocusFields() {
    bookingFocus.unfocus();
    altContFocus.unfocus();
    altContPhoneNoFocus.unfocus();
    spFocus.unfocus();
    bayFocus.unfocus();
    jobTypeFocus.unfocus();
    custConcernsFocus.unfocus();
    remarksFocus.unfocus();
  }

  void disposeFields() {
    vehRegNumController.dispose();
    customerController.dispose();
    locTypeAheadController.dispose();
    kmsController.dispose();
    bookingTypeAheadController.dispose();
    altContController.dispose();
    altContPhoneNoController.dispose();
    spTypeAheadController.dispose();
    bayTypeAheadController.dispose();
    jobTypeTypeAheadController.dispose();
    custConcernsController.dispose();
    remarksController.dispose();
    vehRegNumFocus.dispose();
    bookingFocus.dispose();
    altContFocus.dispose();
    altContPhoneNoFocus.dispose();
    spFocus.dispose();
    bayFocus.dispose();
    jobTypeFocus.dispose();
    custConcernsFocus.dispose();
    remarksFocus.dispose();
  }

  @override
  void dispose() {
    _vehicleBloc.state.registrationNo = null;
    disposeFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    size = MediaQuery.of(context).size;
    bool isMobile = size.shortestSide < 500;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SizedBox(
        height: size.height,
        width: size.width,
        child: PageView.builder(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 2,
          itemBuilder: (context, index) {
            return PopScope(
              canPop: index == 1 ? false : true,
              onPopInvoked: (didPop) async {
                //Navigating to page 1 when user is in page 2
                if (index == 1) {
                  pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease);
                }
              },
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                extendBodyBehindAppBar: false,
                appBar: DMSCustomWidgets.appBar(
                    size: size,
                    isMobile: isMobile,
                    title: 'Service Booking',
                    leadingOnPressed: () {
                      if (index == 0) {
                        navigator.pop();
                      } else {
                        pageController.animateToPage(0,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      }
                    }),
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
                        child:
                            //Service booking first page
                            index == 0
                                ? BlocBuilder<ServiceBloc, ServiceState>(
                                    builder: (context, state) {
                                    switch (state.getSBRequirementsStatus) {
                                      case GetSBRequirementsStatus.loading:
                                        return Transform(
                                          transform: Matrix4.translationValues(
                                              0, -40, 0),
                                          child: Center(
                                            child: Lottie.asset(
                                                'assets/lottie/car_loading.json',
                                                height: isMobile
                                                    ? size.height * 0.5
                                                    : size.height * 0.32,
                                                width: isMobile
                                                    ? size.width * 0.6
                                                    : size.width * 0.32),
                                          ),
                                        );

                                      //After fetching the locations
                                      case GetSBRequirementsStatus.success:
                                        return ListView(
                                          controller: page1ScrollController,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Gap(size.height * 0.13),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    DMSCustomWidgets
                                                        .SearchableDropDown(
                                                            size: size,
                                                            hint: '*Location',
                                                            items: state
                                                                .locations!,
                                                            icon: dropDownUp
                                                                ? Icon(
                                                                    Icons
                                                                        .arrow_drop_up,
                                                                    size: size
                                                                            .height *
                                                                        0.03,
                                                                  )
                                                                : Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    size: size
                                                                            .height *
                                                                        0.03),
                                                            focus: locFocus,
                                                            typeAheadController:
                                                                locTypeAheadController,
                                                            scrollController:
                                                                page1ScrollController,
                                                            isMobile: isMobile),
                                                    Gap(size.height *
                                                        (isMobile
                                                            ? 0.01
                                                            : 0.03)),
                                                    BlocConsumer<VehicleBloc,
                                                        VehicleState>(
                                                      listener:
                                                          (context, state) {
                                                        switch (state.status) {
                                                          case VehicleStatus
                                                                .vehicleAlreadyAdded:
                                                            customerController
                                                                    .text =
                                                                state.vehicle!
                                                                    .cusotmerName!;
                                                          case VehicleStatus
                                                                .newVehicle:
                                                            FocusManager
                                                                .instance
                                                                .primaryFocus
                                                                ?.unfocus();
                                                            customerController
                                                                .text = '';
                                                            if (navigator
                                                                .navigatorkey
                                                                .currentState!
                                                                .mounted) {
                                                              showRegistrationDialog(
                                                                  size: size,
                                                                  state: state);
                                                            }
                                                          case VehicleStatus
                                                                .failure:
                                                            DMSCustomWidgets
                                                                .DMSFlushbar(
                                                                    size,
                                                                    context,
                                                                    message:
                                                                        'Something went wrong. Please try again later',
                                                                    icon:
                                                                        const Icon(
                                                                      Icons
                                                                          .error,
                                                                      color: Colors
                                                                          .white,
                                                                    ));
                                                          default:
                                                            null;
                                                        }
                                                      },
                                                      builder:
                                                          (context, state) {
                                                        return DMSCustomWidgets
                                                            .CustomDataCard(
                                                                context:
                                                                    context,
                                                                size: size,
                                                                hint:
                                                                    '*Vehicle Registration Number',
                                                                inputFormatters: [
                                                                  UpperCaseTextFormatter()
                                                                ],
                                                                icon: state.status ==
                                                                        VehicleStatus
                                                                            .vehicleAlreadyAdded
                                                                    ? Padding(
                                                                        padding:
                                                                            EdgeInsets.only(bottom: size.height * (isMobile ? 0 : 0.005)),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .check_circle_rounded,
                                                                          size: size.height *
                                                                              0.03,
                                                                        ),
                                                                      )
                                                                    : null,
                                                                isMobile:
                                                                    isMobile,
                                                                textcontroller:
                                                                    vehRegNumController,
                                                                focusNode:
                                                                    vehRegNumFocus,
                                                                scrollController:
                                                                    page1ScrollController);
                                                      },
                                                    ),
                                                    Gap(size.height *
                                                        (isMobile
                                                            ? 0.01
                                                            : 0.03)),
                                                    BlocBuilder<VehicleBloc,
                                                        VehicleState>(
                                                      builder:
                                                          (context, state) {
                                                        return DMSCustomWidgets.CustomDataCard(
                                                            context: context,
                                                            size: size,
                                                            hint:
                                                                'Customer Name',
                                                            isMobile: isMobile,
                                                            textcontroller:
                                                                customerController,
                                                            readOnly: true,
                                                            focusNode:
                                                                customerFocus,
                                                            scrollController:
                                                                page1ScrollController);
                                                      },
                                                    ),
                                                    Gap(size.height *
                                                        (isMobile
                                                            ? 0.01
                                                            : 0.03)),
                                                    BlocBuilder<MultiBloc,
                                                        MultiBlocState>(
                                                      builder:
                                                          (context, state) {
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
                                                        (isMobile
                                                            ? 0.01
                                                            : 0.03)),
                                                    DMSCustomWidgets
                                                        .CustomDataCard(
                                                            context: context,
                                                            key: targetKey,
                                                            size: size,
                                                            hint: '*KMS',
                                                            isMobile: isMobile,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
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
                                                Gap(size.height * 0.02),
                                                // view more dialog box
                                                Row(
                                                  children: [
                                                    Gap(size.width *
                                                        (isMobile ? 0.7 : 0.7)),
                                                    BlocBuilder<VehicleBloc,
                                                        VehicleState>(
                                                      builder:
                                                          (context, state) {
                                                        if (state.status ==
                                                            VehicleStatus
                                                                .vehicleAlreadyAdded) {
                                                          return GestureDetector(
                                                              onTap: () {
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
                                                                              fontSize: isMobile ? 16 : 18,
                                                                              fontFamily: 'Montserrat',
                                                                              fontWeight: FontWeight.bold),
                                                                          valueFontStyle: TextStyle(
                                                                              fontSize: isMobile ? 16 : 18,
                                                                              fontFamily: 'Roboto'),
                                                                        ));
                                                              },
                                                              child: Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  height:
                                                                      size.height *
                                                                          0.025,
                                                                  width: size
                                                                          .width *
                                                                      (isMobile
                                                                          ? 0.18
                                                                          : 0.1),
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: Colors
                                                                          .black,
                                                                      boxShadow: [
                                                                        BoxShadow(
                                                                            blurRadius:
                                                                                10,
                                                                            blurStyle: BlurStyle
                                                                                .outer,
                                                                            spreadRadius:
                                                                                0,
                                                                            color:
                                                                                Colors.orange.shade200,
                                                                            offset: const Offset(0, 0))
                                                                      ]),
                                                                  child:
                                                                      const Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    'view more',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            12),
                                                                  )));
                                                        } else {
                                                          return SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.05,
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
                                                Gap(size.height * 0.05),
                                                GestureDetector(
                                                  onTap: () {
                                                    FocusManager
                                                        .instance.primaryFocus
                                                        ?.unfocus();

                                                    String? message =
                                                        (!isConnected()
                                                                ? 'Looks like you'
                                                                    're offline. Please check your connection and try again.'
                                                                : null) ??
                                                            _locationValidator(
                                                                locTypeAheadController
                                                                    .text) ??
                                                            (vehRegNumController
                                                                    .text
                                                                    .isEmpty
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
                                                            (kmsController.text
                                                                    .isEmpty
                                                                ? "kms cannot be empty"
                                                                : null);

                                                    if (message != null) {
                                                      DMSCustomWidgets
                                                          .DMSFlushbar(
                                                              size, context,
                                                              message: message,
                                                              icon: const Icon(
                                                                Icons.error,
                                                                color: Colors
                                                                    .white,
                                                              ));
                                                      return;
                                                    } else {
                                                      pageController.animateToPage(
                                                          1,
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      500),
                                                          curve: Curves.ease);
                                                    }
                                                  },
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      height:
                                                          size.height * 0.045,
                                                      width: size.width *
                                                          (isMobile
                                                              ? 0.2
                                                              : 0.15),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          color: Colors.black,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 10,
                                                                blurStyle:
                                                                    BlurStyle
                                                                        .outer,
                                                                spreadRadius: 0,
                                                                color: Colors
                                                                    .orange
                                                                    .shade200,
                                                                offset:
                                                                    const Offset(
                                                                        0, 0))
                                                          ]),
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        'next',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: (isMobile
                                                                ? 16
                                                                : 18)),
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
                                :
                                //Service booking second  page
                                ListView(
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
                                                      items: [
                                                        "Online",
                                                        "Walk-in"
                                                      ],
                                                      size: size,
                                                      hint: '*Booking Source',
                                                      isMobile: isMobile,
                                                      focus: bookingFocus,
                                                      typeAheadController:
                                                          bookingTypeAheadController,
                                                      icon: bookingSourceDropDownUp
                                                          ? Icon(
                                                              Icons
                                                                  .arrow_drop_up,
                                                              size:
                                                                  size.height *
                                                                      0.03)
                                                          : Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              size:
                                                                  size.height *
                                                                      0.03),
                                                      scrollController:
                                                          page2ScrollController),
                                                  SizedBox(
                                                    height: size.height *
                                                        (isMobile
                                                            ? 0.005
                                                            : 0.015),
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
                                                        (isMobile
                                                            ? 0.005
                                                            : 0.015),
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
                                                        (isMobile
                                                            ? 0.005
                                                            : 0.015),
                                                  ),
                                                  // Sales person searchable dropdown with inital values starting from letting 'ab'
                                                  BlocBuilder<MultiBloc,
                                                      MultiBlocState>(
                                                    builder: (context, state) {
                                                      return DMSCustomWidgets
                                                          .SearchableDropDown(
                                                              onChanged: (p0) {
                                                                if (!isConnected()) {
                                                                  DMSCustomWidgets.DMSFlushbar(
                                                                      size,
                                                                      context,
                                                                      message:
                                                                          'Looks like you'
                                                                          're offline. Please check your connection and try again.',
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .white,
                                                                      ));
                                                                  return;
                                                                }
                                                                spTypeAheadController
                                                                    .text = p0;
                                                                if (p0.length >=
                                                                    3) {
                                                                  _multiBloc.add(
                                                                      GetSalesPersons(
                                                                          searchText:
                                                                              p0));
                                                                } else {
                                                                  _multiBloc
                                                                          .state
                                                                          .salesPersons =
                                                                      null;
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
                                                              hint:
                                                                  '*Sales Person',
                                                              icon: salesPersonDropDownUp
                                                                  ? Icon(Icons.arrow_drop_up,
                                                                      size: size.height *
                                                                          0.03)
                                                                  : Icon(Icons.arrow_drop_down,
                                                                      size: size.height *
                                                                          0.03),
                                                              isMobile:
                                                                  isMobile,
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
                                                        (isMobile
                                                            ? 0.005
                                                            : 0.015),
                                                  ),
                                                  DMSCustomWidgets.SearchableDropDown(
                                                      items: bayList,
                                                      size: size,
                                                      hint: '*Bay',
                                                      isMobile: isMobile,
                                                      icon: bayDropDownUp
                                                          ? Icon(
                                                              Icons
                                                                  .arrow_drop_up,
                                                              size:
                                                                  size.height *
                                                                      0.03)
                                                          : Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              size:
                                                                  size.height *
                                                                      0.03),
                                                      focus: bayFocus,
                                                      typeAheadController:
                                                          bayTypeAheadController,
                                                      scrollController:
                                                          page2ScrollController),
                                                  SizedBox(
                                                    height: size.height *
                                                        (isMobile
                                                            ? 0.005
                                                            : 0.015),
                                                  ),
                                                  BlocBuilder<ServiceBloc,
                                                      ServiceState>(
                                                    builder: (context, state) {
                                                      return DMSCustomWidgets.SearchableDropDown(
                                                          size: size,
                                                          hint: '*Job Type',
                                                          items:
                                                              state.jobTypes!,
                                                          icon: jobTypeDropDownUp
                                                              ? Icon(
                                                                  Icons
                                                                      .arrow_drop_up,
                                                                  size:
                                                                      size.height *
                                                                          0.03)
                                                              : Icon(
                                                                  Icons
                                                                      .arrow_drop_down,
                                                                  size:
                                                                      size.height *
                                                                          0.03),
                                                          focus: jobTypeFocus,
                                                          typeAheadController:
                                                              jobTypeTypeAheadController,
                                                          isMobile: isMobile,
                                                          scrollController:
                                                              page2ScrollController);
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: size.height *
                                                        (isMobile
                                                            ? 0.005
                                                            : 0.015),
                                                  ),
                                                  DMSCustomWidgets.CustomTextFieldCard(
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
                                                        (isMobile
                                                            ? 0.005
                                                            : 0.015),
                                                  ),
                                                  DMSCustomWidgets
                                                      .CustomTextFieldCard(
                                                          size: size,
                                                          hint: 'Remarks',
                                                          context: context,
                                                          scrollController:
                                                              page2ScrollController,
                                                          isMobile: isMobile,
                                                          focusNode:
                                                              remarksFocus,
                                                          textcontroller:
                                                              remarksController),
                                                  SizedBox(
                                                    height: size.height * 0.05,
                                                  ),
                                                ],
                                              ),
                                              BlocConsumer<ServiceBloc,
                                                  ServiceState>(
                                                listener: (context, state) {
                                                  switch (state
                                                      .serviceUploadStatus) {
                                                    //Navigating to Inspection in after successful upload of service booking
                                                    case ServiceUploadStatus
                                                          .success:
                                                      DMSCustomWidgets.DMSFlushbar(
                                                          size, context,
                                                          message:
                                                              'Service Booking Successful',
                                                          icon: const Icon(
                                                            Icons
                                                                .check_circle_rounded,
                                                            color: Colors.white,
                                                          ));
                                                      context
                                                          .read<MultiBloc>()
                                                          .state
                                                          .date = null;
                                                      _vehicleBloc.state
                                                              .registrationNo =
                                                          null;
                                                      _vehicleBloc
                                                              .state.status =
                                                          VehicleStatus.initial;
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                      sliderButtonController
                                                              .position =
                                                          SliderButtonPosition
                                                              .left;
                                                    //Handling failure case from the backend (eg. Found multiple records with same location.)
                                                    case ServiceUploadStatus
                                                          .failure:
                                                      sliderButtonController
                                                              .position =
                                                          SliderButtonPosition
                                                              .left;
                                                      DMSCustomWidgets.DMSFlushbar(
                                                          size, context,
                                                          message:
                                                              'Something went wrong. Please try again later',
                                                          icon: const Icon(
                                                            Icons.error,
                                                            color: Colors.white,
                                                          ));
                                                    default:
                                                      null;
                                                  }
                                                },
                                                builder: (context, state) {
                                                  return BlocBuilder<MultiBloc,
                                                      MultiBlocState>(
                                                    builder: (context, state) {
                                                      return SizedBox(
                                                        width: size.width *
                                                            (isMobile
                                                                ? 0.56
                                                                : 0.3),
                                                        child: LayoutBuilder(
                                                          builder: (context,
                                                              contraints) {
                                                            return CustomSliderButton(
                                                              isMobile:
                                                                  isMobile,
                                                              sliderController:
                                                                  sliderButtonController,
                                                              context: context,
                                                              size: contraints,
                                                              label: const Text(
                                                                "Proceed to receive",
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff4a4a4a),
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        17),
                                                              ),
                                                              icon: const Icon(
                                                                Icons
                                                                    .arrow_forward_ios_rounded,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              onDismissed:
                                                                  () async {
                                                                if (!isConnected()) {
                                                                  DMSCustomWidgets.DMSFlushbar(
                                                                      size,
                                                                      context,
                                                                      message:
                                                                          'Looks like you'
                                                                          're offline. Please check your connection and try again.',
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .white,
                                                                      ));
                                                                  return;
                                                                }
                                                                // Validating the textfields and displaying appropriate error snackbars.
                                                                String? message = _bookingSourceValidator(bookingTypeAheadController.text) ??
                                                                    _altPersonContactNoValidation(
                                                                        altContPhoneNoController
                                                                            .text) ??
                                                                    _salesPersonValidator(
                                                                        spTypeAheadController
                                                                            .text,
                                                                        (state.salesPersons ??
                                                                                [])
                                                                            .map((e) => e
                                                                                .empName)
                                                                            .toList()) ??
                                                                    _bayValidator(
                                                                        bayTypeAheadController
                                                                            .text,
                                                                        bayList) ??
                                                                    _jobTypeValidator(
                                                                        jobTypeTypeAheadController
                                                                            .text,
                                                                        _serviceBloc
                                                                            .state
                                                                            .jobTypes!);

                                                                if (message !=
                                                                    null) {
                                                                  DMSCustomWidgets.DMSFlushbar(
                                                                      size,
                                                                      context,
                                                                      message:
                                                                          message,
                                                                      icon:
                                                                          const Icon(
                                                                        Icons
                                                                            .error,
                                                                        color: Colors
                                                                            .white,
                                                                      ));
                                                                } else {
                                                                  Service service = Service(
                                                                      registrationNo: vehRegNumController.text,
                                                                      location: locTypeAheadController.text,
                                                                      customerName: customerController.text,
                                                                      scheduledDate: state.date.toString().substring(0, 10),
                                                                      kms: int.parse(kmsController.text),
                                                                      bookingSource: bookingTypeAheadController.text,
                                                                      alternateContactPerson: altContController.text,
                                                                      alternatePersonContactNo: altContPhoneNoController.text.isNotEmpty ? int.parse(altContPhoneNoController.text) : null,
                                                                      // salesPerson: spTypeAheadController.text.split('-')[0],
                                                                      salesPerson: sharedPreferences.getString('user_name'),
                                                                      bay: bayTypeAheadController.text,
                                                                      jobType: jobTypeTypeAheadController.text,
                                                                      customerConcerns: custConcernsController.text,
                                                                      remarks: remarksController.text);
                                                                  _serviceBloc
                                                                          .state
                                                                          .service =
                                                                      service;

                                                                  _serviceBloc.add(
                                                                      ServiceAdded(
                                                                          service:
                                                                              service));
                                                                }
                                                              },
                                                            );
                                                          },
                                                        ),
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
                                height: isMobile
                                    ? size.height * 0.5
                                    : size.height * 0.32,
                                width: isMobile
                                    ? size.width * 0.6
                                    : size.width * 0.32)),
                      )
                  ],
                ),
              ),
            );
          },
        ),
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

  String? _jobTypeValidator(String value, List<dynamic> jobTypeList) {
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
          return PopScope(
            canPop: false,
            child: AlertDialog(
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
                        'Oops!\nThis Vehicle not registered with us.',
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
                                navigator.pop();
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
                                state.registrationNo = vehRegNumController.text;
                                navigator.pop();
                                navigator.popAndPush('/addVehicle');
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
                buttonPadding: EdgeInsets.zero),
          );
        });
  }
}

class CustomSliderButton extends StatefulWidget {
  final BoxConstraints size;
  final BuildContext context;
  final Widget label;
  final Widget icon;
  final onDismissed;
  final bool isMobile;
  final ServiceBookingSliderButtonController sliderController;

  const CustomSliderButton(
      {Key? key,
      required this.size,
      required this.context,
      required this.label,
      required this.icon,
      required this.onDismissed,
      required this.sliderController,
      required this.isMobile})
      : super(key: key);

  @override
  _CustomSliderButtonState createState() => _CustomSliderButtonState();
}

class _CustomSliderButtonState extends State<CustomSliderButton> {
  late double _position;
  late double _startPosition;
  late double _endPosition;
  late ServiceBookingSliderButtonController _sliderController;
  @override
  void initState() {
    super.initState();
    _initController();

    _position = widget.size.maxWidth * 0.01;
    _startPosition = widget.size.maxWidth * 0.01;
    _endPosition = widget.size.maxWidth * (widget.isMobile ? 0.78 : 0.77);
    _sliderController.currentPosition = widget.size.maxWidth * 0.01;

    //Updating the initial position of the slider
    if (_sliderController.position == SliderButtonPosition.right) {
      _sliderController.currentPosition = _endPosition;
    } else if (_sliderController.position == SliderButtonPosition.left) {
      _sliderController.currentPosition = _startPosition;
    }
  }

  void _initController() {
    _sliderController = widget.sliderController;
  }

  //Slider in motion
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _sliderController.currentPosition = details.localPosition.dx;
      if (_sliderController.currentPosition > _endPosition) {
        _sliderController._position = SliderButtonPosition.right;
        _sliderController._currentPosition = _endPosition;
      } else if (_sliderController.currentPosition < _startPosition) {
        _sliderController._position = SliderButtonPosition.left;
        _sliderController._currentPosition = _startPosition;
      } else {
        _sliderController.position = SliderButtonPosition.moving;
      }
    });
  }

  //on Slider motion end
  void _onPanEnd(DragEndDetails details) async {
    if (_sliderController.currentPosition <= widget.size.maxWidth / 2) {
      setState(() {
        _sliderController.currentPosition = _startPosition;
        _sliderController.position = SliderButtonPosition.left;
        // _position = _startPosition;
      });
      return;
    }
    await widget.onDismissed();
    setState(() {
      // Updating the posiition based on the Service upload status
      if (context.read<ServiceBloc>().state.serviceUploadStatus ==
          ServiceUploadStatus.initial) {
        _sliderController.currentPosition = _startPosition;
        _sliderController.position = SliderButtonPosition.left;
      } else if (context.read<ServiceBloc>().state.serviceUploadStatus ==
          ServiceUploadStatus.loading) {
        _sliderController.currentPosition = _endPosition;
        _sliderController.position = SliderButtonPosition.right;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // updating the slider postion in the controller
    if (_sliderController.position != SliderButtonPosition.moving) {
      if (_sliderController.position == SliderButtonPosition.right) {
        _sliderController.currentPosition = _endPosition;
      } else if (_sliderController.position == SliderButtonPosition.left) {
        _sliderController.currentPosition = _startPosition;
      }
    }
    print(
        "from build current position${_sliderController.currentPosition} ${_startPosition} ${_endPosition}");
    return GestureDetector(
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
              width: widget.size.maxWidth,
              height: (widget.isMobile ? 45 : 55),
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
            left: _sliderController.currentPosition,
            top: 1.5,
            child: Container(
              width: (widget.isMobile ? 42 : 52),
              height: (widget.isMobile ? 42 : 52),
              decoration: BoxDecoration(
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      color: Colors.orange.shade200,
                      blurRadius: 20,
                      spreadRadius: 0)
                ],
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

class ServiceBookingSliderButtonController extends ChangeNotifier {
  SliderButtonPosition _position;
  double? _currentPosition;

  ServiceBookingSliderButtonController(
      {SliderButtonPosition position = SliderButtonPosition.left})
      : _position = position;

  set position(position) {
    _position = position;
    notifyListeners();
  }

  SliderButtonPosition get position => _position;

  set currentPosition(currentPosition) {
    _currentPosition = currentPosition;
    notifyListeners();
  }

  get currentPosition => _currentPosition;
}

enum SliderButtonPosition { left, right, moving }
