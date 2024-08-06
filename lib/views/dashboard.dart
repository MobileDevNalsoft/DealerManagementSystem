import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                  Navigator.pop(context);
                },
                icon:
                    const Icon(Icons.arrow_back_rounded, color: Colors.white)),
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
          children: [
            Gap(size.height * 0.03),
            Row(
              children: [
                Gap(size.width * 0.04),
                const Text(
                  'Job Cards This Week',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )
              ],
            ),
            Gap(size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
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
                            children: [
                              const Text(
                                'Open',
                                style: TextStyle(color: Colors.white),
                              ),
                              Gap(size.height * 0.008),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stacked_bar_chart_rounded,
                                    color: Colors.white,
                                  ),
                                  Gap(size.height * 0.008),
                                  Text(
                                    '4',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'view all',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          )),
                    ],
                  ),
                ),
                SizedBox(
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
                            children: [
                              Text(
                                'Completed',
                                style: TextStyle(color: Colors.white),
                              ),
                              Gap(size.height * 0.008),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.pie_chart_rounded,
                                    color: Colors.white,
                                  ),
                                  Gap(size.height * 0.008),
                                  Text(
                                    '5',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    'view all',
                                    style: TextStyle(color: Colors.white),
                                  ))
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}