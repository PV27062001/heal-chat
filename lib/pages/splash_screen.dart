// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:heal_chat/doctor/chat_room_page.dart';
import 'package:heal_chat/globals/global_variables.dart';
import 'package:heal_chat/pages/chat_room_page.dart';
import 'package:heal_chat/pages/user_login_page.dart';
// import 'package:chatapp/services/check_connection.dart';
import 'package:heal_chat/services/shared_preference_service.dart';
import 'package:heal_chat/userauthentication/user_auth.dart';
import 'package:flutter/material.dart';

import '../doctor/doc_login_page.dart';

class AppSplashScreen extends StatefulWidget {
  const AppSplashScreen({Key? key}) : super(key: key);

  @override
  _AppSplashScreenState createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends State<AppSplashScreen> {
  final Authentication _authentication = Authentication();
  late SharedPreferenceService _sharedPreferenceService;
  // late CheckConnectivity _checksConnectivity;
  bool isDataAvailable = false;
  Map internetConnection = {};
  @override
  void initState() {
    super.initState();
    _sharedPreferenceService = SharedPreferenceService();
    // _checkConnectivity = CheckConnectivity.instance;
    // _checkConnectivity.initialise();
    // _checkConnectivity.myStream.listen((source) {
    //   setState(() {
    //     internetConnection = source;
    //   });
    // });

    Timer(const Duration(seconds: 5), () {});
    isUserDataAvailable();
    isDocDataAvailable();
  }

  void isUserDataAvailable() async {
    isDataAvailable = await _sharedPreferenceService.getUserData();
    // print("For debugg...");
    if (isDataAvailable) {
      if (globalEMAIL != null || globalUSERPASSWORD != null) {
        _authentication.userLoginWithEmailAndPassword(
          globalEMAIL!,
          globalUSERPASSWORD!,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatRoom(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    }
  }

  void isDocDataAvailable() async {
    isDataAvailable = await _sharedPreferenceService.getUserData();
    // print("For debugg...");
    if (isDataAvailable) {
      if (globalDOCEMAIL != null || globalDOCPASSWORD != null) {
        _authentication.docLoginWithEmailAndPassword(
          globalDOCEMAIL!,
          globalDOCPASSWORD!,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const dChatRoom(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const dLoginPage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
