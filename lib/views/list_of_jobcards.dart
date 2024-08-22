import 'dart:math' as math;

import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/network_handler_mixin/network_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../inits/init.dart';
import 'custom_widgets/clipped_buttons.dart';

class ListOfJobcards extends StatefulWidget {
  const ListOfJobcards({super.key});

  @override
  State<ListOfJobcards> createState() => _ListOfJobcardsState();
}

class _ListOfJobcardsState extends State<ListOfJobcards>
    with ConnectivityMixin {
  late ServiceBloc _serviceBloc;
  PageController pageController = PageController();

  final NavigatorService navigator = getIt<NavigatorService>();
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
    return SafeArea(
        child: Hero(
      tag: 'listOfJobCards',
      transitionOnUserGestures: true,
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
                return const JobCardPage();
              },
            )),
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
    // The shrinkOffset is a distance from [maxExtent] towards [minExtent] representing the current amount by which the sliver has been shrunk.
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
        clipper:
            BackgroundWaveClipper(), // this clipper is used to clip the appbar to give wave effect
        child: Stack(
          children: [
            Container(
              width: size.width,
              height: size.height * 0.15,
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
                      getIt<NavigatorService>().pop();
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

// this is used to create search bar that sticks to the app bar and allows sliverlist to scroll beneath it
class SliverHeader extends SliverPersistentHeaderDelegate {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () => focusNode.requestFocus(),
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 10,
            child: Container(
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
                  // triggers search job cards events for the value entered in the search field
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
          ),
          Expanded(
            flex: 2,
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
          )
        ],
      ),
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
    Path path = Path();

    const minSize = 50.0;

    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();

    path.lineTo(0, size.height - p1Diff);

    final controlPoint1 = Offset(size.width * 0.2, size.height);
    final controlPoint2 =
        Offset(size.width * 0.8, minSize + (minSize - size.height * 0.75) * 2);

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
  const JobCardPage({super.key});

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
                      width: size.width * 0.95,
                      child: ClipShadowPath(
                        clipper: TicketClipper(),
                        shadow: const BoxShadow(
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Gap(size.width * 0.055),
                                            Expanded(
                                              flex: 2,
                                              child: Image.asset(
                                                'assets/images/job_card.png',
                                                scale: size.width * 0.05,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                radius: 100,
                                                splashColor: Colors.transparent,
                                                customBorder:
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20)),
                                                enableFeedback: true,
                                                onTap: () {
                                                  state.service = state
                                                      .filteredJobCards![index];
                                                  getIt<NavigatorService>()
                                                      .push('/jobCardDetails');
                                                },
                                                child: Text(
                                                  state.getJobCardStatus ==
                                                          GetJobCardStatus
                                                              .success
                                                      ? state
                                                          .filteredJobCards![
                                                              index]
                                                          .jobCardNo!
                                                      : 'JC-MAD-633',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 12,
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        Gap(size.width * 0.01),
                                        Row(
                                          children: [
                                            Gap(size.width * 0.055),
                                            Expanded(
                                              flex: 2,
                                              child: Image.asset(
                                                  'assets/images/registration_no.png',
                                                  scale: size.width * 0.055),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: SizedBox(
                                                width: size.width * 0.28,
                                                child: SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Text(
                                                    state.getJobCardStatus ==
                                                            GetJobCardStatus
                                                                .success
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
                                            ),
                                          ],
                                        ),
                                        Gap(size.width * 0.01),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Gap(size.height * 0.03),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Gap(size.width * 0.058),
                                            Expanded(
                                              flex: 2,
                                              child: Image.asset(
                                                  'assets/images/status.png',
                                                  scale: size.width * 0.058),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: Text(
                                                state.getJobCardStatus ==
                                                        GetJobCardStatus.success
                                                    ? state
                                                        .filteredJobCards![
                                                            index]
                                                        .status!
                                                    : 'Work in Progress',
                                                style: const TextStyle(
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.94,
                                margin: EdgeInsets.only(
                                    bottom: size.height * 0.0025),
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade200,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Image.asset(
                                              'assets/images/customer.png',
                                              alignment: Alignment.center,
                                              scale: size.width * 0.06,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: SizedBox(
                                              width: size.width * 0.36,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  state.getJobCardStatus ==
                                                          GetJobCardStatus
                                                              .success
                                                      ? state
                                                          .filteredJobCards![
                                                              index]
                                                          .customerName!
                                                      : 'Customer Name',
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: Image.asset(
                                              'assets/images/call.png',
                                              scale: size.width * 0.06,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: SizedBox(
                                              width: size.width * 0.25,
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  state.getJobCardStatus ==
                                                          GetJobCardStatus
                                                              .success
                                                      ? state
                                                              .filteredJobCards![
                                                                  index]
                                                              .customerContact ??
                                                          '-'
                                                      : 'Contact Number',
                                                  style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                // used to create scroll effect even when the job cards are empty
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
