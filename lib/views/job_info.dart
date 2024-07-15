import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:gap/gap.dart';

import '../models/services.dart';

class JobCardInfo extends StatelessWidget {
  JobCardInfo({super.key, required this.service});

  Service service;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 145, 19, 19),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
        title: const Text(
          "JobCardInfo",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: size.height,
        width: size.width,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 241, 184, 184)),
        child: Center(
          child: Container(
            padding: EdgeInsets.only(
                left: size.width * 0.08, top: size.height * 0.04),
            height: size.height * 0.3,
            width: size.width * 0.9,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 236, 200, 200),
                borderRadius: BorderRadius.circular(size.height * 0.05),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(-20, -20),
                      color: Color.fromARGB(255, 240, 213, 213),
                      blurRadius: 20,
                      inset: true),
                  BoxShadow(
                      offset: Offset(20, 20),
                      color: Color.fromARGB(255, 235, 136, 136),
                      blurRadius: 20,
                      inset: true)
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: size.width * 0.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Job Card No.'),
                      Gap(size.height * 0.02),
                      const Text('Vehicle Registration No.'),
                      Gap(size.height * 0.02),
                      const Text('Location'),
                      Gap(size.height * 0.02),
                      const Text('Job Type'),
                      Gap(size.height * 0.02),
                      const Text('Job Card Status')
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(':'),
                      Gap(size.height * 0.03),
                      const Text(':'),
                      Gap(size.height * 0.035),
                      const Text(':'),
                      Gap(size.height * 0.02),
                      const Text(':'),
                      Gap(size.height * 0.02),
                      const Text(':'),
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.jobCardNo!),
                      Gap(size.height * 0.03),
                      Text(service.registrationNo!),
                      Gap(size.height * 0.035),
                      Text(service.location!),
                      Gap(size.height * 0.02),
                      Text(service.jobType!),
                      Gap(size.height * 0.02),
                      Text(service.status!),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
