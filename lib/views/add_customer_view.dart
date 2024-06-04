import 'package:customs/src.dart';
import 'package:dms/bloc/customer_bloc/customer_bloc.dart';
import 'package:dms/custom_methods/methods.dart';
import 'package:dms/models/customer.dart';
import 'package:dms/views/DMS_custom_widgets.dart';
import 'package:dms/views/add_vehicle_view.dart';
import 'package:dms/views/service_history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCustomerView extends StatelessWidget {
  AddCustomerView({super.key});

  TextEditingController customerIdController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerContactNoController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  ScrollController scrollController = ScrollController();

  FocusNode customerNoFocus = FocusNode();
  FocusNode customerNameFocus = FocusNode();
  FocusNode customerContactNoFocus = FocusNode();
  FocusNode customerAddressFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    var size = MediaQuery.of(context).size;
    double fieldWidth;
    double fieldHeight;

    bool isMobile = size.width < 650;
    if (isMobile) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      fieldWidth = size.width * 0.8;
      fieldHeight = size.height * 0.06;
    } else {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
      fieldWidth = size.width * 0.6;
      fieldHeight = size.height * 0.063;
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        floatingActionButton: MediaQuery.of(context).viewInsets.bottom == 0
            ? Padding(
                padding: EdgeInsets.only(
                    right: isMobile ? 5 : 40, bottom: isMobile ? 15 : 25),
                child: CustomWidgets.CustomExpandableFAB(
                    horizontalAlignment: isMobile ? -17 : -40,
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
                            Navigator.of(context).push(MaterialPageRoute(
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
                        height: size.height * 0.085,
                        width: size.width * (isMobile ? 0.24 : 0.1),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const ServiceHistoryView()));
                          },
                          child: Column(
                            children: [
                              Icon(
                                Icons.history,
                                color: Colors.white,
                                size: isMobile ? 28 : 40,
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
            : const SizedBox(),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white)),
          title: const Text(
            "Add Customer",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/dms_bg.png',
                ),
                fit: BoxFit.cover),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: isMobile ? size.height * 0.05 : size.height * 0.1,
                    ),
                    SizedBox(
                      height: isMobile
                          ? size.height * 0.28
                          : MediaQuery.of(context).viewInsets.bottom == 0
                              ? size.height * 0.5
                              : size.height * 0.2,
                      width: fieldWidth,
                      child: GridView(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : 2,
                          mainAxisExtent: fieldHeight,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 16,
                        ),
                        controller: scrollController,
                        children: [
                          DMSCustomWidgets.CustomDataCard(
                              focusNode: customerNoFocus,
                              size: size,
                              hint: "Id",
                              isMobile: isMobile,
                              scrollController: scrollController,
                              txcontroller: customerIdController,
                              context: context),
                          DMSCustomWidgets.CustomDataCard(
                              focusNode: customerNameFocus,
                              size: size,
                              hint: "Name",
                              isMobile: isMobile,
                              txcontroller: customerNameController,
                              scrollController: scrollController,
                              context: context),
                          DMSCustomWidgets.CustomDataCard(
                              focusNode: customerContactNoFocus,
                              size: size,
                              hint: "Contact Number",
                              isMobile: isMobile,
                              txcontroller: customerContactNoController,
                              scrollController: scrollController,
                              context: context),
                        ],
                      ),
                    ),
                    CustomTextFieldCard(
                        size: size,
                        hint: 'Address',
                        isMobile: isMobile,
                        focusNode: customerAddressFocus,
                        txcontroller: customerAddressController),
                    SizedBox(
                      height:
                          isMobile ? size.height * 0.02 : size.height * 0.05,
                    ),
                    BlocConsumer<CustomerBloc, CustomerState>(
                      listener: (context, state) {
                        if (state.status == CustomerStatus.failure) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                                content: Text(
                                    'Customer with this Id already exists.')));
                        } else if (state.status == CustomerStatus.success) {
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(const SnackBar(
                                content: Text('Customer added Successfully')));
                        }
                      },
                      builder: (context, state) {
                        switch (state.status) {
                          case CustomerStatus.loading:
                            return CircularProgressIndicator();
                          default:
                            return ElevatedButton(
                              onPressed: () {
                                if (customerIdController.text.isNotEmpty &&
                                    customerNameController.text.isNotEmpty &&
                                    customerContactNoController
                                        .text.isNotEmpty &&
                                    customerAddressController.text.isNotEmpty) {
                                  context.read<CustomerBloc>().add(
                                      CustomerDetailsSubmitted(
                                          customer: Customer(
                                              customerId:
                                                  customerIdController
                                                      .text
                                                      .toUpperCase(),
                                              customerName: capitalizeEachWord(
                                                  customerNameController.text),
                                              customerContactNo: int.parse(
                                                  customerContactNoController
                                                      .text),
                                              customerAddress:
                                                  customerAddressController
                                                      .text)));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4)),
                                  minimumSize: const Size(10, 36),
                                  backgroundColor:
                                      Color.fromARGB(255, 145, 19, 19),
                                  foregroundColor: Colors.white),
                              child: const Text("Submit"),
                            );
                        }
                      },
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

  Widget CustomTextFieldCard(
      {required Size size,
      required String hint,
      TextEditingController? txcontroller,
      FocusNode? focusNode,
      Widget? icon,
      required bool isMobile}) {
    return SizedBox(
      height: isMobile ? size.height * 0.1 : size.height * 0.13,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: TextFormField(
          cursorColor: Colors.black,
          style: TextStyle(fontSize: isMobile ? 13 : 14),
          controller: txcontroller,
          focusNode: focusNode,
          minLines: 1,
          maxLines: 5,
          maxLength: 200,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.only(left: 15, top: 0),
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(
                color: Colors.black45, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
