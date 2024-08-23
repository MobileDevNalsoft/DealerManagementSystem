import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DMSCustomWidgets {
  static Widget SearchableDropDown(
      {required Size size,
      required String hint,
      required List<dynamic> items,
      required FocusNode focus,
      required TextEditingController typeAheadController,
      required bool isMobile,
      required ScrollController scrollController,
      Function(String?)? suggestionCall,
      void Function(String)? onChanged,
      SuggestionsController? suggestionsController,
      bool isLoading = false,
      Icon? icon}) {
    if (suggestionsController != null) {
      suggestionsController.refresh();
    }

    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: TypeAheadField(
          suggestionsController: suggestionsController,
          controller: typeAheadController,
          focusNode: focus,
          builder: (context, controller, focusNode) {
            return Padding(
              padding: EdgeInsets.only(top: size.height * 0.005),
              child: TextFormField(
                onChanged: onChanged,
                onTap: () {
                  context.read<MultiBloc>().add(OnFocusChange(focusNode: focusNode, scrollController: scrollController, context: context));
                },
                onTapOutside: (event) => focusNode.unfocus(),
                cursorColor: Colors.black,
                inputFormatters: [
                  // FilteringTextInputFormatter.deny(RegExp(r'\d'))
                ],
                style: TextStyle(fontSize: isMobile ? 13 : 14),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 16, right: 16, bottom: size.height * 0.016),
                  suffixIcon: Transform(transform: Matrix4.translationValues(0, -2, 0), child: icon),
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.normal,
                  ),
                  border: InputBorder.none, // Removes all borders
                ),
                controller: controller,
                focusNode: focusNode,
              ),
            );
          },
          suggestionsCallback: (pattern) {
            if (suggestionsController == null) {
              return items.where((item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
            }
            return items;
          },
          hideOnUnfocus: true,
          emptyBuilder: (context) => Container(
            height: size.height * 0.038,
            width: size.width,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: typeAheadController.text.isNotEmpty
                ? Text(
                    'no items found',
                    style: TextStyle(fontSize: isMobile ? 13 : 14),
                  )
                : null,
          ),
          onSelected: (suggestion) {
            FocusManager.instance.primaryFocus?.unfocus();
            typeAheadController.text = suggestion;
          },
          itemBuilder: (context, suggestion) => Container(
            height: size.height * 0.038,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Text(
              suggestion,
              style: TextStyle(fontSize: isMobile ? 13 : 14),
            ),
          ),
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
        elevation: 3,
        color: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Transform(
          transform: Matrix4.translationValues(0, isMobile ? 1.5 : 0, 0),
          child: TextFormField(
            onChanged: onChange,
            initialValue: initialValue,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textInputAction: TextInputAction.next,
            onTap: () {
              context.read<MultiBloc>().add(OnFocusChange(focusNode: focusNode!, scrollController: scrollController, context: context));
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
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: size.height * 0.016),
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
      List<TextInputFormatter>? inputFormatters,
      FocusNode? focusNode,
      required BuildContext context,
      required ScrollController scrollController,
      Widget? icon,
      required bool isMobile}) {
    return SizedBox(
      height: isMobile ? size.height * 0.1 : size.height * 0.13,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
        child: TextFormField(
          cursorColor: Colors.black,
          style: TextStyle(fontSize: isMobile ? 13 : 14),
          controller: textcontroller,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          onTap: () {
            context.read<MultiBloc>().add(OnFocusChange(focusNode: focusNode!, scrollController: scrollController, context: context));
          },
          minLines: 1,
          maxLines: 5,
          maxLength: 200,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.only(left: 15, top: 0),
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black45, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  static Widget ScheduleDateCalendar({context, required Size size, required bool isMobile, DateTime? date}) {
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
                    width: size.width * (isMobile ? 1 : 0.35),
                    child: SfDateRangePicker(
                      enablePastDates: false,
                      view: DateRangePickerView.month,
                      allowViewNavigation: true,
                      todayHighlightColor: Colors.black,
                      selectionColor: Colors.black,
                      maxDate: DateTime(2024, 12, 31),
                      showNavigationArrow: true,
                      backgroundColor: Colors.white,
                      initialSelectedDate: date ?? DateTime.now(),
                      showActionButtons: true,
                      onCancel: () {
                        Navigator.pop(context);
                      },
                      onSubmit: (p0) {
                        context.read<MultiBloc>().add(DateChanged(date: p0 as DateTime));
                        Navigator.pop(context);
                      },
                      headerStyle: const DateRangePickerHeaderStyle(
                          backgroundColor: Colors.black, textStyle: TextStyle(color: Colors.white), textAlign: TextAlign.center),
                    )),
              );
            },
          );
        },
        child: Card(
            elevation: 3,
            color: Colors.white,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              child: Row(
                children: [
                  Text(
                    date == null ? 'Schedule Date' : DateFormat("dd MMM yyyy").format(date),
                    style: TextStyle(color: date == null ? Colors.black38 : Colors.black),
                  ),
                  const MaxGap(500),
                  const Icon(Icons.calendar_month_outlined, color: Colors.black38),
                ],
              ),
            )),
      ),
    );
  }

  static Widget CustomDataFields(
      {required BuildContext context,
      double? contentPadding,
      double? propertyFontSize,
      double? valueFontSize,
      double? spaceBetweenFields,
      TextStyle? propertyFontStyle,
      TextStyle? valueFontStyle,
      String? propertyFontFamily,
      String? valueFontFamily,
      bool showColonsBetween = true,
      required List<String> propertyList,
      required List<String> valueList}) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(
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
      Gap(contentPadding ?? 20),
      if (showColonsBetween)
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
      if (showColonsBetween) Gap(contentPadding ?? 20),
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
      {required Size size, required bool isMobile, required BuildContext context, required FixedExtentScrollController yearPickerController, int? year}) {
    int now = DateTime.now().year;
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
          yearPickerController = FixedExtentScrollController(initialItem: now - (year ?? 0));
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
                        context.read<MultiBloc>().add(YearChanged(year: now - value));
                      },
                      useMagnifier: true,
                      magnification: 1.2,
                      backgroundColor: Colors.black,
                      selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
                        background: Colors.white30,
                      ),
                      children: List.generate(
                        now - 1980,
                        (index) => Center(
                            child: Text(
                          (now - index).toString(),
                          style: const TextStyle(color: Colors.white),
                        )),
                      )),
                )
              ],
              cancelButton: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Set',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          );
        },
        child: Card(
            color: Colors.white.withOpacity(1),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              child: Text(
                year == null ? 'MFG Year' : year.toString(),
                style: TextStyle(color: year == null ? Colors.black38 : Colors.black),
              ),
            )),
      ),
    );
  }

  static showDMSDialog({
    required BuildContext context,
    required String text,
    required String acceptLable,
    required String rejectLable,
    required void Function()? onAccept,
    required void Function()? onReject,
    Widget? leadingIcon,
  }) {
    Size size = MediaQuery.of(context).size;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: EdgeInsets.only(top: size.height * 0.01),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.03),
                    child: Text(
                      text,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Gap(size.height * 0.01),
                  Container(
                    height: size.height * 0.05,
                    margin: EdgeInsets.all(size.height * 0.001),
                    decoration: const BoxDecoration(
                        color: Colors.black, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: onReject,
                            style: TextButton.styleFrom(fixedSize: Size(size.width * 0.3, size.height * 0.1), foregroundColor: Colors.white),
                            child: Text(
                              rejectLable,
                            ),
                          ),
                        ),
                        const VerticalDivider(
                          color: Colors.white,
                          thickness: 0.5,
                        ),
                        Expanded(
                          child: TextButton(
                            onPressed: onAccept,
                            style: TextButton.styleFrom(fixedSize: Size(size.width * 0.3, size.height * 0.1), foregroundColor: Colors.white),
                            child: Text(
                              rejectLable,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              actionsPadding: EdgeInsets.zero,
              buttonPadding: EdgeInsets.zero);
        });
  }

  static Future DMSFlushbar(Size size, BuildContext context, {String message = 'message', Widget? icon}) async {
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;
    await Flushbar(
      backgroundColor: Colors.black,
      blockBackgroundInteraction: true,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      borderRadius: BorderRadius.circular(8),
      icon: icon,
      boxShadows: [BoxShadow(blurRadius: 12, blurStyle: BlurStyle.outer, spreadRadius: 0, color: Colors.orange.shade200, offset: const Offset(0, 0))],
      margin: EdgeInsets.only(
          top: size.height * 0.01, left: isMobile ? size.width * 0.04 : size.width * 0.8, right: isMobile ? size.width * 0.04 : size.width * 0.03),
    ).show(context);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class InitCapCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text[0].toUpperCase() + newValue.text.substring(1),
      selection: newValue.selection,
    );
  }
}
