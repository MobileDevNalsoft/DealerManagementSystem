import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:customs/src.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/clipped_buttons.dart';
import 'package:dms/views/jobcard_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ticket_widget/ticket_widget.dart';

class VehicleInfo extends StatefulWidget {
  const VehicleInfo({super.key});

  @override
  State<VehicleInfo> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> {
  TextEditingController vehicleRegNoController = TextEditingController();
  late List<Widget> clipperWidgets;
  late Size size;
  @override
  void initState() {
    super.initState();
  }

  List<Widget> initalizeWidgets() {
    size = MediaQuery.of(context).size;
    return clipperWidgets = [
      Stack(
        children: [
          Transform.flip(
            flipX: true,
            child: ClippedButton(
              shadow: Shadow(
                  offset: const Offset(0, 0),
                  color: context.watch<MultiBloc>().state.reverseClippedWidgets!
                      ? Colors.black
                      : Colors.transparent),
              clipper: VehicleInfoClipper(
                  sizeConstraints: Size(size.width * 0.95, size.height * 0.6)),
              size: Size.copy(Size(size.width * 0.95, size.height * 0.6)),
              child: Transform.flip(
                flipX: true,
                child: Container(
                    width: size.width * 0.95,
                    decoration: BoxDecoration(
                        color: context
                                .watch<MultiBloc>()
                                .state
                                .reverseClippedWidgets!
                            ? const Color.fromARGB(136, 109, 108, 108)
                            : null),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: size.height * 0.05,
                              right: size.width * 0.09),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(),
                              Icon(
                                Icons.history,
                                color: Colors.white,
                              ),
                              Gap(4),
                              Text(
                                "Service History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Gap(size.height * 0.04),
                        SizedBox(
                          width: size.width * 0.9,
                          height: size.height * 0.3,
                          child: BlocConsumer<ServiceBloc, ServiceState>(
                            listener: (context, state) {
                              // TODO: implement listener
                            },
                            builder: (context, state) {
                              return CustomScrollView(
                                slivers: [
                                  SliverList(
                                      delegate: SliverChildBuilderDelegate(
                                          (context, index) {
                                    return Skeletonizer(
                                        enableSwitchAnimation: true,
                                        enabled: state.getJobCardStatus ==
                                                GetJobCardStatus.loading ||
                                            state.jobCardStatusUpdate ==
                                                JobCardStatusUpdate.loading,
                                        child: SizedBox(
                                          width: size.width * 0.9,
                                          height: size.height * 0.15,
                                          child: ClipPath(
                                            clipper: TicketClipper(),
                                            clipBehavior: Clip.antiAlias,
                                            child: Card(
                                              margin: EdgeInsets.symmetric(
                                                vertical: size.height * 0.006,
                                              ),
                                              color: Colors.white,
                                              elevation: 3,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Gap(size.width *
                                                                  0.05),
                                                              Image.asset(
                                                                'assets/images/job_card.png',
                                                                scale:
                                                                    size.width *
                                                                        0.05,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              Gap(size.width *
                                                                  0.02),
                                                              InkWell(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                radius: 100,
                                                                splashColor: Colors
                                                                    .transparent,
                                                                customBorder: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                                enableFeedback:
                                                                    true,
                                                                onTap: () {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (_) =>
                                                                              JobCardDetails(service: state.jobCards![index])));
                                                                },
                                                                child: Text(
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  state.getServiceStatus ==
                                                                          GetServiceStatus
                                                                              .success
                                                                      ? state
                                                                          .services![
                                                                              index]
                                                                          .jobCardNo!
                                                                      : 'JC-MAD-633',
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          12,
                                                                      color: Colors
                                                                          .blue,
                                                                      decoration:
                                                                          TextDecoration
                                                                              .underline),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                          Gap(size.width *
                                                              0.01),
                                                          Row(
                                                            children: [
                                                              Gap(size.width *
                                                                  0.055),
                                                              const Icon(Icons
                                                                  .calendar_month_outlined),
                                                              Gap(size.width *
                                                                  0.02),
                                                              SizedBox(
                                                                width:
                                                                    size.width *
                                                                        0.28,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  child: Text(
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    state.getServiceStatus ==
                                                                            GetServiceStatus
                                                                                .success
                                                                        ? state
                                                                            .services![index]
                                                                            .scheduledDate!
                                                                        : '12022004',
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Gap(size.width *
                                                              0.01),
                                                        ],
                                                      ),
                                                      Gap(size.width * 0.01),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          // Gap(size.height * 0.03),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Gap(size.width *
                                                                  0.058),
                                                              const Icon(Icons
                                                                  .mark_unread_chat_alt_outlined),
                                                              // Image.asset('assets/images/status.png', scale: size.width * 0.058),
                                                              Gap(size.width *
                                                                  0.02),
                                                              Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                state.getServiceStatus ==
                                                                        GetServiceStatus
                                                                            .success
                                                                    ? state.services![index]
                                                                            .jobType ??
                                                                        '123123123'
                                                                    : '123123123',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                          Gap(size.width *
                                                              0.01),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Gap(size.width *
                                                                  0.058),
                                                              const Icon(Icons
                                                                  .location_on_outlined),
                                                              Gap(size.width *
                                                                  0.02),
                                                              Text(
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                state.getServiceStatus ==
                                                                        GetServiceStatus
                                                                            .success
                                                                    ? state.services![index]
                                                                            .location ??
                                                                        'Location27'
                                                                    : 'Location27',
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        13,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  // Container(
                                                  //   height: size.height * 0.05,
                                                  //   width: size.width * 0.94,
                                                  //   decoration: BoxDecoration(
                                                  //       color: Colors.orange.shade200,
                                                  //       borderRadius:
                                                  //           const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                                  //   child: Row(
                                                  //     mainAxisAlignment: MainAxisAlignment.center,
                                                  //     children: [
                                                  //       Row(
                                                  //         children: [
                                                  //           Image.asset(
                                                  //             'assets/images/customer.png',
                                                  //             scale: size.width * 0.06,
                                                  //           ),
                                                  //           Gap(size.width * 0.02),
                                                  //           SizedBox(
                                                  //             width: size.width * 0.36,
                                                  //             child: SingleChildScrollView(
                                                  //               scrollDirection: Axis.horizontal,
                                                  //               child: Text(
                                                  //                 'Customer Name',
                                                  //                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                  //               ),
                                                  //             ),
                                                  //           ),
                                                  //         ],
                                                  //       ),
                                                  //       Gap(size.width * 0.1),
                                                  //       Row(
                                                  //         children: [
                                                  //           Image.asset(
                                                  //             'assets/images/call.png',
                                                  //             scale: size.width * 0.06,
                                                  //           ),
                                                  //           Gap(size.width * 0.02),
                                                  //           SizedBox(
                                                  //             width: size.width * 0.25,
                                                  //             child: SingleChildScrollView(
                                                  //               scrollDirection: Axis.horizontal,
                                                  //               child: Text(
                                                  //                 // state.getJobCardStatus ==
                                                  //                 //         GetJobCardStatus.success
                                                  //                 //     ? state.jobCards![index]
                                                  //                 //             .customerContact ??
                                                  //                 // '-'
                                                  //                 // :
                                                  //                 'Contact Number',
                                                  //                 style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                  //               ),
                                                  //             ),
                                                  //           ),
                                                  //         ],
                                                  //       )
                                                  //     ],
                                                  //   ),
                                                  // )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ));
                                  },
                                          childCount: state.services != null
                                              ? state.services!.length
                                              : 0))
                                ],
                              );
                            },
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ),
          Positioned(
            top: 18,
            left: 0,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                print("inside service");
                context
                    .read<MultiBloc>()
                    .add(AddClippedWidgets(reverseClippedWidgets: false));
              },
              child: Container(
                width: size.width * 0.4,
                height: size.height * 0.07,
              ),
            ),
          ),
        ],
      ),
      Stack(
        children: [
          ClippedButton(
            shadow: Shadow(
                offset: const Offset(0, 0),
                color: !context.watch<MultiBloc>().state.reverseClippedWidgets!
                    ? Colors.black
                    : Colors.transparent),
            clipper: VehicleInfoClipper(
                sizeConstraints: Size(size.width * 0.95, size.height * 0.6)),
            size: Size.copy(Size(size.width * 0.95, size.height * 0.6)),
            child: Container(
                decoration: BoxDecoration(
                    color:
                        !context.watch<MultiBloc>().state.reverseClippedWidgets!
                            ? Colors.white
                            : null),
                child: Column(
                  children: [
                    Align(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: size.height * 0.05, right: size.width * 0.45),
                        child: Row(
                          children: [
                            const Gap(16),
                            Image.asset(
                              'assets/images/registration_no.png',
                              scale: size.width * 0.055,
                              color: Colors.black,
                            ),
                            const Gap(4),
                            const Text(
                              "Vehicle Details",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        // ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: size.height * 0.08, left: size.width * 0.1),
                      child: BlocConsumer<VehicleBloc, VehicleState>(
                        listener: (context, state) {
                          // TODO: implement listener
                        },
                        builder: (context, state) {
                          return Skeletonizer(
                            enabled:
                                context.watch<VehicleBloc>().state.status ==
                                    VehicleStatus.loading,
                            child: DMSCustomWidgets.CustomDataFields(
                                context: context,
                                contentPadding: size.width * 0.08,
                                spaceBetweenFields: size.width * 0.03,
                                propertyFontStyle: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 16),
                                valueFontStyle: const TextStyle(
                                    fontWeight: FontWeight.w800, fontSize: 16),
                                propertyList: [
                                  "Vehicle Reg. no.",
                                  "Chassis no.",
                                  "Customer",
                                  "Make",
                                  "Model",
                                  "Color"
                                ],
                                valueList: [
                                  state.vehicle!.vehicleRegNumber ?? "-",
                                  state.vehicle!.chassisNumber ?? "-",
                                  state.vehicle!.cusotmerName ?? "-",
                                  state.vehicle!.make ?? "-",
                                  state.vehicle!.model ?? "-",
                                  state.vehicle!.color ?? "-"
                                ]),
                          );
                        },
                      ),
                    )
                  ],
                )),
          ),
          Positioned(
            top: 18,
            right: 0,
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                print("inside details");

                context
                    .read<MultiBloc>()
                    .add(AddClippedWidgets(reverseClippedWidgets: true));
              },
              child: Container(
                width: size.width * 0.4,
                height: size.height * 0.1,
              ),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    clipperWidgets = initalizeWidgets();
    return SafeArea(
        child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              Navigator.pop(context);
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody: false,
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
                      'Vehicle Info',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16),
                    )),
                centerTitle: true,
              ),
              body: Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black45, Colors.black26, Colors.black45],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    const Gap(8),
                    Container(
                      width: size.width * 0.85,
                      height: size.height * 0.05,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(14)),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2.2),
                        child: Container(
                            width: size.width * 0.6,
                            height: size.height * 0.2,
                            alignment: Alignment.center,
                            child: TextFormField(
                              controller: vehicleRegNoController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: "Vehicle Reg. no....",
                                  hintStyle: TextStyle(color: Colors.white70)),
                              onChanged: (value) {
                                vehicleRegNoController.text =
                                    vehicleRegNoController.text.toUpperCase();
                                // context.read<MultiBloc>().add(MultiBlocStatusChange(status: MultiStateStatus.loading));
                                context.read<VehicleBloc>().add(
                                    FetchVehicleCustomer(
                                        registrationNo:
                                            vehicleRegNoController.text));
                                context.read<ServiceBloc>().add(
                                    GetServiceHistory(
                                        query: 'vehicle_history',
                                        vehicleRegNo:
                                            vehicleRegNoController.text));
                                // context.read<MultiBloc>().add(MultiBlocStatusChange(status: MultiStateStatus.success));
                              },
                            )),
                      ),
                    ),
                    BlocConsumer<VehicleBloc, VehicleState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        print("building");
                        switch (state.status) {
                          case VehicleStatus.vehicleAlreadyAdded:
                            return Stack(
                                children: context
                                            .read<MultiBloc>()
                                            .state
                                            .reverseClippedWidgets! ==
                                        true
                                    ? clipperWidgets.reversed.toList()
                                    : clipperWidgets);
                          case VehicleStatus.loading:
                            return Lottie.asset(
                              "assets/lottie/steering.json",
                              width: size.width * 0.6,
                            );
                          default:
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.car_crash_rounded,
                                    size: size.width * 0.11,
                                  ),
                                  const Text(
                                    "Vehicle not found",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 20),
                                  ),
                                ],
                              ),
                            );
                        }
                      },
                    )
                  ],
                ),
              ),
            )));
  }
}

