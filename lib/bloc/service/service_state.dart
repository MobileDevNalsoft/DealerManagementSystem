part of 'service_bloc.dart';

enum GetServiceStatus { initial, loading, success, failure }

enum ServiceUploadStatus { initial, loading, success, failure }

enum GetJobCardStatus { initial, loading, success, failure }

enum GetMyJobCardsStatus { initial, loading, success, failure }

enum JobCardStatusUpdate { initial, loading, success, failure }

enum GetServiceLocationsStatus { initial, loading, success, failure }

enum GetInspectionStatus { initial, loading, success, failure }

enum JsonStatus { initial, loading, success, failure }

enum InspectionJsonUploadStatus { initial, loading, success, failure }

enum GatePassStatus { initial, loading, success, failure }

final class ServiceState {
  ServiceState(
      {this.getServiceStatus,
      this.service,
      this.services,
      this.jobCards,
      this.locations,
      this.getJobCardStatus,
      this.getMyJobCardsStatus,
      this.serviceUploadStatus,
      this.jobCardStatusUpdate,
      this.jsonStatus,
      this.sliderPosition,
      this.json,
      this.dropDownOpen,
      this.inspectionJsonUploadStatus,
      this.index,
      this.getInspectionStatus,
      this.jobCardNo,
      this.myJobCards,
      this.bottomNavigationBarActiveIndex,
      this.inspectionDetails,
      this.serviceLocationsStatus,
      this.filteredJobCards,
      this.gatePassStatus,
      this.gatePassno,
      this.serviceProceedButtonPosition
      });

  GetServiceStatus? getServiceStatus;
  GetJobCardStatus? getJobCardStatus;
  GetMyJobCardsStatus? getMyJobCardsStatus;
  GetServiceLocationsStatus? serviceLocationsStatus;
  JobCardStatusUpdate? jobCardStatusUpdate;
  InspectionJsonUploadStatus? inspectionJsonUploadStatus;
  JsonStatus? jsonStatus;
  String? jobCardNo;
  final Service? service;
  final List<Service>? services;
  final List<Service>? jobCards;
  final List<Service>? myJobCards;
  final List<dynamic>? locations;
  final Map<String, dynamic>? inspectionDetails;
  final bool? dropDownOpen;
  int? index;
  Position? sliderPosition;
  Map<String, dynamic>? json;
  int? bottomNavigationBarActiveIndex;
  ServiceUploadStatus? serviceUploadStatus;
  GetInspectionStatus? getInspectionStatus;
  GatePassStatus? gatePassStatus;
  String? gatePassno;
  List<Service>? filteredJobCards;
  SliderButtonPosition? serviceProceedButtonPosition;

  factory ServiceState.initial() {
    return ServiceState(
      getServiceStatus: GetServiceStatus.initial,
      getJobCardStatus: GetJobCardStatus.initial,
      serviceLocationsStatus: GetServiceLocationsStatus.initial,
      inspectionJsonUploadStatus: InspectionJsonUploadStatus.initial,
      serviceUploadStatus: ServiceUploadStatus.initial,
      jobCardStatusUpdate: JobCardStatusUpdate.initial,
      getInspectionStatus: GetInspectionStatus.initial,
      getMyJobCardsStatus: GetMyJobCardsStatus.initial,
      sliderPosition: Position.middle,
      jsonStatus: JsonStatus.initial,
      bottomNavigationBarActiveIndex: 0,
      index: 0,
      json: null,
      dropDownOpen: false,
      serviceProceedButtonPosition: SliderButtonPosition.left
    );
  }

  ServiceState copyWith(
      {GetServiceStatus? getServiceStatus,
      GetJobCardStatus? getJobCardStatus,
      GetServiceLocationsStatus? serviceLocationsStatus,
      GetInspectionStatus? getInspectionStatus,
      List<Service>? myJobCards,
      Service? service,
      List<Service>? services,
      int? bottomNavigationBarActiveIndex,
      JsonStatus? jsonStatus,
      ServiceUploadStatus? serviceUploadStatus,
      GetMyJobCardsStatus? getMyJobCardsStatus,
      JobCardStatusUpdate? jobCardStatusUpdate,
      Map<String, dynamic>? json,
      List<Service>? filteredJobCards,
      String? jobCardNo,
      bool? dropDownOpen,
      Map<String, dynamic>? inspectionDetails,
      InspectionJsonUploadStatus? inspectionJsonUploadStatus,
      List<Service>? jobCards,
      Position? sliderPosition,
      int? index,
      List<dynamic>? locations,
      GatePassStatus? gatePassStatus,
      String? gatePassno,
      }) {
    return ServiceState(
        getServiceStatus: getServiceStatus ?? this.getServiceStatus,
        getJobCardStatus: getJobCardStatus ?? this.getJobCardStatus,
        jobCardStatusUpdate: jobCardStatusUpdate ?? jobCardStatusUpdate,
        inspectionDetails: inspectionDetails ?? this.inspectionDetails,
        getMyJobCardsStatus: getMyJobCardsStatus ?? this.getMyJobCardsStatus,
        jobCardNo: jobCardNo ?? this.jobCardNo,
        filteredJobCards: filteredJobCards ?? this.filteredJobCards,
        myJobCards: myJobCards ?? this.myJobCards,
        inspectionJsonUploadStatus:
            inspectionJsonUploadStatus ?? this.inspectionJsonUploadStatus,
        json: json ?? this.json,
        jsonStatus: jsonStatus ?? this.jsonStatus,
        index: index ?? this.index,
        sliderPosition: sliderPosition ?? this.sliderPosition,
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
        locations: locations ?? this.locations,
        gatePassStatus: gatePassStatus ?? this.gatePassStatus,
        gatePassno: gatePassno ?? this.gatePassno,
        );
  }
}
