part of 'service_bloc.dart';

enum ServiceStatus { initial, loading, success, failure }

enum ServiceUploadStatus { initial, loading, success, failure }

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
      this.serviceUploadStatus,
      this.dropDownOpen,
      this.bottomNavigationBarActiveIndex,
      this.serviceLocationsStatus});

  ServiceStatus? status;
  JobCardStatus? jobCardStatus;
  GetServiceLocationsStatus? serviceLocationsStatus;
  final Service? service;
  final List<Service>? services;
  final List<Service>? jobCards;
  final List<dynamic>? locations;
  final bool? dropDownOpen;
  int? bottomNavigationBarActiveIndex;
  ServiceUploadStatus? serviceUploadStatus;

  factory ServiceState.initial() {
    return ServiceState(
        status: ServiceStatus.initial,
        jobCardStatus: JobCardStatus.initial,
        serviceLocationsStatus: GetServiceLocationsStatus.initial,
        serviceUploadStatus: ServiceUploadStatus.initial,
        bottomNavigationBarActiveIndex: 0,
        dropDownOpen: false);
  }

  ServiceState copyWith(
      {ServiceStatus? status,
      JobCardStatus? jobCardStatus,
      GetServiceLocationsStatus? serviceLocationsStatus,
      Service? service,
      List<Service>? services,
      int? bottomNavigationBarActiveIndex,
      ServiceUploadStatus? serviceUploadStatus,
      bool? dropDownOpen,
      List<Service>? jobCards,
      List<dynamic>? locations}) {
    return ServiceState(
        status: status ?? this.status,
        jobCardStatus: jobCardStatus ?? this.jobCardStatus,
        serviceLocationsStatus:
            serviceLocationsStatus ?? this.serviceLocationsStatus,
        serviceUploadStatus: serviceUploadStatus ?? this.serviceUploadStatus,
        bottomNavigationBarActiveIndex: bottomNavigationBarActiveIndex ??
            this.bottomNavigationBarActiveIndex,
        service: service ?? this.service,
        services: services ?? this.services,
        dropDownOpen: dropDownOpen ?? this.dropDownOpen,
        jobCards: jobCards ?? this.jobCards,
        locations: locations ?? this.locations);
  }
}
