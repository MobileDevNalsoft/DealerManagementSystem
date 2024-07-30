import 'package:another_flushbar/flushbar.dart';
import 'package:customs/src.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/service_proceed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../inits/init.dart';

class ServiceMain extends StatefulWidget {
  PageController? pageController;
  ServiceMain({Key? key, this.pageController}) : super(key: key);

  @override
  State<ServiceMain> createState() => _ServiceMain();
}

class _ServiceMain extends State<ServiceMain> {
  // focusnodes
  FocusNode locFocus = FocusNode();
  FocusNode vehRegNumFocus = FocusNode();
  FocusNode customerFocus = FocusNode();
  FocusNode scheduleDateFocus = FocusNode();
  FocusNode kmsFocus = FocusNode();

  // controllers
  TextEditingController locController = TextEditingController();
  TextEditingController locTypeAheadController = TextEditingController();
  TextEditingController vehRegNumController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController scheduleDateController = TextEditingController();
  TextEditingController kmsController = TextEditingController();

  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  GlobalKey targetKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  late ServiceBloc _serviceBloc;
  late VehicleBloc _vehicleBloc;
  late MultiBloc _multiBloc;
  bool dropDownUp = false;

  @override
  void initState() {
    super.initState();
    clearFields();
    vehRegNumFocus.addListener(_onVehRegNumUnfocused);

    _serviceBloc = context.read<ServiceBloc>();
    _vehicleBloc = context.read<VehicleBloc>();
    _multiBloc = context.read<MultiBloc>();

    _serviceBloc.add(GetServiceLocations());
    _vehicleBloc.state.status = VehicleStatus.initial;
    _multiBloc.state.date = null;

    locFocus.addListener(() {
      dropDownUp = !dropDownUp;
      _serviceBloc.add(DropDownOpen());
    });
  }

  void _onVehRegNumUnfocused() {
    if (!vehRegNumFocus.hasFocus && vehRegNumController.text.isNotEmpty) {
      context
          .read<VehicleBloc>()
          .add(FetchVehicleCustomer(registrationNo: vehRegNumController.text));
    }
  }

