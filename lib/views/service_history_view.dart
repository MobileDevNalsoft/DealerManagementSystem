import 'dart:developer';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ServiceHistoryView extends StatefulWidget {
  const ServiceHistoryView({super.key});

  @override
  State<ServiceHistoryView> createState() => _ServiceHistoryViewState();
}

class _ServiceHistoryViewState extends State<ServiceHistoryView> {
  late ServiceHistoryDataSource serviceHistoryDataSource;
  DataGridController dataGridController = DataGridController();
  final ServiceState serviceState = ServiceState();
  final CustomColumnSizer _customColumnSizer = CustomColumnSizer();
  @override
  void initState() {
    super.initState();
    serviceState.copyWith(status: ServiceStatus.initial);
    context
        .read<ServiceBloc>()
        .add(GetServiceHistory(year: '2022', getCompleted: 'true'));
    print('got service list');
    context.read<ServiceBloc>().state.status = ServiceStatus.initial;
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
      child:
          SafeArea(child: OrientationBuilder(builder: (context, orientation) {
        // SystemChrome.setPreferredOrientations([
        //   DeviceOrientation.landscapeLeft,
        //   DeviceOrientation.landscapeRight
        // ]);
        return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: const Color.fromARGB(255, 145, 19, 19),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
              title: const Text(
                "Service History",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              centerTitle: true,
            ),
            body: Container(
              height: size.height,
              width: double.infinity,
              margin: EdgeInsets.zero,
              padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.darken),
                    image: const AssetImage(
                      'assets/images/dms_bg.png',
                    ),
                    fit: BoxFit.cover),
              ),
              child: SfDataGridTheme(
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
                    switch (state.status) {
                      case ServiceStatus.loading:
                        return Transform(
                          transform: Matrix4.translationValues(0, -40, 0),
                          child: Center(
                            child: Lottie.asset(
                                'assets/lottie/car_loading.json',
                                height: size.height * 0.5,
                                width: size.width * 0.6),
                          ),
                        );
                      case ServiceStatus.success:
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
                          ),
                        );
                      default:
                        return SizedBox();
                    }
                  },
                ),
              ),
            ));
      })),
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
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
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
