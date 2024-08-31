import 'package:image_picker/image_picker.dart';

class VehiclePartMedia2 {
  String name;
  String? comments;
  List<XFile>? images;
  bool isUploaded;
  bool? isAccepted;
  String? reasonForRejection;
  String? normalPosition;
  String? dataPosition;
  VehiclePartMedia2({required this.name, this.comments, this.images, required this.isUploaded, this.isAccepted, this.reasonForRejection = "",this.normalPosition,this.dataPosition});
}
