part of 'service_bloc.dart';

enum GetServiceStatus { initial, loading, success, failure }

enum ServiceUploadStatus { initial, loading, success, failure }

enum GetJobCardStatus { initial, loading, success, failure }

enum JobCardStatusUpdate { initial, loading, success, failure }

enum GetServiceLocationsStatus { initial, loading, success, failure }

final class ServiceState {
  ServiceState(
      {this.getServiceStatus,
      this.service,
      this.services,
      this.jobCards,
      this.locations,
      this.getJobCardStatus,
      this.serviceUploadStatus,
      this.jobCardStatusUpdate,
      this.dropDownOpen,
      this.bottomNavigationBarActiveIndex,
      this.serviceLocationsStatus});

  GetServiceStatus? getServiceStatus;
  GetJobCardStatus? getJobCardStatus;
  GetServiceLocationsStatus? serviceLocationsStatus;
  JobCardStatusUpdate? jobCardStatusUpdate;
  final Service? service;
  final List<Service>? services;
  final List<Service>? jobCards;
  final List<dynamic>? locations;
  final bool? dropDownOpen;
  int? bottomNavigationBarActiveIndex;
  ServiceUploadStatus? serviceUploadStatus;

  factory ServiceState.initial() {
    return ServiceState(
        getServiceStatus: GetServiceStatus.initial,
        getJobCardStatus: GetJobCardStatus.initial,
        serviceLocationsStatus: GetServiceLocationsStatus.initial,
        serviceUploadStatus: ServiceUploadStatus.initial,
        jobCardStatusUpdate: JobCardStatusUpdate.initial,
        bottomNavigationBarActiveIndex: 0,
        dropDownOpen: false);
  }

  ServiceState copyWith(
      {GetServiceStatus? getServiceStatus,
      GetJobCardStatus? getJobCardStatus,
      GetServiceLocationsStatus? serviceLocationsStatus,
      Service? service,
      List<Service>? services,
      int? bottomNavigationBarActiveIndex,
      ServiceUploadStatus? serviceUploadStatus,
      JobCardStatusUpdate? jobCardStatusUpdate,
      bool? dropDownOpen,
      List<Service>? jobCards,
      List<dynamic>? locations,  jobCardStatus}) {
    return ServiceState(
        getServiceStatus: getServiceStatus ?? this.getServiceStatus,
        getJobCardStatus: getJobCardStatus ?? this.getJobCardStatus,
        jobCardStatusUpdate: jobCardStatusUpdate ?? jobCardStatusUpdate,
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
