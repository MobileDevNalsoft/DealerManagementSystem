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

enum SVGStatus { initial, loading, success, failure }

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
      this.svgStatus,
      this.sliderPosition,
      this.value,
      this.json,
      this.dropDownOpen,
      this.inspectionJsonUploadStatus,
      this.index,
      this.getInspectionStatus,
      this.jobCardNo,
      this.myJobCards,
      this.bottomNavigationBarActiveIndex,
      this.serviceLocationsStatus,
      this.filteredJobCards,
      this.gatePassStatus,
      this.gatePassno,
      this.serviceProceedButtonPosition});

  GetServiceStatus? getServiceStatus;
  GetJobCardStatus? getJobCardStatus;
  GetMyJobCardsStatus? getMyJobCardsStatus;
  GetServiceLocationsStatus? serviceLocationsStatus;
  JobCardStatusUpdate? jobCardStatusUpdate;
  InspectionJsonUploadStatus? inspectionJsonUploadStatus;
  JsonStatus? jsonStatus;
  SVGStatus? svgStatus;
  String? jobCardNo;
  Service? service;
  final List<Service>? services;
  final List<Service>? jobCards;
  final List<Service>? myJobCards;
  final List<dynamic>? locations;
  final bool? dropDownOpen;
  int? index;
  Position? sliderPosition;
  double? value;
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
        svgStatus: SVGStatus.initial,
        jsonStatus: JsonStatus.initial,
        sliderPosition: Position.middle,
        bottomNavigationBarActiveIndex: 0,
        index: 0,
        json: null,
        locations: null,
        dropDownOpen: false,
        serviceProceedButtonPosition: SliderButtonPosition.left);
  }

  ServiceState copyWith({
    GetServiceStatus? getServiceStatus,
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
    SVGStatus? svgStatus,
    Map<String, dynamic>? json,
    List<Service>? filteredJobCards,
    String? jobCardNo,
    bool? dropDownOpen,
    InspectionJsonUploadStatus? inspectionJsonUploadStatus,
    List<Service>? jobCards,
    Position? sliderPosition,
    double? value,
    int? index,
    List<dynamic>? locations,
    GatePassStatus? gatePassStatus,
    String? gatePassno,
  }) {
    return ServiceState(
      getServiceStatus: getServiceStatus ?? this.getServiceStatus,
      getJobCardStatus: getJobCardStatus ?? this.getJobCardStatus,
      jobCardStatusUpdate: jobCardStatusUpdate ?? jobCardStatusUpdate,
      getMyJobCardsStatus: getMyJobCardsStatus ?? this.getMyJobCardsStatus,
      svgStatus: svgStatus ?? this.svgStatus,
      jobCardNo: jobCardNo ?? this.jobCardNo,
      filteredJobCards: filteredJobCards ?? this.filteredJobCards,
      myJobCards: myJobCards ?? this.myJobCards,
      inspectionJsonUploadStatus:
          inspectionJsonUploadStatus ?? this.inspectionJsonUploadStatus,
      json: json ?? this.json,
      jsonStatus: jsonStatus ?? this.jsonStatus,
      index: index ?? this.index,
      sliderPosition: sliderPosition ?? this.sliderPosition,
      value: value ?? this.value,
      serviceLocationsStatus:
          serviceLocationsStatus ?? this.serviceLocationsStatus,
      getInspectionStatus: getInspectionStatus ?? this.getInspectionStatus,
      serviceUploadStatus: serviceUploadStatus ?? this.serviceUploadStatus,
      bottomNavigationBarActiveIndex:
          bottomNavigationBarActiveIndex ?? this.bottomNavigationBarActiveIndex,
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
