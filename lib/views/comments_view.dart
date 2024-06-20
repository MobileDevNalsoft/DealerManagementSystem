import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(child: CommentsView()),
    ),
  ));
}

class CommentsView extends StatefulWidget {
  CommentsView({super.key});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  late List<CameraDescription> _cameras;
  late CameraController cameraController;
  TextEditingController commentsController = TextEditingController();
  FocusNode commentsFocus = FocusNode();
  var imagesCaptured = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    _cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Center(
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0), color: Colors.black12),
          child: Column(
            children: [
              Text(
                'Front right tire',
                style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white),
                padding: EdgeInsets.all(8.0),
                width: size.width * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Comments",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    SizedBox(
                      height: size.height * 0.1,
                      child: TextFormField(
                        focusNode: commentsFocus,
                        controller: commentsController,
                        maxLines: 10,
                      ),
                    ),
                    Center(
                        child: IconButton(
                            onPressed: () async {
                              commentsFocus.unfocus();
                              cameraController = CameraController(
                                  _cameras[0], ResolutionPreset.max);
                              cameraController.initialize().then((_) {
                                if (!mounted) {
                                  return;
                                }
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return PopScope(
                                        onPopInvoked: (didPop) {
                                          cameraController.dispose();
                                        },
                                        child: AlertDialog(
                                          content: SingleChildScrollView(
                                            child: Column(children: [
                                              SizedBox(
                                                height: size.height * 0.4,
                                                width: size.width * 0.5,
                                                child: cameraController
                                                    .buildPreview(),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    child: Stack(
                                                      children: [
                                                        Icon(Icons
                                                            .image_rounded),
                                                        Positioned(
                                                            left: 2,
                                                            child: Text(
                                                              "${imagesCaptured.length}",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  IconButton(
                                                      onPressed: () async {
                                                        cameraController
                                                            .pausePreview();
                                                        imagesCaptured.add(
                                                            await cameraController
                                                                .takePicture());
                                                        cameraController
                                                            .resumePreview();
                                                        setState(() {});
                                                      },
                                                      icon: Icon(Icons
                                                          .camera_rounded)),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Done"))
                                                ],
                                              )
                                            ]),
                                          ),
                                        ),
                                      );
                                    });
                              }).catchError((Object e) {
                                if (e is CameraException) {
                                  switch (e.code) {
                                    case 'CameraAccessDenied':
                                      // Handle access errors here.
                                      print("cannot access camera");
                                      break;
                                    default:
                                      // Handle other errors here.
                                      break;
                                  }
                                }
                              });
                              CameraPreview(cameraController);
                            },
                            icon: Icon(Icons.add_photo_alternate_rounded))),
                    SizedBox(
                        height:
                            imagesCaptured.length == 0 ? 0 : size.height * 0.2,
                        width: size.width * 0.5,
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemBuilder: (context, index) {
                            return Stack(fit: StackFit.expand, children: [
                              Image.file(
                                File(imagesCaptured[index].path),
                                fit: BoxFit.fill,
                              ),
                              Positioned(
                                  top: -10,
                                  right: -10.0,
                                  child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          imagesCaptured.removeAt(index);
                                        });
                                      },
                                      icon: Icon(
                                        Icons.cancel_rounded,
                                        color: Colors.red,
                                      )))
                            ]);
                          },
                          itemCount: imagesCaptured.length,
                        )
                        //  GridView (
                        //   scrollDirection: Axis.horizontal,
                        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //       crossAxisCount: 1),
                        //   children: imagesCaptured
                        //       .map((e) => Stack(children: [
                        //             Image.file(File(e.path)),
                        //             Positioned(
                        //                 right: 0.0,
                        //                 child: IconButton(
                        //                     onPressed: () {},
                        //                     icon: Icon(
                        //                       Icons.cancel_rounded,
                        //                       color: Colors.red,
                        //                     )))
                        //           ]))
                        //       .toList(),
                        // )
                        )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
