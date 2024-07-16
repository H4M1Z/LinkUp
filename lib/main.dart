import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:gossip_go/features/auth/controller/auth_controller.dart';
import 'package:gossip_go/features/auth/screens/error_screen/error_screen.dart';
import 'package:gossip_go/features/auth/screens/landing_screen/view/landing_screen.dart';
import 'package:gossip_go/firebase_options.dart';
import 'package:gossip_go/models/user_model.dart';
import 'package:gossip_go/navigation/pages_navigation.dart';
import 'package:gossip_go/screens/mobile_layout_screen/view/mobile_layout_screen.dart';
import 'package:gossip_go/screens/splash_screen.dart/view/splash_screen.dart';
import 'package:gossip_go/utils/colors.dart';
import 'package:workmanager/workmanager.dart';

const getAppUsers = 'Get App Users';

@pragma('vm:entry-point')
void callBackDispatcher() {
  Workmanager().executeTask(
    (taskName, inputData) async {
      try {
        const usersCollection = 'users';
        await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
        List<UserModel> appUsers = [];
        List<Contact> contacts = [];
        if (await FlutterContacts.requestPermission()) {
          contacts = await FlutterContacts.getContacts(withProperties: true);
        }
        log(contacts.length.toString());
        for (var i = 0; i < contacts.length; i++) {
          if (contacts[i].phones.isNotEmpty) {
            var firestoreUser = await FirebaseFirestore.instance
                .collection(usersCollection)
                .where(
                  'phoneNumber',
                  isEqualTo: getPhoneNumber(
                    number: contacts[i].phones[0].number,
                  ),
                )
                .get();
            if (firestoreUser.docs.isNotEmpty) {
              var user = UserModel.fromMap(firestoreUser.docs[0].data());
              if (user.uid != FirebaseAuth.instance.currentUser!.uid) {
                bool isAlreadyPresent = false;
                for (var element in appUsers) {
                  if (element.uid == user.uid) {
                    isAlreadyPresent = true;
                  }
                }
                if (!isAlreadyPresent) {
                  appUsers.add(user);
                }
              }
            }
          } else {
            log('contact empty');
          }
        }
        GetIt.I.registerSingleton<List<UserModel>>(appUsers);
        log('task completed app users : ${appUsers.length}');
      } catch (e) {
        throw Exception(e);
      }
      return true;
    },
  );
}

String getPhoneNumber({required String number}) {
  String phoneNumber = '';
  if (number.startsWith('0')) {
    phoneNumber = number.replaceFirst(RegExp('0'), '+92');
    phoneNumber = phoneNumber.replaceAll(' ', '');
    return phoneNumber;
  } else {
    phoneNumber = number.replaceAll(' ', '');
    return phoneNumber;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);

  Workmanager().registerOneOffTask(getAppUsers, getAppUsers);

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
    SchedulerBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Workmanager().initialize(
          callBackDispatcher,
          isInDebugMode: true,
        );
      },
    );
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
                GetIt.I.registerSingleton<UserModel>(user);
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
