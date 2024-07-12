import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/call/screens/call_screen.dart';
import 'package:gossip_go/models/call_model.dart';

class CallReceivingScreen extends ConsumerWidget {
  const CallReceivingScreen({
    super.key,
    required this.callInfo,
  });
  final CallModel callInfo;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const incomingCall = 'Incoming call';
    final Size(:height) = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 2,
              child: CircleAvatar(
                radius: height * 0.08,
                backgroundImage: NetworkImage(
                  callInfo.callerPic,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  callInfo.callerName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: height * 0.04),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topCenter,
                child: Text(
                  incomingCall,
                  style:
                      TextStyle(color: Colors.grey, fontSize: height * 0.025),
                ),
              ),
            ),
            const Spacer(
              flex: 6,
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Center(
                        child: RejectReciveCallBtn(
                            onTap: () {},
                            btnIcon: Icons.call_end_rounded,
                            iconColor: Colors.red,
                            backgroundColor: Colors.black54),
                      )),
                  Expanded(
                    flex: 1,
                    child: Center(
                        child: RejectReciveCallBtn(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                CallScreen.pageName,
                                arguments: {
                                  'channelName': callInfo.callId,
                                  'call': callInfo,
                                  'isGroupChat': false,
                                },
                              );
                            },
                            btnIcon: Icons.call,
                            iconColor: Colors.white,
                            backgroundColor: Colors.green.shade300)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RejectReciveCallBtn extends StatelessWidget {
  const RejectReciveCallBtn(
      {super.key,
      required this.onTap,
      required this.btnIcon,
      required this.iconColor,
      required this.backgroundColor});
  final VoidCallback onTap;
  final IconData btnIcon;
  final Color backgroundColor, iconColor;
  @override
  Widget build(BuildContext context) {
    final Size(:width, :height) = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width * 0.2,
        height: height * 0.07,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          btnIcon,
          color: iconColor,
        ),
      ),
    );
  }
}
