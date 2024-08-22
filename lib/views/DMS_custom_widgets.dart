import 'package:another_flushbar/flushbar.dart';
import 'package:dms/bloc/multi/multi_bloc.dart';
import 'package:dms/bloc/service/service_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  /// This widget creates a searchable dropdown field.
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
    // Refresh the suggestions if a SuggestionsController is provided
    if (suggestionsController != null) {
      suggestionsController.refresh();
    }

    // Define the size of the widget based on whether it's mobile or not
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: TypeAheadField(
          // Use the provided suggestions controller or create a new list based on items
          suggestionsController: suggestionsController,
          controller: typeAheadController,
          focusNode: focus,
          builder: (context, controller, focusNode) {
            return Padding(
              padding: EdgeInsets.only(top: size.height * 0.005),
              child: TextFormField(
                // Call the onChanged function when the text changes
                onChanged: onChanged,
                // Focus the field when tapped
                onTap: () {
                  // when this event is triggered it automatically scrolls the searchable text field to a visible position above the keyboard.
                  context.read<MultiBloc>().add(OnFocusChange(
                      focusNode: focusNode,
                      scrollController: scrollController,
                      context: context));
                },
                // Unfocus the field when tapped outside
                onTapOutside: (event) => focusNode.unfocus(),
                cursorColor: Colors.black,
                inputFormatters: [
                  // FilteringTextInputFormatter.deny(RegExp(r'\d'))
                ],
                style: TextStyle(fontSize: isMobile ? 13 : 14),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(
                      left: 16, right: 16, bottom: size.height * 0.016),
                  suffixIcon: Transform(
                      transform: Matrix4.translationValues(0, -2, 0),
                      child: icon),
                  hintText: hint,
                  hintStyle: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.normal,
                  ),
                  // Remove all borders for a cleaner look
                  border: InputBorder.none, // Removes all borders
                ),
                controller: controller,
                focusNode: focusNode,
              ),
            );
          },
          // Filter suggestions based on the pattern entered
          suggestionsCallback: (pattern) {
            if (suggestionsController == null) {
              return items
                  .where((item) =>
                      item.toLowerCase().contains(pattern.toLowerCase()))
                  .toList();
            }
            return items;
          },
          // Hide the suggestions list when the field loses focus
          hideOnUnfocus: true,
          // Display a message when no suggestions are found
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
            // removes focus when an item from the suggestion list is selected.
            FocusManager.instance.primaryFocus?.unfocus();
            typeAheadController.text = suggestion;
          },
          // defines widget that to be built for each item in the suggestions list
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

  // This widget creates a custom data card for text input
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
      // Set the card height and width based on mobile status
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Transform(
          // Adjust vertical position slightly for mobile layout
          transform: Matrix4.translationValues(0, isMobile ? 1.5 : 0, 0),
          child: TextFormField(
            onChanged: onChange,
            initialValue: initialValue,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            textInputAction: TextInputAction.next,
            onTap: () {
              // Trigger event on focus change in MultiBloc
              // when this event is triggered it automatically scrolls the searchable text field to a visible position above the keyboard.
              context.read<MultiBloc>().add(OnFocusChange(
                  focusNode: focusNode!,
                  scrollController: scrollController,
                  context: context));
            },
            key: key,
            validator: validator,
            focusNode: focusNode,
            cursorColor: Colors.black,
            controller: textcontroller,
            style: TextStyle(
              fontSize:
                  isMobile ? 13 : 14, // Adjust font size for mobile layout
            ),
            maxLength: 25, // Set maximum allowed characters
            maxLengthEnforcement:
                MaxLengthEnforcement.enforced, // Enforce max length
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
                  // Adjust vertical position of suffix icon slightly
                  transform: Matrix4.translationValues(0, -2, 0),
                  child: icon,
                ),
                suffixIconColor: Colors.green),
          ),
        ),
      ),
    );
  }

  // This widget creates a custom text field card
  // This function defines a reusable widget named `CustomTextFieldCard`.
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
      // Set the height and width of the card based on mobile/non-mobile
      height: isMobile ? size.height * 0.1 : size.height * 0.13,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: TextFormField(
          cursorColor: Colors.black,
          style: TextStyle(fontSize: isMobile ? 13 : 14),
          controller: textcontroller,
          focusNode: focusNode,
          inputFormatters: inputFormatters,
          onTap: () {
            // when this event is triggered it automatically scrolls the searchable text field to a visible position above the keyboard.
            context.read<MultiBloc>().add(OnFocusChange(
                focusNode: focusNode!,
                scrollController: scrollController,
                context: context));
          },
          // Set text field properties
          minLines: 1,
          maxLines: 5,
          maxLength: 200,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.only(left: 15, top: 0),
            border: InputBorder.none, // Remove default border
            hintText: hint,
            hintStyle: const TextStyle(
                color: Colors.black45, fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }

  /// This widget displays a clickable card to select a schedule date using a calendar dialog.
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
                    width: size.width * (isMobile ? 1 : 0.35),
                    child: SfDateRangePicker(
                      // Configure date range picker options
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
                        // Handle submit action (update selected date)
                        context
                            .read<MultiBloc>()
                            .add(DateChanged(date: p0 as DateTime));
                        Navigator.pop(context);
                      },
                      headerStyle: const DateRangePickerHeaderStyle(
                          backgroundColor: Colors.black,
                          textStyle: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
                    )),
              );
            },
          );
        },
        child: Card(
            elevation: 3,
            color: Colors.white,
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
                    style: TextStyle(
                        color: date == null ? Colors.black38 : Colors.black),
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

  // used to create data fields with key value pairs
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

  /// This widget builds a custom year picker for selecting a vehicle's manufacturing year.
  static Widget CustomYearPicker(
      {required Size size,
      required bool isMobile,
      required BuildContext context,
      required FixedExtentScrollController yearPickerController,
      int? year}) {
    // Get the current year
    int now = DateTime.now().year;
    return SizedBox(
      /// Set height and width based on device type
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: () {
          // Unfocus any currently focused widget
          FocusManager.instance.primaryFocus?.unfocus();
          // Update the year picker controller with initial selection based on current year and pre-selected year (if any)
          yearPickerController =
              FixedExtentScrollController(initialItem: now - (year ?? 0));

          // Show the year picker dialog using CupertinoModalPopup
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
                        // Update the MultiBloc state with the selected year
                        context
                            .read<MultiBloc>()
                            .add(YearChanged(year: now - value));
                      },
                      useMagnifier: true,
                      magnification: 1.2,
                      backgroundColor: Colors.black,
                      selectionOverlay:
                          const CupertinoPickerDefaultSelectionOverlay(
                        background: Colors.white30,
                      ),

                      /// Generate list of year Text widgets from current year back to 1980
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

              /// Set cancel button for the dialog
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
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              child: Text(
                /// Display "MFG Year" if no year is selected, otherwise display the selected year
                year == null ? 'MFG Year' : year.toString(),
                style: TextStyle(
                    color: year == null ? Colors.black38 : Colors.black),
              ),
            )),
      ),
    );
  }

  // This function shows a custom DMS dialog
  static showDMSDialog({
    required BuildContext context,
    required String text,
    required String acceptLable,
    required String rejectLable,
    required void Function()? onAccept,
    required void Function()? onReject,
    Widget? leadingIcon,
  }) {
    // Get the screen size
    Size size = MediaQuery.of(context).size;

    // Show an AlertDialog with customizations
    showDialog(
        context: context,
        // Prevent dismissal by tapping outside the dialog
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: onReject,
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
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
                            style: TextButton.styleFrom(
                                fixedSize:
                                    Size(size.width * 0.3, size.height * 0.1),
                                foregroundColor: Colors.white),
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
              actionsPadding:
                  EdgeInsets.zero, // Remove default padding around buttons
              buttonPadding:
                  EdgeInsets.zero); // Remove default padding around buttons
        });
  }

