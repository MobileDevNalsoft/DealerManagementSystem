import 'package:customs/src.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/providers/home_provider.dart';
import 'package:flutter/cupertino.dart';
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
                onChanged: (value) {
                  controller.text = value;
                },
                onTap: () {
                  Provider.of<HomeProvider>(context, listen: false)
                      .setFocusNode(focusNode, scrollController, context);
                },
                cursorColor: Colors.black,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'\d')),
                ],
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
          itemBuilder: (context, suggestion) => SizedBox(
            height: size.height * 0.038,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                suggestion,
                style: TextStyle(fontSize: isMobile ? 13 : 14),
              ),
            ),
          ),
          onSelected: (suggestion) {
            textcontroller.text = suggestion;
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
              fontSize: isMobile ? 13 : 14,
            ),
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
                  color: Colors.black38,
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
    DateTime? initialDate = date;
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
                      initialSelectedDate: date ?? DateTime.now(),
                      showActionButtons: true,
                      onCancel: () {
                        print("initialdate $initialDate");
                        date = initialDate;
                        context
                            .read<MultiBloc>()
                            .add(DateChanged(date: date ?? DateTime.now()));
                        Navigator.pop(context);
                      },
                      onSubmit: (p0) {
                        print("scheduled data $p0");
                        Navigator.pop(context);
                      },
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
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const MaxGap(500),
                  const Icon(Icons.calendar_month_outlined,
                      color: Colors.black38),
                ],
              ),
            )),
      ),
    );
  }

  static Widget CustomDataFields(
      {required BuildContext context,
      contentPadding,
      double? propertyFontSize,
      double? valueFontSize,
      double? spaceBetweenFields,
      TextStyle? propertyFontStyle,
      TextStyle? valueFontStyle,
      String? propertyFontFamily,
      String? valueFontFamily,
      required List<String> propertyList,
      required List<String> valueList}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: propertyList
                .expand((element) => [
                      Text(
                        element,
                        style: propertyFontStyle,
                      ),
                      Gap(spaceBetweenFields ?? 0)
                    ])
                .toList(),
          ),
          const Gap(20),
          Column(
            children: propertyList
                .expand((element) => [
                      Text(
                        ":",
                        style: propertyFontStyle,
                      ),
                      Gap(spaceBetweenFields ?? 0)
                    ])
                .toList(),
          ),
          const Gap(20),
          Column(
            children: valueList
                .expand((element) => [
                      Text(
                        element,
                        style: valueFontStyle,
                      ),
                      Gap(spaceBetweenFields ?? 0)
                    ])
                .toList(),
          )
        ]);
  }

  static Widget CustomYearPicker(
      {required Size size,
      required bool isMobile,
      required BuildContext context,
      required FixedExtentScrollController yearPickerController,
      int? year}) {
    int now = DateTime.now().year;
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          print(now - (year ?? 0));
          yearPickerController =
              FixedExtentScrollController(initialItem: now - (year ?? 0));
          showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
              actions: [
                SizedBox(
                  height: size.height * 0.27,
                  width: size.width * 0.9,
                  child: CupertinoPicker(
                      itemExtent: 45,
                      looping: true,
                      scrollController: yearPickerController,
                      onSelectedItemChanged: (value) {
                        context
                            .read<MultiBloc>()
                            .add(YearChanged(year: now - value));
                      },
                      useMagnifier: true,
                      magnification: 1.2,
                      backgroundColor: const Color.fromARGB(255, 245, 202, 202),
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                        background: const Color.fromARGB(255, 145, 19, 19)
                            .withOpacity(0.2),
                      ),
                      children: List.generate(
                        now - 1980,
                        (index) =>
                            Center(child: Text((now - index).toString())),
                      )),
                )
              ],
              cancelButton: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Set',
                  style:
                      TextStyle(color: const Color.fromARGB(255, 145, 19, 19)),
                ),
              ),
            ),
          );
        },
        child: Card(
            color: Colors.white.withOpacity(1),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              child: Text(
                year == null ? 'MFG Year' : year.toString(),
                style: TextStyle(
                    color: year == null ? Colors.black38 : Colors.black),
              ),
            )),
      ),
    );
  }
}
