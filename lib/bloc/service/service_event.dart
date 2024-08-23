part of 'service_bloc.dart';

@immutable
sealed class ServiceEvent {}

// ignore: must_be_immutable
// triggers when clicked proceed to receive in service booking
class ServiceAdded extends ServiceEvent {
  Service service;
  ServiceAdded({required this.service});
}

class GetServiceHistory extends ServiceEvent {
  final String? query;
  final String? vehicleRegNo;
  GetServiceHistory({
    this.query,
    this.vehicleRegNo,
  });
}

// handles inspection in and out page change events.
class PageChange extends ServiceEvent {
  final int index;
  PageChange({required this.index});
}

// triggers when submit buttom is pressed in inspection in page.
class InspectionJsonAdded extends ServiceEvent {
  final String jobCardNo;
  final String inspectionIn;
  InspectionJsonAdded({required this.jobCardNo, required this.inspectionIn});
}

// used for dynamic updation of inspection json.
class InspectionJsonUpdated extends ServiceEvent {
  final Map<String, dynamic> json;
  InspectionJsonUpdated({required this.json});
}

// triggers when we need to get inspection json.
class GetJson extends ServiceEvent {}

// triggered to get job cards based on query in home page and vehicle info page
class GetJobCards extends ServiceEvent {
  final String? query;
  GetJobCards({this.query});
}

// triggered to get job cards based on query in my job cards page
class GetMyJobCards extends ServiceEvent {
  final String? query;
  GetMyJobCards({this.query});
}

// to update job card status
class JobCardStatusUpdated extends ServiceEvent {
  final String? jobCardStatus;
  final String? jobCardNo;
  JobCardStatusUpdated({this.jobCardStatus, this.jobCardNo});
}

class GetServiceLocations extends ServiceEvent {}

// triggers when navigated to inspection out page.
class GetInspectionDetails extends ServiceEvent {
  final String? jobCardNo;
  GetInspectionDetails({this.jobCardNo});
}

// triggers when navigated to gatepass page.
class GetGatePass extends ServiceEvent {
  final String jobCardNo;
  GetGatePass({required this.jobCardNo});
}

// used to filter required job cards from the list of job cards
class SearchJobCards extends ServiceEvent {
  final String searchText;
  SearchJobCards({required this.searchText});
}

// used to change the drop down icon in UI where ever required
class DropDownOpen extends ServiceEvent {}

// to change gate pass status
class ModifyGatePassStatus extends ServiceEvent {
  final GatePassStatus status;
  ModifyGatePassStatus({required this.status});
}
