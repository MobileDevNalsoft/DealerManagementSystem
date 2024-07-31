import 'package:dms/inits/init.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../bloc/service/service_bloc.dart';
import 'dashboard.dart';
import 'jobcard_details.dart';

class MyJobcards extends StatefulWidget {
  const MyJobcards({super.key});

  @override
  State<MyJobcards> createState() => _MyJobcardsState();
}

class _MyJobcardsState extends State<MyJobcards> {
  late ServiceBloc _serviceBloc;

  @override
  void initState() {
    super.initState();

    // initiating service bloc variable
    _serviceBloc = context.read<ServiceBloc>();

    // setting initial statuses of service and job card status to initial
    _serviceBloc.state.getMyJobCardsStatus = GetMyJobCardsStatus.initial;

    // invoking getjob cards and getservice history to invoke bloc method to get data from db
    _serviceBloc.add(GetMyJobCards(
        query: getIt<SharedPreferences>().getString('service_advisor_id')));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        elevation: 0,
        backgroundColor: Colors.black45,
        leadingWidth: size.width * 0.14,
        leading: Container(
          margin: EdgeInsets.only(left: size.width * 0.045),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 0,
                    color: Colors.orange.shade200,
                    offset: const Offset(0, 0))
              ]),
          child: Transform(
            transform: Matrix4.translationValues(-3, 0, 0),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon:
                    const Icon(Icons.arrow_back_rounded, color: Colors.white)),
          ),
        ),
        title: Container(
            height: size.height * 0.05,
            width: size.width * 0.45,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10,
                      blurStyle: BlurStyle.outer,
                      spreadRadius: 0,
                      color: Colors.orange.shade200,
                      offset: const Offset(0, 0))
                ]),
            child: const Center(
              child: Text(
                textAlign: TextAlign.center,
                'My Job Cards',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16),
              ),
            )),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black45, Colors.black26, Colors.black45],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.5, 1]),
        ),
        child: BlocBuilder<ServiceBloc, ServiceState>(
          builder: (context, state) {
            return ListView.builder(
              itemCount:
                  state.getMyJobCardsStatus == GetMyJobCardsStatus.success
                      ? state.myJobCards!.length
                      : 7,
              itemBuilder: (context, index) => Skeletonizer(
                  enableSwitchAnimation: true,
                  enabled: state.getMyJobCardsStatus ==
                          GetMyJobCardsStatus.loading ||
                      state.getMyJobCardsStatus == GetMyJobCardsStatus.initial,
                  child: SizedBox(
                    height: size.height * 0.15,
                    width: size.width * 0.95,
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          customBorder: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          enableFeedback: true,
                                          onTap: () {
                                            state.jobCardNo = state
                                                .myJobCards![index].jobCardNo!;
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        JobCardDetails(
                                                            service: state
                                                                    .myJobCards![
                                                                index])));
                                          },
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            state.getMyJobCardsStatus ==
                                                    GetMyJobCardsStatus.success
                                                ? state.myJobCards![index]
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
                                              state.getMyJobCardsStatus ==
                                                      GetMyJobCardsStatus
                                                          .success
                                                  ? state.myJobCards![index]
                                                      .registrationNo!
                                                  : 'TS09ED7884',
                                              style:
                                                  const TextStyle(fontSize: 13),
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
                                    Gap(size.height * 0.03),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Gap(size.width * 0.058),
                                        Image.asset('assets/images/status.png',
                                            scale: size.width * 0.058),
                                        Gap(size.width * 0.02),
                                        Text(
                                          textAlign: TextAlign.center,
                                          state.getMyJobCardsStatus ==
                                                  GetMyJobCardsStatus.success
                                              ? state.myJobCards![index].status!
                                              : 'Work in Progress',
                                          style: const TextStyle(fontSize: 13),
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
                                            state.getMyJobCardsStatus ==
                                                    GetMyJobCardsStatus.success
                                                ? state.myJobCards![index]
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
                                            state.getMyJobCardsStatus ==
                                                    GetMyJobCardsStatus.success
                                                ? state.myJobCards![index]
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
                  )),
            );
          },
        ),
      ),
    );
  }
}
