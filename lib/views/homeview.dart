import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/add_vehicle_view.dart';
import 'package:dms/views/home_proceed.dart';
import 'package:dms/views/inspection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:customs/src.dart';
import 'package:gap/gap.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  FocusNode locFocus = FocusNode();
  FocusNode vehRegNumFocus = FocusNode();
  FocusNode customerFocus = FocusNode();
  FocusNode scheduleDateFocus = FocusNode();
  FocusNode kmsFocus = FocusNode();
  TextEditingController locController = TextEditingController();
  TextEditingController vehRegNumController = TextEditingController();
  TextEditingController customerController = TextEditingController();
  TextEditingController scheduleDateController = TextEditingController();
  TextEditingController kmsController = TextEditingController();

  GlobalKey targetKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    vehRegNumFocus.addListener(_onVehRegNumUnfocused);
    context.read<ServiceBloc>().add(GetServiceLocations());
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
      child: GestureDetector(
        onTap: () {
          locFocus.unfocus();
          vehRegNumFocus.unfocus();
          customerFocus.unfocus();
          kmsFocus.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: const Color.fromARGB(255, 145, 19, 19),
            // leading: IconButton(
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //     icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
            title: const Text(
              "Service",
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
            padding: const EdgeInsets.only(top: 20),
            controller: scrollController,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(size.height * 0.15),
                  Consumer<HomeProvider>(
                    builder: (context, provider, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                           DMSCustomWidgets.SearchableDropDown(
                                size: size,
                                hint: 'Location',
                                items: state.locations!,
                                icon: locFocus.hasFocus
                                    ? const Icon(Icons.arrow_drop_up)
                                    : const Icon(Icons.arrow_drop_down),
                                focus: locFocus,
                                textcontroller: locController,
                                scrollController: scrollController,
                                isMobile: isMobile),
                          Gap(size.height * (isMobile ? 0.01 : 0.03)),
                          BlocConsumer<VehicleBloc, VehicleState>(
                            listener: (context, state) {
                              if (state.status ==
                                  VehicleStatus.vehicleAlreadyAdded) {
                                customerController.text =
                                    state.vehicle!.cusotmerName!;
                              }
                              else if(state.status ==
                                  VehicleStatus.failure){
                                  Flushbar(
                                  flushbarPosition: FlushbarPosition.TOP,
                                  backgroundColor: Colors.red,
                                  mainButton: InkWell(
                                    onTap: () {
                                      context.read<VehicleBloc>().state.status =
                                          VehicleStatus.initial;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AddVehicleView()));
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.directions_car),
                                        Text(
                                          "Add Vehicle",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  margin: EdgeInsets.only(top:24),
                                  maxWidth: size.width*0.6,
                                  duration: Duration(seconds: 5),
                                  message:
                                      'Please register vehicle before service')
                              .show(context);
                              }
                            },
                            builder: (context, state) {
                              return DMSCustomWidgets.CustomDataCard(
                                  context: context,
                                  size: size,
                                  hint: 'Vehicle Registration Number',
                                  onChange: (value) {
                                    if (value!.length == 10)
                                      context.read<VehicleBloc>().add(
                                          FetchVehicleCustomer(
                                              registrationNo: value));
                                  },
                                  icon: state.status ==
                                          VehicleStatus.vehicleAlreadyAdded
                                      ? const Icon(Icons.check_circle_rounded)
                                      : null,
                                  isMobile: isMobile,
                                  textcontroller: vehRegNumController,
                                  focusNode: vehRegNumFocus,
                                  scrollController: scrollController);
                            },
                          ),
                          Gap(size.height * (isMobile ? 0.01 : 0.03)),
                          DMSCustomWidgets.CustomDataCard(
                              context: context,
                              size: size,
                              hint: 'Customer Name',
                              isMobile: isMobile,
                              textcontroller: customerController,
                              focusNode: customerFocus,
                              scrollController: scrollController),
                          Gap(size.height * (isMobile ? 0.01 : 0.03)),
                          BlocBuilder<MultiBloc, MultiBlocState>(
                            builder: (context, state) {
                              return DMSCustomWidgets.ScheduleDateCalendar(
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
                      );
                    },
                  ),
                  Row(
                    children: [
                      Gap(isMobile ? (size.width * 0.7) : (size.width * 0.595)),
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
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: isMobile ? 20 : 40,
                                          horizontal: isMobile ? 12 : 40),
                                      child: DMSCustomWidgets.CustomDataFields(
                                        context: context,
                                        propertyList: [
                                          "Chassis no.",
                                          "Make",
                                          "Model",
                                          "Varient",
                                          "Color"
                                        ],
                                        valueList: [
                                          state.vehicle!.chassisNumber ?? "",
                                          state.vehicle!.make ?? "",
                                          state.vehicle!.model ?? "",
                                          state.vehicle!.varient ?? "",
                                          state.vehicle!.color ?? ""
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
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    minimumSize: isMobile
                                        ? const Size(65, 10)
                                        : const Size(80.0, 20.0),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5))),
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
        
                        }else if (!state.locations!
                                  .contains(locController.text)) {
                                message = "Invalid Location"; 
                        else if (vehRegNumController.text.isEmpty) {
                          message =
                              "Vehicle registration number cannot be empty";
                        } else if (context.read<MultiBloc>().state.date ==
                            null) {
                          message = "Please select schedule date";
                        }
                        if (message != "") {
                          Flushbar(
                            backgroundColor: Colors.red,
                            blockBackgroundInteraction: true,
                            message: message,
                            flushbarPosition: FlushbarPosition.TOP,
                            duration: Duration(seconds: 2),
                            borderRadius: BorderRadius.circular(12),
                            margin: EdgeInsets.only(
                                top: 24,
                                left: isMobile ? 10 : size.width * 0.8,
                                right: 10),
                          ).show(context);
                          return;
                        }
        
                        if (context.read<VehicleBloc>().state.status ==
                            VehicleStatus.vehicleAlreadyAdded) {
                          print("vehicle present");
                          // context.read<VehicleBloc>().state.status =
                          //     VehicleStatus.initial;
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 200),
                              pageBuilder: (context, animation,
                                      secondaryAnimation) =>
                                  HomeProceedView(
                                    clearFields: clearFields,
                                      service: Service(
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
                                          customerName:
                                              customerController.text)),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1, 0.0);
                                const end = Offset.zero;
                                final tween = Tween(begin: begin, end: end);
                                final offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        } else {
                          print("vehicle not present");
                          Flushbar(
                                  flushbarPosition: FlushbarPosition.TOP,
                                  backgroundColor: Colors.red,
                                  mainButton: InkWell(
                                    onTap: () {
                                      context.read<VehicleBloc>().state.status =
                                          VehicleStatus.initial;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  AddVehicleView()));
                                    },
                                    child: Column(
                                      children: [
                                        Icon(Icons.directions_car),
                                        Text(
                                          "Add Vehicle",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  margin: EdgeInsets.only(top:24),
                                  maxWidth: size.width*0.6,
                                  duration: Duration(seconds: 5),
                                  message:
                                      'Please register vehicle before service')
                              .show(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size(70.0, 35.0),
                          padding: EdgeInsets.zero,
                          backgroundColor:
                              const Color.fromARGB(255, 145, 19, 19),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5))),
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
                return const SizedBox();
            }
          }),
        ),
      ),
    ));
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
