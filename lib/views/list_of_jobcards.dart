import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../inits/init.dart';
import '../models/services.dart';
import 'custom_widgets/clipped_buttons.dart';
import 'custom_widgets/loginformfield.dart';
import 'jobcard_details.dart';
import 'dart:math' as math;

class ListOfJobcards extends StatefulWidget {
  const ListOfJobcards({super.key});

  @override
  State<ListOfJobcards> createState() => _ListOfJobcardsState();
}

class _ListOfJobcardsState extends State<ListOfJobcards>
    with ConnectivityMixin {
  late ServiceBloc _serviceBloc;
  PageController pageController = PageController();
  @override
  void initState() {
    super.initState();

    // initiating service bloc variable
    _serviceBloc = context.read<ServiceBloc>();

    // setting initial statuses of service and job card status to initial
    _serviceBloc.state.getJobCardStatus = GetJobCardStatus.initial;

    // invoking getjob cards and getservice history to invoke bloc method to get data from db
    _serviceBloc.add(GetJobCards(query: 'Location27'));

    // set default orientation to portrait up
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  Widget build(BuildContext context) {
    // responsive UI
    Size size = MediaQuery.of(context).size;

    return PopScope(
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
            return JobCardPage();
          },
        )),
          ),
        );
  }
}

// sliverwidget used to design complex headers in UI
class SliverAppBar extends SliverPersistentHeaderDelegate {
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    Size size = MediaQuery.of(context).size;
    print('shrinkOffset $shrinkOffset');
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
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.13,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: shrinkOffset > 55
                        ? size.height * 0.02
                        : 42 - 0.5 * shrinkOffset,
                    left: shrinkOffset > 50
                        ? size.width * 0.37
                        : 2.5 * shrinkOffset + 8),
                child: const Text(
                  'Job Cards',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 18),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Transform(
                transform: Matrix4.translationValues(-5, -3, 0),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white)),
              ),
            )
          ],
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
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;
    print(size.height);
    print('shrink offset $shrinkOffset');

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: size.width * 0.03),
          padding: EdgeInsets.only(top: size.height * 0.033),
          height: size.height * 0.06,
          width: size.width * 0.8,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              color: Colors.white60),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            style: const TextStyle(color: Colors.black),
            onTapOutside: (event) => focusNode.unfocus(),
            onChanged: (value) {
              controller.text = value;
              context
                  .read<ServiceBloc>()
                  .add(SearchJobCards(searchText: value));
            },
            cursorColor: Colors.black,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 15, horizontal: 16),
              hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
              hintText: 'Vehicle Registration Number',
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () => focusNode.requestFocus(),
            child: Container(
              margin: EdgeInsets.only(right: size.width * 0.03),
              height: size.height * 0.06,
              decoration: const BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10))),
              child: const Icon(
                Icons.search_rounded,
                color: Colors.white60,
              ),
            ),
          ),
        )
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

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // size will be of the container's
    print('height ${size.height} width ${size.width}');
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    path.addArc(
      Rect.fromCircle(center: Offset(0.0, size.height / 2), radius: 8.0),
      0, // Start angle (0 radians)
      2 * math.pi,
    );
    path.addArc(
      Rect.fromCircle(center: Offset(size.width, size.height / 2), radius: 8.0),
      0, // Start angle (0 radians)
      2 * math.pi,
    );
    path.close();

    return path;
  }

  // reclips the widgets based on difference between old instance and new instance
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) =>
      oldClipper != this;
}

class JobCardPage extends StatelessWidget {
  JobCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
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
                pinned: false,
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Skeletonizer(
                    enableSwitchAnimation: true,
                    enabled:
                        state.getJobCardStatus == GetJobCardStatus.loading ||
                            state.getJobCardStatus == GetJobCardStatus.initial,
                    child: SizedBox(
                      height: size.height * 0.15,
                      width: size.width * 0.95,
                      child: ClipShadowPath(
                        clipper: TicketClipper(),
                        shadow: BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 5,
                          blurStyle: BlurStyle.normal,
                          spreadRadius: 1,
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: size.height * 0.006,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Gap(size.width * 0.05),
                                          Image.asset(
                                            'assets/images/job_card.png',
                                            scale: size.width * 0.05,
                                            color: Colors.black,
                                          ),
                                          Gap(size.width * 0.02),
                                          InkWell(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            radius: 100,
                                            splashColor: Colors.transparent,
                                            customBorder:
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                            enableFeedback: true,
                                            onTap: () {
                                              state.jobCardNo = state
                                                  .filteredJobCards![index]
                                                  .jobCardNo!;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          JobCardDetails(
                                                              service: state
                                                                      .jobCards![
                                                                  index])));
                                            },
                                            child: Text(
                                              textAlign: TextAlign.center,
                                              state.getJobCardStatus ==
                                                      GetJobCardStatus.success
                                                  ? state
                                                      .filteredJobCards![index]
                                                      .jobCardNo!
                                                  : 'JC-MAD-633',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 12,
                                                  color: Colors.blue,
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                          )
                                        ],
                                      ),
                                      Gap(size.width * 0.01),
                                      Row(
                                        children: [
                                          Gap(size.width * 0.055),
                                          Image.asset(
                                              'assets/images/registration_no.png',
                                              scale: size.width * 0.055),
                                          Gap(size.width * 0.02),
                                          SizedBox(
                                            width: size.width * 0.28,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                textAlign: TextAlign.center,
                                                state.getJobCardStatus ==
                                                        GetJobCardStatus.success
                                                    ? state
                                                        .filteredJobCards![
                                                            index]
                                                        .registrationNo!
                                                    : 'TS09ED7884',
                                                style: const TextStyle(
                                                    fontSize: 13),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Gap(size.height * 0.03),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Gap(size.width * 0.058),
                                          Image.asset(
                                              'assets/images/status.png',
                                              scale: size.width * 0.058),
                                          Gap(size.width * 0.02),
                                          Text(
                                            textAlign: TextAlign.center,
                                            state.getJobCardStatus ==
                                                    GetJobCardStatus.success
                                                ? state.filteredJobCards![index]
                                                    .status!
                                                : 'Work in Progress',
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.94,
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade200,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/customer.png',
                                          scale: size.width * 0.06,
                                        ),
                                        Gap(size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.36,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              state.getJobCardStatus ==
                                                      GetJobCardStatus.success
                                                  ? state
                                                      .filteredJobCards![index]
                                                      .customerName!
                                                  : 'Customer Name',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Gap(size.width * 0.1),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/call.png',
                                          scale: size.width * 0.06,
                                        ),
                                        Gap(size.width * 0.02),
                                        SizedBox(
                                          width: size.width * 0.25,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              state.getJobCardStatus ==
                                                      GetJobCardStatus.success
                                                  ? state
                                                          .filteredJobCards![
                                                              index]
                                                          .customerContact ??
                                                      '-'
                                                  : 'Contact Number',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ));
              },
                      childCount:
                          state.getJobCardStatus == GetJobCardStatus.success
                              ? state.filteredJobCards!.length
                              : 7)),
              if (state.getJobCardStatus == GetJobCardStatus.success &&
                  state.filteredJobCards!.isEmpty)
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      Gap(size.height * 0.25),
                      Lottie.asset(
                        'assets/lottie/no_data_found.json',
                      ),
                      Gap(size.height * 0.01),
                      const Text('No Job Cards are in progress.')
                    ],
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

// if (shrinkOffset > 45) const Spacer(),
              // if (shrinkOffset > 45)
                