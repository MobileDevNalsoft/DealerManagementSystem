part of 'vehicle_bloc.dart';

@immutable
sealed class VehicleEvent {}

// triggers when vehicle details are submitted in add vehicle page.
class AddVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;
  AddVehicleEvent({required this.vehicle});
}

// triggers when vehicle registration number field is unfocused to check that vehicle is already registered or not
class VehicleCheck extends VehicleEvent {
  final String registrationNo;
  VehicleCheck({required this.registrationNo});
}

class CustomerCheck extends VehicleEvent {
  final String customerContactNo;
  CustomerCheck({required this.customerContactNo});
}

// used to update the vehilce check status
class UpdateState extends VehicleEvent {
  Vehicle? vehicle;
  VehicleStatus? status;
  UpdateState({this.vehicle, this.status});
}

// triggers when vehicle registration number field is unfocused in service booking view.
class FetchVehicleCustomer extends VehicleEvent {
  final String registrationNo;
  FetchVehicleCustomer({required this.registrationNo});
}
