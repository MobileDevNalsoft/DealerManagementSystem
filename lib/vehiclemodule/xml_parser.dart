import 'package:dms/vehiclemodule/xml_model.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

Future<List<GeneralBodyPart>> loadSvgImage({required String svgImage}) async {
  List<GeneralBodyPart> parts = [];

  String generalString = await rootBundle.loadString(svgImage);

  XmlDocument document = XmlDocument.parse(generalString);

  final paths = document.findAllElements('path');

  paths.forEach((element) {
    String partName = element.getAttribute('id').toString();
    String partPath = element.getAttribute('d').toString();
    String partClass = element.getAttribute('class').toString();

    GeneralBodyPart part =
        GeneralBodyPart(name: partName, path: partPath, color: partClass);
    parts.add(part);
  });
  return parts;
}
