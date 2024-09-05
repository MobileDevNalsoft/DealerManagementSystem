import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dms/models/vehicle_parts_media2.dart';
import 'package:dms/navigations/navigator_service.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

part 'vehicle_parts_interaction_event2.dart';
part 'vehicle_parts_interaction_state2.dart';

class VehiclePartsInteractionBloc2 extends Bloc<VehiclePartsInteractionBlocEvent2, VehiclePartsInteractionBlocState2> {
  NavigatorService? navigator;
  VehiclePartsInteractionBloc2({Repository? repo, this.navigator})
      : _repo = repo!,
        super(VehiclePartsInteractionBlocState2(mapMedia: {}, status: VehiclePartsInteractionStatus.initial)) {
    on<VehiclePartsInteractionBlocEvent2>((event, emit) {});
    on<AddCommentsEvent>(_onAddComments as EventHandler<AddCommentsEvent, VehiclePartsInteractionBlocState2>);
    on<AddImageEvent>(_onAddImage as EventHandler<AddImageEvent, VehiclePartsInteractionBlocState2>);
    on<RemoveImageEvent>(_onRemoveImage as EventHandler<RemoveImageEvent, VehiclePartsInteractionBlocState2>);
    on<SubmitBodyPartVehicleMediaEvent>(_onSubmitBodyPartVehicleMedia as EventHandler<SubmitBodyPartVehicleMediaEvent, VehiclePartsInteractionBlocState2>);
    on<FetchVehicleMediaEvent>(_onFetchVehicleMedia as EventHandler<FetchVehicleMediaEvent, VehiclePartsInteractionBlocState2>);
    on<ModifyAcceptedEvent>(_onModifyAcceptedStatus as EventHandler<ModifyAcceptedEvent, VehiclePartsInteractionBlocState2>);
    on<SubmitQualityCheckStatusEvent>(_onSubmitQualityCheckStatus as EventHandler<SubmitQualityCheckStatusEvent, VehiclePartsInteractionBlocState2>);
    on<ModifyVehicleExaminationPageIndex>(
        _onModifyVehicleExaminationPageIndex as EventHandler<ModifyVehicleExaminationPageIndex, VehiclePartsInteractionBlocState2>);
    on<AddHotspotEvent>(_onAddHotspot as EventHandler<AddHotspotEvent, VehiclePartsInteractionBlocState2>);
    on<RemoveHotspotEvent>(_onRemoveHotspot as EventHandler<RemoveHotspotEvent, VehiclePartsInteractionBlocState2>);
    on<BodyPartSelected>(_onModifyVehicleInteractionStatus);
  }

  final Repository _repo;

  void _onAddHotspot(AddHotspotEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) {
    state.mapMedia.putIfAbsent(
      event.name,
      () {
        return VehiclePartMedia2(name: event.name, normalPosition: event.normal, dataPosition: event.position, isUploaded: false, images: [], comments: "");
      },
    );
    emit(state.copyWith(state.mapMedia, state.status));
  }

  void _onRemoveHotspot(RemoveHotspotEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) {
    state.mapMedia.removeWhere((e, v) => e == event.name);
    emit(state.copyWith(state.mapMedia, state.status));
  }

  void _onAddComments(AddCommentsEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) {
    if (state.mapMedia.containsKey(event.name)) {
      state.mapMedia[event.name]!.comments = event.comments;
    } else {
      state.mapMedia.putIfAbsent(
        event.name,
        () {
          return VehiclePartMedia2(name: event.name, isUploaded: false, images: []);
        },
      );
    }
    state.mapMedia[event.name]!.isUploaded = false;
  }

  void _onAddImage(AddImageEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) {
    if (state.mapMedia.containsKey(event.name)) {
      state.mapMedia[event.name]?.images ??= [];
      state.mapMedia[event.name]!.images!.add(event.image);
    } else {
      state.mapMedia.putIfAbsent(
        event.name,
        () {
          return VehiclePartMedia2(name: event.name, isUploaded: false, comments: "", images: [event.image]);
        },
      );
    }
    state.mapMedia[event.name]!.isUploaded = false;
    emit(state.copyWith(state.mapMedia, state.status));
  }

  void _onRemoveImage(RemoveImageEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) {
    state.mapMedia[event.name]!.images!.removeAt(event.index);
    emit(state.copyWith(state.mapMedia, state.status));
  }

