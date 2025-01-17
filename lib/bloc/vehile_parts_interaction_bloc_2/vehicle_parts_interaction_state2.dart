part of 'vehicle_parts_interaction_bloc2.dart';

enum VehiclePartsInteractionStatus { initial, loading, success, failure, rebuild }

enum MediaJsonStatus { initial, loading, success, failure }

enum HotspotRenamingStatus { initial, openTextField, hotspotRenamed }

@immutable
class VehiclePartsInteractionBlocState2 {
  Map<String, VehiclePartMedia2> mapMedia;
  VehiclePartsInteractionStatus status;
  MediaJsonStatus mediaJsonStatus;
  int vehicleExaminationPageIndex;
  bool? isTapped;
  String? selectedBodyPart;
  String? renamedValue;
  HotspotRenamingStatus? renamingStatus;
  VehiclePartsInteractionBlocState2(
      {required this.mapMedia,
      this.status = VehiclePartsInteractionStatus.initial,
      this.vehicleExaminationPageIndex = 0,
      this.isTapped,
      this.mediaJsonStatus = MediaJsonStatus.initial,
      this.selectedBodyPart = '',
      this.renamingStatus = HotspotRenamingStatus.initial,
      this.renamedValue});

  VehiclePartsInteractionBlocState2 copyWith(
      {Map<String, VehiclePartMedia2>? mapMedia,
      status,
      HotspotRenamingStatus? renamingStatus,
      vehicleExaminationPageIndex,
      String? hotspot,
      MediaJsonStatus? mediaJsonStatus,
      String? selectedBodyPart,
      bool? isTapped,
      String? renamedValue}) {
    return VehiclePartsInteractionBlocState2(
        mapMedia: mapMedia ?? this.mapMedia,
        status: status ?? this.status,
        mediaJsonStatus: mediaJsonStatus ?? this.mediaJsonStatus,
        vehicleExaminationPageIndex: vehicleExaminationPageIndex ?? this.vehicleExaminationPageIndex,
        selectedBodyPart: selectedBodyPart ?? this.selectedBodyPart,
        renamingStatus: renamingStatus ?? this.renamingStatus,
        isTapped: isTapped ?? this.isTapped,
        renamedValue: renamedValue ?? this.renamedValue);
  }
}
