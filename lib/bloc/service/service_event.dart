part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

// ignore: must_be_immutable
class ServiceAdded extends ServiceEvent {
  Service service;
  ServiceAdded({required this.service});
}

class GetServiceHistory extends ServiceEvent {
  final String? year;
  final String getCompleted;
  GetServiceHistory({ this.year, required this.getCompleted});
}

class GetJobCards extends ServiceEvent {
  String getCompleted = 'false';
  GetJobCards();
}
class GetServiceLocations extends ServiceEvent {}
