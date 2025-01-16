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
  XFile image;
  RemoveImageEvent({required this.name, required this.image});
}

class SubmitVehicleMediaEvent extends VehiclePartsInteractionBlocEvent2 {
  SubmitVehicleMediaEvent();
}

class SubmitBodyPartVehicleMediaEvent
    extends VehiclePartsInteractionBlocEvent2 {
  String serviceBookingNo;
  String bodyPartName;
  SubmitBodyPartVehicleMediaEvent(
      {required this.bodyPartName, required this.serviceBookingNo});
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

class ModifyVehicleExaminationPageIndex
    extends VehiclePartsInteractionBlocEvent2 {
  int index;
  ModifyVehicleExaminationPageIndex({required this.index});
}

class AddHotspotEvent extends VehiclePartsInteractionBlocEvent2 {
  String name;
  String normal;
  String position;
  AddHotspotEvent(
      {required this.name, required this.normal, required this.position});
}

class RemoveHotspotEvent extends VehiclePartsInteractionBlocEvent2 {
  String name;
  RemoveHotspotEvent({required this.name});
}

// triggers when any part of vehicle svg image is tapped.
// class BodyPartSelected extends VehiclePartsInteractionBlocEvent2 {
//   String selectedBodyPart;
//   BodyPartSelected({required this.selectedBodyPart});
// }

class ModifyVehicleInteractionStatus extends VehiclePartsInteractionBlocEvent2 {
  String selectedBodyPart;
  bool? isTapped;
  ModifyVehicleInteractionStatus(
      {required this.selectedBodyPart, this.isTapped});
}

class ModifyRenamingStatus extends VehiclePartsInteractionBlocEvent2 {
  HotspotRenamingStatus renameStatus;
  String? renamedValue;
  ModifyRenamingStatus({required this.renameStatus, this.renamedValue});
}
