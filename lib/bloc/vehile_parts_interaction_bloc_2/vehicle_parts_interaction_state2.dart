part of 'vehicle_parts_interaction_bloc2.dart';

enum VehiclePartsInteractionStatus { initial, loading, success, failure, rebuild }

enum MediaJsonStatus { initial, loading, success, failure }

@immutable
class VehiclePartsInteractionBlocState2 {
  Map<String, VehiclePartMedia2> mapMedia;
  VehiclePartsInteractionStatus status;
  MediaJsonStatus mediaJsonStatus;
  int vehicleExaminationPageIndex;
  String? hotspot;
  String selectedGeneralBodyPart;
  VehiclePartsInteractionBlocState2(
      {required this.mapMedia,
      this.status = VehiclePartsInteractionStatus.initial,
      this.vehicleExaminationPageIndex = 0,
      this.hotspot,
      this.mediaJsonStatus = MediaJsonStatus.initial,
      this.selectedGeneralBodyPart = ''});

  VehiclePartsInteractionBlocState2 copyWith({Map<String, VehiclePartMedia2>? mapMedia, status,
      vehicleExaminationPageIndex, String? hotspot, MediaJsonStatus? mediaJsonStatus, String? selectedGeneralBodyPart}) {
    return VehiclePartsInteractionBlocState2(
        mapMedia: mapMedia ?? this.mapMedia,
        status: status ?? this.status,
        mediaJsonStatus: mediaJsonStatus ?? this.mediaJsonStatus,
        vehicleExaminationPageIndex: vehicleExaminationPageIndex ?? this.vehicleExaminationPageIndex,
        selectedGeneralBodyPart: selectedGeneralBodyPart ?? this.selectedGeneralBodyPart,
        hotspot: hotspot ?? this.hotspot);
  }
}
