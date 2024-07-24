import 'dart:io';

import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/views/custom_widgets/draggable_sheet.dart';
import 'package:dms/views/service_main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../inits/init.dart';
import '../models/services.dart';
import 'custom_widgets/clipped_buttons.dart';
import 'jobcard_details.dart';
import 'login.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late ServiceBloc _serviceBloc;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    // initiating service bloc variable
    _serviceBloc = context.read<ServiceBloc>();

    // setting initial statuses of service and job card status to initial
    _serviceBloc.state.getServiceStatus = GetServiceStatus.initial;
    _serviceBloc.state.getJobCardStatus = GetJobCardStatus.initial;

    // invoking getjob cards and getservice history to invoke bloc method to get data from db
    _serviceBloc.add(GetJobCards(query: 'Main  Workshop'));
    _serviceBloc.add(GetServiceHistory(query: '2022'));

    // set default orientation to portrait up
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    // responsive UI
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        Navigator.pop(context);
        // await showDialog(
        //   context: context,
        //   builder: (BuildContext context) {
        //     return SizedBox(
        //       height: size.height * 0.03,
        //       child: AlertDialog(
        //         backgroundColor: const Color.fromARGB(255, 245, 216, 216),
        //         contentPadding: EdgeInsets.only(
        //             left: size.width * 0.04, top: size.height * 0.02),
        //         content: const Text('Are you sure you want to exit the app?'),
        //         actionsPadding: EdgeInsets.zero,
        //         buttonPadding: EdgeInsets.zero,
        //         actions: [
        //           TextButton(
        //             onPressed: () {
        //               Navigator.pop(context, false); // Don't exit
        //             },
        //             style: TextButton.styleFrom(
        //                 foregroundColor:
        //                     const Color.fromARGB(255, 145, 19, 19)),
        //             child: const Text('No'),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               exit(0); // Exit
        //             },
        //             style: TextButton.styleFrom(
        //                 foregroundColor:
        //                     const Color.fromARGB(255, 145, 19, 19)),
        //             child: const Text('Yes'),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // );
      },
      child: Scaffold(
        extendBody:
            false, // restricts the scaffold till above the bottom navigation bar in this case
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.black45, Colors.black26, Colors.black45],
                  stops: [0.1, 0.5, 1]),
            ),
            child: BlocBuilder<ServiceBloc, ServiceState>(
              builder: (context, state) {
                return PageView(
                    controller: pageController,
                    onPageChanged: (value) {
                      // if (value == 1) {
                      //   Future.delayed(
                      //     Duration(milliseconds: 500),
                      //     () {
                      //       SystemChrome.setPreferredOrientations([
                      //         DeviceOrientation.landscapeLeft,
                      //       ]);
                      //     },
                      //   );
                      // } else {
                      //   Future.delayed(
                      //     Duration(milliseconds: 500),
                      //     () {
                      //       SystemChrome.setPreferredOrientations([
                      //         DeviceOrientation.portraitUp,
                      //       ]);
                      //     },
                      //   );
                      // }
                      _serviceBloc.add(BottomNavigationBarClicked(
                          index: value == 0 ? 0 : 2));
                    },
                    children: [
                      JobCardPage(
                        serviceBloc: _serviceBloc,
                      ),
                      Services()
                    ]);
              },
            )),
        // bottomNavigationBar: BlocBuilder<ServiceBloc, ServiceState>(
        //   builder: (context, state) {
        //     return CircleNavBar(
        //       activeIcons: [
        //         Icon(
        //           Icons.home,
        //           color: const Color.fromARGB(255, 145, 19, 19),
        //           size: size.height * 0.04,
        //         ),
        //         Icon(
        //           Icons.add,
        //           color: const Color.fromARGB(255, 145, 19, 19),
        //           size: size.height * 0.04,
        //         ),
        //         Icon(
        //           Icons.history,
        //           color: const Color.fromARGB(255, 145, 19, 19),
        //           size: size.height * 0.04,
        //         ),
        //       ],
        //       inactiveIcons: [
        //         Icon(
        //           Icons.home,
        //           size: size.height * 0.04,
        //           color: const Color.fromARGB(255, 145, 19, 19),
        //         ),
        //         Icon(
        //           Icons.add,
        //           size: size.height * 0.04,
        //           color: const Color.fromARGB(255, 145, 19, 19),
        //         ),
        //         Icon(
        //           Icons.history,
        //           size: size.height * 0.04,
        //           color: const Color.fromARGB(255, 145, 19, 19),
        //         ),
        //       ],
        //       iconCurve: Curves.easeIn,
        //       iconDurationMillSec: 1000,
        //       tabCurve: Curves.easeIn,
        //       tabDurationMillSec: 1000,
        //       color: const Color.fromARGB(255, 236, 224, 224),
        //       height: size.height * 0.07,
        //       circleWidth: size.height * 0.06,
        //       activeIndex: state.bottomNavigationBarActiveIndex!,
        //       onTap: (index) {
        //         _serviceBloc.add(BottomNavigationBarClicked(index: index));
        //         if (index == 0) {
        //           pageController.animateToPage(0,
        //               duration: const Duration(seconds: 1), curve: Curves.ease);
        //         } else if (index == 1) {
        //           // added delay to show the button flow animation in bottom navigation bar
        //           Future.delayed(const Duration(seconds: 1), () {
        //             Navigator.push(
        //                 context,
        //                 MaterialPageRoute(
        //                     builder: (context) => HomeView(
        //                           pageController: pageController,
        //                         )));
        //           });
        //         } else {
        //           pageController.animateToPage(1,
        //               duration: const Duration(seconds: 1), curve: Curves.ease);
        //         }
        //       },
        //       padding: EdgeInsets.only(
        //           left: size.width * 0.02,
        //           right: size.width * 0.02,
        //           bottom: size.width * 0.02),
        //       cornerRadius: const BorderRadius.only(
        //         topLeft: Radius.circular(8),
        //         topRight: Radius.circular(8),
        //         bottomRight: Radius.circular(30),
        //         bottomLeft: Radius.circular(30),
        //       ),
        //       shadowColor: const Color.fromARGB(255, 201, 94, 94),
        //       elevation: 5,
        //     );
        //   },
        // ),
      ),
    ));
  }
}

