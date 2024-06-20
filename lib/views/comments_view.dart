import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CommentsView extends StatefulWidget {
  CommentsView({super.key});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {

  TextEditingController commentsController = TextEditingController();
  FocusNode commentsFocus = FocusNode();
  var imagesCaptured = [];

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    // _cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

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
                              ImagePicker imagePicker = ImagePicker();
                              XFile? image = await imagePicker.pickImage(
                                  source: ImageSource.camera);
                              if (image != null) {
                                //adding to the list of images
                              }
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
