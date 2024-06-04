import 'package:dms/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';


class DMSCustomWidgets{

static Widget SearchableDropDown(
      {required size,
      required hint,
      required List<String> items,
      required FocusNode focus,
      required TextEditingController txcontroller,
      required bool isMobile,
      required ScrollController scrollController,
      Icon? icon 
      }) {
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: TypeAheadField(
          builder: (context, controller, focusNode) {
            focus = focusNode;
            return TextFormField(
              
              onTap: () {
                Provider.of<HomeProvider>(context, listen: false)
                    .setFocusNode(focusNode, scrollController, context);
              },
              cursorColor: Colors.black,
              style: TextStyle(fontSize: isMobile ? 13 : 14),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: size.height*0.016),
                suffixIcon: icon,
                hintText: hint,
                hintStyle: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none, // Removes all borders
              ),
              controller: txcontroller,
              focusNode: focus,
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
            txcontroller.text = suggestion;
            focus.unfocus();
          },
        ),
      ),
    );
  }

static Widget CustomDataCard(
      {required Size size,
      required String hint,
      required bool isMobile,
      required ScrollController scrollController,
      GlobalKey? key,
      TextEditingController? txcontroller,
      Widget? icon,
      BuildContext? context,
      FocusNode? focusNode}) {
    return SizedBox(
      height: isMobile ? size.height * 0.06 : size.height * 0.063,
      width: isMobile ? size.width * 0.8 : size.width * 0.3,
      child: Card(
        color: Colors.white.withOpacity(1),
        child: TextFormField(
          onTap: () {
            Provider.of<HomeProvider>(context! , listen: false)
                .setFocusNode(focusNode!, scrollController, context );
          },
          key: key,
          focusNode: focusNode,
          cursorColor: Colors.black,
          controller: txcontroller,
          style: TextStyle(fontSize: isMobile ? 13 : 14, fontFamily: 'euclid-circular-a'),

          maxLength: 25,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16,vertical: size.height*0.016),
              counterText: "",
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
              suffixIcon: icon,
              suffixIconColor: Colors.green),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
    );
  }

}