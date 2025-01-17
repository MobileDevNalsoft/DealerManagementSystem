import 'dart:async';

import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/clipped_buttons.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_core/core.dart';

class VehicleInfo extends StatefulWidget {
  const VehicleInfo({super.key});

  @override
  State<VehicleInfo> createState() => _VehicleInfoState();
}

class _VehicleInfoState extends State<VehicleInfo> with ConnectivityMixin {
  TextEditingController vehicleRegNoController = TextEditingController();
  FocusNode focusNode = FocusNode();
  late List<Widget> clipperWidgets;
  late Size size;

  Timer? _debounce;

  late ServiceBloc _serviceBloc;
  late VehicleBloc _vehicleBloc;

  final NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();
    _serviceBloc = context.read<ServiceBloc>();
    _vehicleBloc = context.read<VehicleBloc>();
    _serviceBloc.state.services = [];
    _serviceBloc.state.getServiceStatus = GetServiceStatus.initial;
    _vehicleBloc.add(UpdateState(vehicle: Vehicle(), status: VehicleStatus.initial));
  }

  List<Widget> initalizeWidgets() {
    size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    // Clipper widgets vehicle details and srvice history are present in a stack and swap each other dynamically.
    return clipperWidgets = [
      Stack(
        children: [
          // Service history of the vehicle
          LayoutBuilder(builder: (context, constraints) {
            return VehicleInfoClippedButton(
              decorationColor: context.watch<MultiBloc>().state.reverseClippedWidgets! ? const Color.fromARGB(136, 109, 108, 108) : null,
              shadowColor: context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.black : Colors.transparent,
              flipX: true,
              child: Transform.flip(
                // Makes the entire child to flip with respect to x-axis
                flipX: true,
                child: Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.only(
                            top: constraints.maxHeight * 0.08, right: constraints.maxWidth * (isMobile ? 0.07 : 0.12), bottom: isMobile ? 0 : 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Spacer(),
                            Icon(Icons.history, color: context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.white : Colors.black),
                            const Gap(4),
                            Text(
                              "Service History",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 16 : 18,
                                  color: context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.white : Colors.black),
                            ),
                          ],
                        )),
                    if (context.watch<MultiBloc>().state.reverseClippedWidgets!)
                      Padding(
                        padding: EdgeInsets.only(right: constraints.maxWidth * 0.12),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            width: constraints.maxWidth * 0.24,
                            child: Divider(
                              color: Colors.orange.shade200,
                            ),
                          ),
                        ),
                      ),
                    // Gap(size.height * 0.025),
                    Container(
                      margin: EdgeInsets.only(top: constraints.maxHeight * 0.032),
                      width: constraints.maxWidth * (isMobile ? 0.9 : 0.9),
                      height: constraints.maxHeight * (isMobile ? 0.3 : 0.32),
                      child: BlocConsumer<ServiceBloc, ServiceState>(
                        listener: (context, state) {
                          if (state.getServiceStatus == GetServiceStatus.success) {
                            focusNode.unfocus();
                          }
                        },
                        builder: (context, state) {
                          // Service history of the vehicle
                          return CustomScrollView(
                            slivers: [
                              (state.services == null || state.services!.isEmpty) // vehicle with no services
                                  ? SliverToBoxAdapter(
                                      child: Center(
                                          heightFactor: isMobile ? size.height * 0.01 : 8,
                                          child: Text("No services found !",
                                              style: TextStyle(
                                                  color: Colors.white, fontSize: size.width * (isMobile ? 0.045 : 0.016), fontWeight: FontWeight.w300))))
                                  : SliverList(
                                      delegate: SliverChildBuilderDelegate((context, index) {
                                      return Skeletonizer(
                                          enableSwitchAnimation: true,
                                          enabled:
                                              state.getJobCardStatus == GetJobCardStatus.loading || state.jobCardStatusUpdate == JobCardStatusUpdate.loading,
                                          child: SizedBox(
                                            width: constraints.maxWidth * (isMobile ? 0.9 : 0.72),
                                            height: constraints.maxHeight * (isMobile ? 0.14 : 0.24),
                                            child: ClipPath(
                                              clipper: TicketClipper(),
                                              child: Card(
                                                elevation: 5,
                                                surfaceTintColor: Colors.orange.shade200,
                                                shadowColor: Colors.orange.shade200,
                                                margin: EdgeInsets.symmetric(
                                                  vertical: constraints.maxHeight * 0.006,
                                                ),
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Gap(constraints.maxWidth * 0.03),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Gap(constraints.maxWidth * (isMobile ? 0.05 : 0.008)),
                                                                Image.asset(
                                                                  'assets/images/job_card.png',
                                                                  width: constraints.maxWidth * 0.048,
                                                                  // scale: constraints.maxWidth * (isMobile ? 0.05 : 0.012),
                                                                  color: Colors.black,
                                                                ),
                                                                Gap(constraints.maxWidth * (isMobile ? 0.02 : 0.012)),
                                                                Text(
                                                                  textAlign: TextAlign.center,
                                                                  state.getServiceStatus == GetServiceStatus.success ? state.services![index].jobCardNo! : 'NA',
                                                                  style: TextStyle(
                                                                    fontWeight: FontWeight.w600,
                                                                    fontSize: isMobile ? 13 : 15,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Gap(size.width * 0.01),
                                                            Row(
                                                              children: [
                                                                Gap(constraints.maxWidth * (isMobile ? 0.05 : 0.008)),
                                                                Icon(
                                                                  Icons.calendar_month_outlined,
                                                                  size: isMobile ? null : constraints.maxWidth * 0.042,
                                                                ),
                                                                Gap(constraints.maxWidth * (isMobile ? 0.02 : 0.012)),
                                                                SizedBox(
                                                                  width: constraints.maxWidth * (isMobile ? 0.28 : 0.08),
                                                                  child: SingleChildScrollView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: Text(
                                                                      textAlign: TextAlign.center,
                                                                      state.getServiceStatus == GetServiceStatus.success
                                                                          ? state.services![index].scheduledDate!
                                                                          : '-',
                                                                      style: TextStyle(fontSize: isMobile ? 13 : 15, fontWeight: FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Gap(constraints.maxWidth * 0.01),
                                                          ],
                                                        ),
                                                        Gap(constraints.maxWidth * (isMobile ? 0.01 : 0.008)),
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Gap(size.height * 0.004),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Gap(constraints.maxWidth * 0.058),
                                                                Icon(Icons.mark_unread_chat_alt_outlined, size: isMobile ? null : constraints.maxWidth * 0.04),
                                                                // Image.asset('assets/images/status.png', scale: constraints.maxWidth * 0.058),
                                                                Gap(constraints.maxWidth * (isMobile ? 0.02 : 0.016)),
                                                                Text(
                                                                  textAlign: TextAlign.center,
                                                                  state.getServiceStatus == GetServiceStatus.success
                                                                      ? state.services![index].jobType ?? 'NA'
                                                                      : 'NA',
                                                                  style: TextStyle(fontSize: isMobile ? 13 : 15, fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                            Gap(constraints.maxWidth * 0.01),
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                              children: [
                                                                Gap(constraints.maxWidth * 0.058),
                                                                Icon(Icons.location_on_outlined, size: isMobile ? null : constraints.maxWidth * 0.042),
                                                                Gap(constraints.maxWidth * (isMobile ? 0.02 : 0.016)),
                                                                Text(
                                                                  textAlign: TextAlign.center,
                                                                  state.getServiceStatus == GetServiceStatus.success
                                                                      ? state.services![index].location ?? 'NA'
                                                                      : 'NA',
                                                                  style: TextStyle(fontSize: isMobile ? 13 : 15, fontWeight: FontWeight.w600),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ));
                                    }, childCount: state.services != null ? state.services!.length : 0))
                            ],
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }),

          // Present above the "Vehicle details" and on click swaps the stack elements to display the vehicle detials
          Positioned(
            top: 18,
            left: 0,
            child: InkWell(
              splashColor: Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                context.read<MultiBloc>().add(AddClippedWidgets(reverseClippedWidgets: false));
              },
              child: SizedBox(
                width: size.width * (isMobile ? 0.4 : 0.32),
                height: size.height * (isMobile ? 0.1 : 0.12),
              ),
            ),
          ),
        ],
      ),
      Stack(
        children: [
          //Vehicle details clipped widget
          LayoutBuilder(builder: (context, constraints) {
            return VehicleInfoClippedButton(
                decorationColor: !context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.white : null,
                shadowColor: !context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.black : Colors.transparent,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: constraints.maxHeight * 0.08, left: constraints.maxWidth * (isMobile ? 0.07 : 0.12), bottom: isMobile ? 0 : 8),
                      // padding: EdgeInsets.only(top: size.height * (isMobile?0.05:0.042), right: size.width * (isMobile ? 0.40 : 0), bottom: isMobile ? 0 : 8,left: isMobile?0:size.width*0.08),
                      child: Row(
                        children: [
                          // Gap(isMobile ? constraints.maxWidth * 0.03 : constraints.maxWidth * 0.040),
                          Image.asset(
                            'assets/images/registration_no.png',
                            width: constraints.maxWidth * 0.04,
                            // scale: constraints.maxWidth * (isMobile ? 0.055 : 0.012),
                            color: Colors.black,
                          ),
                          const Gap(6),
                          Text(
                            "Vehicle Details",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 16 : 18),
                          ),
                        ],
                      ),
                      // ),
                    ),
                    if (!context.watch<MultiBloc>().state.reverseClippedWidgets!)
                      Padding(
                        padding: EdgeInsets.only(left: constraints.maxWidth * (isMobile ? 0.45 : 0.12)),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: SizedBox(
                            width: size.width * 0.24,
                            child: const Divider(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: constraints.maxHeight * (isMobile ? 0.056 : 0.08), left: constraints.maxWidth * (isMobile ? 0.08 : 0.16)),
                      child: BlocBuilder<VehicleBloc, VehicleState>(
                        builder: (context, state) {
                          return Skeletonizer(
                            enabled: context.watch<VehicleBloc>().state.status == VehicleStatus.loading,
                            child: DMSCustomWidgets.CustomDataFields(
                                context: context,
                                contentPadding: constraints.maxWidth * (isMobile ? 0.08 : 0.12),
                                spaceBetweenFields: constraints.maxWidth * (isMobile ? 0.03 : 0.02),
                                propertyFontStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                                valueFontStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                                valueWidth: constraints.maxWidth * (isMobile ? 0.4 : 0.4),
                                showColonsBetween: false,
                                propertyList: [
                                  "Vehicle Reg. no.",
                                  "Chassis no.",
                                  "Engine no.",
                                  "Customer",
                                  "Make",
                                  "Model",
                                  "Color"
                                ],
                                valueList: [
                                  state.vehicle!.vehicleRegNumber ?? "NA",
                                  state.vehicle!.chassisNumber ?? "NA",
                                  state.vehicle!.engineNumber ?? "NA",
                                  state.vehicle!.cusotmerName ?? "NA",
                                  state.vehicle!.make ?? "NA",
                                  state.vehicle!.model ?? "NA",
                                  state.vehicle!.color ?? "NA"
                                ]),
                          );
                        },
                      ),
                    )
                  ],
                ));
          }),
          // Present above the heading "Servce history" and on click swaps the stack elements to display the service history detials
          Positioned(
            top: 18,
            right: 0,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              splashColor: Colors.transparent,
              onTap: () {
                context.read<MultiBloc>().add(AddClippedWidgets(reverseClippedWidgets: true));
              },
              child: Container(
                width: size.width * (isMobile ? 0.4 : 0.32),
                height: size.height * (isMobile ? 0.1 : 0.12),
              ),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    clipperWidgets = initalizeWidgets();
    return Hero(
      tag: 'vehicleInfo',
      transitionOnUserGestures: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: false,
        appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Vehicle Info'),
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(isMobile ? 8 : 16),
              InkWell(
                onTap: () => focusNode.requestFocus(),
                overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * (isMobile ? 0.032 : 0.2)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          // padding: EdgeInsets.only(top: size.height * (isMobile ? 0.03 : 0.005)),
                          height: size.height * (isMobile ? 0.06 : 0.05),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)), color: Colors.white60),
                          child: TextFormField(
                            controller: vehicleRegNoController,
                            focusNode: focusNode,
                            style: const TextStyle(color: Colors.black),
                            onTapOutside: (event) => focusNode.unfocus(),
                            onChanged: (value) {
                              //making a call to the api once the user stop typing instead of multiple calls using debounce
                              vehicleRegNoController.text = vehicleRegNoController.text.toUpperCase();
                              if (_debounce?.isActive ?? false) _debounce!.cancel();
                              _debounce = Timer(const Duration(milliseconds: 300), () {
                                if (!isConnected()) {
                                  DMSCustomWidgets.DMSFlushbar(size, context,
                                      message: 'Looks like you'
                                          're offline. Please check your connection and try again.',
                                      icon: const Icon(
                                        Icons.error,
                                        color: Colors.white,
                                      ));
                                  return;
                                }
                                context.read<VehicleBloc>().add(FetchVehicleCustomer(registrationNo: vehicleRegNoController.text));
                                context.read<ServiceBloc>().add(GetServiceHistory(query: 'vehicle_history', vehicleRegNo: vehicleRegNoController.text));
                              });
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                              hintStyle: TextStyle(color: Colors.black38, fontSize: isMobile ? 14 : 16),
                              hintText: 'Vehicle Registration Number',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * (isMobile ? 0.14 : 0.08),
                        height: size.height * (isMobile ? 0.06 : 0.05),
                        decoration: const BoxDecoration(
                            color: Colors.black38, borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                        child: const Icon(
                          Icons.search_rounded,
                          color: Colors.white60,
                        ),
                      ),
                      // )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.44,
                width: vehicleRegNoController.text.isEmpty ? size.width * 0.2 : size.width * 0.72,
                child: BlocBuilder<VehicleBloc, VehicleState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case VehicleStatus.vehicleAlreadyAdded:
                        return Stack(children: context.watch<MultiBloc>().state.reverseClippedWidgets! ? clipperWidgets.reversed.toList() : clipperWidgets);
                      case VehicleStatus.loading:
                        return Lottie.asset(
                          "assets/lottie/steering.json",
                          // width: size.width * 0.1,
                        );
                      default:
                        if (vehicleRegNoController.text.isEmpty) {
                          return LayoutBuilder(builder: (context, psize) {
                            return Image.asset(
                              "assets/images/vehicle_search.png",
                              fit: BoxFit.scaleDown,
                            );
                          });
                        }
                        // if vehicle not found
                        return Transform(
                          transform: Matrix4.translationValues(0, size.height * 0.1, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Expanded(
                              //   flex: 20,
                              //   child: Gap(size.height * 0.01),
                              // ),
                              Expanded(
                                flex: 2,
                                child: Icon(
                                  Icons.car_crash_rounded,
                                  size: size.width * (isMobile ? 0.11 : 0.11),
                                ),
                              ),
                              if (!isMobile)
                                // Expanded(
                                //   flex: 5,
                                //   child: Gap(size.height * 0.01),
                                // ),
                                Expanded(
                                  flex: 5,
                                  child: Text(
                                    "Vehicle not found",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: (isMobile ? 20 : 25)),
                                  ),
                                ),
                            ],
                          ),
                        );
                    }
                  },
                ),
              ),
              Expanded(
                flex: context.watch<VehicleBloc>().state.status == VehicleStatus.vehicleAlreadyAdded ? 2 : 20,
                child: Gap(size.height * 0.01),
              )
            ],
          ),
        ),
      ),
    );
  }
}