  void _onSubmitBodyPartVehicleMedia(SubmitBodyPartVehicleMediaEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) async {
    emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.loading));
    Map<String, dynamic> partJson = {};
    List<String> compressedImagesBase64List = [];
    late Uint8List bytes;
    if (state.mapMedia[event.bodyPartName]!.images != null && state.mapMedia[event.bodyPartName]!.images!.isNotEmpty) {
      for (int i = 0; i < state.mapMedia[event.bodyPartName]!.images!.length; i++) {
        final compressedImage = await FlutterImageCompress.compressAndGetFile(
          state.mapMedia[event.bodyPartName]!.images![i].path,
          "${state.mapMedia[event.bodyPartName]!.images![i].path}_compressed.jpg",
          quality: 60,
        );
        bytes = await compressedImage!.readAsBytes();
        String base64String = base64Encode(bytes);
        compressedImagesBase64List.add(base64String);
      }
      partJson = {"images": compressedImagesBase64List, "comments": state.mapMedia[event.bodyPartName]!.comments ?? ""};
    }
    await _repo.addVehiclePartMedia(bodyPartData: partJson, id: event.jobCardNo, name: event.bodyPartName).then((onValue) {
      state.mapMedia[event.bodyPartName]!.isUploaded = true;
      emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.success));
      emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.initial));
    }).onError(
      (error, stackTrace) {
        emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.failure));
        emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.initial));
      },
    );
  }

  void _onModifyVehicleInteractionStatus(BodyPartSelected event, Emitter<VehiclePartsInteractionBlocState2> emit) {
    emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.initial));
  }

  void _onFetchVehicleMedia(FetchVehicleMediaEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) async {
    emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.loading, mediaJsonStatus: MediaJsonStatus.loading));
    late Map<String, dynamic> imageMedia;
    try {
      imageMedia = jsonDecode(await _repo.getImage(event.jobCardNo));
    } catch (e) {
      emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.failure));
      emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.initial));
      return;
    }
    for (var entry in imageMedia.entries) {
      List<XFile> images = [];
      if (entry.value != {} && entry.value["images"] != null && entry.value["images"] != []) {
        for (int i = 0; i < entry.value["images"].length; i++) {
          Directory tempDir = Directory('${(await getTemporaryDirectory()).path}/${entry.key}');
          if (!await tempDir.exists()) {
            await tempDir.create(recursive: true);
          }
          String fileName = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
          File imageFile = File(fileName);
          await imageFile.writeAsBytes(Base64Codec().decode(entry.value["images"][i]));
          images.add(XFile(fileName));
        }
      }
      state.mapMedia.putIfAbsent(
          entry.key,
          () => VehiclePartMedia2(
              name: entry.key,
              images: images,
              comments: entry.value["comments"],
              dataPosition: entry.value["position"],
              normalPosition: entry.value["normal"],
              isUploaded: false,
              isAccepted: entry.value["isAccepted"] != null
                  ? entry.value["isAccepted"] == "true"
                      ? true
                      : false
                  : null,
              reasonForRejection: entry.value["rejectedReason"]));
    }
    emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.initial,
        mediaJsonStatus: MediaJsonStatus.success, selectedGeneralBodyPart: state.mapMedia.entries.first.key));
  }

  void _onModifyAcceptedStatus(ModifyAcceptedEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) {
    state.mapMedia[event.bodyPartName]!.isAccepted = event.isAccepted;
    emit(state.copyWith(state.mapMedia, state.status));
  }

  void _onSubmitQualityCheckStatus(SubmitQualityCheckStatusEvent event, Emitter<VehiclePartsInteractionBlocState2> emit) async {
    emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.loading));
    Map<String, dynamic> qualityCheckJson = {};
    for (var entry in state.mapMedia.entries) {
      qualityCheckJson.putIfAbsent(entry.key, () {
        return {"isAccepted": entry.value.isAccepted, "rejectedReason": entry.value.reasonForRejection};
      });
    }
    await _repo.addQualityStatus(qualityCheckJson: {"id": event.jobCardNo, "data": qualityCheckJson}).then((onValue) {
      print("after api call");
      emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.success));
      // emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.initial));
    }).onError((e, s) {
      emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.failure));
      emit(state.copyWith(state.mapMedia, VehiclePartsInteractionStatus.initial));
    });
  }

  void _onModifyVehicleExaminationPageIndex(ModifyVehicleExaminationPageIndex event, Emitter<VehiclePartsInteractionBlocState2> emit) {
    emit(state.copyWith(state.mapMedia, state.status, vehicleExaminationPageIndex: event.index));
  }
}
