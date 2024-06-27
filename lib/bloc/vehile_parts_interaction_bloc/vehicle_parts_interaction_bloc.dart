import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:dms/dynamic_ui_src/Logger/logger.dart';
import 'package:dms/models/vehicle_parts_media.dart';
import 'package:dms/repository/repository.dart';
import 'package:flutter/foundation.dart';
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
    on<RemoveImageEvent>(_onRemoveImage
        as EventHandler<RemoveImageEvent, VehiclePartsInteractionBlocState>);
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
  //   Map<String, dynamic> allPartsJson = {};
  //   Map<String, dynamic> partJson={};
  
  //   for(int index=0;index<state.media.length;index++){
  //     List<String> compressedImagesBase64List = [];
  // print("state media ${state.media[index].name} ${state.media[index].images}");
  //     if (state.media[index].images != null && state.media[index].images!.isNotEmpty) {
  //       print("name ${state.media[index].name}${state.media[index].images!.length}");
  //      for(int i=0;i<state.media[index].images!.length;i++){
  //       final compressedImage = await FlutterImageCompress.compressAndGetFile(
  //           state.media[index].images![i].path,
  //           "${state.media[index].images![i].path}_compressed.jpg",
  //           quality: 60,
  //         );
  //         bytes = await compressedImage!.readAsBytes();
  //         String base64String =  base64Encode(bytes);
  //         compressedImagesBase64List.add(base64String);
  //      }
  //       partJson={
  //         "images": compressedImagesBase64List,
  //         "comments": state.media[index].comments ?? ""
  //       };
  //       allPartsJson.addAll({state.media[index].name:partJson});
  //     print('${state.media[index].name} $partJson');
  //     compressedImagesBase64List=[];
  //     print(allPartsJson);
  //     }
      
  //   }
  //     await _repo.addVehicleMedia(allPartsJson);


    //displaying images and comments from db  
    Map<String,dynamic> imageMedia = jsonDecode(await  _repo.getImage());
    print(imageMedia);
    // Directory dir =  await getTemporaryDirectory();
    imageMedia.forEach((key, value) async{ 
      List<XFile> images=[];
      print('key $key value $value');
      if(value != {} && value["images"] != [] && value["images"] != null){
         print("images ${value["images"]}");
      for(int i=0;i<value["images"].length;i++){
       
        Directory tempDir = Directory('${(await getTemporaryDirectory()).path}/$key');
    if (!await tempDir.exists()) {
      await tempDir.create(recursive: true);
    } 
    String fileName = '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg'; 
    // File imageFile = File(fileName);
    // await imageFile.writeAsBytes(Base64Codec().decode(value["images"][i]));
    images.add(XFile(fileName));
        print("$key $fileName");
      }}
        
      
      state.media.add(VehiclePartMedia(name: key,images: images,comments: value["comments"]));
    },);
    emit(state.copyWith(state.media, state.status));
    
  }

  void _onRemoveImage(
      RemoveImageEvent event, Emitter<VehiclePartsInteractionBlocState> emit) {
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
