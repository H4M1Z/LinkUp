import 'package:flutter/material.dart';
import 'package:gossip_go/features/group/screens/create_group_Screen.dart';
import 'package:gossip_go/screens/contacts_screen/widgets/contacts_list.dart';
import 'package:gossip_go/screens/contacts_screen/widgets/groups_list.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/strings.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const createdGroup = 'Create Group';
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          elevation: 0,
          forceElevated: false,
          scrolledUnderElevation: 0.0,
          backgroundColor: backgroundColor,
          centerTitle: false,
          title: const Text(
            appName,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text(
                    createdGroup,
                  ),
                  onTap: () {
                    // when we tap on the popup menu item it will call the navigator.pop method to pop the menu but we have opened a page so it wll close it so we wrap the navigator in the future to avoid this
                    Future(
                      () => Navigator.of(context)
                          .pushNamed(CreateGroupScreen.pageName),
                    );
                  },
                )
              ],
            )
          ],
        ),
        const GroupsList(),
        const ContactsList()
      ],
    );
  }
}
