part of 'vehicle_parts_interaction_bloc2.dart';

@immutable
class VehiclePartsInteractionBlocEvent2 {}

class AddCommentsEvent extends VehiclePartsInteractionBlocEvent2 {
  String name;
  String? comments;
  AddCommentsEvent({required this.name, this.comments});
}

class AddImageEvent extends VehiclePartsInteractionBlocEvent2 {
  String name;
  XFile image;
  AddImageEvent({required this.name, required this.image});
}

class RemoveImageEvent extends VehiclePartsInteractionBlocEvent2 {
  String name;
  int index;
  RemoveImageEvent({required this.name, required this.index});
}

class SubmitVehicleMediaEvent extends VehiclePartsInteractionBlocEvent2 {
  SubmitVehicleMediaEvent();
}

class SubmitBodyPartVehicleMediaEvent extends VehiclePartsInteractionBlocEvent2 {
  String jobCardNo;
  String bodyPartName;
  SubmitBodyPartVehicleMediaEvent({required this.bodyPartName, required this.jobCardNo});
}

class FetchVehicleMediaEvent extends VehiclePartsInteractionBlocEvent2 {
  String jobCardNo;
  FetchVehicleMediaEvent({required this.jobCardNo});
}

class ModifyAcceptedEvent extends VehiclePartsInteractionBlocEvent2 {
  String bodyPartName;
  bool? isAccepted;
  ModifyAcceptedEvent({required this.bodyPartName, required this.isAccepted});
}

class SubmitQualityCheckStatusEvent extends VehiclePartsInteractionBlocEvent2 {
  String jobCardNo;
  SubmitQualityCheckStatusEvent({required this.jobCardNo});
}


class ModifyVehicleExaminationPageIndex extends VehiclePartsInteractionBlocEvent2 {
  int index;
  ModifyVehicleExaminationPageIndex({required this.index});
}

class AddHotspotEvent extends VehiclePartsInteractionBlocEvent2 {
  String name;
  String normal;
  String position;
  AddHotspotEvent({required this.name,required this.normal,required this.position});
}

