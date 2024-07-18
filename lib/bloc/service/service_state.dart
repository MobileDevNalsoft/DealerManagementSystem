part of 'service_bloc.dart';

enum GetServiceStatus { initial, loading, success, failure }

enum ServiceUploadStatus { initial, loading, success, failure }

enum GetJobCardStatus { initial, loading, success, failure }

enum JobCardStatusUpdate { initial, loading, success, failure }

enum GetServiceLocationsStatus { initial, loading, success, failure }

enum GetInspectionStatus { initial, loading, success, failure }

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
      this.getInspectionStatus,
      this.bottomNavigationBarActiveIndex,
      this.inspectionDetails,
      this.serviceLocationsStatus});

  GetServiceStatus? getServiceStatus;
  GetJobCardStatus? getJobCardStatus;
  GetServiceLocationsStatus? serviceLocationsStatus;
  JobCardStatusUpdate? jobCardStatusUpdate;
  final Service? service;
  final List<Service>? services;
  final List<Service>? jobCards;
  final List<dynamic>? locations;
  final Map<String, dynamic>? inspectionDetails;
  final bool? dropDownOpen;
  int? bottomNavigationBarActiveIndex;
  ServiceUploadStatus? serviceUploadStatus;
  GetInspectionStatus? getInspectionStatus;

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
      GetInspectionStatus? getInspectionStatus,
      Service? service,
      List<Service>? services,
      int? bottomNavigationBarActiveIndex,
      ServiceUploadStatus? serviceUploadStatus,
      JobCardStatusUpdate? jobCardStatusUpdate,
      bool? dropDownOpen,
      Map<String, dynamic>? inspectionDetails,
      List<Service>? jobCards,
      List<dynamic>? locations}) {
    return ServiceState(
        getServiceStatus: getServiceStatus ?? this.getServiceStatus,
        getJobCardStatus: getJobCardStatus ?? this.getJobCardStatus,
        jobCardStatusUpdate: jobCardStatusUpdate ?? jobCardStatusUpdate,
        inspectionDetails: inspectionDetails ?? this.inspectionDetails,
        serviceLocationsStatus:
            serviceLocationsStatus ?? this.serviceLocationsStatus,
        getInspectionStatus: getInspectionStatus ?? this.getInspectionStatus,
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
