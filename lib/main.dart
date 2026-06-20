import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:housemasterapp/Pages/screen_controller_page.dart';
import 'package:housemasterapp/Pages/update_available_page.dart';
import 'package:housemasterapp/Pages/welcome_page.dart';
import 'package:housemasterapp/theme_controller.dart';
import 'package:package_info_plus/package_info_plus.dart';

final box = GetStorage();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> saveFMToken() async {
  try {
    await FirebaseMessaging.instance.requestPermission();
    final token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      box.write("fcmtoken", token);
      debugPrint("FCM Token: $token");
    }
  } catch (e) {
    debugPrint("FCM token error: $e");
  }
}

Future<void> getAppLocalVersion() async {
  final packageInfo = await PackageInfo.fromPlatform();
  box.write('localversion', packageInfo.version);

  if (kDebugMode) {
    debugPrint("Local version: ${packageInfo.version}");
  }
}

Future<void> getAppOnlineVersion() async {
  final snap = await FirebaseFirestore.instance
      .collection("settings")
      .doc("userapp")
      .get();

  box.write('onlineversion', snap["onlineversion"]);

  if (kDebugMode) {
    debugPrint("Online version: ${snap["onlineversion"]}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GetStorage.init();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await getAppOnlineVersion();
  await getAppLocalVersion();
  await saveFMToken();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController themeController = Get.put(ThemeController());
  String apponlineversion = "";
  String applocalversion = "";

  @override
  void initState() {
    super.initState();
    loadVersions();
    checkUserStillExists();
  }

  void loadVersions() {
    final online = box.read('onlineversion') ?? "";
    final local = box.read('localversion') ?? "";

    setState(() {
      apponlineversion = online;
      applocalversion = local;
    });
  }

  /// 🔥 This signs out users whose Firestore document was deleted
  Future<void> checkUserStillExists() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        await FirebaseAuth.instance.signOut();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("User validation error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (_) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: "House Master",

          themeMode: themeController.themeMode,

          theme: ThemeData(
            highlightColor: Colors.transparent,
            hintColor: Colors.transparent,
            splashColor: Colors.transparent,
          ),

          darkTheme: ThemeData.dark(),

          home: applocalversion != apponlineversion
              ? UpdateAvailablePage()
              : StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Scaffold(
                        backgroundColor: Colors.grey[900],
                        body: Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const WelcomePage();
                    }

                    return const ScreenControllerPage();
                  },
                ),
        );
      },
    );
  }
}
