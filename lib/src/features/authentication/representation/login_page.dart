import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:indoor_plant_watering_app/src/features/manage_device/representation/device_selection_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  static const String routeName = '/login';
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      
      headerBuilder: (context, constraints, shrinkOffset) {
        return const Image(
          image: AssetImage('assets/TreeHanging.png'),
        );
      },
      footerBuilder: ((context, action) {
        return const Image(
          image: AssetImage('assets/TreeCover.png'),
        );
      }),
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pushReplacementNamed(
              context, DeviceSelectionPage.routeName);
          // if (!state.user!.emailVerified) {
          //   Navigator.pushNamed(context, '/verify-email');
          // } else {
          //   Navigator.pushReplacementNamed(context, '/profile');
          // }
        }),
      ],
    );
  }
}
