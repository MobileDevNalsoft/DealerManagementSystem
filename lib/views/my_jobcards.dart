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

class MyJobcards extends StatefulWidget {
  const MyJobcards({super.key});

  @override
  State<MyJobcards> createState() => _MyJobcardsState();
}

class _MyJobcardsState extends State<MyJobcards> with TickerProviderStateMixin {
  late ServiceBloc _serviceBloc;

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  // navigator service
  NavigatorService navigator = getIt<NavigatorService>();

  @override
  void initState() {
    super.initState();

    // initiating service bloc variable
    _serviceBloc = context.read<ServiceBloc>();

    // setting initial statuses of service and job card status to initial
    _serviceBloc.state.getMyJobCardsStatus = GetMyJobCardsStatus.initial;

    // invoking getjob cards and getservice history to invoke bloc method to get data from db
    _serviceBloc.add(GetMyJobCards());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    return Hero(
      tag: 'myJobCards',
      transitionOnUserGestures: true,
      child: Scaffold(
        // Prevent the layout from resizing to avoid bottom inset issues
        resizeToAvoidBottomInset: false,
        appBar: DMSCustomWidgets.appBar(
          size: size,
          isMobile: isMobile,
          title: 'My Job Cards',
          actions: [
            // this drop down will display the logout button when pressed.
            FutureBuilder(
                future: Future.delayed(const Duration(milliseconds: 600)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return DropdownButtonHideUnderline(
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
                          navigator.pushAndRemoveUntil('/login', '/x');
                        },
                        buttonStyleData: ButtonStyleData(
                          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)), color: Colors.transparent),
                          height: size.height * (isMobile ? 0.05 : 0.045),
                          width: size.width * 0.25,
                          padding: EdgeInsets.only(right: size.width * 0.04),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Container(
                            height: size.height * 0.1,
                            width: size.width * 0.09,
                            margin: EdgeInsets.only(
                              left: size.width * 0.045,
                            ),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black, boxShadow: [
                              BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))
                            ]),
                            child: Transform(
                              transform: Matrix4.translationValues(0, 0, 0),
                              child: const Icon(Icons.person, color: Colors.white),
                            ),
                          ),
                          iconSize: size.height * 0.025,
                          iconEnabledColor: Colors.black,
                          iconDisabledColor: Colors.black,
                        ),
                        dropdownStyleData: DropdownStyleData(
                            width: size.width * (isMobile ? 0.17 : 0.11),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            offset: Offset(size.width * (isMobile ? 0.01 : 0.05), 0)),
                        menuItemStyleData: MenuItemStyleData(
                          selectedMenuItemBuilder: (context, child) {
                            return Padding(
                              padding: EdgeInsets.only(left: size.width * 0.02),
                              child: Text(
                                'Log out',
                                style: TextStyle(fontSize: (isMobile ? 13 : 15), fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }
                  return SizedBox();
                })
          ],
        ),
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
                          itemCount: state.getMyJobCardsStatus == GetMyJobCardsStatus.success ? state.myJobCards!.length : 7,
                          itemBuilder: (context, index) => Skeletonizer(
                              enableSwitchAnimation: true,
                              enabled: state.getMyJobCardsStatus == GetMyJobCardsStatus.loading || state.getMyJobCardsStatus == GetMyJobCardsStatus.initial,
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
                                  width: size.width * (isMobile ? 0.94 : 0.8),
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
                                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                                      state.service = state.myJobCards![index];
                                                      navigator.push('/jobCardDetails');
                                                    },
                                                    child: Text(
                                                      state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                          ? state.myJobCards![index].jobCardNo!
                                                          : 'JC-MAD-633',
                                                      style: TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                          fontSize: (isMobile ? 12 : 16),
                                                          color: Colors.blue,
                                                          decoration: TextDecoration.underline),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Gap(size.width * (isMobile ? 0.03 : 0.02)),
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
                                                        state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                            ? state.myJobCards![index].registrationNo!
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
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Gap(size.height * 0.04),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Gap(size.width * 0.058),
                                                  Image.asset(
                                                    'assets/images/status.png',
                                                    scale: size.width * (isMobile ? 0.058 : 0.016),
                                                  ),
                                                  Gap(size.width * 0.01),
                                                  Text(
                                                    state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                        ? state.myJobCards![index].status!
                                                        : 'Work in Progress',
                                                    style: TextStyle(fontSize: isMobile ? 13 : 17),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Gap(size.height * (isMobile ? 0 : 0.01)),
                                      Container(
                                        height: size.height * 0.05,
                                        width: size.width * (isMobile ? 0.93 : 0.79),
                                        margin: EdgeInsets.only(bottom: size.height * 0.002),
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
                                                      state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                          ? state.myJobCards![index].customerName!
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
                                                      state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                          ? state.myJobCards![index].customerContact ?? '-'
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
                                height: size.height * (isMobile ? 0.15 : 0.158),
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