  void clearFields() {
    vehRegNumController.text = "";
    customerController.text = "";
    locController.text = "";
    kmsController.text = "";
    context.read<MultiBloc>().add(DateChanged(date: null));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
              child: const Center(
                child: Text(
                  textAlign: TextAlign.center,
                  'Service Main',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 16),
                ),
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
              child: BlocBuilder<ServiceBloc, ServiceState>(
                  builder: (context, state) {
                switch (state.serviceLocationsStatus) {
                  case GetServiceLocationsStatus.loading:
                    return Transform(
                      transform: Matrix4.translationValues(0, -40, 0),
                      child: Center(
                        child: Lottie.asset('assets/lottie/car_loading.json',
                            height: size.height * 0.5, width: size.width * 0.6),
                      ),
                    );
                  case GetServiceLocationsStatus.success:
                    return ListView(
                      controller: scrollController,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Gap(size.height * 0.15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DMSCustomWidgets.SearchableDropDown(
                                    size: size,
                                    hint: 'Location',
                                    items: state.locations!,
                                    onChanged: (value) {
                                      if (value != null) {
                                        locTypeAheadController.text = value;
                                        context
                                            .read<ServiceBloc>()
                                            .state
                                            .copyWith(
                                                service: Service()
                                                    .copyWith(location: value));
                                      }
                                    },
                                    icon: dropDownUp
                                        ? const Icon(Icons.arrow_drop_up)
                                        : const Icon(Icons.arrow_drop_down),
                                    focus: locFocus,
                                    textcontroller: locController,
                                    typeAheadController: locTypeAheadController,
                                    scrollController: scrollController,
                                    isMobile: isMobile),
                                Gap(size.height * (isMobile ? 0.01 : 0.03)),
                                BlocConsumer<VehicleBloc, VehicleState>(
                                  listener: (context, state) {
                                    if (state.status ==
                                        VehicleStatus.vehicleAlreadyAdded) {
                                      customerController.text =
                                          state.vehicle!.cusotmerName!;
                                    } else if (state.status ==
                                        VehicleStatus.newVehicle) {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets.only(
                                                top: size.height * 0.02,
                                                left: size.width * 0.03),
                                            content: SizedBox(
                                              height: size.height * 0.115,
                                              width: size.width * 0.5,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                      'Oops! This Vehicle not Registered with us'),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: const Text('Ok'),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else if (state.status ==
                                        VehicleStatus.failure) {
                                      Flushbar(
                                        backgroundColor: Colors.red,
                                        blockBackgroundInteraction: true,
                                        message:
                                            "Server Failure Please check the internet connectivity",
                                        flushbarPosition: FlushbarPosition.TOP,
                                        duration: const Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: size.height * 0.01,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: size.width * 0.03),
                                      ).show(context);
                                    }
                                  },
                                  builder: (context, state) {
                                    return DMSCustomWidgets.CustomDataCard(
                                        context: context,
                                        size: size,
                                        hint: 'Vehicle Registration Number',
                                        inputFormatters: [
                                          UpperCaseTextFormatter()
                                        ],
                                        icon: state.status ==
                                                VehicleStatus
                                                    .vehicleAlreadyAdded
                                            ? const Icon(
                                                Icons.check_circle_rounded)
                                            : null,
                                        isMobile: isMobile,
                                        textcontroller: vehRegNumController,
                                        focusNode: vehRegNumFocus,
                                        scrollController: scrollController);
                                  },
                                ),
                                Gap(size.height * (isMobile ? 0.01 : 0.03)),
                                BlocBuilder<VehicleBloc, VehicleState>(
                                  builder: (context, state) {
                                    return DMSCustomWidgets.CustomDataCard(
                                        context: context,
                                        size: size,
                                        hint: 'Customer Name',
                                        isMobile: isMobile,
                                        textcontroller: customerController,
                                        focusNode: customerFocus,
                                        scrollController: scrollController);
                                  },
                                ),
                                Gap(size.height * (isMobile ? 0.01 : 0.03)),
                                BlocBuilder<MultiBloc, MultiBlocState>(
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
                                Gap(size.height * (isMobile ? 0.01 : 0.03)),
                                DMSCustomWidgets.CustomDataCard(
                                    context: context,
                                    key: targetKey,
                                    size: size,
                                    hint: 'KMS',
                                    isMobile: isMobile,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    textcontroller: kmsController,
                                    focusNode: kmsFocus,
                                    scrollController: scrollController),
                              ],
                            ),
                            Row(
                              children: [
                                Gap(isMobile
                                    ? (size.width * 0.7)
                                    : (size.width * 0.595)),
                                BlocBuilder<VehicleBloc, VehicleState>(
                                  builder: (context, state) {
                                    if (state.status ==
                                        VehicleStatus.vehicleAlreadyAdded) {
                                      return ElevatedButton(
                                          onPressed: () {
                                            locFocus.unfocus();
                                            vehRegNumFocus.unfocus();
                                            customerFocus.unfocus();
                                            kmsFocus.unfocus();
                                            CustomWidgets.CustomDialogBox(
                                                context: context,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical:
                                                            isMobile ? 20 : 40,
                                                        horizontal:
                                                            isMobile ? 12 : 40),
                                                child: DMSCustomWidgets
                                                    .CustomDataFields(
                                                  context: context,
                                                  propertyList: [
                                                    "Chassis no.",
                                                    "Make",
                                                    "Model",
                                                    "Varient",
                                                    "Color"
                                                  ],
                                                  valueList: [
                                                    state.vehicle!
                                                            .chassisNumber ??
                                                        "",
                                                    state.vehicle!.make ?? "",
                                                    state.vehicle!.model ?? "",
                                                    state.vehicle!.varient ??
                                                        "",
                                                    state.vehicle!.color ?? ""
                                                  ],
                                                  propertyFontStyle: TextStyle(
                                                      fontSize:
                                                          isMobile ? 16 : 18,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  valueFontStyle: TextStyle(
                                                      fontSize:
                                                          isMobile ? 16 : 18,
                                                      fontFamily: 'Roboto'),
                                                ));
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              minimumSize: isMobile
                                                  ? const Size(65, 10)
                                                  : const Size(80.0, 20.0),
                                              padding: EdgeInsets.zero,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5))),
                                          child: Text(
                                            'view more',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: isMobile ? 12 : 14),
                                          ));
                                    } else {
                                      return SizedBox(
                                        height: size.height * 0.05,
                                      );
                                    }
                                  },
                                ),
                                Spacer(
                                  flex: isMobile
                                      ? (size.width * 0.1).round()
                                      : (size.width * 0.3).round(),
                                )
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  locFocus.unfocus();
                                  vehRegNumFocus.unfocus();
                                  customerFocus.unfocus();
                                  scheduleDateFocus.unfocus();
                                  kmsFocus.unfocus();
                                  String message = "";
                                  if (locController.text.isEmpty) {
                                    message = "Location cannot be empty";
                                  } else if (!state.locations!
                                      .contains(locController.text)) {
                                    message = "Invalid Location";
                                  } else if (vehRegNumController.text.isEmpty) {
                                    message =
                                        "Vehicle registration number cannot be empty";
                                  } else if (context
                                          .read<MultiBloc>()
                                          .state
                                          .date ==
                                      null) {
                                    message = "Please select schedule date";
                                  }
                                  if (message != "") {
                                    Flushbar(
                                      backgroundColor: Colors.red,
                                      blockBackgroundInteraction: true,
                                      message: message,
                                      flushbarPosition: FlushbarPosition.TOP,
                                      duration: const Duration(seconds: 2),
                                      borderRadius: BorderRadius.circular(12),
                                      margin: EdgeInsets.only(
                                          top: size.height * 0.01,
                                          left:
                                              isMobile ? 10 : size.width * 0.8,
                                          right: size.width * 0.03),
                                    ).show(context);
                                    return;
                                  } else {
                                    Service service = Service(
                                        registrationNo:
                                            vehRegNumController.text,
                                        scheduleDate: context
                                            .read<MultiBloc>()
                                            .state
                                            .date!
                                            .toString()
                                            .substring(0, 10),
                                        location: locController.text,
                                        kms: int.parse(kmsController.text),
                                        customerName: customerController.text);

                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 200),
                                        pageBuilder: (context, animation,
                                                secondaryAnimation) =>
                                            ServiceProceed(
                                                clearFields: clearFields,
                                                homeData: service.toJson()),
                                        transitionsBuilder: (context, animation,
                                            secondaryAnimation, child) {
                                          const begin = Offset(1, 0.0);
                                          const end = Offset.zero;
                                          final tween =
                                              Tween(begin: begin, end: end);
                                          final offsetAnimation =
                                              animation.drive(tween);
                                          return SlideTransition(
                                            position: offsetAnimation,
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(70.0, 35.0),
                                    padding: EdgeInsets.zero,
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
                                child: const Text(
                                  'next',
                                  style: TextStyle(color: Colors.white),
                                )),
                            if (MediaQuery.of(context).viewInsets.bottom != 0)
                              Gap(size.height * (isMobile ? 0.4 : 0.5)),
                          ],
                        ),
                      ],
                    );
                  default:
                    return const Center(
                      child: Text('Error'),
                    );
                }
              }),
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
        ),
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
