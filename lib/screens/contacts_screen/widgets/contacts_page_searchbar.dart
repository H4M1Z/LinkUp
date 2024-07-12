import 'package:flutter/material.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/strings.dart';

class ContactsSearchBar extends StatelessWidget {
  const ContactsSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.07,
      child: SearchAnchor(
        builder: (context, controller) => SearchBar(
          controller: controller,
          backgroundColor: const WidgetStatePropertyAll(searchBarColor),
          hintText: searchBarHintText,
          padding: const WidgetStatePropertyAll(EdgeInsets.only(left: 10.0)),
          hintStyle: const WidgetStatePropertyAll(TextStyle(
            color: Colors.grey,
            fontSize: 15,
          )),
        ),
        suggestionsBuilder: (context, controller) => List.generate(
          0,
          (index) => const SizedBox(),
        ),
      ),
    );
  }
}
