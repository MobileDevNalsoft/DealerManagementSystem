import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';

class ServiceHistoryView extends StatefulWidget {
  const ServiceHistoryView({super.key});

  @override
  State<ServiceHistoryView> createState() => _ServiceHistoryViewState();
}

class _ServiceHistoryViewState extends State<ServiceHistoryView> {
  List<ServiceHistory> serviceHistory = getServiceHistory();

  late ServiceHistoryDataSource serviceHistoryDataSource;
  DataGridController dataGridController = DataGridController();
  @override
  void initState() {
    super.initState();
    serviceHistoryDataSource =
        ServiceHistoryDataSource(serviceHistoryData: serviceHistory);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    Size size = MediaQuery.of(context).size;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      },
      child:
          SafeArea(child: OrientationBuilder(builder: (context, orientation) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ]);
        return Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
              title: const Text(
                "Service History",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              centerTitle: true,
            ),
            body: Container(
              height: size.height,
              width: size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.darken),
                    image: const AssetImage(
                      'assets/images/dms_bg.png',
                    ),
                    fit: BoxFit.cover),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0, left: 16.0, right: 16.0, top: 60),
                child: SfDataGridTheme(
                  data: SfDataGridThemeData.raw(
                      headerColor: Colors.white,
                      currentCellStyle: const DataGridCurrentCellStyle(
                        borderColor: Colors.red,
                        borderWidth: 2,
                      )),
                  child: SfDataGrid(
                    source: serviceHistoryDataSource,
                    columnWidthMode: ColumnWidthMode.fill,
                    allowEditing: true,
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
                ),
              ),
            ));
      })),
    );
  }
}

class ServiceHistory {
  final int sno;
  final String date;
  final String jobCardNo;
  final String location;
  final String jobType;

  const ServiceHistory({
    required this.sno,
    required this.date,
    required this.jobCardNo,
    required this.location,
    required this.jobType,
  });
}

List<ServiceHistory> getServiceHistory() {
  return [
    const ServiceHistory(
        sno: 1,
        date: '2024-02-22',
        jobCardNo: '123456789',
        location: 'Main Workshop',
        jobType: 'General service'),
    const ServiceHistory(
        sno: 2,
        date: '2024-02-23',
        jobCardNo: '123456789',
        location: 'Main Workshop',
        jobType: 'General service'),
    const ServiceHistory(
        sno: 3,
        date: '2024-02-24',
        jobCardNo: '123456789',
        location: 'Main Workshop',
        jobType: 'General service'),
  ];
}

class ServiceHistoryDataSource extends DataGridSource {
  /// Creates the serviceHistory data source class with required details.
  ServiceHistoryDataSource({required List<ServiceHistory> serviceHistoryData}) {
    _serviceHistoryData = serviceHistoryData
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(
                columnName: 'sno',
                value: e.sno,
              ),
              DataGridCell<String>(columnName: 'date', value: e.date),
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
