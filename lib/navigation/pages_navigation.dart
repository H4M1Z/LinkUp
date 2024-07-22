import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:gossip_go/features/auth/screens/error_screen/error_screen.dart';
import 'package:gossip_go/features/auth/screens/landing_screen/view/landing_screen.dart';
import 'package:gossip_go/features/auth/screens/login_screen/view/login_screen.dart';
import 'package:gossip_go/features/auth/screens/otp_screen/view/otp_screen.dart';
import 'package:gossip_go/features/auth/screens/user_information_screen/view/user_information_screen.dart';
import 'package:gossip_go/features/call/screens/call_screen.dart';
import 'package:gossip_go/features/chat/view/mobile_chat_screen.dart';
import 'package:gossip_go/features/group/screens/create_group_Screen.dart';
import 'package:gossip_go/features/select_contacts/view/select_contacts_screen.dart';
import 'package:gossip_go/features/status/view/confirm_status_screen.dart';
import 'package:gossip_go/features/status/view/show_status_screen.dart';
import 'package:gossip_go/features/status/view/status_contacts_screen.dart';
import 'package:gossip_go/models/status_model.dart';
import 'package:gossip_go/screens/camera_screen.dart/view/confirm_picture_screen.dart';
import 'package:gossip_go/screens/camera_screen.dart/view/send_picture_screen.dart';
import 'package:gossip_go/screens/camera_screen.dart/view/take_picture_screen.dart';
import 'package:gossip_go/screens/mobile_layout_screen/view/mobile_layout_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) =>
    switch (settings.name) {
      LandingScreen.pageName => MaterialPageRoute(
          builder: (context) => LandingScreen(
            camera: settings.arguments as CameraDescription,
          ),
        ),
      LoginScreen.pageName => MaterialPageRoute(
          builder: (context) => const LoginScreen(),
          settings: settings,
        ),
      OTPScreen.pageName => MaterialPageRoute(
          builder: (context) => const OTPScreen(),
          settings: settings,
        ),
      UserInformationScreen.pageName => MaterialPageRoute(
          builder: (context) => const UserInformationScreen(),
          settings: settings,
        ),
      MobileLayoutScreen.pageName => MaterialPageRoute(
          builder: (context) => MobileLayoutScreen(
            camera: settings.arguments as CameraDescription,
          ),
        ),
      SelectContactsScreen.pageName => MaterialPageRoute(
          builder: (context) => const SelectContactsScreen(),
          settings: settings,
        ),
      MobileChatScreen.pageName => MaterialPageRoute(
          builder: (context) => const MobileChatScreen(),
          settings: settings,
        ),
      StatusScreen.pageName => MaterialPageRoute(
          builder: (context) => const StatusScreen(),
          settings: settings,
        ),
      ConfirmStatusScreen.pageName => MaterialPageRoute(
          builder: (context) => const ConfirmStatusScreen(),
          settings: settings,
        ),
      ShowStatusScreen.pageName => MaterialPageRoute(
          builder: (context) => ShowStatusScreen(
            status: settings.arguments as StatusModel,
          ),
        ),
      CreateGroupScreen.pageName => MaterialPageRoute(
          builder: (context) => const CreateGroupScreen(),
          settings: settings,
        ),
      CallScreen.pageName => MaterialPageRoute(
          builder: (context) {
            var callInfo = settings.arguments as Map<String, dynamic>;
            return CallScreen(
              isCalling: callInfo['isCalling'],
              channelName: callInfo['channelName'],
              call: callInfo['call'],
              isGroupChat: callInfo['isGroupChat'],
            );
          },
        ),
      TakePictureScreen.pageName => MaterialPageRoute(
          builder: (context) => TakePictureScreen(
            camera: settings.arguments as CameraDescription,
          ),
        ),
      ConfirmPicutureScreen.pageName => MaterialPageRoute(
          builder: (context) => const ConfirmPicutureScreen(),
          settings: settings),
      SendPictureScreen.pageName => MaterialPageRoute(
          builder: (context) => const SendPictureScreen(),
          settings: settings,
        ),
      _ => MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        )
    };
