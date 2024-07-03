part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

// ignore: must_be_immutable
class ServiceAdded extends ServiceEvent {
  Service service;
  ServiceAdded({required this.service});
}

class GetServiceHistory extends ServiceEvent {
  final String? query;
  GetServiceHistory({this.query});
}

class GetJobCards extends ServiceEvent {
  final String? query;
  GetJobCards({this.query});
}

class JobCardStatusUpdated extends ServiceEvent {
  JobCardStatusUpdated();
}

class GetServiceLocations extends ServiceEvent {}

class BottomNavigationBarClicked extends ServiceEvent {
  final int? index;
  BottomNavigationBarClicked({this.index});
}

class DropDownOpenClose extends ServiceEvent{
  final bool? isOpen;
  DropDownOpenClose({this.isOpen});
}
