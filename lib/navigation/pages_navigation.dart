import 'package:flutter/material.dart';
import 'package:gossip_go/features/auth/screens/error_screen/error_screen.dart';
import 'package:gossip_go/features/auth/screens/landing_screen/view/landing_screen.dart';
import 'package:gossip_go/features/auth/screens/loading_screen/loading_screen.dart';
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
import 'package:gossip_go/screens/mobile_layout_screen/view/mobile_layout_screen.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) =>
    switch (settings.name) {
      LoadingScreen.pageName => MaterialPageRoute(
          builder: (context) => const LoadingScreen(),
        ),
      LandingScreen.pageName => MaterialPageRoute(
          builder: (context) => const LandingScreen(),
        ),
      LoginScreen.pageName => MaterialPageRoute(
          builder: (context) => const LoginScreen(),
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
          builder: (context) => const MobileLayoutScreen(),
          settings: settings,
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
        ),
      CallScreen.pageName => MaterialPageRoute(
          builder: (context) {
            var callInfo = settings.arguments as Map<String, dynamic>;
            return CallScreen(
              channelName: callInfo['channelName'],
              call: callInfo['call'],
              isGroupChat: callInfo['isGroupChat'],
            );
          },
        ),
      _ => MaterialPageRoute(
          builder: (context) => const ErrorScreen(),
        )
    };