// sliverwidget used to design complex headers in UI
class SliverAppBar extends SliverPersistentHeaderDelegate {
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Size size = MediaQuery.of(context).size;
    return ClipShadowPath(
        shadow: shrinkOffset < 40
            ? BoxShadow(
                blurRadius: 20,
                blurStyle: BlurStyle.outer,
                spreadRadius: 25,
                color: Colors.orange.shade200,
                offset: const Offset(0, 0))
            : const BoxShadow(
                blurRadius: 20,
                blurStyle: BlurStyle.outer,
                spreadRadius: 25,
                color: Colors.transparent,
                offset: Offset(0, 0)),
        clipper: BackgroundWaveClipper(),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Gap(size.width * (shrinkOffset < 45 ? 0.03 : 0.4)),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: Text(
                  'Job Cards',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 18),
                ),
              ),
              if (shrinkOffset > 45) const Spacer(),
              if (shrinkOffset > 45)
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: const SizedBox(),
                    items: const [
                      DropdownMenuItem<String>(
                          value: '0',
                          child: Text(
                            'Log out',
                            style: TextStyle(color: Colors.transparent),
                          ))
                    ],
                    value: '0',
                    onChanged: (String? value) {
                      sharedPreferences.setBool("isLogged", false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                        (route) => false,
                      );
                    },
                    buttonStyleData: ButtonStyleData(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          color: Colors.transparent),
                      height: size.height * 0.05,
                      width: size.width * 0.25,
                      padding: const EdgeInsets.only(left: 14, right: 14),
                    ),
                    iconStyleData: IconStyleData(
                      icon: const Icon(
                        Icons.person_pin,
                        color: Colors.white,
                      ),
                      iconSize: size.height * 0.03,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.black,
                    ),
                    dropdownStyleData: DropdownStyleData(
                        width: size.width * 0.17,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        offset: const Offset(5, 0)),
                    menuItemStyleData: MenuItemStyleData(
                      selectedMenuItemBuilder: (context, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.01),
                          child: const Text(
                            'Log out',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ),
                  ),
                )
            ],
          ),
        ));
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}

