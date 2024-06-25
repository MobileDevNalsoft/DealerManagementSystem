import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dms/dynamic_ui_src/Logger/logger.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'vehicle_parts_interaction_event.dart';
part 'vehicle_parts_interaction_state.dart';

class VehiclePartsInteractionBloc extends Bloc<VehiclePartsInteractionBlocEvent,
    VehiclePartsInteractionBlocState> {
  VehiclePartsInteractionBloc({required Repository repo})
      : _repo = repo,
        super(VehiclePartsInteractionBlocState(
            media: [], status: VehiclePartsInteractionStatus.initial)) {
    on<VehiclePartsInteractionBlocEvent>((event, emit) {});
    on<AddCommentsEvent>(_onAddComments
        as EventHandler<AddCommentsEvent, VehiclePartsInteractionBlocState>);
    on<AddImageEvent>(_onAddImage
        as EventHandler<AddImageEvent, VehiclePartsInteractionBlocState>);
    on<SubmitVehicleMediaEvent>(_onSubmitVehicleMedia as EventHandler<
        SubmitVehicleMediaEvent, VehiclePartsInteractionBlocState>);
    on<RemoveImageEvent>(_onRemoveImage as EventHandler<
      RemoveImageEvent, VehiclePartsInteractionBlocState>);
  }

  final Repository _repo;
  void _onAddComments(
      AddCommentsEvent event, Emitter<VehiclePartsInteractionBlocState> emit) {
    bool commentsUpdated = false;
    print("${event.name}");

    state.media.forEach((e) {
      print("${e.name} ${event.name}");
      if (e.name == event.name) {
        e.comments = event.comments;
        commentsUpdated = true;
      }
    });
    if (commentsUpdated == false) {
      state.media
          .add(VehiclePartMedia(name: event.name, comments: event.comments));
    }
    print(state.media);
  }

  void _onAddImage(
      AddImageEvent event, Emitter<VehiclePartsInteractionBlocState> emit) {
    bool commentsUpdated = false;
    print("${event.name}");

    state.media.forEach((e) {
      print("${e.name} ${event.name}");
      if (e.name == event.name) {
        if (e.images != null) {
          e.images!.add(event.image);
        } else {
          e.images = [event.image];
        }
        commentsUpdated = true;
      }
    });
    if (commentsUpdated == false) {
      state.media
          .add(VehiclePartMedia(name: event.name, images: [event.image]));
    }
    emit(state.copyWith(state.media, state.status));
    print(state.media);
  }

  void _onSubmitVehicleMedia(SubmitVehicleMediaEvent event,
      Emitter<VehiclePartsInteractionBlocState> emit) async {
        late Uint8List bytes;
    state.media.forEach((element) async {
      final file = File(element.images!.first.path);
      print("images from bloc${element.images}");
      final compressedImage = await FlutterImageCompress.compressAndGetFile(
        element.images!.first.path,
        "${element.images!.first.path}_compressed.jpg",
        quality: 60,
      );
      bytes = await compressedImage!.readAsBytes();
     print("bytes while sending $bytes");
      String base64String = base64Encode(await compressedImage!.readAsBytes());
     Log.d(base64String);
     print(base64String);
      await _repo.addVehicleMedia(base64String);
    }
    );
    // print("image to string ${state.media.first.images!.first.}");
      List<int> bytesData= base64Decode(await  _repo.getImage());
      print(bytesData==bytes);
      final dir = await getApplicationDocumentsDirectory();
      print("path ${dir.path}");
      print("bytes while sending ${Uint8List.fromList(bytesData)}");
      // state.media.add(VehiclePartMedia(name: 'roof',images: [XFile(dir.path ,bytes:Uint8List.fromList(bytesData) )]));
      state.media.forEach((element){
        if(element.name=='roof'){
          element.images!.add(XFile(dir.path ,bytes:Uint8List.fromList(bytesData) ));
        }
      });
      emit(state.copyWith(state.media, state.status));

  }

  void _onRemoveImage(RemoveImageEvent event,
      Emitter<VehiclePartsInteractionBlocState> emit){
        print("got into bloc event");
         state.media.forEach((e) {
      print("${e.name} ${event.name}");
      if (e.name == event.name) {
        e.images!.removeAt(event.index);
      }
    });
    emit(state.copyWith(state.media, state.status));
  }

  // void _getImage()

}
