import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:good_tymes/constants/language_constants.dart';
import 'package:good_tymes/layout/responsive.dart';
import 'package:good_tymes/provider/user_provider.dart';
import 'package:good_tymes/screens/add_activity_screen.dart';
import 'package:good_tymes/screens/decide_activity_screen.dart';
import 'package:good_tymes/screens/discover_activity_screen.dart';
import 'package:good_tymes/screens/home_screen.dart';
import 'package:good_tymes/screens/landing_screen.dart';
import 'package:good_tymes/screens/manage_activity_screen.dart';
import 'package:good_tymes/screens/profile_screen.dart';
import 'package:good_tymes/screens/settings_screen.dart';
import 'package:good_tymes/theme/theme_data.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {setLocale(locale)});
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MyUserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Good Tymes',
        theme: themeData,
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: _locale,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapshot) {
            if (userSnapshot.hasData) {
              return const ResponsiveLayout();
            } else if (userSnapshot.hasError) {
              return Center(
                child: Text('${userSnapshot.error}'),
              );
            }
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return const LandingScreen();
          },
        ),
        routes: {
          LandingScreen.routeName: (ctx) => const LandingScreen(),
          HomeScreen.routeName: (ctx) => const HomeScreen(),
          ProfileScreen.routeName: (ctx) => const ProfileScreen(),
          SettingsScreen.routeName: (ctx) => const SettingsScreen(),
          DecideActivityScreen.routeName: (ctx) => const DecideActivityScreen(),
          AddActivityScreen.routeName: (ctx) => const AddActivityScreen(),
          DiscoverActivityScreen.routeName: (ctx) =>
              const DiscoverActivityScreen(),
          ManageActivityScreen.routeName: (ctx) => const ManageActivityScreen(),
        },
      ),
    );
  }
}
