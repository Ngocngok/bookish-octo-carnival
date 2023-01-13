import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:indoor_plant_watering_app/src/features/authentication/representation/login_page.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 217, 247, 244),
              image: DecorationImage(
                  image: AssetImage('assets/TreeLeft.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomRight),
            ),
            accountName: Text(
              (user != null &&
                      user.displayName != null &&
                      user.displayName!.isNotEmpty)
                  ? user.displayName!
                  : "User",
              style: const TextStyle(
                color: Colors.teal,
              ),
            ),
            accountEmail: Text(
              user!.email!,
              style: const TextStyle(
                color: Colors.teal,
              ),
            ),
            currentAccountPictureSize: const Size.square(72),
            
            currentAccountPicture: UserAvatar(
              size: 72,
              auth: FirebaseAuth.instance,
              placeholderColor: Colors.teal,
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.notifications,
              color: Colors.teal,
            ),
            title: Text(
              "Notifications",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(
              Icons.share,
              color: Colors.teal,
            ),
            title: Text(
              "Share",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          const ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Colors.teal,
            ),
            title: Text(
              "About",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
            leading: const Icon(
              Icons.logout,
              color: Colors.teal,
            ),
            title: const Text(
              "Log out",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
