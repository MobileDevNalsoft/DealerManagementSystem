import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow, Stepper, Step;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/service/service_bloc.dart';
import '../navigations/navigator_service.dart';
import 'custom_widgets/stepper.dart';

class JobCardDetails extends StatefulWidget {
  const JobCardDetails({super.key});

  @override
  State<JobCardDetails> createState() => _JobCardDetailsState();
}

class _JobCardDetailsState extends State<JobCardDetails> with TickerProviderStateMixin {
  // Get the NavigatorService instance using GetIt dependency injection
  final NavigatorService navigator = getIt<NavigatorService>();

  // shared preferences
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // for animation
  late AnimationController animationController;
  late Animation<double> animation;
  late Tween<double> tween;

  // bloc variables
  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();
    _serviceBloc = context.read<ServiceBloc>();
    tween = Tween(begin: 0.0, end: (sharedPreferences.getBool('isMobile') ?? true ? 0.8 : 1));
    animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    animation = CurvedAnimation(parent: animationController, curve: Curves.easeIn).drive(tween);
    animationController.forward();
  }

  // dispose controller to avoid data leaks
  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // responsive UI
    Size size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    // Define the stages of the work flow
    List<String> dmsFlow = ['New', 'Work in progress', 'Quality Check', 'Inspection Out', 'Completed'];

    // Define icon names for each stage
    List<String> icons = ['initiated', 'work_in_progress', 'quality_check', 'inspection_out', 'completed'];

    // Define status lines based on current stage and service creation date
    List<String> statusLines = [
      'JC created on ${_serviceBloc.state.service!.creationDate}',
      'Vehicle Service is done',
      'Quality Check is done',
      'Inpection out is done',
      'Gate Pass'
    ];

    // Define status lines for stages that are still pending
    List<String> pendingStatusLines = [
      'JC created on ${_serviceBloc.state.service!.creationDate}',
      'Vehicle Service is in progress',
      'Quality Check needs to be done',
      'Inpection out needs to be done',
      'Gate Pass'
    ];

    return PopScope(
      onPopInvoked: (didPop) => animationController.stop(),
      child: Scaffold(
          // Prevent the layout from resizing to avoid bottom inset issues
          resizeToAvoidBottomInset: false,
          // Don't extend the content behind the app bar
          extendBodyBehindAppBar: false,
          appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Job Card Details'),
          body: Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black45, Colors.black26, Colors.black45],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.5, 1])),
                child: ListView(
                  children: [
                    IntrinsicHeight(
                      child: Container(
                        margin:
                            EdgeInsets.only(top: size.height * 0.04, left: size.width * (isMobile ? 0.02 : 0.08), right: size.width * (isMobile ? 0.02 : 0.08)),
                        padding: EdgeInsets.symmetric(horizontal: size.width * (isMobile ? 0.05 : 0.032), vertical: size.height * 0.03),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(isMobile ? 25 : 35)),
                        child: Column(
                          children: [
                            buildDetailRow('Job Card Number', _serviceBloc.state.service!.jobCardNo.toString(), size, isMobile),
                            Gap(size.height * 0.02),
                            buildDetailRow('Vehicle Registration Number', _serviceBloc.state.service!.registrationNo.toString(), size, isMobile),
                            Gap(size.height * 0.02),
                            buildDetailRow('Location', _serviceBloc.state.service!.location.toString(), size, isMobile),
                            Gap(size.height * 0.02),
                            buildDetailRow('Job Type', _serviceBloc.state.service!.jobType.toString(), size, isMobile),
                            Gap(size.height * 0.02),
                            buildDetailRow('Scheduled Date', _serviceBloc.state.service!.scheduledDate.toString(), size, isMobile)
                          ],
                        ),
                      ),
                    ),
                    AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          return Container(
                              height: size.height * animation.value,
                              margin: EdgeInsets.only(
                                top: size.height * 0.03,
                                left: size.width * (isMobile ? 0.02 : 0.04),
                                right: size.width * (isMobile ? 0.02 : 0.04),
                              ),
                              padding: EdgeInsets.only(top: size.height * 0.01),
                              width: size.width * (isMobile ? 0.93 : 0.48),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(isMobile ? 25 : 35), topRight: Radius.circular(isMobile ? 25 : 35)),
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black12, blurRadius: 10, blurStyle: BlurStyle.normal, offset: Offset(1, 1), spreadRadius: 10)
                                  ]),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Status',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 16 : 18),
                                    ),
                                  ),
                                  Expanded(flex: 1, child: Gap(size.height * 0.01)),
                                  // creates stepper widget to show the status of the job card
                                  Expanded(
                                      flex: 25,
                                      child: BlocBuilder<ServiceBloc, ServiceState>(
                                        builder: (context, state) {
                                          return Stepper(
                                            steps: dmsFlow
                                                .map((e) => Step(
                                                      activeStep: dmsFlow.indexWhere((e) => e == _serviceBloc.state.service!.status),
                                                      currentStep: dmsFlow.indexOf(e),
                                                      icons: icons,
                                                      stepperLength: dmsFlow.length,
                                                      title: e,
                                                      statusLines: statusLines,
                                                      pendingStatusLines: pendingStatusLines,
                                                      jobCardNo: _serviceBloc.state.service!.jobCardNo!,
                                                    ))
                                                .toList(),
                                          );
                                        },
                                      )),
                                ],
                              ));
                        })
                  ],
                ),
              ),
              if (context.watch<MultiBloc>().state.status == MultiStateStatus.loading)
                // shows loader widget based on the multistate bloc status.
                Container(
                  color: Colors.blueGrey.withOpacity(0.25),
                  child: Center(
                      child: Lottie.asset('assets/lottie/car_loading.json',
                          height: isMobile ? size.height * 0.5 : size.height * 0.32, width: isMobile ? size.width * 0.6 : size.width * 0.32)),
                )
            ],
          )),
    );
  }

  // this method is used to create a detail row with key value pairs in the UI
  Widget buildDetailRow(String key, String value, Size size, bool isMobile) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        width: size.width * (isMobile ? 0.4 : 0.3),
        child: Text(
          key,
          softWrap: true,
          style: TextStyle(fontSize: isMobile ? 13 : 17),
        ),
      ),
      SizedBox(
        width: size.width * (isMobile ? 0.4 : 0.35),
        child: Text(
          textAlign: TextAlign.right,
          value,
          softWrap: true,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: isMobile ? 13 : 17, overflow: TextOverflow.visible),
        ),
      )
    ]);
  }
}
