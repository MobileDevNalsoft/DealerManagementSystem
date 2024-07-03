import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/views/homeview.dart';
import 'package:dms/views/service_history_view.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../inits/init.dart';
import 'login.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late ServiceBloc _bloc;
  DataGridController dataGridController = DataGridController();
  final ServiceState serviceState = ServiceState();
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1);

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ServiceBloc>();

    context.read<ServiceBloc>().state.status = ServiceStatus.initial;
    context.read<ServiceBloc>().state.jobCardStatus = JobCardStatus.initial;

    _bloc.add(GetJobCards(query: 'Main  Workshop'));
    _bloc.add(GetServiceHistory(query: '2022'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      extendBody: true,
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  // Color.fromARGB(255, 255, 231, 231),
                  Color.fromARGB(255, 238, 209, 209),
                  Color.fromARGB(255, 238, 194, 194),
                  Color.fromARGB(255, 231, 200, 200)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.01, 0.35, 1]),
          ),
          child: PageView(controller: pageController, children: [
            const Column(
              children: [
                JobCardPage(),
              ],
            ),
            Services()
          ])),
      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.home, color: Color.fromARGB(255, 145, 19, 19)),
          Icon(Icons.add, color: Color.fromARGB(255, 145, 19, 19)),
          Icon(Icons.history, color: Color.fromARGB(255, 145, 19, 19)),
        ],
        inactiveIcons: const [
          Icon(
            Icons.home,
            color: Color.fromARGB(255, 145, 19, 19),
          ),
          Icon(
            Icons.add,
            color: Color.fromARGB(255, 145, 19, 19),
          ),
          Icon(
            Icons.history,
            color: Color.fromARGB(255, 145, 19, 19),
          ),
        ],
        color: const Color.fromARGB(255, 236, 232, 232),
        height: size.height * 0.07,
        circleWidth: size.height * 0.06,
        activeIndex: 1,
        onTap: (index) {
          if (index == 0) {
            pageController.animateToPage(0,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          } else if (index == 1) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeView()));
          } else {
            pageController.animateToPage(1,
                duration: const Duration(seconds: 1), curve: Curves.ease);
          }
        },
        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
          bottomRight: Radius.circular(24),
          bottomLeft: Radius.circular(24),
        ),
        shadowColor: const Color.fromARGB(255, 201, 94, 94),
        elevation: 5,
      ),
    ));
  }
}

class SliverAppBar extends SliverPersistentHeaderDelegate {
  final SharedPreferences sharedPreferences = getIt<SharedPreferences>();
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(
      height: 280,
      child: ClipPath(
          clipper: BackgroundWaveClipper(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 145, 19, 19),
                Color.fromARGB(255, 201, 94, 94)
              ],
            )),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    'Job Cards',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sharedPreferences.setBool("isLogged", false);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.person_pin))
              ],
            ),
          )),
    );
  }

  @override
  double get maxExtent => 100;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}

class BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    print('height ${size.height} width ${size.width}');
    Path path = Path();

    const minSize = 50.0;

    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();

    path.lineTo(0, size.height - p1Diff);

    final controlPoint1 = Offset(size.width * 0.2, size.height);
    final controlPoint2 =
        Offset(size.width * 0.8, minSize + (minSize - size.height * 0.75) * 2);

    print('control point 1 $controlPoint1 control point 2 $controlPoint2');
    final endPoint = Offset(size.width, minSize);

    path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
        controlPoint2.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

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
      height: size.height * 0.92,
      width: size.width,
      child: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                delegate: SliverAppBar(),
                // Set this param so that it won't go off the screen when scrolling
                pinned: true,
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return Skeletonizer(
                  enableSwitchAnimation: true,
                  enabled: state.jobCardStatus == JobCardStatus.loading,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: size.height * 0.05,
                        width: size.width * 0.3,
                        child: Text(
                          state.jobCardStatus != JobCardStatus.loading
                              ? state.jobCards![index].jobCardNo!
                              : 'JC-MAD-633',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: size.height * 0.05,
                        width: size.width * 0.3,
                        child: Text(
                          state.jobCardStatus != JobCardStatus.loading
                              ? state.jobCards![index].registrationNo!
                              : 'TS09ED7884',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          height: size.height * 0.05,
                          width: size.width * 0.4,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                              onMenuStateChange: (isOpen) {},
                              isExpanded: true,
                              items: ['I', 'N', 'CL', 'C']
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(
                                              item,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ))
                                  .toList(),
                              value:
                                  state.jobCardStatus == JobCardStatus.success
                                      ? state.jobCards![index].status!
                                      : 'I',
                              onChanged: (String? value) {
                                context
                                    .read<ServiceBloc>()
                                    .state
                                    .jobCards![index]
                                    .status = value;
                                context
                                    .read<ServiceBloc>()
                                    .add(JobCardStatusUpdated());
                              },
                              buttonStyleData: ButtonStyleData(
                                height: size.height * 0.04,
                                width: size.width * 0.5,
                                padding:
                                    const EdgeInsets.only(left: 14, right: 14),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  color: Colors.white,
                                ),
                                elevation: 0,
                              ),
                              iconStyleData: const IconStyleData(
                                icon: Icon(!false
                                    ? Icons.keyboard_arrow_down_rounded
                                    : Icons.keyboard_arrow_up_rounded),
                                iconSize: 14,
                                iconEnabledColor: Colors.black,
                                iconDisabledColor: Colors.black,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: size.height * 0.3,
                                width: size.width * 0.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                offset: const Offset(0, 0),
                                scrollbarTheme: ScrollbarThemeData(
                                  radius: const Radius.circular(40),
                                  thickness: WidgetStateProperty.all<double>(6),
                                  thumbVisibility:
                                      WidgetStateProperty.all<bool>(true),
                                ),
                              ),
                              menuItemStyleData: const MenuItemStyleData(
                                height: 30,
                                padding: EdgeInsets.only(left: 14, right: 14),
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              },
                      childCount: state.status != ServiceStatus.success
                          ? 50
                          : state.jobCards!.length)),
            ],
          );
        },
      ),
    );
  }
}

