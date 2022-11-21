import 'dart:ui';

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: const <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Color.fromARGB(255, 255, 191, 0),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
            child: Text('data'),
          ),
          ListTile(
            title: Text('home'),
          ),
          ListTile(
            title: Text('home'),
          ),
          ListTile(
            title: Text('home'),
          ),
          ListTile(
            title: Text('home'),
          ),
          ListTile(
            title: Text('home'),
          ),
        ],
      ),
    );
  }
}
