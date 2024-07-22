import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/group/controller/group_screen_notifier.dart';
import 'package:gossip_go/features/group/widgets/group_image_widget.dart';
import 'package:gossip_go/features/group/widgets/group_name_field.dart';
import 'package:gossip_go/features/group/widgets/select_group_contacts_widget.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/strings.dart';

class CreateGroupScreen extends ConsumerWidget {
  const CreateGroupScreen({super.key});
  static const pageName = '/create-group-screen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const selectContacts = 'Select Contacts';
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    void onAddImageTap() =>
        ref.read(groupScreenNotifierProvider.notifier).pickGroupImage(context);
    var appUsers =
        ModalRoute.of(context)?.settings.arguments as List<UserModel>;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          createGroupScreenAppBarTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const GroupImageAvatar(),
                  Positioned(
                    top: height * 0.13,
                    left: width * 0.23,
                    child: IconButton(
                        color: Colors.white,
                        onPressed: onAddImageTap,
                        icon: const Icon(Icons.add_a_photo)),
                  )
                ],
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: GroupScreenTextField()),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(left: width * 0.04, top: height * 0.03),
              child: FittedBox(
                child: Text(
                  selectContacts,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: height * 0.028),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: GroupContacts(appUsers: appUsers),
          ),
        ],
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () =>
            ref.read(groupScreenNotifierProvider.notifier).createGroup(context),
        style: ButtonStyle(
            backgroundColor: const WidgetStatePropertyAll(
              tabColor,
            ),
            shape: const WidgetStatePropertyAll(CircleBorder()),
            minimumSize:
                WidgetStatePropertyAll(Size(width * 0.1, height * 0.08))),
        child: const Icon(
          Icons.done,
          color: Colors.black,
        ),
      ),
    );
  }
}