class Services extends StatelessWidget {
  Services({super.key});
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();
  DataGridController dataGridController = DataGridController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      width: size.width,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              // Color.fromARGB(255, 255, 231, 231),
              Color.fromARGB(255, 238, 209, 209),
              Color.fromARGB(255, 238, 194, 194),
              Color.fromARGB(255, 231, 200, 200)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.01, 0.35, 1]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 50,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 201, 94, 94),
                Color.fromARGB(255, 145, 19, 19)
              ],
            )),
            child: Center(
              child: Text(
                'Service History',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    fontSize: 22),
              ),
            ),
          ),
          SfDataGridTheme(
            data: SfDataGridThemeData.raw(
                headerColor: Colors.white,
                currentCellStyle: const DataGridCurrentCellStyle(
                  borderColor: Colors.red,
                  borderWidth: 2,
                )),
            child: BlocConsumer<ServiceBloc, ServiceState>(
              listener: (context, state) {
                if (state.status == ServiceStatus.success) {}
              },
              builder: (context, state) {
                print('state ${state.status}');
                switch (state.status) {
                  case ServiceStatus.loading:
                    return Transform(
                      transform: Matrix4.translationValues(0, -40, 0),
                      child: Center(
                        child: Lottie.asset('assets/lottie/car_loading.json',
                            height: size.height * 0.5, width: size.width * 0.6),
                      ),
                    );
                  case ServiceStatus.success:
                    print('services ${state.services}');
                    return Expanded(
                      flex: 1,
                      child: SfDataGrid(
                        columnSizer: _customColumnSizer,
                        columnWidthMode: ColumnWidthMode.fitByColumnName,
                        source: ServiceHistoryDataSource(
                            serviceHistoryData: state.services!),
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        showHorizontalScrollbar: false,
                        allowEditing: true,
                        shrinkWrapColumns: false,
                        shrinkWrapRows: false,
                        allowSorting: true,
                        allowColumnsResizing: true,
                        allowColumnsDragging: true,
                        columnResizeMode: ColumnResizeMode.onResize,
                        allowFiltering: true,
                        editingGestureType: EditingGestureType.doubleTap,
                        onCellDoubleTap: (details) {
                          print(details.rowColumnIndex);
                          dataGridController.beginEdit(details.rowColumnIndex);
                        },
                        controller: dataGridController,
                        columns: <GridColumn>[
                          GridColumn(
                              allowEditing: true,
                              width: 150,
                              columnName: 'sno',
                              label: Container(
                                  padding: const EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Sno',
                                  ))),
                          GridColumn(
                              columnName: 'date',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text('Date'))),
                          GridColumn(
                              columnName: 'Job Card no.',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: InkWell(
                                    onTap: () {},
                                    child: const Text(
                                      'Job Card no.',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))),
                          GridColumn(
                              columnName: 'Location',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text('Location'))),
                          GridColumn(
                              columnName: 'Job Type',
                              label: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: const Text('Job Type'))),
                        ],
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
