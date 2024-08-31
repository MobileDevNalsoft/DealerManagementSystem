part of 'vehicle_parts_interaction_bloc2.dart';

enum VehiclePartsInteractionStatus { initial, loading, success, failure, rebuild }

@immutable
class VehiclePartsInteractionBlocState2 {
  Map<String, VehiclePartMedia2> mapMedia;
  VehiclePartsInteractionStatus status;
  int vehicleExaminationPageIndex;
  String? hotspot;
  VehiclePartsInteractionBlocState2({required this.mapMedia, this.status = VehiclePartsInteractionStatus.initial, this.vehicleExaminationPageIndex = 0,this.hotspot});

  VehiclePartsInteractionBlocState2 copyWith(Map<String, VehiclePartMedia2>? mapMedia, status, { vehicleExaminationPageIndex,String? hotspot}) {
    return VehiclePartsInteractionBlocState2(
        mapMedia: mapMedia ?? this.mapMedia,
        status: status ?? this.status,
        vehicleExaminationPageIndex: vehicleExaminationPageIndex ?? this.vehicleExaminationPageIndex,
        hotspot: hotspot??this.hotspot
        );
  }
}
