import 'package:dms/inits/init.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../navigations/navigator_service.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  NavigatorService navigator = getIt<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Hero(
      tag: 'dashboard',
      transitionOnUserGestures: true,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: false,
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
                    navigator.pop();
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
            ),
          ),
          title: Container(
              alignment: Alignment.center,
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
              child: const Text(
                textAlign: TextAlign.center,
                'Dashboard',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 16),
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
                  stops: [0.1, 0.5, 1])),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(size.height * 0.01),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Gap(size.width * 0.04),
                    Expanded(
                      child: const Text(
                        'Job Cards This Week',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: size.height * 0.15,
                        width: size.width * 0.492,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(size.width * 0.02),
                                padding: EdgeInsets.all(size.width * 0.02),
                                height: size.height * 0.11,
                                width: size.width * 0.45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                    color: Colors.black12,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          blurStyle: BlurStyle.outer,
                                          spreadRadius: 0,
                                          color: Colors.black38,
                                          offset: const Offset(0, 0))
                                    ]),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(size.width * 0.02),
                                padding: EdgeInsets.all(size.width * 0.02),
                                height: size.height * 0.11,
                                width: size.width * 0.45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                    color: Colors.black54,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          blurStyle: BlurStyle.outer,
                                          spreadRadius: 0,
                                          color: Colors.black26,
                                          offset: const Offset(0, 0))
                                    ]),
                              ),
                            ),
                            Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(size.width * 0.02),
                                padding: EdgeInsets.all(size.width * 0.02),
                                height: size.height * 0.11,
                                width: size.width * 0.45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: const Text(
                                        'Open',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      child: Gap(size.height * 0.008),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.stacked_bar_chart_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              '4',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            'view all',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: size.height * 0.15,
                        width: size.width * 0.492,
                        child: Stack(
                          children: [
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(size.width * 0.02),
                                padding: EdgeInsets.all(size.width * 0.02),
                                height: size.height * 0.11,
                                width: size.width * 0.45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                    color: Colors.black12,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          blurStyle: BlurStyle.outer,
                                          spreadRadius: 0,
                                          color: Colors.black38,
                                          offset: const Offset(0, 0))
                                    ]),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                alignment: Alignment.centerLeft,
                                margin: EdgeInsets.all(size.width * 0.02),
                                padding: EdgeInsets.all(size.width * 0.02),
                                height: size.height * 0.11,
                                width: size.width * 0.45,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.white),
                                    color: Colors.black54,
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 10,
                                          blurStyle: BlurStyle.outer,
                                          spreadRadius: 0,
                                          color: Colors.black26,
                                          offset: const Offset(0, 0))
                                    ]),
                              ),
                            ),
                            Container(
                                margin: EdgeInsets.all(size.width * 0.02),
                                padding: EdgeInsets.all(size.width * 0.02),
                                alignment: Alignment.centerLeft,
                                height: size.height * 0.11,
                                width: size.width * 0.45,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Completed',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    Expanded(
                                      child: Gap(size.height * 0.008),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Icon(
                                              Icons.pie_chart_rounded,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              '5',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            'view all',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Gap(size.height * 0.6),
                flex: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
