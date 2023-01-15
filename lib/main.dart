import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:indoor_plant_watering_app/src/features/device_monitoring/representation/device_monitoring_page.dart';
import 'src/constants/firebase_options.dart';

import 'package:indoor_plant_watering_app/src/theme/theme_constant.dart';
import 'package:indoor_plant_watering_app/src/features/manage_device/representation/device_selection_page.dart';
import 'package:indoor_plant_watering_app/src/features/authentication/representation/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
     //GoogleProvider(clientId: "146521422465-e67nhfmdd198em738a7ugvbu7lf9mav5.apps.googleusercontent.com"),
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
      initialRoute: FirebaseAuth.instance.currentUser == null ? LoginPage.routeName : DeviceSelectionPage.routeName,
      routes: {
        LoginPage.routeName: (context) => const LoginPage(),
        DeviceSelectionPage.routeName: (context) => const DeviceSelectionPage(),
        DeviceMonitoringPage.routeName: (context) =>
            const DeviceMonitoringPage(),
      },
    );
  }
}
