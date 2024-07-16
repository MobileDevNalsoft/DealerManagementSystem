
import 'package:image_picker/image_picker.dart';

class VehiclePartMedia{
  String name;
  String? comments;
  List<XFile>? images;
  bool isUploaded;
  VehiclePartMedia({required this.name,this.comments,this.images,required this.isUploaded});
}