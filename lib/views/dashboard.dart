import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/views/service_main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../inits/init.dart';
import '../models/services.dart';
import 'login.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late ServiceBloc _serviceBloc;
  final PageController pageController =
      PageController(initialPage: 0, viewportFraction: 1);

  @override
  void initState() {
    super.initState();

    // initiating service bloc variable
    _serviceBloc = context.read<ServiceBloc>();

    // setting initial statuses of service and job card status to initial
    _serviceBloc.state.status = ServiceStatus.initial;
    _serviceBloc.state.jobCardStatus = JobCardStatus.initial;

    // invoking getjob cards and getservice history to invoke bloc method to get data from db
    _serviceBloc.add(GetJobCards(query: 'Main  Workshop'));
    _serviceBloc.add(GetServiceHistory(query: '2022'));
  }

  @override
  Widget build(BuildContext context) {
    // responsive UI
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 174, 174),
      extendBody:
          false, // restricts the scaffold till above the bottom navigation bar in this case
      body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 241, 193, 193),
                  Color.fromARGB(255, 235, 136, 136),
                  Color.fromARGB(255, 226, 174, 174)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.01, 0.35, 1]),
          ),
          child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                _serviceBloc
                    .add(BottomNavigationBarClicked(index: value == 0 ? 0 : 2));
              },
              children: [
                JobCardPage(
                  serviceBloc: _serviceBloc,
                ),
                Services()
              ])),
      bottomNavigationBar: BlocBuilder<ServiceBloc, ServiceState>(
        builder: (context, state) {
          return CircleNavBar(
            activeIcons: [
              Icon(
                Icons.home,
                color: const Color.fromARGB(255, 145, 19, 19),
                size: size.height * 0.04,
              ),
              Icon(
                Icons.add,
                color: const Color.fromARGB(255, 145, 19, 19),
                size: size.height * 0.04,
              ),
              Icon(
                Icons.history,
                color: const Color.fromARGB(255, 145, 19, 19),
                size: size.height * 0.04,
              ),
            ],
            inactiveIcons: [
              Icon(
                Icons.home,
                size: size.height * 0.04,
                color: const Color.fromARGB(255, 145, 19, 19),
              ),
              Icon(
                Icons.add,
                size: size.height * 0.04,
                color: const Color.fromARGB(255, 145, 19, 19),
              ),
              Icon(
                Icons.history,
                size: size.height * 0.04,
                color: const Color.fromARGB(255, 145, 19, 19),
              ),
            ],
            iconCurve: Curves.easeIn,
            iconDurationMillSec: 1000,
            tabCurve: Curves.easeIn,
            tabDurationMillSec: 1000,
            color: const Color.fromARGB(255, 236, 224, 224),
            height: size.height * 0.07,
            circleWidth: size.height * 0.06,
            activeIndex: state.bottomNavigationBarActiveIndex!,
            onTap: (index) {
              _serviceBloc.add(BottomNavigationBarClicked(index: index));
              if (index == 0) {
                pageController.animateToPage(0,
                    duration: const Duration(seconds: 1), curve: Curves.ease);
              } else if (index == 1) {
                // added delay to show the button flow animation in bottom navigation bar
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeView()));
                });
              } else {
                pageController.animateToPage(1,
                    duration: const Duration(seconds: 1), curve: Curves.ease);
              }
            },
            padding: EdgeInsets.only(
                left: size.width * 0.02,
                right: size.width * 0.02,
                bottom: size.width * 0.02),
            cornerRadius: const BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
              bottomRight: Radius.circular(30),
              bottomLeft: Radius.circular(30),
            ),
            shadowColor: const Color.fromARGB(255, 201, 94, 94),
            elevation: 5,
          );
        },
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
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: 100,
      child: ClipPath(
          clipper: BackgroundWaveClipper(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 100,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 145, 19, 19)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(size.width * (shrinkOffset < 45 ? 0.03 : 0.4)),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    'Job Cards',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18),
                  ),
                ),
                if (shrinkOffset > 45) const Spacer(),
                if (shrinkOffset > 45)
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
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Colors.transparent),
                        height: size.height * 0.05,
                        width: size.width * 0.25,
                        padding: const EdgeInsets.only(left: 14, right: 14),
                      ),
                      iconStyleData: IconStyleData(
                        icon: const Icon(
                          Icons.person_pin,
                          color: Colors.white,
                        ),
                        iconSize: size.height * 0.038,
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
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.01),
                            child: const Text(
                              'Log out',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                // IconButton(
                //   color: Colors.white,
                //     onPressed: () {
                //       sharedPreferences.setBool("isLogged", false);
                //       Navigator.pushAndRemoveUntil(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => const LoginView(),
                //         ),
                //         (route) => false,
                //       );
                //     },
                //     icon: const Icon(Icons.person_pin))
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
    // size will be of the container's
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

class JobCardPage extends StatelessWidget {
  ServiceBloc? _serviceBloc;
  JobCardPage({super.key, required ServiceBloc serviceBloc})
      : _serviceBloc = serviceBloc;

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
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          vertical: size.height * 0.005,
                          horizontal: size.width * 0.026),
                      color: Colors.white,
                      elevation: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: size.height * 0.05,
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    bottomLeft: Radius.circular(10))),
                            child: Text(
                              textAlign: TextAlign.center,
                              state.jobCardStatus != JobCardStatus.loading
                                  ? state.jobCards![index].jobCardNo!
                                  : 'JC-MAD-633',
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: size.height * 0.05,
                            width: size.width * 0.39,
                            decoration: const BoxDecoration(
                                border: Border.symmetric(
                                    horizontal:
                                        BorderSide(color: Colors.black12)),
                                borderRadius: BorderRadius.only()),
                            child: Text(
                              textAlign: TextAlign.center,
                              state.jobCardStatus != JobCardStatus.loading
                                  ? state.jobCards![index].registrationNo!
                                  : 'TS09ED7884',
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              height: size.height * 0.05,
                              width: size.width * 0.25,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton2<String>(
                                  onMenuStateChange: (isOpen) {
                                    _serviceBloc!
                                        .add(DropDownOpenClose(isOpen: isOpen));
                                  },
                                  isExpanded: true,
                                  items: ['I', 'N', 'CL', 'C']
                                      .map((String item) =>
                                          DropdownMenuItem<String>(
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
                                  value: state.jobCardStatus ==
                                          JobCardStatus.success
                                      ? state.jobCards![index].status!
                                      : 'I',
                                  onChanged: (String? value) {
                                    _serviceBloc!
                                        .state.jobCards![index].status = value;
                                    context
                                        .read<ServiceBloc>()
                                        .add(JobCardStatusUpdated());
                                  },
                                  buttonStyleData: ButtonStyleData(
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight:
                                                const Radius.circular(10)),
                                        color: _serviceBloc!.state.status! ==
                                                ServiceStatus.success
                                            ? _serviceBloc!
                                                        .state
                                                        .jobCards![index]
                                                        .status ==
                                                    'I'
                                                ? Colors.yellow.shade200
                                                : _serviceBloc!
                                                            .state
                                                            .jobCards![index]
                                                            .status ==
                                                        'N'
                                                    ? Colors.orange.shade200
                                                    : _serviceBloc!
                                                                .state
                                                                .jobCards![
                                                                    index]
                                                                .status ==
                                                            'CL'
                                                        ? Colors.green.shade200
                                                        : Colors.red.shade200
                                            : null),
                                    height: size.height * 0.05,
                                    width: size.width * 0.25,
                                    padding: const EdgeInsets.only(
                                        left: 14, right: 14),
                                  ),
                                  iconStyleData: IconStyleData(
                                    icon: Icon(_serviceBloc!.state.dropDownOpen!
                                        ? Icons.keyboard_arrow_up_rounded
                                        : Icons.keyboard_arrow_down_rounded),
                                    iconSize: 14,
                                    iconEnabledColor: Colors.black,
                                    iconDisabledColor: Colors.black,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    maxHeight: size.height * 0.3,
                                    width: size.width * 0.15,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    offset: const Offset(0, 0),
                                    scrollbarTheme: ScrollbarThemeData(
                                      radius: const Radius.circular(40),
                                      thickness:
                                          WidgetStateProperty.all<double>(6),
                                      thumbVisibility:
                                          WidgetStateProperty.all<bool>(true),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    height: 30,
                                    padding:
                                        EdgeInsets.only(left: 14, right: 14),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ));
              },
                      childCount: state.status != ServiceStatus.success
                          ? 15
                          : state.jobCards!.length)),
            ],
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
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
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 145, 19, 19)),
            child: const Center(
              child: Text(
                'Service History',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18),
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

class CustomColumnSizer extends ColumnSizer {
  @override
  double computeCellWidth(GridColumn column, DataGridRow row, Object? cellValue,
      TextStyle textStyle) {
    if (column.columnName == 'Sno') {
      cellValue = cellValue;
    } else if (column.columnName == 'Date') {
      cellValue = cellValue;
    }

    return super.computeCellWidth(column, row, cellValue, textStyle);
  }
}

class ServiceHistoryDataSource extends DataGridSource {
  /// Creates the serviceHistory data source class with required details.
  ServiceHistoryDataSource({required List<Service> serviceHistoryData}) {
    _serviceHistoryData = serviceHistoryData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                columnName: 'sno',
                value: e.sNo,
              ),
              DataGridCell<String>(columnName: 'date', value: e.scheduleDate),
              DataGridCell<String>(
                  columnName: 'Job Card no.', value: e.jobCardNo),
              DataGridCell<String>(columnName: 'Location', value: e.location),
              DataGridCell<String>(columnName: 'Job Type', value: e.jobType),
            ]))
        .toList();
  }

  List<DataGridRow> _serviceHistoryData = [];

  @override
  List<DataGridRow> get rows => _serviceHistoryData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        color: Colors.white,
        cells: row.getCells().map<Widget>((e) {
          print("e ${e.columnName}");
          return e.columnName == "Job Card no."
              ? InkWell(
                  onTap: () {
                    print("${e.value}");
                  },
                  child: Center(
                      child: Text(
                    e.value.toString(),
                    style: const TextStyle(color: Colors.blue),
                  )),
                )
              : Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8.0),
                  child: Text(e.value.toString()),
                );
        }).toList());
  }
}