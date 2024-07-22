import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
        //We have to end the call on both devices so whoever ends the call we have to pop the screen on both devices so for that reason i am using a boolean shold pop which will pop the current screen which will be the call screen and navigate the user back to whatever screen he was on. So first of all we will start when we are the receiver
        /**
         * When a person calls us and we reject the call we will not change the value of should pop because we are already returning the scaffold
         * When a person calls us and the caller ends the calls we will not change the value of should pop because we are already returning the scaffold
         * When a person calls us and we accept the call we will set this value to true so that when ever the call ends we will pop the screen
         * When a person calls us and we accept the call the value will be set to true and the person ends the call we will pop the call screen 
         * Now if we call a person and we end the call we will set the value to true in the make call function so if either of the user ends the call we will pop the screen  
         */
        if (!(snapshot.data?.exists ?? false) &&
            ref.read(callNotifierProvider.notifier).shouldPop) {
          ref.read(callNotifierProvider.notifier).shouldPopScreen(false);
          SchedulerBinding.instance.addPostFrameCallback(
            (_) => Navigator.pop(context),
          );
        }
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call =
              CallModel.fromMap(snapshot.data!.data() as Map<String, dynamic>);
          // if we have dialed the call we will not do anything but if it is incoming we will perform some work
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
