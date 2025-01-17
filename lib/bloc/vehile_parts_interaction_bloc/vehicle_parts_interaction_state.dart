part of 'vehicle_parts_interaction_bloc.dart';

enum VehiclePartsInteractionStatus { initial, loading, success, failure, rebuild }

@immutable
class VehiclePartsInteractionBlocState {
  Map<String, VehiclePartMedia> mapMedia;
  VehiclePartsInteractionStatus status;
  int vehicleExaminationPageIndex;
  String? selectedBodyPart;
  bool isTapped;
  VehiclePartsInteractionBlocState(
      {required this.mapMedia,
      this.status = VehiclePartsInteractionStatus.initial,
      this.vehicleExaminationPageIndex = 0,
      this.selectedBodyPart,
      this.isTapped = false});

  VehiclePartsInteractionBlocState copyWith(
      {Map<String, VehiclePartMedia>? mapMedia, status, vehicleExaminationPageIndex, String? selectedBodyPart, bool? isTapped}) {
    return VehiclePartsInteractionBlocState(
        mapMedia: mapMedia ?? this.mapMedia,
        status: status ?? this.status,
        vehicleExaminationPageIndex: vehicleExaminationPageIndex ?? this.vehicleExaminationPageIndex,
        selectedBodyPart: selectedBodyPart ?? this.selectedBodyPart,
        isTapped: isTapped ?? this.isTapped);
  }
}
