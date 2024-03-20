import 'dart:js_util';

import 'package:flutter/material.dart';

void main() {
  runApp(ServiceHistoryView());
}

class ServiceHistoryView extends StatefulWidget {
  const ServiceHistoryView({super.key});

  @override
  State<ServiceHistoryView> createState() => _ServiceHistoryViewState();
}

class _ServiceHistoryViewState extends State<ServiceHistoryView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ServiceHistory'),
        ),
        body: ListView.builder(
          itemCount: serviceHistoryItems.length,
          itemBuilder: (context, index) {
            ServiceHistoryListView(historyIndex: index,);
          },
        ),
      ),
    );
  }
}

class ServiceHistoryListView extends StatelessWidget {
  final historyIndex;

  const ServiceHistoryListView({super.key, this.historyIndex});
  @override
  Widget build(BuildContext context) {
    return 
    (historyIndex==0) ?
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(children: [
              Text("sno"),
              Text("date"),
              Text("jobCardNo"),
              Text("location"),
              Text("jobType")
            ],),
          ),
          Row(
      children: [
        Text(serviceHistoryItems[historyIndex].sno.toString()),
        Text(serviceHistoryItems[historyIndex].date.toString()),
        Text(serviceHistoryItems[historyIndex].jobCardNo.toString()),
        Text(serviceHistoryItems[historyIndex].location.toString()),
        Text(serviceHistoryItems[historyIndex].jobType.toString())
      ],
    )
        ],
      )

    :
    Row(
      children: [
        Text(serviceHistoryItems[historyIndex].sno.toString()),
        Text(serviceHistoryItems[historyIndex].date.toString()),
        Text(serviceHistoryItems[historyIndex].jobCardNo.toString()),
        Text(serviceHistoryItems[historyIndex].location.toString()),
        Text(serviceHistoryItems[historyIndex].jobType.toString())
      ],
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

List<ServiceHistory> serviceHistoryItems = [
  ServiceHistory(
      sno: 1,
      date: '2024-02-21',
      jobCardNo: '123456789',
      location: 'Main Workshop',
      jobType: 'General service'),
  ServiceHistory(
      sno: 2,
      date: '2024-02-21',
      jobCardNo: '123456789',
      location: 'Main Workshop',
      jobType: 'General service'),
  ServiceHistory(
      sno: 3,
      date: '2024-02-21',
      jobCardNo: '123456789',
      location: 'Main Workshop',
      jobType: 'General service'),
];
