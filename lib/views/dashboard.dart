import 'package:dms/inits/init.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../navigations/navigator_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> with TickerProviderStateMixin {
  // navigator service
  NavigatorService navigator = getIt<NavigatorService>();

  // Define lists for job card statuses and their corresponding values (replace with actual data)
  List<BarData> barData = [
    BarData(xLabel: 'N', yValue: 10, abbreviation: 'New'),
    BarData(xLabel: 'I', yValue: 4, abbreviation: 'In Progress'),
    BarData(xLabel: 'QC', yValue: 6, abbreviation: 'Quality Check'),
    BarData(xLabel: 'IO', yValue: 3, abbreviation: 'Inspection Out'),
    BarData(xLabel: 'CL', yValue: 20, abbreviation: 'Completed'),
    BarData(xLabel: 'C', yValue: 2, abbreviation: 'Closed')
  ];

  // animation variables
  Tween<double> tween = Tween(begin: 0.0, end: 1.0);
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation = CurvedAnimation(parent: animationController, curve: Curves.ease);
    animation.addListener(() {
      setState(() {});
    });
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
    Size size = MediaQuery.of(context).size;

    // Wrap the entire dashboard with a Hero widget for transitions
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    return PopScope(
      onPopInvoked: (didPop) => animationController.stop(),
      child: Hero(
        tag: 'dashboard',
        transitionOnUserGestures: true,
        child: Scaffold(
          // Prevent keyboard from resizing the body
          resizeToAvoidBottomInset: false,
          // Disable app bar extending behind content
          extendBodyBehindAppBar: false,
          appBar: DMSCustomWidgets.appBar(size: size, isMobile: isMobile, title: 'DashBoard'),
          // Create the body of the dashboard
          body: Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black45, Colors.black26, Colors.black45], begin: Alignment.topCenter, end: Alignment.bottomCenter, stops: [0.1, 0.5, 1])),
            // This Column widget defines a section with the title "Job Cards This Week" and a container
            child: Column(
              mainAxisSize: MainAxisSize.min, // Set minimum height for this column
              children: [
                Gap(size.height * 0.01),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Gap(size.width * 0.04),
                      Expanded(
                        child: Text(
                          'Job Cards This Week',
                          style: TextStyle(fontSize: (isMobile ? 16 : 18), fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Gap(size.width * 0.01),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          height: size.height * 0.15,
                          width: size.width * 0.492,
                          // Stack the container with background layers
                          child: Stack(
                            children: [
                              // Black background with inner shadow
                              Positioned(
                                top: 8,
                                right: size.width * 0.025,
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
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.black38, offset: Offset(0, 0))
                                      ]),
                                ),
                              ),

                              Positioned(
                                top: 4,
                                right: size.width * 0.016,
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
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.black26, offset: Offset(0, 0))
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
                                    border: const Border(left: BorderSide(color: Colors.white), bottom: BorderSide(color: Colors.white)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Open',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Gap(size.height * 0.008),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                              flex: 3,
                                              child: Text(
                                                '4',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              'view all',
                                              style: TextStyle(color: Colors.white),
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
                          // Stack the container with background layers
                          child: Stack(
                            children: [
                              // Black background with inner shadow
                              Positioned(
                                top: 8,
                                right: size.width * 0.025,
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
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.black38, offset: Offset(0, 0))
                                      ]),
                                ),
                              ),

                              Positioned(
                                top: 4,
                                right: size.width * 0.016,
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
                                      boxShadow: const [
                                        BoxShadow(blurRadius: 10, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.black26, offset: Offset(0, 0))
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
                                    border: const Border(left: BorderSide(color: Colors.white), bottom: BorderSide(color: Colors.white)),
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Completed',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Gap(size.height * 0.008),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                              flex: 3,
                                              child: Text(
                                                '5',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 2,
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              'view all',
                                              style: TextStyle(color: Colors.white),
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

                // This section builds the top portion of the job card stats widget
                Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Gap(size.width * 0.06),
                      Expanded(
                        child: Text(
                          "Today's Job Cards Stats",
                          style: TextStyle(fontSize: (isMobile ? 16 : 18), fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                        ),
                      )
                    ],
                  ),
                ),
                // This section builds the bar chart
                Expanded(
                    flex: 6,
                    child: Opacity(
                      opacity: animation.value,
                      child: Container(
                        padding: EdgeInsets.only(top: size.height * 0.02),
                        decoration:
                            BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.black, border: Border.all(color: Colors.white, width: 1.5)),
                        width: size.width * 0.9,
                        child: LayoutBuilder(builder: (context, constraints) {
                          return SfCartesianChart(
                              primaryXAxis: CategoryAxis(
                                labelStyle: TextStyle(color: Colors.white, fontSize: isMobile ? 14 : 16),
                                majorGridLines: const MajorGridLines(
                                  width: 0,
                                ),
                                majorTickLines: const MajorTickLines(width: 0),
                                axisLine: const AxisLine(width: 0),
                              ),
                              primaryYAxis: const NumericAxis(
                                isVisible: false,
                              ),
                              plotAreaBorderWidth: 0,
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                                color: Colors.white,
                                textStyle: const TextStyle(color: Colors.black),
                                textAlignment: ChartAlignment.center,
                                animationDuration: 100,
                                duration: 2000,
                                shadowColor: Colors.black,
                                builder: (data, point, series, pointIndex, seriesIndex) => IntrinsicWidth(
                                  child: Container(
                                      height: constraints.maxHeight * 0.1,
                                      margin: EdgeInsets.only(
                                          left: constraints.maxWidth * 0.03, right: constraints.maxWidth * 0.03, top: constraints.maxWidth * 0.02),
                                      child: Text((data as BarData).abbreviation)),
                                ),
                              ),
                              borderWidth: 0,
                              series: [
                                ColumnSeries<BarData, String>(
                                  dataSource: barData,
                                  xValueMapper: (BarData data, _) => data.xLabel,
                                  yValueMapper: (BarData data, _) => data.yValue,
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.orange.shade200,
                                  dataLabelMapper: (datum, index) => datum.yValue.toString(),
                                  dataLabelSettings: DataLabelSettings(
                                    isVisible: true,
                                    useSeriesColor: true,
                                    builder: (data, point, series, pointIndex, seriesIndex) => Text(
                                      (data as BarData).yValue.toString(),
                                      style: TextStyle(color: Colors.white, fontSize: isMobile ? 10 : 14),
                                    ),
                                  ),
                                  width: 0.6,
                                )
                              ]);
                        }),
                      ),
                    )),
                Expanded(
                  flex: 4,
                  child: Gap(size.height * 0.6),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BarData {
  String xLabel;
  int yValue;
  String abbreviation;
  BarData({required this.xLabel, required this.yValue, required this.abbreviation});
}
