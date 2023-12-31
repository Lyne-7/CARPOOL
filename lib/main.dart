import 'package:carpool_users/infoHandler/app_info.dart';
import 'package:carpool_users/screens/admin_screen.dart';
import 'package:carpool_users/screens/login_screen.dart';
import 'package:carpool_users/screens/main_screen.dart';
import 'package:carpool_users/screens/register_screen.dart';
import 'package:carpool_users/screens/search_places_screen.dart';
import 'package:carpool_users/themeProvider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:carpool_users/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: MyThemes.lightTheme,
        darkTheme: MyThemes.darkTheme,
        debugShowCheckedModeBanner: false,
        home: RegisterScreen(),
      ),
    );
  }
}


