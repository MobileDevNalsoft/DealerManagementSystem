import 'package:dms/inits/init.dart';
import 'package:dms/views/login.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../bloc/service/service_bloc.dart';
import 'list_of_jobcards.dart';
import 'jobcard_details.dart';

class MyJobcards extends StatefulWidget {
  const MyJobcards({super.key});

  @override
  State<MyJobcards> createState() => _MyJobcardsState();
}

class _MyJobcardsState extends State<MyJobcards> {
  late ServiceBloc _serviceBloc;

  SharedPreferences sharedPreferences = getIt<SharedPreferences>();

  @override
  void initState() {
    super.initState();

    // initiating service bloc variable
    _serviceBloc = context.read<ServiceBloc>();

    // setting initial statuses of service and job card status to initial
    _serviceBloc.state.getMyJobCardsStatus = GetMyJobCardsStatus.initial;

    // invoking getjob cards and getservice history to invoke bloc method to get data from db
    _serviceBloc.add(GetMyJobCards(query: getIt<SharedPreferences>().getInt('service_advisor_id').toString()));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    return Hero(
      tag: 'myJobCards',
      transitionOnUserGestures: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          elevation: 0,
          backgroundColor: Colors.black45,
          leadingWidth: size.width * 0.14,
          leading: Container(
            margin: EdgeInsets.only(left: size.width * 0.045, top: isMobile ? 0 : size.height * 0.008, bottom: isMobile ? 0 : size.height * 0.008),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                boxShadow: [BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))]),
            child: Transform(
              transform: Matrix4.translationValues(-3, 0, 0),
              child: IconButton(
                  onPressed: () {
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
              child: const Text(
                textAlign: TextAlign.center,
                'My Job Cards',
                style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white, fontSize: 16),
              )),
          centerTitle: true,
          actions: [
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
                  overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)), color: Colors.transparent),
                  height: size.height * 0.05,
                  width: size.width * 0.25,
                  padding: const EdgeInsets.only(left: 14, right: 14),
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
                    width: size.width * 0.17,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    offset: const Offset(5, 0)),
                menuItemStyleData: MenuItemStyleData(
                  selectedMenuItemBuilder: (context, child) {
                    return Padding(
                      padding: EdgeInsets.only(left: size.width * 0.02),
                      child: const Text(
                        'Log out',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black45, Colors.black26, Colors.black45], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 0.5, 1]),
          ),
          child: BlocBuilder<ServiceBloc, ServiceState>(
            builder: (context, state) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile
                      ?1: state.myJobCards == null
                          ? 1
                          : state.myJobCards!.length <= 1
                              ? 1
                              : 2
                      ,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  mainAxisExtent: state.myJobCards != null
                      ? state.myJobCards!.length > 7
                          ? size.height
                          : size.height * (state.myJobCards!.length * 0.16)
                      : size.height*0.14,
                ),
                itemCount: state.getMyJobCardsStatus == GetMyJobCardsStatus.success ? state.myJobCards!.length : 7,
                itemBuilder: (context, index) => Skeletonizer(
                    enableSwitchAnimation: true,
                    enabled: state.getMyJobCardsStatus == GetMyJobCardsStatus.loading || state.getMyJobCardsStatus == GetMyJobCardsStatus.initial,
                    child: Expanded(
                      child: SizedBox(
                        // height: size.height * 0.16,
                        width: size.width * (isMobile ? 0.95 : 0.35),
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Gap(size.width * (isMobile ? 0.05 : 0.024)),
                                              Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  'assets/images/job_card.png',
                                                  scale: size.width * (isMobile ? 0.05 : 0.016),
                                                  color: Colors.black,
                                                ),
                                              ),
                                              // Gap(size.width * 0.01),
                                              Expanded(
                                                flex: 8,
                                                child: InkWell(
                                                  borderRadius: BorderRadius.circular(20),
                                                  radius: 100,
                                                  splashColor: Colors.transparent,
                                                  customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                  enableFeedback: true,
                                                  onTap: () {
                                                    state.service = state.myJobCards![index];
                      
                                                    Navigator.push(context, MaterialPageRoute(builder: (_) => JobCardDetails()));
                                                  },
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    state.getMyJobCardsStatus == GetMyJobCardsStatus.success ? state.myJobCards![index].jobCardNo! : 'JC-MAD-633',
                                                    style: const TextStyle(
                                                        fontWeight: FontWeight.w500, fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Gap(size.width * (isMobile ? 0.01 : 0)),
                                          Row(
                                            children: [
                                              Gap(size.width * (isMobile ? 0.055 : 0.024)),
                                              Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  'assets/images/registration_no.png',
                                                  scale: size.width * (isMobile ? 0.055 : 0.016),
                                                ),
                                              ),
                                              Gap(size.width * 0.02),
                                              Expanded(
                                                flex: 8,
                                                child: SizedBox(
                                                  width: size.width * (isMobile ? 0.28 : 0.16),
                                                  child: SingleChildScrollView(
                                                    scrollDirection: Axis.horizontal,
                                                    child: Text(
                                                      textAlign: TextAlign.center,
                                                      state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                          ? state.myJobCards![index].registrationNo!
                                                          : 'TS09ED7884',
                                                      style: const TextStyle(fontSize: 13),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Gap(size.width * (isMobile ? 0.01 : 0.0016)),
                                        ],
                                      ),
                                    ),
                                    Gap(size.width * (isMobile ? 0.008 : 0)),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Gap(size.height * 0.03),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Gap(size.width * 0.058),
                                              Expanded(
                                                flex: 2,
                                                child: Image.asset(
                                                  'assets/images/status.png',
                                                  scale: size.width * (isMobile ? 0.058 : 0.016),
                                                ),
                                              ),
                                              // Gap(size.width * 0.02),
                                              Expanded(
                                                flex: 6,
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                      ? state.myJobCards![index].status!
                                                      : 'Work in Progress',
                                                  style: const TextStyle(fontSize: 13),
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
                                  height: size.height * (isMobile ? 0.05 : 0.045),
                                  width: size.width * (isMobile ? 0.94 : 0.36),
                                  decoration: BoxDecoration(
                                      color: Colors.orange.shade200,
                                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Image.asset(
                                                'assets/images/customer.png',
                                                scale: size.width * (isMobile ? 0.06 : 0.024),
                                              ),
                                            ),
                                            Gap(size.width * (isMobile ? 0.02 : 0.008)),
                                            Expanded(
                                              flex: 8,
                                              child: SizedBox(
                                                width: size.width * (isMobile ? 0.36 : 0.16),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                        ? state.myJobCards![index].customerName!
                                                        : 'Customer Name',
                                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Gap(size.width * (isMobile ? 0.1 : 0.064)),
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Image.asset(
                                                'assets/images/call.png',
                                                scale: size.width * (isMobile ? 0.06 : 0.02),
                                              ),
                                            ),
                                            Gap(size.width * 0.02),
                                            Expanded(
                                              flex: 8,
                                              child: SizedBox(
                                                width: size.width * (isMobile ? 0.25 : 0.08),
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                                                        ? state.myJobCards![index].customerContact ?? '-'
                                                        : 'Contact Number',
                                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
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
                      ),
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
