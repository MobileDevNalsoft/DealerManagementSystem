import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/providers/home_provider.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/add_customer_view.dart';
import 'package:dms/views/add_vehicle_view.dart';
import 'package:dms/views/home_proceed.dart';
import 'package:dms/views/service_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:customs/src.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
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
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
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
          child: ListView(
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
                              items: [
                                'Madhapur',
                                'Hitech city',
                                'Durgam Cheruvu',
                                'Jubilee Hills',
                                'Raidurg'
                              ],
                              icon: const Icon(Icons.arrow_drop_down),
                              focus: locFocus,
                              textcontroller: locController,
                              scrollController: scrollController,
                              isMobile: isMobile),
                          Gap(size.height * (isMobile ? 0.01 : 0.03)),
                          BlocConsumer<VehicleBloc, VehicleState>(
                            listener: (context, state) {
                              if (state.status == VehicleStatus.newVehicle) {
                                // Flushbar(
                                //         flushbarPosition: FlushbarPosition.TOP,
                                //         backgroundColor: Colors.red,
                                //         message:
                                //             'Please Register Vehicle Before Service')
                                //     .show(context);
                              }
                            },
                            builder: (context, state) {
                              return DMSCustomWidgets.CustomDataCard(
                                  context: context,
                                  size: size,
                                  hint: 'Vehicle Registration Number',
                                  onChange: (value) {
                                    context.read<VehicleBloc>().add(
                                        VehicleCheck(registrationNo: value!));
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
                          if (state.status == VehicleStatus.initial ||
                              state.status == VehicleStatus.success) {
                            return ElevatedButton(
                                onPressed: () {
                                  CustomWidgets.CustomDialogBox(
                                    context: context,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: isMobile ? 20 : 40,
                                        horizontal: isMobile ? 12 : 40),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text('Chassis no.',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text('Make',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text('Model',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text('Variant',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text('Color',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          Text('Customer Name',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          Text('Contact Person',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          Text('Contact Number',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(' : ',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text(' : ',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text(' : ',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text(' : ',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text(' : ',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          Text(' : ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          Text(' : ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          Text(' : ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          width: size.width *
                                                              (isMobile
                                                                  ? 0.39
                                                                  : 0.16),
                                                          child: Text(
                                                              'ABCDEFG1234567890',
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        ),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text('Suzuki',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text('Dzire',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text('ZXI',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        Gap(size.height *
                                                            (isMobile
                                                                ? 0.01
                                                                : 0.03)),
                                                        Text('Blue',
                                                            style: TextStyle(
                                                                fontSize:
                                                                    isMobile
                                                                        ? 12
                                                                        : 18)),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          SizedBox(
                                                            width: size.width *
                                                                0.39,
                                                            child: Text(
                                                                'Prappanssssssssssssssssssssssssssssssssssssssssssss',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        isMobile
                                                                            ? 12
                                                                            : 18)),
                                                          ),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          Text('Jack',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        if (isMobile)
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                        if (isMobile)
                                                          Text('1234567890',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (size.width > 600)
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text('Customer Name',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                          Text('Contact Person',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                          Text('Contact Number',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(' : ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                          Text(' : ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                          Text(' : ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        ],
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: size.width *
                                                                0.12,
                                                            child: Text(
                                                                'Prappanssssssssssssssssssssssssssssssssssssssssssssssss',
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18,
                                                                )),
                                                          ),
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                          Text('Jack',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                          Gap(size.height *
                                                              (isMobile
                                                                  ? 0.01
                                                                  : 0.03)),
                                                          Text('1234567890',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      isMobile
                                                                          ? 12
                                                                          : 18)),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
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
                        print(locController.text);
                        locFocus.unfocus();
                        vehRegNumFocus.unfocus();
                        customerFocus.unfocus();
                        scheduleDateFocus.unfocus();
                        kmsFocus.unfocus();
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                const Duration(milliseconds: 200),
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    HomeProceedView(),
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
          ),
        ),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: EdgeInsets.only(
                    right: isMobile ? 5 : 40, bottom: isMobile ? 15 : 25),
                child: CustomWidgets.CustomExpandableFAB(
                    horizontalAlignment: isMobile ? -17 : -40,
                    verticalAlignment: -15,
                    rotational: false,
                    angle: 90,
                    distance: isMobile ? 50 : 70,
                    color: const Color.fromARGB(255, 145, 19, 19),
                    iconColor: Colors.white,
                    children: [
                      // SizedBox(
                      //   height: size.height * 0.08,
                      //   width: size.width * (isMobile ? 0.24 : 0.1),
                      //   child: GestureDetector(
                      //     onTap: () {
                      //       Navigator.of(context).push(MaterialPageRoute(
                      //           builder: (_) => AddCustomerView()));
                      //     },
                      //     child: Column(
                      //       children: [
                      //         Image.asset(
                      //           'assets/images/add_user.png',
                      //           color: Colors.white,
                      //           fit: BoxFit.cover,
                      //           scale: isMobile ? 22 : 15,
                      //         ),
                      //         Text(
                      //           'Add Customer',
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: isMobile ? 11 : 14),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: size.height * 0.08,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => AddVehicleView()));
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
                        height: size.height * 0.085,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ServiceHistoryView(),
                            ));
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
            transitionDuration: Duration(milliseconds: 200),
            transitionsBuilder: (context, animation, secondaryAnimation,
                    child) =>
                RotationTransition(
                  turns: Tween<double>(begin: -0.5, end: 0).animate(
                      CurvedAnimation(parent: animation, curve: Curves.linear)),
                  child: child,
                ));
}