class SliverHeader extends SliverPersistentHeaderDelegate {
  SliverHeader();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        Card(
            margin: EdgeInsets.only(
                left: size.width * 0.026,
                right: size.width * 0.026,
                bottom: size.height * 0.005),
            color: Colors.white,
            elevation: 4,
            shadowColor: const Color.fromARGB(255, 145, 19, 19),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: size.height * 0.068,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10))),
                    child: const Text(
                      textAlign: TextAlign.center,
                      'Job Card No.',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: size.height * 0.068,
                    width: size.width * 0.398,
                    decoration: const BoxDecoration(
                        border: Border.symmetric(
                            horizontal: BorderSide(color: Colors.black38)),
                        borderRadius: BorderRadius.only()),
                    child: const Text(
                      textAlign: TextAlign.center,
                      'Registration No.',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: size.height * 0.068,
                    width: size.width * 0.25,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: const Text(
                      textAlign: TextAlign.center,
                      'Status',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ]))
      ],
    );
  }

  @override
  double get maxExtent => 56;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent;
  }
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // size will be of the container's
    // print('height ${size.height} width ${size.width}');
    Path path = Path();

    const minSize = 50.0;

    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();

    path.lineTo(0, size.height - p1Diff);

    final controlPoint1 = Offset(size.width * 0.2, size.height);
    final controlPoint2 =
        Offset(size.width * 0.8, minSize + (minSize - size.height * 0.75) * 2);

    print('control point 1 $controlPoint1 control point 2 $controlPoint2');
    final endPoint = Offset(size.width, minSize);

    // used to difine two arcs according to the two control points
    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  // reclips the widgets based on difference between old instance and new instance
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}

