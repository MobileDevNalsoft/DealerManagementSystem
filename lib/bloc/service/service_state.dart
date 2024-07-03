part of 'service_bloc.dart';

enum ServiceStatus { initial, loading, success, failure }

enum JobCardStatus { initial, loading, success, failure }

enum GetServiceLocationsStatus { initial, loading, success, failure }

final class ServiceState {
  ServiceState(
      {this.status,
      this.service,
      this.services,
      this.jobCards,
      this.locations,
      this.jobCardStatus,
      this.serviceLocationsStatus});

  ServiceStatus? status;
  JobCardStatus? jobCardStatus;
  GetServiceLocationsStatus? serviceLocationsStatus;
  final Service? service;
  final List<Service>? services;
  final List<Service>? jobCards;
  final List<dynamic>? locations;

  factory ServiceState.initial() {
    return ServiceState(
        status: ServiceStatus.initial, jobCardStatus: JobCardStatus.initial);
  }

  ServiceState copyWith(
      {ServiceStatus? status,
      JobCardStatus? jobCardStatus,
      GetServiceLocationsStatus? serviceLocationsStatus,
      Service? service,
      List<Service>? services,
      List<Service>? jobCards,
      List<dynamic>? locations}) {
    return ServiceState(
        status: status ?? this.status,
        jobCardStatus: jobCardStatus ?? this.jobCardStatus,
        serviceLocationsStatus:
            serviceLocationsStatus ?? this.serviceLocationsStatus,
        service: service ?? this.service,
        services: services ?? this.services,
        jobCards: jobCards ?? this.jobCards,
        locations: locations ?? this.locations);
  }
}