class VehicleInfoClipper extends CustomClipper<Path> {
  Size sizeConstraints;
  VehicleInfoClipper({
    required this.sizeConstraints,
  });
  @override
  getClip(Size size) {
    // TODO: implement getClip
    print(size.height);
    double x1 = 0;
    double y1 = 20;
    double x = sizeConstraints.width;
    double y = sizeConstraints.height;

    Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x1, y - 20);
    path.arcToPoint(Offset(x1 + 20, y),
        radius: const Radius.circular(20), clockwise: false);
    path.lineTo(x - 20, y);
    path.arcToPoint(Offset(x, y - 20),
        radius: const Radius.circular(20), clockwise: false);
    path.lineTo(x, y1 + 80);
    path.arcToPoint(Offset(x - 20, y1 + 60),
        radius: const Radius.circular(20), clockwise: false);
    path.lineTo(x - 150, y1 + 60);
    path.arcToPoint(Offset(x - 170, y1 + 40),
        radius: const Radius.circular(20), clockwise: true);
    path.lineTo(x - 170, y1 + 20);
    path.arcToPoint(Offset(x - 190, y1),
        radius: const Radius.circular(20), clockwise: false);
    path.lineTo(x1 + 20, y1);
    path.arcToPoint(Offset(x1, y1 + 20),
        radius: const Radius.circular(20), clockwise: false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
