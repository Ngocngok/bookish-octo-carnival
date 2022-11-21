import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'src/constants/firebase_options.dart';

import 'package:indoor_plant_watering_app/src/theme/theme_constant.dart';
import 'package:indoor_plant_watering_app/src/features/manage_device/representation/device_selection_page.dart';
import 'package:indoor_plant_watering_app/src/features/authentication/representation/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    // ... other providers
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/device_selection': (context) => const DeviceSelectionPage(),
      },
    );
  }
}
