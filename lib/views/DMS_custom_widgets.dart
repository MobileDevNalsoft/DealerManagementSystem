import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DMSCustomWidgets {
  // ignore: non_constant_identifier_names
  static Widget SearchableDropDown(
      {required size,
      required hint,
      required List<String> items,
      required FocusNode focus,
      required TextEditingController textcontroller,
      required bool isMobile,
      required ScrollController scrollController,
      Function(String?)? onChange,
      Icon? icon}) {
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: TypeAheadField(
          builder: (context, controller, focusNode) {
            focus = focusNode;
            // textcontroller = controller;
            // textcontroller.text = controller.text;

            return Transform(
              transform: Matrix4.translationValues(0, isMobile ? 1.5 : 0, 0),
              child: TextFormField(
                onChanged:(value) {
                  controller.text=value;
                },
                onTap: () {
                  Provider.of<HomeProvider>(context, listen: false)
                      .setFocusNode(focusNode, scrollController, context);
                },
                onChanged: (value) {
                  controller.text = value;
                },
                cursorColor: Colors.black,
                style: TextStyle(fontSize: isMobile ? 13 : 14),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: size.height * 0.016),
                  suffixIcon: icon,
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                  ),
                  border: InputBorder.none, // Removes all borders
                ),
                controller: textcontroller,
                focusNode: focus,
              ),
            );
          },
          suggestionsCallback: (pattern) {
            return items
                .where((item) =>
                    item.toLowerCase().contains(pattern.toLowerCase()))
                .toList();
          },
          itemBuilder: (context, suggestion) => ListTile(
            title: Text(
              suggestion,
              style: TextStyle(fontSize: isMobile ? 13 : 14),
            ),
          ),
          onSelected: (suggestion) {
            // print(suggestion);
            textcontroller.text = suggestion;
            print(textcontroller.text);
            // focus.unfocus();
          },
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  static Widget CustomDataCard(
      {required Size size,
      required String hint,
      required bool isMobile,
      required ScrollController scrollController,
      Function(String?)? onChange,
      String? Function(String?)? validator,
      GlobalKey? key,
      TextEditingController? textcontroller,
      Widget? icon,
      required BuildContext context,
      List<TextInputFormatter>? inputFormatters,
      TextInputType? keyboardType,
      String? initialValue,
      Widget? suffixIcon,
      FocusNode? focusNode}) {
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Transform(
          transform: Matrix4.translationValues(0, isMobile ? 1.5 : 0, 0),
          child: TextFormField(
            onChanged: onChange,
            initialValue: initialValue,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textInputAction: TextInputAction.next,
            onTap: () {
              Provider.of<HomeProvider>(context, listen: false)
                  .setFocusNode(focusNode!, scrollController, context);
            },
            key: key,
            validator: validator,
            focusNode: focusNode,
            cursorColor: Colors.black,
            controller: textcontroller,
            style: TextStyle(
                fontSize: isMobile ? 13 : 14, fontFamily: 'euclid-circular-a'),
            maxLength: 25,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            decoration: InputDecoration(
                suffix: suffixIcon,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 16, vertical: size.height * 0.016),
                counterText: "",
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
                suffixIcon: Transform(
                  transform: Matrix4.translationValues(0, -2, 0),
                  child: icon,
                ),
                suffixIconColor: Colors.green),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  static Widget CustomTextFieldCard(
      {required Size size,
      required String hint,
      TextEditingController? textcontroller,
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
          controller: textcontroller,
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

  // ignore: non_constant_identifier_names
  static Widget ScheduleDateCalendar(
      {context, required Size size, required bool isMobile, DateTime? date}) {
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                content: SizedBox(
                    height: size.height * 0.4,
                    width: size.width,
                    child: SfDateRangePicker(
                      view: DateRangePickerView.month,
                      onSelectionChanged:
                          (dateRangePickerSelectionChangedArgs) {
                        date = dateRangePickerSelectionChangedArgs.value;
                        context
                            .read<MultiBloc>()
                            .add(DateChanged(date: date ?? DateTime.now()));
                      },
                      allowViewNavigation: true,
                      todayHighlightColor:
                          const Color.fromARGB(255, 145, 19, 19),
                      selectionColor: const Color.fromARGB(255, 145, 19, 19),
                      maxDate: DateTime(2024, 12, 31),
                      showNavigationArrow: true,
                      backgroundColor: Colors.white,
                      headerStyle: const DateRangePickerHeaderStyle(
                          backgroundColor: Color.fromARGB(255, 187, 76, 76),
                          textAlign: TextAlign.center),
                    )),
              );
            },
          );
        },
        child: Card(
            color: Colors.white.withOpacity(1),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              child: Row(
                children: [
                  Text(
                    date == null
                        ? 'Schedule Date'
                        : DateFormat("dd MMM yyyy").format(date),
                    style: TextStyle(color: Colors.black54),
                  ),
                  MaxGap(500),
                  Icon(Icons.calendar_month_outlined, color: Colors.black38),
                ],
              ),
            )),
      ),
    );
  }
}
