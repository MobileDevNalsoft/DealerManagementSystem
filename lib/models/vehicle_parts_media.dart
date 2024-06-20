import 'package:image_picker/image_picker.dart';

class VehiclePartsMedia{
  String name;
  String? comments;
  List<XFile>? images;

  VehiclePartsMedia({required this.name,this.comments});
}