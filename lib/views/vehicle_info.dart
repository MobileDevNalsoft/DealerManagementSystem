import 'dart:async';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/custom_widgets/clipped_buttons.dart';
import 'package:dms/views/list_of_jobcards.dart';
import 'package:dms/views/jobcard_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<ServiceBloc>().add(ClearServices());
    context.read<VehicleBloc>().add(UpdateState(vehicle: Vehicle(), status: VehicleStatus.initial));
  }

  List<Widget> initalizeWidgets() {
    size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    return clipperWidgets = [
      Stack(
        children: [
          Transform.flip(
            flipX: true,
            child: ClippedButton(
              shadow: Shadow(offset: Offset(0, 0), color: context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.black : Colors.transparent),
              clipper: VehicleInfoClipper(),
              size: Size(size.width * (isMobile?0.95:0.4), size.height * (isMobile?0.5:0.56)),
              child: Transform.flip(
                flipX: true,
                child: Container(
                    width: size.width * (isMobile? 0.95:0.4),
                    decoration: BoxDecoration(
                        color: context.watch<MultiBloc>().state.reverseClippedWidgets! ? Color.fromARGB(136, 109, 108, 108) : null),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: size.height * 0.05, right: size.width * (isMobile?0.07:0.04),bottom: isMobile?0:8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Spacer(),
                              Icon(Icons.history, color: context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.white : Colors.black),
                              Gap(4),
                              Text(
                                "Service History",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.white : Colors.black),
                              ),
                            ],
                          ),
                        ),
                        if (context.watch<MultiBloc>().state.reverseClippedWidgets!)
                          Padding(
                            padding: EdgeInsets.only(left: size.width * (isMobile?0.45:0.2)),
                            child: SizedBox(
                              width: size.width * 0.16,
                              child: Divider(
                                color: Colors.orange.shade200,
                              ),
                            ),
                          ),
                        Gap(size.height * 0.025),
                        SizedBox(
                          width: size.width * (isMobile?0.9:0.48),
                          height: size.height * (isMobile? 0.3:0.32),
                          child: BlocConsumer<ServiceBloc, ServiceState>(
                            listener: (context, state) {
                              if (state.getServiceStatus == GetServiceStatus.success) {
                                focusNode.unfocus();
                              }
                            },
                            builder: (context, state) {
                              print("serevice status ${state.getServiceStatus} ${state.services}");
                              return CustomScrollView(
                                slivers: [
                                  (state.services == null || state.services!.isEmpty)
                                      ? SliverToBoxAdapter(
                                          child: Center(
                                              heightFactor: 
                                              isMobile?size.height * 0.01:8,
                                              child: Text("No services found !",
                                                  style: TextStyle(color: Colors.white, fontSize: size.width *(isMobile? 0.045:0.016), fontWeight: FontWeight.w300))))
                                      : 
                                      SliverList(
                                          delegate: SliverChildBuilderDelegate((context, index) {
                                          return Skeletonizer(
                                              enableSwitchAnimation: true,
                                              enabled: state.getJobCardStatus == GetJobCardStatus.loading ||
                                                  state.jobCardStatusUpdate == JobCardStatusUpdate.loading,
                                              child: SizedBox(
                                                width: size.width * (isMobile? 0.9:0.36),
                                                height: size.height * 0.14,
                                                child: ClipPath(
                                                  clipper: TicketClipper(),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: Card(
                                                    elevation: 5,
                                                    surfaceTintColor: Colors.orange.shade200,
                                                    shadowColor: Colors.orange.shade200,
                                                    margin: EdgeInsets.symmetric(
                                                      vertical: size.height * 0.006,
                                                    ),
                                                    color: Colors.white,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          
                                                          children: [
                                                            Gap(size.width * 0.03),
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Gap(size.width * (isMobile?0.05:0.016)),
                                                                    Image.asset(
                                                                      'assets/images/job_card.png',
                                                                      scale: size.width * (isMobile?0.05:0.02),
                                                                      color: Colors.black,
                                                                    ),
                                                                    Gap(size.width * 0.02),
                                                                    Text(
                                                                      textAlign: TextAlign.center,
                                                                      state.getServiceStatus == GetServiceStatus.success
                                                                          ? state.services![index].jobCardNo!
                                                                          : 'JC-MAD-633',
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight.w600,
                                                                          fontSize: 12,
                                                                          color: Colors.black,
                                                                          ),
                                                                    )
                                                                  ],
                                                                ),
                                                                Gap(size.width * 0.01),
                                                                Row(
                                                                  children: [
                                                                    Gap(size.width *(isMobile?0.05:0.016)),
                                                                    Icon(Icons.calendar_month_outlined),
                                                                    Gap(size.width * 0.02),
                                                                    SizedBox(
                                                                      width: size.width * (isMobile? 0.28:0.08),
                                                                      child: SingleChildScrollView(
                                                                        scrollDirection: Axis.horizontal,
                                                                        child: Text(
                                                                          textAlign: TextAlign.center,
                                                                          state.getServiceStatus == GetServiceStatus.success
                                                                              ? state.services![index].scheduledDate!
                                                                              : '12022004',
                                                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Gap(size.width * 0.01),
                                                              ],
                                                            ),
                                                            Gap(size.width * 0.01),    
                                                            Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                // Gap(size.height * 0.03),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Gap(size.width * 0.058),
                                                                    Icon(Icons.mark_unread_chat_alt_outlined),
                                                                    // Image.asset('assets/images/status.png', scale: size.width * 0.058),
                                                                    Gap(size.width * 0.02),
                                                                    Text(
                                                                      textAlign: TextAlign.center,
                                                                      state.getServiceStatus == GetServiceStatus.success
                                                                          ? state.services![index].jobType ?? '123123123'
                                                                          : '123123123',
                                                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Gap(size.width * 0.01),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                  children: [
                                                                    Gap(size.width * 0.058),
                                                                    Icon(Icons.location_on_outlined),
                                                                    Gap(size.width * 0.02),
                                                                    Text(
                                                                      textAlign: TextAlign.center,
                                                                      state.getServiceStatus == GetServiceStatus.success
                                                                          ? state.services![index].location ?? 'Location27'
                                                                          : 'Location27',
                                                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
                context.read<MultiBloc>().add(AddClippedWidgets(reverseClippedWidgets: false));
              },
              child: Container(
                width: size.width * (isMobile? 0.4: 0.24),
                height: size.height * (isMobile?0.1:0.12)
              ),
            ),
          ),
        ],
      ),
      Stack(
        children: [
          ClippedButton(
            
            shadow: Shadow(offset: Offset(0, 0), color: !context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.black : Colors.transparent),
            clipper: VehicleInfoClipper(),
            size: Size.copy(Size(size.width *(isMobile? 0.95:0.4), size.height * (isMobile?0.5:0.60))),
            child: Container(
              width:  size.width * (isMobile? 0.95:0.4),
                decoration: BoxDecoration(color: !context.watch<MultiBloc>().state.reverseClippedWidgets! ? Colors.white : null),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: size.height * 0.05, right: size.width * (isMobile?0.45:0),bottom: isMobile?0:8),
                      child: Row(
                        children: [
                          Gap(isMobile?24:size.width*0.040),
                          Image.asset(
                            'assets/images/registration_no.png',
                            scale: size.width * (isMobile? 0.055:0.016),
                            color: Colors.black,
                          ),
                          Gap(6),
                          Text(
                            "Vehicle Details",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                      // ),
                    ),

                    if (!context.watch<MultiBloc>().state.reverseClippedWidgets!)
                      Padding(
                        padding: EdgeInsets.only(right: size.width * (isMobile?0.45:0.2)),
                        child: SizedBox(
                          width: size.width * 0.16,
                          child: Divider(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(top: size.height * (isMobile?0.08:0.04), left: size.width * 0.064),
                      child: BlocBuilder<VehicleBloc, VehicleState>(
                        builder: (context, state) {
                          return DMSCustomWidgets.CustomDataFields(
                              context: context,
                              contentPadding: size.width * (isMobile?0.08:0.088),
                              spaceBetweenFields: size.width *(isMobile? 0.03:0.016),
                              propertyFontStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                              valueFontStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                              showColonsBetween: false,
                              propertyList: [
                                "Vehicle Reg. no.",
                                "Engine no.",
                                "Chassis no.",
                                "Customer",
                                "Make",
                                "Model",
                                "Color"
                              ],
                              valueList: [
                                state.vehicle!.vehicleRegNumber ?? "-",
                                state.vehicle!.engineNumber??"-",
                                state.vehicle!.chassisNumber ?? "-",
                                state.vehicle!.cusotmerName ?? "-",
                                state.vehicle!.make ?? "-",
                                state.vehicle!.model ?? "-",
                                state.vehicle!.color ?? "-"
                              ]);
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

                context.read<MultiBloc>().add(AddClippedWidgets(reverseClippedWidgets: true));
              },
              child: Container(
                width: size.width * (isMobile? 0.4:0.24),
                height: size.height * (isMobile?0.1:0.12),
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
    return SafeArea(
        child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) async {
              focusNode.unfocus();
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
                  margin: EdgeInsets.only(left: size.width * 0.045, top: isMobile ? 0 : size.height * 0.008, bottom: isMobile ? 0 : size.height * 0.008),
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, boxShadow: [
                    BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                  ]),
                  child: Transform(
                    transform: Matrix4.translationValues(-3, 0, 0),
                    child: IconButton(
                        onPressed: () {
                          focusNode.unfocus();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
                  ),
                ),
                title: Container(
                    alignment: Alignment.center,
                    height: size.height * 0.05,
                    width: isMobile ? size.width * 0.45 : size.width * 0.32,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black, boxShadow: [
                      BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                    ]),
                    child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        'Vehicle Info',
                        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
                      ),
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
                    Gap(isMobile?8:16),
                    InkWell(
                      onTap: () => focusNode.requestFocus(),
                      splashColor: Colors.transparent,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(left: size.width * (isMobile?0.03:0.32),),
                            padding: EdgeInsets.only(top: size.height * (0.033)),
                            height: size.height * 0.06,
                            width: size.width * (isMobile?0.8:0.32),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)), color: Colors.white60),
                            child: TextFormField(
                              controller: vehicleRegNoController,
                              focusNode: focusNode,
                              style: const TextStyle(color: Colors.black),
                              onTapOutside: (event) => focusNode.unfocus(),
                              onChanged: (value) {
                                vehicleRegNoController.text = vehicleRegNoController.text.toUpperCase();
                                if (_debounce?.isActive ?? false) _debounce!.cancel();
                                _debounce = Timer(const Duration(milliseconds: 300), () {
                                  if (!isConnected()) {
                                    DMSCustomWidgets.DMSFlushbar(size, context, message: 'Please check the internet connectivity', icon: Icon(Icons.error));
                                    return;
                                  }
                                  context.read<VehicleBloc>().add(FetchVehicleCustomer(registrationNo: vehicleRegNoController.text));
                                  context.read<ServiceBloc>().add(GetServiceHistory(query: 'vehicle_history', vehicleRegNo: vehicleRegNoController.text));
                                });
                              },
                              cursorColor: Colors.black,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 16),
                                hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                                hintText: 'Vehicle Registration Number',
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: size.width * (isMobile?0.03:0.32),),
                              height: size.height * 0.06,
                              decoration: const BoxDecoration(
                                  color: Colors.black38, borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))),
                              child: const Icon(
                                Icons.search_rounded,
                                color: Colors.white60,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    BlocConsumer<VehicleBloc, VehicleState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        print("building");
                        switch (state.status) {
                          case VehicleStatus.vehicleAlreadyAdded:
                            return Stack(
                                children: context.read<MultiBloc>().state.reverseClippedWidgets! == true ? clipperWidgets.reversed.toList() : clipperWidgets);
                          case VehicleStatus.loading:
                            return Transform(
                              transform: Matrix4.translationValues(0, isMobile?size.height * 0.15 : size.height * 0.1, 0),
                              child: Lottie.asset(
                                "assets/lottie/steering.json",
                                width: size.width *(isMobile? 0.6: 0.16),
                              ),
                            );
                          default:
                            if (vehicleRegNoController.text.isEmpty) {
                              return Transform(
                                transform: Matrix4.translationValues(0, size.height *(isMobile ?0.18:0.1), 0),
                                child: Lottie.asset(
                                  "assets/lottie/car_search.json",
                                  width: size.width *(isMobile? 0.6: 0.16)
                                ),
                              );
                            }
                            return Column(
                              children: [
                                Gap(size.height * (isMobile?0.25:0.16)),
                                Icon(
                                  Icons.car_crash_rounded,
                                  size: size.width * (isMobile?0.11:0.032),
                                ),
                                Text(
                                  "Vehicle not found",
                                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                                ),
                              ],
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
 
  VehicleInfoClipper();
  @override
  getClip(Size size) {
    // TODO: implement getClip
    print(size.height);
    double x1 = 0;
    double y1 = 30;
    double x = size.width;
    double y = size.height;

    Path path = Path();
    path.moveTo(x1, y1);
    path.lineTo(x1, y - 20);
    path.arcToPoint(Offset(x1 + 20, y), radius: Radius.circular(20), clockwise: false);
    path.lineTo(x - 20, y);
    path.arcToPoint(Offset(x, y - 20), radius: Radius.circular(20), clockwise: false);
    path.lineTo(x, y1 + 80);
    path.arcToPoint(Offset(x - 20, y1 + 60), radius: Radius.circular(20), clockwise: false);
    path.lineTo(x - (size.width * 0.45), y1 + 60);
    path.arcToPoint(Offset(x - (size.width * 0.45 + 20), y1 + 40), radius: Radius.circular(20), clockwise: true);
    path.lineTo(x - (size.width * 0.45 + 20), y1 + 20);
    path.arcToPoint(Offset(x - (size.width * 0.45 + 40), y1), radius: Radius.circular(20), clockwise: false);
    path.lineTo(x1 + 20, y1);
    path.arcToPoint(Offset(x1, y1 + 20), radius: Radius.circular(20), clockwise: false);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
