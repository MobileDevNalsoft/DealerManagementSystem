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
  final String? vehicleRegNo;
  GetServiceHistory({this.query,this.vehicleRegNo,});
}

class PageChange extends ServiceEvent {
  final int index;
  PageChange({required this.index});
}

class InspectionJsonAdded extends ServiceEvent {
  final String jobCardNo;
  final String inspectionIn;
  InspectionJsonAdded({required this.jobCardNo, required this.inspectionIn});
}

class InspectionJsonUpdated extends ServiceEvent {
  final Map<String, dynamic> json;
  InspectionJsonUpdated({required this.json});
}

class GetJson extends ServiceEvent {}

class UpdateSliderPosition extends ServiceEvent {
  final Position position;
  UpdateSliderPosition({required this.position});
}

class GetJobCards extends ServiceEvent {
  final String? query;
  GetJobCards({this.query});
}

class GetMyJobCards extends ServiceEvent {
  final String? query;
  GetMyJobCards({this.query});
}

class JobCardStatusUpdated extends ServiceEvent {
  final String? jobCardStatus;
  final String? jobCardNo;
  JobCardStatusUpdated({this.jobCardStatus, this.jobCardNo});
}

class GetServiceLocations extends ServiceEvent {}

class BottomNavigationBarClicked extends ServiceEvent {
  final int? index;
  BottomNavigationBarClicked({this.index});
}

class DropDownOpenClose extends ServiceEvent {
  final bool? isOpen;
  DropDownOpenClose({this.isOpen});
}

class GetInspectionDetails extends ServiceEvent {
  final String? jobCardNo;
  GetInspectionDetails({this.jobCardNo});
}

class GetGatePass extends ServiceEvent {
  final String jobCardNo;
  GetGatePass({required this.jobCardNo});
}

class SearchJobCards extends ServiceEvent {
  final String searchText;
  SearchJobCards({required this.searchText});
}

class DropDownOpen extends ServiceEvent {}
class ModifyGatePassStatus extends ServiceEvent{
  final GatePassStatus status;
  ModifyGatePassStatus({required this.status});
}

