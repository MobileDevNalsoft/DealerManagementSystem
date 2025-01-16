import 'package:another_flushbar/flushbar.dart';
import 'package:customs/src.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/models/services.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/add_vehicle.dart';
import 'package:dms/views/inspection_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

import '../../logger/logger.dart';

class ServiceProceedSample extends StatefulWidget {
  @override
  Map<String, dynamic> homeData;
  Function? clearFields;

  ServiceProceedSample({super.key, required this.homeData, this.clearFields});
  State<ServiceProceedSample> createState() => _ServiceProceedSample();
}

class _ServiceProceedSample extends State<ServiceProceedSample> {
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

  TextEditingController jobTypeAheadController = TextEditingController();

  TextEditingController custConcernsController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  SuggestionsController suggestionsController = SuggestionsController();
  ScrollController scrollController = ScrollController();

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

  late ServiceBloc _serviceBloc;
  NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();
    _serviceBloc = context.read<ServiceBloc>();
    _serviceBloc.state.serviceUploadStatus = ServiceUploadStatus.initial;
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

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

    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: const Color.fromARGB(255, 145, 19, 19),
          leading: IconButton(
              onPressed: () {
                navigator.pop();
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
          title: const Text(
            "Service",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body:
            // Stack(
            //   children: [

            GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      // Color.fromARGB(255, 255, 231, 231),
                      Color.fromARGB(255, 241, 193, 193),
                      Color.fromARGB(255, 235, 136, 136),
                      Color.fromARGB(255, 226, 174, 174)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.01, 0.35, 1]),
              ),
              child: ListView(
                controller: scrollController,
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: size.height * (0.05),
                          ),
                          Column(
                            children: [
                              DMSCustomWidgets.SearchableDropDown(
                                  items: ["Online", "Walk-in"],
                                  size: size,
                                  hint: 'Booking Source',
                                  isMobile: isMobile,
                                  focus: bookingFocus,
                                  typeAheadController:
                                      bookingTypeAheadController,
                                  icon: const Icon(Icons.arrow_drop_down),
                                  scrollController: scrollController),
                              SizedBox(
                                height:
                                    size.height * (isMobile ? 0.005 : 0.015),
                              ),
                              DMSCustomWidgets.CustomDataCard(
                                  context: context,
                                  size: size,
                                  hint: 'Alternate Contact Person',
                                  inputFormatters: [InitCapCaseTextFormatter()],
                                  isMobile: isMobile,
                                  focusNode: altContFocus,
                                  textcontroller: altContController,
                                  scrollController: scrollController),
                              SizedBox(
                                height:
                                    size.height * (isMobile ? 0.005 : 0.015),
                              ),
                              DMSCustomWidgets.CustomDataCard(
                                  context: context,
                                  size: size,
                                  hint: 'Alternate Person Contact No.',
                                  isMobile: isMobile,
                                  focusNode: altContPhoneNoFocus,
                                  textcontroller: altContPhoneNoController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10)
                                  ],
                                  scrollController: scrollController),
                              SizedBox(
                                height:
                                    size.height * (isMobile ? 0.005 : 0.015),
                              ),
                              BlocBuilder<MultiBloc, MultiBlocState>(
                                builder: (context, state) {
                                  return DMSCustomWidgets.SearchableDropDown(
                                      size: size,
                                      items: state.salesPersons == null
                                          ? []
                                          : state.salesPersons!
                                              .map((e) =>
                                                  "${e.empName}-${e.empId}")
                                              .toList(),
                                      hint: 'Sales Person',
                                      // icon: const Icon(Icons.arrow_drop_down),
                                      isMobile: isMobile,
                                      isLoading: state.status ==
                                              MultiStateStatus.loading
                                          ? true
                                          : false,
                                      focus: spFocus,
                                      typeAheadController:
                                          spTypeAheadController,
                                      suggestionsController:
                                          suggestionsController,
                                      scrollController: scrollController);
                                },
                              ),
                              SizedBox(
                                height:
                                    size.height * (isMobile ? 0.005 : 0.015),
                              ),
                              DMSCustomWidgets.SearchableDropDown(
                                  items: bayList,
                                  size: size,
                                  hint: 'Bay',
                                  isMobile: isMobile,
                                  focus: bayFocus,
                                  typeAheadController: bayTypeAheadController,
                                  scrollController: scrollController),
                              SizedBox(
                                height:
                                    size.height * (isMobile ? 0.005 : 0.015),
                              ),
                              DMSCustomWidgets.SearchableDropDown(
                                  size: size,
                                  hint: 'Job Type',
                                  items: jobTypeList,
                                  // icon: const Icon(Icons.arrow_drop_down),
                                  focus: jobTypeFocus,
                                  typeAheadController: jobTypeAheadController,
                                  // provider: provider,
                                  isMobile: isMobile,
                                  scrollController: scrollController),
                              SizedBox(
                                height:
                                    size.height * (isMobile ? 0.005 : 0.015),
                              ),
                              DMSCustomWidgets.CustomTextFieldCard(
                                  size: size,
                                  hint: 'Customer Concerns',
                                  context: context,
                                  scrollController: scrollController,
                                  isMobile: isMobile,
                                  focusNode: custConcernsFocus,
                                  textcontroller: custConcernsController),
                              SizedBox(
                                height:
                                    size.height * (isMobile ? 0.005 : 0.015),
                              ),
                              DMSCustomWidgets.CustomTextFieldCard(
                                  size: size,
                                  hint: 'Remarks',
                                  context: context,
                                  scrollController: scrollController,
                                  isMobile: isMobile,
                                  focusNode: remarksFocus,
                                  textcontroller: remarksController),
                              SizedBox(
                                height: size.height * (isMobile ? 0.05 : 0.015),
                              ),
                            ],
                          ),
                          BlocConsumer<ServiceBloc, ServiceState>(
                            listener: (context, state) {
                              switch (state.serviceUploadStatus) {
                                case ServiceUploadStatus.success:
                                  widget.clearFields!();
                                  bookingTypeAheadController.text = "";
                                  altContController.text = "";
                                  altContPhoneNoController.text = "";
                                  spTypeAheadController.text = "";
                                  bayTypeAheadController.text = "";
                                  jobTypeAheadController.text = "";
                                  custConcernsController.text = "";
                                  remarksController.text = "";
                                  DMSCustomWidgets.DMSFlushbar(size, context,
                                      message: 'Service Added Successfully');

                                  context.read<MultiBloc>().state.date = null;
                                  navigator.pushReplacement("/inspectionIn");
                                case ServiceUploadStatus.failure:
                                  DMSCustomWidgets.DMSFlushbar(size, context,
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
                              return BlocBuilder<MultiBloc, MultiBlocState>(
                                builder: (context, state) {
                                  return CustomSliderButton(
                                    context: context,
                                    size: size,
                                    sliderStatus: context
                                        .watch<ServiceBloc>()
                                        .state
                                        .serviceUploadStatus!,
                                    label: const Text(
                                      "Proceed to receive",
                                      style: TextStyle(
                                          color: Color(0xff4a4a4a),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 17),
                                    ),
                                    icon: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Color.fromARGB(255, 145, 19, 19),
                                    ),
                                    onDismissed: () async {
                                      bookingFocus.unfocus();
                                      altContFocus.unfocus();
                                      spFocus.unfocus();
                                      bayFocus.unfocus();
                                      jobTypeFocus.unfocus();
                                      custConcernsFocus.unfocus();
                                      remarksFocus.unfocus();
                                      print(jobTypeAheadController.text);

                                      String? message = _bookingSourceValidator(
                                              bookingTypeAheadController
                                                  .text) ??
                                          (altContController.text.isEmpty
                                              ? "Alternate Contact Person cannot be empty"
                                              : null) ??
                                          _altPersonContactNoValidation(
                                              altContPhoneNoController.text) ??
                                          _salesPersonValidator(
                                              spTypeAheadController.text,
                                              (state.salesPersons ?? [])
                                                  .map((e) => e.empName)
                                                  .toList()) ??
                                          _bayValidator(
                                              bayTypeAheadController.text,
                                              bayList) ??
                                          _jobTypeValidator(
                                              jobTypeAheadController.text,
                                              jobTypeList);

                                      if (message != null) {
                                        DMSCustomWidgets.DMSFlushbar(
                                            size, context,
                                            message: message,
                                            icon: const Icon(
                                              Icons.error,
                                              color: Colors.white,
                                            ));
                                      } else {
                                        Service service =
                                            Service.fromJson(widget.homeData);

                                        Service finalService = Service(
                                            registrationNo:
                                                service.registrationNo,
                                            location: service.location,
                                            customerName: service.customerName,
                                            scheduledDate:
                                                service.scheduledDate,
                                            kms: service.kms,
                                            bookingSource:
                                                bookingTypeAheadController.text,
                                            alternateContactPerson:
                                                altContController.text,
                                            alternatePersonContactNo: int.parse(
                                                altContPhoneNoController.text),
                                            salesPerson: spTypeAheadController
                                                .text
                                                .split('-')[0],
                                            bay: bayTypeAheadController.text,
                                            jobType:
                                                jobTypeAheadController.text,
                                            jobCardNo:
                                                'JC-${service.location!.substring(0, 3).toUpperCase()}-${service.kms.toString().substring(0, 2)}',
                                            customerConcerns:
                                                custConcernsController.text,
                                            remarks: remarksController.text);

                                        Log.d(finalService.toJson());
                                        context.read<ServiceBloc>().add(
                                            ServiceAdded(
                                                service: finalService));
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          if (MediaQuery.of(context).viewInsets.bottom != 0)
                            SizedBox(
                              height: size.height * (isMobile ? 0.4 : 0.5),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              )),
        ),

        // if(context.watch<ServiceBloc>().state.serviceUploadStatus ==
        //     ServiceUploadStatus.loading)
        //   Container(
        //     color: Colors.black54,
        //     child: Center(
        //         child: Lottie.asset('assets/lottie/car_loading.json',
        //             height: size.height * 0.5, width: size.width * 0.6)),
        //   ),
        //   ],
        // ),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: EdgeInsets.only(
                    right: isMobile ? 5 : 40, bottom: isMobile ? 15 : 25),
                child: CustomWidgets.CustomExpandableFAB(
                    horizontalAlignment: isMobile ? -17 : -38,
                    verticalAlignment: -15,
                    rotational: false,
                    angle: 90,
                    distance: isMobile ? 50 : 70,
                    color: const Color.fromARGB(255, 145, 19, 19),
                    iconColor: Colors.white,
                    children: [
                      SizedBox(
                        height: size.height * 0.08,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          onTap: () {
                            navigator.pushReplacement("/addVehicle");
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/car.png',
                                color: Colors.white,
                                fit: BoxFit.cover,
                                scale: isMobile ? 22 : 15,
                              ),
                              Text(
                                'Add Vehicle',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 11 : 14),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.09,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          onTap: () {
                            context.read<VehicleBloc>().add(UpdateState(
                                status: VehicleStatus.initial,
                                vehicle: Vehicle()));
                            widget.clearFields!();
                            navigator.pushReplacement("/addVehicle");
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: isMobile ? 28 : 40,
                                color: Colors.white,
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
      ),
    );
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
    if (value.isEmpty) {
      return "Alternate Person Contact Number can't be empty!";
    } else if (!contactNoRegex.hasMatch(value)) {
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
}

class CustomSliderButton extends StatefulWidget {
  final Size size;
  final BuildContext context;
  final Widget label;
  final Widget icon;
  final onDismissed;
  ServiceUploadStatus sliderStatus;
  CustomSliderButton(
      {Key? key,
      required this.size,
      required this.context,
      required this.label,
      required this.icon,
      required this.onDismissed,
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
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 235, 136, 136),
              ),
              width: widget.size.width * 0.58,
              height: 45,
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0),
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
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Center(
                  child: Stack(
                children: [
                  Center(
                      child: (context
                                      .watch<ServiceBloc>()
                                      .state
                                      .serviceUploadStatus ==
                                  ServiceUploadStatus.success &&
                              _position == _endPosition)
                          ? Lottie.asset("assets/lottie/success.json",
                              repeat: false)
                          : widget.icon),
                  if (context.watch<ServiceBloc>().state.serviceUploadStatus ==
                      ServiceUploadStatus.loading)
                    Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        strokeWidth: widget.size.width * 0.008,
                        strokeCap: StrokeCap.round,
                      ),
                    )
                ],
              )),
            ),
          ),
        ],
      ),
    );
  }
}
