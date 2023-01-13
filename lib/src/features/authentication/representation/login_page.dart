import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
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
      oauthButtonVariant: OAuthButtonVariant.icon,
      headerBuilder: (context, constraints, shrinkOffset) {
        return const Image(
          image: AssetImage('assets/TreeHanging.png'),
        );
      },
      footerBuilder: ((context, action) {
        return Column(
          children: [
            SizedBox(height: 5,),
            Text(
              "- OR -",
              style: TextStyle(
                color: Colors.black26,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5,),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AuthStateListener<OAuthController>(
                  child: OAuthProviderButton(
                    variant: OAuthButtonVariant.icon,
                    provider: GoogleProvider(
                        clientId:
                            "146521422465-e67nhfmdd198em738a7ugvbu7lf9mav5.apps.googleusercontent.com"),
                  ),
                  listener: (oldState, newState, ctrl) {
                    if (newState is SignedIn) {
                      Navigator.pushReplacementNamed(
                          context, DeviceSelectionPage.routeName);
                    }
                    return null;
                  },
                ),
              ],
            ),
            const Image(
              image: AssetImage('assets/TreeCover.png'),
            ),
          ],
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
