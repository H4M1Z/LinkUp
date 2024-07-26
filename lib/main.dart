import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/auth/screens/error_screen/error_screen.dart';
import 'package:gossip_go/features/auth/screens/landing_screen/view/landing_screen.dart';
import 'package:gossip_go/firebase_options.dart';
import 'package:gossip_go/navigation/pages_navigation.dart';
import 'package:gossip_go/screens/mobile_layout_screen/view/mobile_layout_screen.dart';
import 'package:gossip_go/screens/splash_screen.dart/view/splash_screen.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:gossip_go/utils/common_functions.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await Workmanager().initialize(
    callBackDispatcher,
    isInDebugMode: true,
  );

  await Workmanager().registerOneOffTask(getAppUsers, getAppUsers);

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    ProviderScope(
      child: MyApp(
        camera: firstCamera,
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    super.key,
    required this.camera,
  });
  final CameraDescription camera;

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
                return LandingScreen(
                  camera: camera,
                );
              } else {
                return MobileLayoutScreen(
                  camera: camera,
                );
              }
            },
            error: (error, stackTrace) => const ErrorScreen(),
            loading: () => const SplashScreen(),
          ),
      onGenerateRoute: onGenerateRoute,
    );
  }
}
