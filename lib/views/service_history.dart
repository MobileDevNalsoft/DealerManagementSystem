import 'dart:developer';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/inits/init.dart';
import 'package:dms/models/services.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../navigations/navigator_service.dart';

class ServiceHistory extends StatefulWidget {
  const ServiceHistory({super.key});

  @override
  State<ServiceHistory> createState() => _ServiceHistoryState();
}

class _ServiceHistoryState extends State<ServiceHistory> {
  late ServiceHistoryDataSource serviceHistoryDataSource;
  DataGridController dataGridController = DataGridController();
  final ServiceState serviceState = ServiceState();
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();
  final NavigatorService navigator = getIt<NavigatorService>();
  @override
  void initState() {
    super.initState();
    serviceState.copyWith(getServiceStatus: GetServiceStatus.initial);
    context.read<ServiceBloc>().add(GetServiceHistory(query: '2022'));
    context.read<ServiceBloc>().state.getServiceStatus =
        GetServiceStatus.initial;
  }

  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.portraitUp,
  //     DeviceOrientation.portraitDown,
  //   ]);
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    // Set preferred orientations based on device type
    if (!isMobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.portraitUp,
        //   DeviceOrientation.portraitDown,
        // ]);
      },
      child: OrientationBuilder(builder: (context, orientation) {
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.landscapeLeft,
        //   DeviceOrientation.landscapeRight
        // ]);
        return Hero(
          tag: 'serviceHistory',
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
                      'Service History',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 16),
                    )),
                centerTitle: true,
              ),
              body: Container(
                height: size.height,
                width: double.infinity,
                margin: EdgeInsets.zero,
                padding: EdgeInsets.only(
                    top: size.height * 0.01, left: size.width * 0.01),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.black45, Colors.black26, Colors.black45],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.1, 0.5, 1]),
                ),
                child: SfDataGridTheme(
                  data: SfDataGridThemeData.raw(
                      headerColor: Colors.white,
                      currentCellStyle: const DataGridCurrentCellStyle(
                        borderColor: Colors.black,
                        borderWidth: 2,
                      )),
                  child: BlocBuilder<ServiceBloc, ServiceState>(
                    builder: (context, state) {
                      switch (state.getServiceStatus) {
                        case GetServiceStatus.loading:
                          return Transform(
                            transform: Matrix4.translationValues(0, -40, 0),
                            child: Center(
                              child: Lottie.asset(
                                  'assets/lottie/car_loading.json',
                                  height: size.height * 0.5,
                                  width: size.width * 0.6),
                            ),
                          );
                        case GetServiceStatus.success:
                          return SfDataGrid(
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
                              dataGridController
                                  .beginEdit(details.rowColumnIndex);
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
                          );
                        default:
                          return const SizedBox();
                      }
                    },
                  ),
                ),
              )),
        );
      }),
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
                value: serviceHistoryData.indexOf(e),
              ),
              DataGridCell<String>(columnName: 'date', value: e.scheduledDate),
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

// class MobileView extends StatefulWidget {
//   const MobileView({super.key});

//   @override
//   State<MobileView> createState() => _MobileViewState();
// }

// class _MobileViewState extends State<MobileView> {
//   List<ServiceHistory> serviceHistory = getServiceHistory();

//   late ServiceHistoryDataSource serviceHistoryDataSource;
//   DataGridController dataGridController = DataGridController();
//   @override
//   void initState() {
//     super.initState();
//     serviceHistoryDataSource =
//         ServiceHistoryDataSource(serviceHistoryData: serviceHistory);
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     List<String> columnButtons = [
//       "Date",
//       "Job Card No",
//       "Location",
//       "Job Type"
//     ];

//     List<GridColumn> gridColumns = [
//       GridColumn(
//           allowEditing: true,
//           width: 150,
//           columnName: 'sno',
//           label: Container(
//               padding: const EdgeInsets.all(16.0),
//               alignment: Alignment.center,
//               child: const Text(
//                 'Sno',
//               )))
//     ];

//     return Column(
//       
//       
//       children: [
//         SizedBox(
//           height: size.height * 0.03,
//           width: size.width,
//           child: ListView.separated(
//               separatorBuilder: (context, index) => Gap(size.height * 0.005),
//               shrinkWrap: true,
//               itemCount: columnButtons.length,
//               scrollDirection: Axis.horizontal,
//               padding: EdgeInsets.zero,
//               itemBuilder: (context, index) => Container(
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           color: const Color.fromARGB(255, 145, 19, 19)),
//                       borderRadius: BorderRadius.circular(50),
//                       color: Colors
//                           .transparent, //const Color.fromARGB(255, 145, 19, 19),
//                     ),
//                     padding: EdgeInsets.only(
//                         left: size.width * 0.03, right: size.width * 0.03),
//                     child: InkWell(
//                       child: Text(
//                         columnButtons[index],
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   )),
//         ),
//         SizedBox(
//           height: size.height * 0.7,
//           child: PageView.builder(
//             itemBuilder: (context, index) {
//               return SfDataGrid(
//                   source: MobileServiceHistoryDataSource(),
//                   columns: gridColumns +
//                       <GridColumn>[
//                         GridColumn(
//                             columnName: 'date',
//                             label: Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 alignment: Alignment.center,
//                                 child: const Text('Date'))),
//                         GridColumn(
//                             columnName: 'Job Card no.',
//                             label: Container(
//                                 padding: const EdgeInsets.all(8.0),
//                                 alignment: Alignment.center,
//                                 child: InkWell(
//                                   onTap: () {},
//                                   child: const Text(
//                                     'Job Card no.',
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 )))
//                       ]);
//             },
//           ),
//         )
//       ],
//     );
//   }
// }

// class MobileServiceHistoryDataSource extends DataGridSource {
//   /// Creates the serviceHistory data source class with required details.
//   ServiceHistoryDataSource({required List<ServiceHistory> serviceHistoryData}) {
//     _serviceHistoryData = serviceHistoryData
//         .map<DataGridRow>((e) => DataGridRow(cells: [
//               DataGridCell<String>(columnName: 'date', value: e.date),
//               DataGridCell<String>(
//                   columnName: 'Job Card no.', value: e.jobCardNo),
//               DataGridCell<String>(columnName: 'Location', value: e.location),
//               DataGridCell<String>(columnName: 'Job Type', value: e.jobType),
//             ]))
//         .toList();
//   }

//   List<DataGridRow> _serviceHistoryData = [];

//   @override
//   List<DataGridRow> get rows => _serviceHistoryData;

//   @override
//   DataGridRowAdapter buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         color: Colors.white,
//         cells: row.getCells().map<Widget>((e) {
//           print("e ${e.columnName}");
//           return e.columnName == "Job Card no."
//               ? InkWell(
//                   onTap: () {
//                     print("${e.value}");
//                   },
//                   child: Center(
//                       child: Text(
//                     e.value.toString(),
//                     style: const TextStyle(color: Colors.blue),
//                   )),
//                 )
//               : Container(
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(e.value.toString()),
//                 );
//         }).toList());
//   }
// }
