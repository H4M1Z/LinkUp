// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:developer';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/config/agora_config.dart';
import 'package:gossip_go/features/call/controller/call_notifier.dart';
import 'package:gossip_go/models/call_model.dart';

class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({
    super.key,
    required this.channelName,
    required this.call,
    required this.isCalling,
    required this.isGroupChat,
  });

  static const pageName = '/call-screen';

  final String channelName;
  final CallModel call;
  final bool isGroupChat;
  final bool isCalling;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? client;
  String baseUrl = 'https://gossipgo-d42f62bf962a.herokuapp.com';

  @override
  void initState() {
    super.initState();
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelName,
        username: widget.isCalling
            ? widget.call.callerName
            : widget.call.receiverName,
        //the token url will generate the token for every new chaneel name , in the app there will be lots of channel name that we don't know about coz the user name will differ for every user
        tokenUrl: baseUrl,
      ),
    );
    initializeAgora();
  }

  @override
  void dispose() {
    log('call screen disposed');
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async => client!.engine.leaveChannel(),
    );
    super.dispose();
  }

  void initializeAgora() async {
    await client!.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: client!.isInitialized
          ? const CircularProgressIndicator()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(client: client!),
                  //to end the call we need to define our own implmentation
                  AgoraVideoButtons(
                    client: client!,
                    disconnectButtonChild: IconButton(
                        onPressed: () async {
                          ref.read(callNotifierProvider.notifier).endCall(
                              context: context,
                              callerId: widget.call.callerId,
                              callReceiverId: widget.call.receiverId,
                              isGroupCall: widget.isGroupChat);
                          ref
                              .read(callNotifierProvider.notifier)
                              .shouldPopScreen(true);
                        },
                        icon: const Icon(
                          Icons.call_end,
                          color: Colors.red,
                        )),
                  ),
                ],
              ),
            ),
    );
  }
}
