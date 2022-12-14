import 'package:heal_chat/pages/splash_screen.dart';
import 'package:heal_chat/sizeConfig/size_config.dart';
import 'package:heal_chat/themedata/app_theme_styling.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'chatapp',
              theme: AppTheme.lightTheme,
              home: const AppSplashScreen(),
            );
          },
        );
      },
    );
  }
}
