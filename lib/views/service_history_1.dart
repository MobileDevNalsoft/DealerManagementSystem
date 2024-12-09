import 'package:dms/inits/init.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../bloc/service/service_bloc.dart';
import 'custom_widgets/clipped_buttons.dart';
import 'list_of_jobcards.dart';

class ServiceHistory1 extends StatefulWidget {
  const ServiceHistory1({super.key});

  @override
  State<ServiceHistory1> createState() => _ServiceHistory1State();
}

class _ServiceHistory1State extends State<ServiceHistory1> with TickerProviderStateMixin {
  late ServiceBloc _serviceBloc;

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // navigator service
  NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();

    // initiating service bloc variable
    _serviceBloc = context.read<ServiceBloc>();

    // setting initial statuses of service status to initial
    _serviceBloc.state.getServiceStatus = GetServiceStatus.initial;
    _serviceBloc.add(GetServiceHistory(query: '2022'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    return Hero(
      tag: 'serviceHistory',
      transitionOnUserGestures: true,
      child: Scaffold(
        // Prevent the layout from resizing to avoid bottom inset issues
        resizeToAvoidBottomInset: false,
        appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'Service History'),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black45, Colors.black26, Colors.black45], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 0.5, 1]),
          ),
          child: FutureBuilder(
              future: Future.delayed(const Duration(milliseconds: 600)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return BlocBuilder<ServiceBloc, ServiceState>(
                    builder: (context, state) {
                      return ListView.builder(
                          itemCount: state.getServiceStatus == GetServiceStatus.success ? state.services!.length : 7,
                          itemBuilder: (context, index) => Skeletonizer(
                              enableSwitchAnimation: true,
                              enabled: state.getServiceStatus == GetServiceStatus.loading || state.getServiceStatus == GetServiceStatus.initial,
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
                                  width: size.width * (isMobile ? 0.95 : 0.8),
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
                                      Gap(size.height * 0.02),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Gap(size.height * (isMobile ? 0.01 : 0.015)),
                                              Row(
                                                children: [
                                                  Gap(size.width * (isMobile ? 0.055 : 0.08)),
                                                  Image.asset(
                                                    'assets/images/job_card.png',
                                                    scale: size.width * (isMobile ? 0.05 : 0.015),
                                                    color: Colors.black,
                                                  ),
                                                  Gap(size.width * 0.01),
                                                  InkWell(
                                                    borderRadius: BorderRadius.circular(20),
                                                    radius: 100,
                                                    splashColor: Colors.transparent,
                                                    customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    enableFeedback: true,
                                                    onTap: () {
                                                      state.service = state.services![index];
                                                      navigator.push('/jobCardDetails');
                                                    },
                                                    child: Text(
                                                      state.getServiceStatus == GetServiceStatus.success ? state.services![index].jobCardNo! : 'JC-MAD-633',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: (isMobile ? 12 : 16),
                                                          color: Colors.blue,
                                                          decoration: TextDecoration.underline),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Gap(size.width * (isMobile ? 0.06 : 0.07)),
                                              Row(
                                                children: [
                                                  Gap(size.width * (isMobile ? 0.055 : 0.082)),
                                                  Image.asset(
                                                    'assets/images/registration_no.png',
                                                    scale: size.width * (isMobile ? 0.055 : 0.016),
                                                  ),
                                                  Gap(size.width * 0.01),
                                                  SizedBox(
                                                    width: size.width * (isMobile ? 0.28 : 0.25),
                                                    child: SingleChildScrollView(
                                                      scrollDirection: Axis.horizontal,
                                                      child: Text(
                                                        textAlign: TextAlign.center,
                                                        state.getServiceStatus == GetServiceStatus.success
                                                            ? state.services![index].registrationNo!
                                                            : 'TS09ED7884',
                                                        style: TextStyle(fontSize: isMobile ? 13 : 17),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(size.width * (isMobile ? 0.01 : 0.0016)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Gap(size.height * (isMobile ? 0.02 : 0.02)),
                                      Container(
                                        height: size.height * 0.05,
                                        width: size.width * (isMobile ? 0.94 : 0.79),
                                        margin: EdgeInsets.only(bottom: size.height * 0.003),
                                        decoration: BoxDecoration(
                                            color: Colors.orange.shade200,
                                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Gap(size.width * (isMobile ? 0.01 : 0.03)),
                                                Image.asset(
                                                  'assets/images/customer.png',
                                                  scale: size.width * (isMobile ? 0.06 : 0.018),
                                                ),
                                                Gap(size.width * (isMobile ? 0.01 : 0.02)),
                                                SizedBox(
                                                  width: size.width * (isMobile ? 0.36 : 0.33),
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      state.getServiceStatus == GetServiceStatus.success
                                                          ? state.services![index].customerName!
                                                          : 'Customer Name',
                                                      style:
                                                          TextStyle(fontSize: isMobile ? 13 : 17, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Gap(size.width * 0.02),
                                            Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/call.png',
                                                  scale: size.width * (isMobile ? 0.06 : 0.018),
                                                ),
                                                Gap(size.width * 0.01),
                                                SizedBox(
                                                  width: size.width * (isMobile ? 0.25 : 0.08),
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      state.getServiceStatus == GetServiceStatus.success
                                                          ? state.services![index].customerContact ?? '-'
                                                          : 'Contact Number',
                                                      style:
                                                          TextStyle(fontSize: isMobile ? 13 : 17, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
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
                              )));
                    },
                  );
                }
                return SizedBox(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: size.width * (isMobile ? 0.03 : 0.1)),
                    shrinkWrap: true,
                    children: [1, 2, 3, 4, 5, 6]
                        .map((e) => ClipShadowPath(
                              clipper: TicketClipper(),
                              shadow: const BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 2),
                                blurRadius: 5,
                                blurStyle: BlurStyle.normal,
                                spreadRadius: 1,
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: size.height * 0.006),
                                height: size.height * (isMobile ? 0.129 : 0.128),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Divider(),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