class JobCardPage extends StatelessWidget {
  ServiceBloc? _serviceBloc;
  JobCardPage({super.key, required ServiceBloc serviceBloc})
      : _serviceBloc = serviceBloc;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: SliverAppBar(),
                // Set this param so that it won't go off the screen when scrolling
                pinned: true,
              ),
              SliverPersistentHeader(
                delegate: SliverHeader(),
                // Set this param so that it won't go off the screen when scrolling
                pinned: true,
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return state.getJobCardStatus == GetJobCardStatus.success
                    ? index >= state.jobCards!.length
                        ? SizedBox(
                            height: size.height * 0.05,
                          )
                        : Skeletonizer(
                            enableSwitchAnimation: true,
                            enabled: state.getJobCardStatus ==
                                    GetJobCardStatus.loading ||
                                state.jobCardStatusUpdate ==
                                    JobCardStatusUpdate.loading,
                            child: Card(
                              margin: EdgeInsets.symmetric(
                                  vertical: size.height * 0.005,
                                  horizontal: size.width * 0.026),
                              color: Colors.white,
                              elevation: 3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: size.height * 0.05,
                                    width: size.width * 0.3,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(20),
                                      radius: 100,
                                      splashColor: Colors.transparent,
                                      customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      enableFeedback: true,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => JobCardDetails(
                                                    service: state
                                                        .jobCards![index])));
                                      },
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        state.getJobCardStatus !=
                                                GetJobCardStatus.loading
                                            ? state.jobCards![index].jobCardNo!
                                            : 'JC-MAD-633',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: Colors.blue,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: size.height * 0.05,
                                    width: size.width * 0.398,
                                    decoration: const BoxDecoration(
                                        border: Border.symmetric(
                                            horizontal: BorderSide(
                                                color: Colors.black12)),
                                        borderRadius: BorderRadius.only()),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      state.getJobCardStatus !=
                                              GetJobCardStatus.loading
                                          ? state
                                              .jobCards![index].registrationNo!
                                          : 'TS09ED7884',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0),
                                    height: size.height * 0.05,
                                    width: size.width * 0.25,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black12),
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10))),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      state.getJobCardStatus !=
                                              GetJobCardStatus.loading
                                          ? state.jobCards![index].status!
                                          : 'N',
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  )
                                ],
                              ),
                            ))
                    : Skeletonizer(
                        enableSwitchAnimation: true,
                        enabled: true,
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: size.height * 0.005,
                              horizontal: size.width * 0.026),
                          color: Colors.white,
                          elevation: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: size.height * 0.05,
                                width: size.width * 0.3,
                                child: const Text(
                                  'JC-MAD-633',
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height: size.height * 0.05,
                                width: size.width * 0.3,
                                child: const Text(
                                  'TS09ED7884',
                                ),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  height: size.height * 0.05,
                                  width: size.width * 0.25,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2<String>(
                                      isExpanded: true,
                                      items: const [
                                        DropdownMenuItem<String>(
                                          value: 'N',
                                          child: Text('N'),
                                        )
                                      ],
                                      value: 'N',
                                    ),
                                  ))
                            ],
                          ),
                        ));
              },
                      childCount:
                          state.getJobCardStatus == GetJobCardStatus.success
                              ? state.jobCards!.length < 15
                                  ? state.jobCards!.length +
                                      (15 - state.jobCards!.length)
                                  : state.jobCards!.length
                              : 15)),
              if (state.getJobCardStatus == GetJobCardStatus.success &&
                  state.jobCards!.isEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => SizedBox(
                            height: size.height * 0.8,
                            child: Transform(
                                transform: Matrix4.translationValues(
                                    size.width * 0.22, size.height * 0.3, 0),
                                child: const Text(
                                    'No Job Cards are in progress.')),
                          ),
                      childCount: 1),
                )
            ],
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class Services extends StatelessWidget {
  Services({super.key});
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();
  DataGridController dataGridController = DataGridController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 238, 209, 209),
              Color.fromARGB(255, 238, 194, 194),
              Color.fromARGB(255, 231, 200, 200)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.01, 0.35, 1]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 145, 19, 19)),
            child: const Center(
              child: Text(
                'Service History',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
              ),
            ),
          ),
          SfDataGridTheme(
            data: SfDataGridThemeData.raw(
                headerColor: Colors.white,
                currentCellStyle: const DataGridCurrentCellStyle(
                  borderColor: Colors.red,
                  borderWidth: 2,
                )),
            child: BlocConsumer<ServiceBloc, ServiceState>(
              listener: (context, state) {
                if (state.getServiceStatus == GetServiceStatus.success) {}
              },
              builder: (context, state) {
                switch (state.getServiceStatus) {
                  case GetServiceStatus.loading:
                    return Transform(
                      transform: Matrix4.translationValues(0, 80, 0),
                      child: Center(
                        child: Lottie.asset('assets/lottie/car_loading.json',
                            height: size.height * 0.5, width: size.width * 0.6),
                      ),
                    );
                  case GetServiceStatus.success:
                    return Expanded(
                      flex: 1,
                      child: SfDataGrid(
                        columnSizer: _customColumnSizer,
                        columnWidthMode: ColumnWidthMode.fitByColumnName,
                        source: ServiceHistoryDataSource(
                            serviceHistoryData: state.services!),
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        showHorizontalScrollbar: false,
                        allowEditing: true,
                        shrinkWrapColumns: false,
                        shrinkWrapRows: false,
                        allowSorting: true,
                        allowColumnsResizing: true,
                        allowColumnsDragging: true,
                        columnResizeMode: ColumnResizeMode.onResize,
                        allowFiltering: true,
                        editingGestureType: EditingGestureType.doubleTap,
                        onCellDoubleTap: (details) {
                          dataGridController.beginEdit(details.rowColumnIndex);
                        },
                        controller: dataGridController,
                        columns: <GridColumn>[
                          GridColumn(
                              allowEditing: true,
                              width: 120,
                              columnName: 'sno',
                              label: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Sno',
                                  ))),
                          GridColumn(
                              columnName: 'date',
                              label: Container(
                                  alignment: Alignment.center,
                                  child: const Text('Date'))),
                          GridColumn(
                              columnName: 'Job Card no.',
                              label: Container(
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Text(
                                      'Job Card no.',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))),
                          GridColumn(
                              columnName: 'Location',
                              label: Container(
                                  alignment: Alignment.center,
                                  child: const Text('Location'))),
                          GridColumn(
                              columnName: 'Job Type',
                              label: Container(
                                  alignment: Alignment.center,
                                  child: const Text('Job Type'))),
                        ],
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    if (column.columnName == 'Sno') {
      cellValue = cellValue;
    } else if (column.columnName == 'Date') {
      cellValue = cellValue;
    }

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}

class ServiceHistoryDataSource extends DataGridSource {
  /// Creates the serviceHistory data source class with required details.
  ServiceHistoryDataSource({required List<Service> serviceHistoryData}) {
    _serviceHistoryData = serviceHistoryData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                columnName: 'sno',
                value: serviceHistoryData.indexOf(e) + 1,
              ),
              DataGridCell<String>(columnName: 'date', value: e.scheduleDate),
              DataGridCell<String>(
                  columnName: 'Job Card no.', value: e.jobCardNo),
              DataGridCell<String>(columnName: 'Location', value: e.location),
              DataGridCell<String>(columnName: 'Job Type', value: e.jobType),
            ]))
        .toList();
  }

  List<DataGridRow> _serviceHistoryData = [];

  @override
  List<DataGridRow> get rows => _serviceHistoryData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((e) {
          return e.columnName == "Job Card no."
              ? InkWell(
                  onTap: () {},
                  child: Center(
                      child: Text(
                    e.value.toString(),
                    style: const TextStyle(color: Colors.blue),
                  )),
                )
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.value.toString()),
                );
        }).toList());
  }
}
