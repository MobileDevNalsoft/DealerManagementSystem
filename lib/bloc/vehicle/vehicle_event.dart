part of 'vehicle_bloc.dart';

@immutable
sealed class VehicleEvent {}

class AddVehicleEvent extends VehicleEvent {
  final Vehicle vehicle;

  AddVehicleEvent({required this.vehicle});
}

class VehicleCheck extends VehicleEvent {
  final String registrationNo;
  VehicleCheck({required this.registrationNo});
}

class CustomerCheck extends VehicleEvent {
  final String customerContactNo;
  CustomerCheck({required this.customerContactNo});
}

class UpdateState extends VehicleEvent{
  Vehicle? vehicle;
  VehicleStatus? status;
  UpdateState({this.vehicle,this.status});
}

class FetchVehicleCustomer extends VehicleEvent{
   final String registrationNo;
  FetchVehicleCustomer({required this.registrationNo});
}

