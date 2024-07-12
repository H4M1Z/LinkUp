import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/auth/screens/error_screen/error_screen.dart';
import 'package:gossip_go/features/auth/screens/landing_screen/view/landing_screen.dart';
import 'package:gossip_go/features/auth/screens/loading_screen/loading_screen.dart';
import 'package:gossip_go/firebase_options.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/navigation/pages_navigation.dart';
import 'package:gossip_go/screens/mobile_layout_screen/view/mobile_layout_screen.dart';
import 'package:gossip_go/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: ref.watch(userProvider).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              } else {
                GetIt.I.registerSingleton<UserModel>(user);
                return const MobileLayoutScreen();
              }
            },
            error: (error, stackTrace) => const ErrorScreen(),
            loading: () => const LoadingScreen(),
          ),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
