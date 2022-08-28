import 'package:flutter/material.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/screens/home_screen.dart';
import 'package:good_tymes/screens/profile_screen.dart';
import 'package:good_tymes/screens/settings_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            bottomOpacity: 0,
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            toolbarHeight: 100,
            title: const Text(
              "Good Tymes",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'Montserrat',
              ),
            ),
            centerTitle: true,
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(getText(context).home),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(getText(context).account),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text(getText(context).settings),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(SettingsScreen.routeName);
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