// This function displays a custom flushbar message on the screen
  static Future DMSFlushbar(Size size, BuildContext context,
      {String message = 'message', Widget? icon}) async {
    // Check if the device is mobile based on screen size
    bool isMobile = MediaQuery.of(context).size.shortestSide < 500;

    // Show the flushbar using Flushbar package
    await Flushbar(
      backgroundColor: Colors.black,
      blockBackgroundInteraction: true,
      message: message,
      flushbarPosition: FlushbarPosition.TOP,
      duration: const Duration(seconds: 2),
      borderRadius: BorderRadius.circular(8),
      icon: icon,
      boxShadows: [
        BoxShadow(
            blurRadius: 12,
            blurStyle: BlurStyle.outer,
            spreadRadius: 0,
            color: Colors.orange.shade200,
            offset: const Offset(0, 0))
      ],
      margin: EdgeInsets.only(
          top: size.height * 0.01,
          left: isMobile ? size.width * 0.04 : size.width * 0.8,
          right: isMobile ? size.width * 0.04 : size.width * 0.03),
    ).show(context);
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  /// Converts all input text to uppercase.
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class InitCapCaseTextFormatter extends TextInputFormatter {
  /// Capitalizes the first letter of each word in the input text.
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      // This implementation only capitalizes the first letter of the entire string.
      // For proper word capitalization, more complex logic is required.
      text: newValue.text[0].toUpperCase() + newValue.text.substring(1),
      selection: newValue.selection,
    );
  }
}

