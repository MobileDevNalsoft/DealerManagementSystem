part of 'service_bloc.dart';

enum GetServiceStatus { initial, loading, success, failure }

enum ServiceUploadStatus { initial, loading, success, failure }

enum GetJobCardStatus { initial, loading, success, failure }

enum JobCardStatusUpdate { initial, loading, success, failure }

enum GetServiceLocationsStatus { initial, loading, success, failure }

enum GetInspectionStatus { initial, loading, success, failure }

enum JsonStatus { initial, loading, success, failure }

enum InspectionJsonUploadStatus { initial, loading, success, failure }

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
      this.jsonStatus,
      this.json,
      this.dropDownOpen,
      this.inspectionJsonUploadStatus,
      this.index,
      this.getInspectionStatus,
      this.bottomNavigationBarActiveIndex,
      this.inspectionDetails,
      this.serviceLocationsStatus});

  GetServiceStatus? getServiceStatus;
  GetJobCardStatus? getJobCardStatus;
  GetServiceLocationsStatus? serviceLocationsStatus;
  JobCardStatusUpdate? jobCardStatusUpdate;
  InspectionJsonUploadStatus? inspectionJsonUploadStatus;
  JsonStatus? jsonStatus;
  final Service? service;
  final List<Service>? services;
  final List<Service>? jobCards;
  final List<dynamic>? locations;
  final Map<String, dynamic>? inspectionDetails;
  final bool? dropDownOpen;
  int? index;
  Map<String, dynamic>? json;
  int? bottomNavigationBarActiveIndex;
  ServiceUploadStatus? serviceUploadStatus;
  GetInspectionStatus? getInspectionStatus;

  factory ServiceState.initial() {
    return ServiceState(
        getServiceStatus: GetServiceStatus.initial,
        getJobCardStatus: GetJobCardStatus.initial,
        serviceLocationsStatus: GetServiceLocationsStatus.initial,
        inspectionJsonUploadStatus: InspectionJsonUploadStatus.initial,
        serviceUploadStatus: ServiceUploadStatus.initial,
        jobCardStatusUpdate: JobCardStatusUpdate.initial,
        getInspectionStatus: GetInspectionStatus.initial,
        jsonStatus: JsonStatus.initial,
        bottomNavigationBarActiveIndex: 0,
        index: 0,
        json: null,
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
      JsonStatus? jsonStatus,
      ServiceUploadStatus? serviceUploadStatus,
      JobCardStatusUpdate? jobCardStatusUpdate,
      Map<String, dynamic>? json,
      bool? dropDownOpen,
      Map<String, dynamic>? inspectionDetails,
      InspectionJsonUploadStatus? inspectionJsonUploadStatus,
      List<Service>? jobCards,
      int? index,
      List<dynamic>? locations}) {
    return ServiceState(
        getServiceStatus: getServiceStatus ?? this.getServiceStatus,
        getJobCardStatus: getJobCardStatus ?? this.getJobCardStatus,
        jobCardStatusUpdate: jobCardStatusUpdate ?? jobCardStatusUpdate,
        inspectionDetails: inspectionDetails ?? this.inspectionDetails,
        inspectionJsonUploadStatus:
            inspectionJsonUploadStatus ?? this.inspectionJsonUploadStatus,
        json: json ?? this.json,
        jsonStatus: jsonStatus ?? this.jsonStatus,
        index: index ?? this.index,
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
