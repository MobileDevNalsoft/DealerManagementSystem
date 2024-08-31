
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Madhan3D extends StatefulWidget {
  const Madhan3D({super.key});

  @override
  State<Madhan3D> createState() => _Madhan3DState();
}

class _Madhan3DState extends State<Madhan3D> {

  Future<String> loadMadhanJS() async {
    return await rootBundle.loadString('assets/madhan.js');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Model Viewer')),
        body: FutureBuilder(
          future: loadMadhanJS(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.done){
            return ModelViewer(
              backgroundColor: Color.fromARGB(0xFF, 0xEE, 0xEE, 0xEE),
              src: 'assets/3d_models/sedan.glb',
              iosSrc: 'assets/3d_models/sedan.glb',
              relatedJs: snapshot.data,
              disableTap: true,
              disableZoom: true,
              id: 'model',
              onWebViewCreated: (value) {
                print('value $value');
              },
              javascriptChannels: {JavascriptChannel('madhanChannel', onMessageReceived: (message) {
                print('Message ${message.message}');
              })},
            );}
            return CircularProgressIndicator();
          }
        ),
      ),
    );
  }
}

