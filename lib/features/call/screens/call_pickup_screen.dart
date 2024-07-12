import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/call/controller/call_notifier.dart';
import 'package:gossip_go/features/call/widgets/call_receiving_screen.dart';
import 'package:gossip_go/models/call_model.dart';

//this screen will consist of the stream taht will continously listen to the call subcollection and whenever there is a call with our uid in it this screen will pop up
class CallPickUpScreen extends ConsumerWidget {
  //if stream builder does not have our uid in it we will show Scaffold
  final Widget scaffold;
  const CallPickUpScreen({super.key, required this.scaffold});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: ref.read(callNotifierProvider.notifier).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          // if we have dilaed the call we will not do anything but if it is incoming we will perform some work
          if (!call.hasDialed) {
            return CallReceivingScreen(
              callInfo: call,
            );
          }
        }
        return scaffold;
      },
    );
  }
}
