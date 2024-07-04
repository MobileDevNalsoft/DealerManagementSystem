import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/providers/home_provider.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/add_vehicle.dart';
import 'package:dms/views/inspection.dart';
import 'package:dms/views/inspection_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:customs/src.dart';

import '../logger/logger.dart';

class HomeProceedView extends StatefulWidget {
  @override
  Map<String, dynamic> homeData;
  Function? clearFields;

  HomeProceedView({super.key, required this.homeData, this.clearFields});
  State<HomeProceedView> createState() => _HomeProceedView();
}

class _HomeProceedView extends State<HomeProceedView> {
  FocusNode bookingFocus = FocusNode();
  FocusNode altContFocus = FocusNode();
  FocusNode altContPhoneNoFocus = FocusNode();
  FocusNode spFocus = FocusNode();
  FocusNode bayFocus = FocusNode();
  FocusNode jobTypeFocus = FocusNode();
  FocusNode custConcernsFocus = FocusNode();
  FocusNode remarksFocus = FocusNode();
  TextEditingController bookingController = TextEditingController();
  TextEditingController bookingTypeAheadController = TextEditingController();
  TextEditingController altContController = TextEditingController();
  TextEditingController altContPhoneNoController = TextEditingController();
  TextEditingController spController = TextEditingController();
  TextEditingController spTypeAheadController = TextEditingController();
  TextEditingController bayController = TextEditingController();
  TextEditingController bayTypeAheadController = TextEditingController();

  TextEditingController jobTypeController = TextEditingController();
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
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
          title: const Text(
            "Service",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: size.height * (0.05),
                        ),
                        Consumer<HomeProvider>(
                          builder: (context, provider, child) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                DMSCustomWidgets.SearchableDropDown(
                                    items: ["Online", "Walk-in"],
                                    size: size,
                                    hint: 'Booking Source',
                                    onChanged: (p0) {
                                      if (p0 != null) {
                                        bookingTypeAheadController.text = p0;
                                      }
                                    },
                                    isMobile: isMobile,
                                    focus: bookingFocus,
                                    textcontroller: bookingController,
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
                                    inputFormatters: [
                                      InitCapCaseTextFormatter()
                                    ],
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
                                        onChanged: (p0) {
                                          if (p0 != null) {
                                            spTypeAheadController.text = p0;
                                          }
                                          if (p0!.length >= 3) {
                                            context.read<MultiBloc>().add(
                                                GetSalesPersons(
                                                    searchText: p0));
                                          } else {
                                            context
                                                .read<MultiBloc>()
                                                .state
                                                .salesPersons = null;
                                          }
                                        },
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
                                        textcontroller: spController,
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
                                    onChanged: (p0) {
                                      if (p0 != null) {
                                        bayTypeAheadController.text = p0;
                                      }
                                    },
                                    focus: bayFocus,
                                    textcontroller: bayController,
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
                                    onChanged: (p0) {
                                      if (p0 != null) {
                                        jobTypeAheadController.text = p0;
                                      }
                                    },
                                    // icon: const Icon(Icons.arrow_drop_down),
                                    focus: jobTypeFocus,
                                    textcontroller: jobTypeController,
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
                                    isMobile: isMobile,
                                    focusNode: remarksFocus,
                                    textcontroller: remarksController),
                                SizedBox(
                                  height:
                                      size.height * (isMobile ? 0.05 : 0.015),
                                ),
                              ],
                            );
                          },
                        ),
                        BlocConsumer<ServiceBloc, ServiceState>(
                          listener: (context, state) {
                            switch (state.serviceUploadStatus) {
                              case ServiceUploadStatus.success:
                                widget.clearFields!();
                                bookingController.text = "";
                                altContController.text = "";
                                altContPhoneNoController.text = "";
                                spController.text = "";
                                bayController.text = "";
                                jobTypeController.text = "";
                                custConcernsController.text = "";
                                remarksController.text = "";
                                Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP,
                                        backgroundColor: Colors.green,
                                        message: 'Service Added Successfully',
                                        duration: const Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10))
                                    .show(context);
                                context.read<MultiBloc>().state.date = null;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const InspectionView()));
                              case ServiceUploadStatus.failure:
                                Flushbar(
                                        flushbarPosition: FlushbarPosition.TOP,
                                        backgroundColor: Colors.red,
                                        message: 'Some error occured',
                                        duration: const Duration(seconds: 2),
                                        borderRadius: BorderRadius.circular(12),
                                        margin: EdgeInsets.only(
                                            top: 24,
                                            left: isMobile
                                                ? 10
                                                : size.width * 0.8,
                                            right: 10))
                                    .show(context);

                              default:
                                null;
                            }
                          },
                          builder: (context, state) {
                            return BlocBuilder<MultiBloc, MultiBlocState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                    onPressed: () {
                                      bookingFocus.unfocus();
                                      altContFocus.unfocus();
                                      spFocus.unfocus();
                                      bayFocus.unfocus();
                                      jobTypeFocus.unfocus();
                                      custConcernsFocus.unfocus();
                                      remarksFocus.unfocus();

                                      String? message = _bookingSourceValidator(
                                              bookingController.text) ??
                                          (altContController.text.isEmpty
                                              ? "Alternate Contact Person cannot be empty"
                                              : null) ??
                                          _altPersonContactNoValidation(
                                              altContPhoneNoController.text) ??
                                          _salesPersonValidator(
                                              spController.text,
                                              (state.salesPersons ?? [])
                                                  .map((e) => e.empName)
                                                  .toList()) ??
                                          _bayValidator(
                                              bayController.text, bayList) ??
                                          _jobTypeValidator(
                                              jobTypeController.text,
                                              jobTypeList);

                                      if (message != null) {
                                        Flushbar(
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                          backgroundColor: Colors.red,
                                          message: message,
                                          duration: const Duration(seconds: 2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          margin: EdgeInsets.only(
                                              top: size.height * 0.01,
                                              left: isMobile
                                                  ? 10
                                                  : size.width * 0.8,
                                              right: size.width * 0.03),
                                        ).show(context);
                                      } else {
                                        Service service =
                                            Service.fromJson(widget.homeData);

                                        Service finalService = Service(
                                            registrationNo:
                                                service.registrationNo,
                                            location: service.location,
                                            customerName: service.customerName,
                                            scheduleDate: service.scheduleDate,
                                            kms: service.kms,
                                            bookingSource:
                                                bookingController.text,
                                            alternateContactPerson:
                                                altContController.text,
                                            alternatePersonContactNo: int.parse(
                                                altContPhoneNoController.text),
                                            salesPerson:
                                                spController.text.split('-')[0],
                                            bay: bayController.text,
                                            jobType: jobTypeController.text,
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
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(140.0, 35.0),
                                        padding: EdgeInsets.zero,
                                        backgroundColor: const Color.fromARGB(
                                            255, 145, 19, 19),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5))),
                                    child: const Text(
                                      'proceed to recieve',
                                      style: TextStyle(color: Colors.white),
                                    ));
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
              ),
            ),
            if (context.watch<ServiceBloc>().state.serviceUploadStatus ==
                ServiceUploadStatus.loading)
              Container(
                color: Colors.black54,
                child: Center(
                    child: Lottie.asset('assets/lottie/car_loading.json',
                        height: size.height * 0.5, width: size.width * 0.6)),
              )
          ],
        ),
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddVehicleView()));
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const AddVehicleView()));
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