// returns widget dynamically according to the widget name extracted from json.
Widget getWidget(
    {required Size size,
    required String page,
    required int index,
    required Map<String, dynamic> json,
    required BuildContext context,
    required bool isMobile}) {
  ServiceBloc _serviceBloc = context.read<ServiceBloc>();
  // Switch statement to handle different widget types based on "widget" key in JSON
  switch (json[page][index]['widget']) {
    case "checkBox":
      // Return a Checkbox widget with specific properties and behavior
      return SizedBox(
        height: size.height * 0.03,
        width: isMobile ? size.width * 0.05 : size.width * 0.024,
        child: Checkbox(
          checkColor: Colors.white,
          fillColor: json[page][index]['properties']['value'] == true
              ? const WidgetStatePropertyAll(Colors.black)
              : const WidgetStatePropertyAll(Colors.white),
          value: json[page][index]['properties']['value'],
          side: const BorderSide(strokeAlign: 1, style: BorderStyle.solid),
          onChanged: (value) {
            json[page][index]['properties']['value'] = value;
            _serviceBloc.add(InspectionJsonUpdated(json: json));
          },
        ),
      );
    case "textField":
      // Return a TextField widget with specific properties and behavior
      TextEditingController textEditingController = TextEditingController();

      textEditingController.text = json[page][index]['properties']['value'];

      textEditingController.selection = TextSelection.fromPosition(
          TextPosition(offset: textEditingController.text.length));

      return Container(
        height: size.height * 0.11,
        width: isMobile ? size.width * 0.62 : size.width * 0.32,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border: Border.all(color: Colors.black)),
        child: TextField(
            textInputAction: TextInputAction.done,
            controller: textEditingController,
            cursorColor: Colors.black,
            minLines: 1,
            maxLines: 5,
            maxLength: 200,
            decoration: const InputDecoration(
              counterText: '',
              enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              hintStyle: TextStyle(color: Colors.black38),
            ),
            onChanged: (value) {
              _serviceBloc.state.json![page][index]['properties']['value'] =
                  value;
            }),
      );
    case "dropDown":
      // Return a DropdownButton2 widget with specific properties and behavior
      // Create a list of items based on the JSON properties
      List<String> items = [];

      for (String s in json[page][index]['properties']['items']) {
        items.add(s);
      }

      if (json[page][index]['properties']['value'] == '') {
        json[page][index]['properties']['value'] = items[0];
      }

      return DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          onMenuStateChange: (isOpen) {},
          isExpanded: true,
          items: items
              .map((String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ))
              .toList(),
          value: json[page][index]['properties']['value'],
          onChanged: (String? value) {
            json[page][index]['properties']['value'] = value;
            _serviceBloc.add(InspectionJsonUpdated(json: json));
          },
          buttonStyleData: ButtonStyleData(
            height: size.height * 0.04,
            width: isMobile ? size.width * 0.5 : size.width * 0.32,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.black,
              ),
              color: Colors.white,
            ),
            elevation: 0,
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(!false
                ? Icons.keyboard_arrow_down_rounded
                : Icons.keyboard_arrow_up_rounded),
            iconSize: 14,
            iconEnabledColor: Colors.black,
            iconDisabledColor: Colors.black,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: size.height * 0.3,
            width: size.width * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            offset: const Offset(0, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all<double>(6),
              thumbVisibility: WidgetStateProperty.all<bool>(true),
            ),
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 30,
            padding: EdgeInsets.only(left: 14, right: 14),
          ),
        ),
      );
    case "radioButtons":
      // Return a column of Radio widgets with specific properties and behavior
      List<String> options = [];

      for (String s in json[page][index]['properties']['options']) {
        options.add(s);
      }

      return SizedBox(
        height: size.height * 0.25,
        width: size.width * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: options
              .map(
                (e) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    json[page][index]['properties']['options']
                        [options.indexOf(e)],
                    style: const TextStyle(fontSize: 13),
                  ),
                  leading: Radio<int>(
                    value: options.indexOf(e) + 1,
                    groupValue: json[page][index]['properties']['value'],
                    activeColor: Colors
                        .white, // Change the active radio button color here
                    fillColor: WidgetStateProperty.all(
                        Colors.black), // Change the fill color when selected
                    splashRadius: 20, // Change the splash radius when clicked
                    onChanged: (value) {
                      json[page][index]['properties']['value'] = value;
                      _serviceBloc.add(InspectionJsonUpdated(json: json));
                    },
                  ),
                ),
              )
              .toList(),
        ),
      );
  }

  // If no matching widget is found, return an empty SizedBox
  return const SizedBox();
}
