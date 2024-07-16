import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gap/gap.dart';

import '../models/services.dart';

class JobCardDetails extends StatelessWidget {
  JobCardDetails({super.key, required this.service});

  Service service;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              elevation: 5,
              backgroundColor: const Color.fromARGB(255, 145, 19, 19),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white)),
              title: const Text(
                "JobCardDetails",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              centerTitle: true,
            ),
            body: Container(
              height: size.height,
              width: size.width,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 241, 184, 184),
                        Colors.white
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.4, 1])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gap(size.height * 0.03),
                  SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.9,
                    child: Opacity(
                        opacity: 0.6,
                        child: Card(
                          color: Colors.white,
                          elevation: 6,
                        )),
                  )
                ],
              ),
            )));
  }
}
