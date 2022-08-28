import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/components/drawer.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/screens/landing_screen.dart';
import 'package:good_tymes/services/auth_services.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getText(context).settings),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).colorScheme.secondary
              ],
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: SettingsList(
        lightTheme: SettingsThemeData(
          settingsListBackground: Colors.white,
          settingsSectionBackground: Colors.white,
          settingsTileTextColor: Colors.black,
          titleTextColor: Colors.black,
          tileDescriptionTextColor: Theme.of(context).primaryColor,
          leadingIconsColor: Theme.of(context).primaryColor,
        ),
        sections: [
          // Support
          SettingsSection(
            title: Text(getText(context).support),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.support_agent),
                title: Text(getText(context).customerSupport),
              ),
            ],
          ),

          // About
          SettingsSection(
            title: Text(getText(context).about),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.handshake_outlined),
                title: Text(getText(context).userAgreement),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.privacy_tip),
                title: Text(getText(context).privacyTerms),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.app_settings_alt),
                title: Text(getText(context).version),
                value: const Text('1.0'),
              ),
            ],
          ),

          // Logout
          SettingsSection(
            title: Text(getText(context).logout),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: Text(getText(context).logout),
                onPressed: (context) async {
                  if (await confirm(
                    context,
                    title: Text(getText(context).logoutConfirmationTitle),
                    content: Text(getText(context).logoutConfirmationText),
                    textOK: Text(
                      getText(context).yes,
                      style: const TextStyle(color: Colors.red),
                    ),
                    textCancel: Text(
                      getText(context).no,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  )) {
                    await AuthServices().signOut(context);
                    if (!mounted) return;
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LandingScreen.routeName, (route) => false);
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
