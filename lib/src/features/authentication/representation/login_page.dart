import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pushReplacementNamed(context, '/device_selection');
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
