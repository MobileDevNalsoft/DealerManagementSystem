import 'package:dms/providers/service_history_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';



class ServiceHistoryView extends StatefulWidget {
  const ServiceHistoryView({super.key});

  @override
  State<ServiceHistoryView> createState() => _ServiceHistoryViewState();
}

class _ServiceHistoryViewState extends State<ServiceHistoryView> {
  late List<ServiceHistory> serviceHistory = getServiceHistory();

  late ServiceHistoryDataSource serviceHistoryDataSource;
  DataGridController dataGridController = DataGridController();
  @override
  void initState() {
    super.initState();
    serviceHistoryDataSource =
        ServiceHistoryDataSource(serviceHistoryData: serviceHistory);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                'Service History',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.white,
              ),
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      'assets/images/dms_bg.png',
                    ),
                    fit: BoxFit.cover),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData.raw(
                        headerColor: Colors.white,
                        currentCellStyle: DataGridCurrentCellStyle(
                          borderColor: Colors.red,
                          borderWidth: 2,
                        )),
                    child: SfDataGrid(
                      allowExpandCollapseGroup: true,
                      source: serviceHistoryDataSource,
                      
                      columnWidthMode: ColumnWidthMode.fill,
                      allowEditing: true,
                      allowSorting: true,
                      allowColumnsResizing: true,
                      // allowColumnsDragging: true,
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
                            allowEditing: false,
                            allowFiltering: false,
                            allowSorting: false,
                            columnWidthMode: ColumnWidthMode.fitByColumnName,
                            columnName: 'sno',
                            label: Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                  'Sno',
                                ))),
                        GridColumn(

                          columnWidthMode: ColumnWidthMode.auto,
                          
                            allowFiltering: false,
                            columnName: 'date',
                            filterPopupMenuOptions: FilterPopupMenuOptions(
                                filterMode: FilterMode.checkboxFilter,
                                showColumnName: true),
                            label: Container(
                              padding: EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      final pickedDateTime = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime(2025),
                                      );
                                      if (pickedDateTime != null) {
                                        Provider.of<ServiceHistoryProvider>(context,
                                                listen: false)
                                            .selectedDateTime = pickedDateTime;
                                          serviceHistory = getServiceHistory(dateFilter: 
                                              pickedDateTime
                                                  .toString()
                                                  .substring(0, 10));
                                          print(pickedDateTime.toString());
                                          setState(() {
                                            serviceHistoryDataSource=ServiceHistoryDataSource(serviceHistoryData: serviceHistory);
                                          });
                                      
                                      }
                                    },
                                    child: Text("Date"),
                                  ),
                                   if(Provider.of<ServiceHistoryProvider>(context,
                                                listen: false)
                                            .selectedDateTime!=null) IconButton(onPressed: (){
                                              setState(() {
                                                  serviceHistory = getServiceHistory();
                                                  Provider.of<ServiceHistoryProvider>(context,
                                                listen: false)
                                            .selectedDateTime=null;
                                                  serviceHistoryDataSource=ServiceHistoryDataSource(serviceHistoryData: serviceHistory);
                                              });
                                            }, icon: Icon(Icons.filter_alt_off))
                                
                                ],
                              ),
                            )),
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.auto,
                            columnName: 'Job Card no.',
                            label: Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {},
                                  child: Text(
                                    'Job Card no.',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ))),
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.auto,
                          
                            columnName: 'Location',
                            label: Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text('Location'))),
                        GridColumn(
                          columnWidthMode: ColumnWidthMode.auto,
                            columnName: 'Job Type',
                            label: Container(
                                padding: EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text('Job Type'))),
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
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

List<ServiceHistory> getServiceHistory({String? dateFilter}) {
  print(dateFilter);
  return [
    ServiceHistory(
        sno: 1,
        date: '2024-02-22',
        jobCardNo: '123456789',
        location: 'Main Workshop',
        jobType: 'General service'),
    ServiceHistory(
        sno: 2,
        date: '2024-02-23',
        jobCardNo: '123456789',
        location: 'Main Workshop',
        jobType: 'General service'),
    ServiceHistory(
        sno: 3,
        date: '2024-02-24',
        jobCardNo: '123456789',
        location: 'Main Workshop',
        jobType: 'General service'),
  ].where((element) {
    if (dateFilter != null) {
      if (element.date == dateFilter)
        return true;
      else {
        return false;
      }
    } else
      return true;
  }).toList();
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
                    style: TextStyle(color: Colors.blue),
                  )),
                )
              : Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(8.0),
                  child: Text(e.value.toString()),
                );
        }).toList());
  }
}
