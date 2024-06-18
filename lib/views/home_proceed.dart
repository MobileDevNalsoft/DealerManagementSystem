import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dms/bloc/vehicle/vehicle_bloc.dart';
import 'package:dms/models/services.dart';
import 'package:dms/models/vehicle.dart';
import 'package:dms/providers/home_provider.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/add_vehicle_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:customs/src.dart';

class HomeProceedView extends StatefulWidget {
  @override
  Service service;
  Function? clearFields;

  HomeProceedView({super.key, required this.service,this.clearFields});
  State<HomeProceedView> createState() => _HomeProceedView();
}

class _HomeProceedView extends State<HomeProceedView> {
  FocusNode bookingFocus = FocusNode();
  FocusNode altContFocus = FocusNode();
  FocusNode altContPhoneNoFocus = FocusNode();
  FocusNode spFocus = FocusNode();
  FocusNode bayFocus = FocusNode();
  FocusNode jobTypeFocus = FocusNode();
  FocusNode custConcernsFocus = FocusNode();
  FocusNode remarksFocus = FocusNode();
  TextEditingController bookingController = TextEditingController();
  TextEditingController altContController = TextEditingController();
  TextEditingController altContPhoneNoController = TextEditingController();
  TextEditingController spController = TextEditingController();
  TextEditingController bayController = TextEditingController();
  TextEditingController jobTypeController = TextEditingController();
  TextEditingController custConcernsController = TextEditingController();
  TextEditingController remarksController = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    // Set preferred orientations based on device type
    if (!isMobile) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    var size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(  elevation: 0.0,
          backgroundColor:  const Color.fromARGB(255, 145, 19, 19),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
          title: const Text(
            "Service",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    'assets/images/dms_bg.png',
                  ),
                  fit: BoxFit.cover),
            ),
            child: ListView(
              controller: scrollController,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * (0.05),
                    ),
                    Consumer<HomeProvider>(
                      builder: (context, provider, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DMSCustomWidgets.SearchableDropDown(
                                items: ["Online", "Walk-in"],
                                size: size,
                                hint: 'Booking Source',
                                isMobile: isMobile,
                                focus: bookingFocus,
                                textcontroller: bookingController,
                                icon: Icon(Icons.arrow_drop_down),
                                scrollController: scrollController),
                            SizedBox(
                              height: size.height * (isMobile ? 0.005 : 0.015),
                            ),
                            DMSCustomWidgets.CustomDataCard(
                                context: context,
                                size: size,
                                hint: 'Alternate Contact Person',
                                isMobile: isMobile,
                                focusNode: altContFocus,
                                textcontroller: altContController,
          
                                scrollController: scrollController),
                            SizedBox(
                              height: size.height * (isMobile ? 0.005 : 0.015),
                            ),
                            DMSCustomWidgets.CustomDataCard(
                                context: context,
                                size: size,
                                hint: 'Alternate Person Contact No.',
                                isMobile: isMobile,
                               
                                focusNode: altContPhoneNoFocus,
                                textcontroller: altContPhoneNoController,
                                keyboardType: TextInputType.number, 
                                inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                       LengthLimitingTextInputFormatter(10)
                                    ],
                                scrollController: scrollController),
                            SizedBox(
                              height: size.height * (isMobile ? 0.005 : 0.015),
                            ),
                            DMSCustomWidgets.SearchableDropDown(
                                size: size,
                                items: ["1", "2", "3", "4", "5"],
                                hint: 'Sales Person',
                                icon: Icon(Icons.arrow_drop_down),
                                isMobile: isMobile,
                                focus: spFocus,
                                textcontroller: spController,
                                scrollController: scrollController),
                            SizedBox(
                              height: size.height * (isMobile ? 0.005 : 0.015),
                            ),
                            DMSCustomWidgets.SearchableDropDown(
                                items: ["Bay 1","Bay 2","Bay 3","Bay 4"],
                                size: size,
                                hint: 'Bay',
                                isMobile: isMobile,
                                focus: bayFocus,
                                textcontroller: bayController,
                                scrollController: scrollController),
                            SizedBox(
                              height: size.height * (isMobile ? 0.005 : 0.015),
                            ),
                            DMSCustomWidgets.SearchableDropDown(
                                size: size,
                                hint: 'Job Type',
                                items: [
                                  'Type 1',
                                  'Type 2',
                                  'Type 3',
                                  'Type 4',
                                  'Type 5'
                                ],
                                icon: Icon(Icons.arrow_drop_down),
                                focus: jobTypeFocus,
                                textcontroller: jobTypeController,
          
                                // provider: provider,
                                isMobile: isMobile,
                                scrollController: scrollController),
                            SizedBox(
                              height: size.height * (isMobile ? 0.005 : 0.015),
                            ),
                            DMSCustomWidgets.CustomTextFieldCard(
                                size: size,
                                hint: 'Customer Concerns',
                                isMobile: isMobile,
                                focusNode: custConcernsFocus,
                                textcontroller: custConcernsController),
                            SizedBox(
                              height: size.height * (isMobile ? 0.005 : 0.015),
                            ),
                            DMSCustomWidgets.CustomTextFieldCard(
                                size: size,
                                hint: 'Remarks',
                                isMobile: isMobile,
                                focusNode: remarksFocus,
                                textcontroller: remarksController),
                            SizedBox(
                              height: size.height * (isMobile ? 0.05 : 0.015),
                            ),
                          ],
                        );
                      },
                    ),
                    BlocConsumer<ServiceBloc, ServiceState>(
                      listener: (context, state) {
                        switch(state.status){
                        case ServiceStatus.success:
                        context.read<VehicleBloc>().add(UpdateState(status: VehicleStatus.initial,vehicle:Vehicle()));
                        widget.clearFields!(); 
                        bookingController.text = "";
                        altContController.text = "";  
                        altContPhoneNoController.text  = "";
                        spController.text = ""; 
                        bayController.text = "";  
                        jobTypeController.text = "";  
                        custConcernsController.text =  "";
                        remarksController .text = ""; 
                        Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor: Colors.green,
                                message: 'Service Added Successfully',
                                duration: Duration(seconds: 2),
                                borderRadius: BorderRadius.circular(12),
                              margin: EdgeInsets.only(
                                  top: 24,
                                  left: isMobile ? 10 : size.width * 0.8,
                                  right: 10))
                            .show(context);
                         case ServiceStatus.failure:
                            Flushbar(
                                flushbarPosition: FlushbarPosition.TOP,
                                backgroundColor: Colors.red,
                                message: 'Some error occured',
                                duration: Duration(seconds: 2),
                                borderRadius: BorderRadius.circular(12),
                              margin: EdgeInsets.only(
                                  top: 24,
                                  left: isMobile ? 10 : size.width * 0.8,
                                  right: 10))
                            .show(context);
          
                          default: null;
                            }
                      },
                      builder: (context, state) {
                        return state.status == ServiceStatus.loading
                            ? CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  bookingFocus.unfocus();
                                  altContFocus.unfocus();
                                  spFocus.unfocus();
                                  bayFocus.unfocus();
                                  jobTypeFocus.unfocus();
                                  custConcernsFocus.unfocus();
                                  remarksFocus.unfocus();
                                  print( jobTypeController.text);
                                  context.read<ServiceBloc>().add(
                                    ServiceAdded(
                                      service: widget.service.copyWith(
                                          bookingSource: bookingController.text,
                                          alternateContactPerson: altContController.text,
                                          alternatePersonContactNo: int.parse( altContPhoneNoController.text),
                                          salesPerson: spController.text,
                                          bay: bayController.text,
                                          jobType: jobTypeController.text,
                                          customerConcerns: custConcernsController.text,
                                          remarks: remarksController.text)));
                                },
                                child: Text(
                                  'proceed to recieve',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    minimumSize: Size(140.0, 35.0),
                                    padding: EdgeInsets.zero,
                                    backgroundColor:
                                        const Color.fromARGB(255, 145, 19, 19),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5))));
                      },
                    ),
                    if (MediaQuery.of(context).viewInsets.bottom != 0)
                      SizedBox(
                        height: size.height * (isMobile ? 0.4 : 0.5),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: EdgeInsets.only(
                    right: isMobile ? 5 : 40, bottom: isMobile ? 15 : 25),
                child: CustomWidgets.CustomExpandableFAB(
                    horizontalAlignment: isMobile ? -17 : -38,
                    verticalAlignment: -15,
                    rotational: false,
                    angle: 90,
                    distance: isMobile ? 50 : 70,
                    color: const Color.fromARGB(255, 145, 19, 19),
                    iconColor: Colors.white,
                    children: [
                      SizedBox(
                        height: size.height * 0.08,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (_) => AddVehicleView()));
                            
                          },
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/car.png',
                                color: Colors.white,
                                fit: BoxFit.cover,
                                scale: isMobile ? 22 : 15,
                              ),
                              Text(
                                'Add Vehicle',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 11 : 14),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.09,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          onTap: () {
                            context.read<VehicleBloc>().add(UpdateState(status: VehicleStatus.initial,vehicle:Vehicle()));
                              widget.clearFields!(); 
                                  Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (_) => AddVehicleView()));
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                size: isMobile ? 28 : 40,
                                color: Colors.white,
                              ),
                              Text(
                                'History',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isMobile ? 11 : 14),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
              )
            : SizedBox(),
      ),
    );
  }
}
