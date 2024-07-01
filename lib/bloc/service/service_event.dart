part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

// ignore: must_be_immutable
class ServiceAdded extends ServiceEvent {
  Service service;
  ServiceAdded({required this.service});
}

class GetServiceHistory extends ServiceEvent {
  final String year;
  final String getCompleted;
  GetServiceHistory({required this.year, required this.getCompleted});
}

class GetServiceLocations extends ServiceEvent {}
