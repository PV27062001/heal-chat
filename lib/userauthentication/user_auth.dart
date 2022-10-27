import 'package:heal_chat/services/database_method.dart';
import 'package:heal_chat/services/shared_preference_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../globals/global_variables.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<bool> docLoginWithEmailAndPassword(
      String docLoginEmail, String docLoginPassword) async {
    SharedPreferenceService _sharedPreferenceService =
        SharedPreferenceService();
    bool isUserLoggedIn = true;
    try {
      UserCredential doctorCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: docLoginEmail, password: docLoginPassword);
      User? doctor = doctorCredential.user;
      if (doctor != null) {
        Map<String, dynamic> usermap = {
          "username": doctor.displayName as String,
          "email": docLoginEmail,
          "password": docLoginPassword,
        };
        // Constants.usermap = usermap;
        // print("For Debugg..");
        isUserLoggedIn = await _sharedPreferenceService.saveUserData(usermap);
        // globalUSERNAME = user.displayName ?? "";
        // globalEMAIL = userLoginEmail;
        // globalUSERPASSWORD = userLoginPassword;
        // isUserLoggedIn = true;
        // ignore: avoid_print
        print("User login successfully...");
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return isUserLoggedIn;
  }


 Future<bool> userLoginWithEmailAndPassword(
      String userLoginEmail, String userLoginPassword) async {
    SharedPreferenceService _sharedPreferenceService =
        SharedPreferenceService();
    bool isUserLoggedIn = true;
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
              email: userLoginEmail, password: userLoginPassword);
      User? user = userCredential.user;
      if (user != null) {
        Map<String, dynamic> usermap = {
          "username": user.displayName as String,
          "email": userLoginEmail,
          "password": userLoginPassword,
        };
        // Constants.usermap = usermap;
        // print("For Debugg..");
        isUserLoggedIn = await _sharedPreferenceService.saveUserData(usermap);
        // globalUSERNAME = user.displayName ?? "";
        // globalEMAIL = userLoginEmail;
        // globalUSERPASSWORD = userLoginPassword;
        // isUserLoggedIn = true;
        // ignore: avoid_print
        print("User login successfully...");
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return isUserLoggedIn;
  }

  Future<bool> userSignUpWithEmailAndPassword(
      Map<String, dynamic> userSignUpInfo) async {
    bool isUserLoggedIn = false;
    try {
      SharedPreferenceService _sharedPreferenceService =
          SharedPreferenceService();
      DataBaseMethod dataBaseMethod = DataBaseMethod();
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: userSignUpInfo['email'],
              password: userSignUpInfo['password']);
      User? user = userCredential.user;
      if (user != null) {
        userSignUpInfo.addAll({
          "status": "unavailable",
        });
        user.updateDisplayName(userSignUpInfo['name']);
        await dataBaseMethod.storeUserDataOnSignUp(userSignUpInfo, user.uid);

        isUserLoggedIn = await _sharedPreferenceService.saveUserData(
          {
            "username": userSignUpInfo['name'],
            "email": userSignUpInfo['email'],
            "password": userSignUpInfo['password'],
          },
        );
        globalUSERNAME = userSignUpInfo['name'];
        globalEMAIL = userSignUpInfo['email'];
        globalUSERPASSWORD = userSignUpInfo['password'];
        print("User created successfully...");
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return isUserLoggedIn;
  }

  
  Future<bool> DocSignUpWithEmailAndPassword(
      Map<String, dynamic> DocSignUpInfo) async {
    bool isUserLoggedIn = false;
    try {
      SharedPreferenceService _sharedPreferenceService =
          SharedPreferenceService();
      DataBaseMethod dataBaseMethod = DataBaseMethod();
      UserCredential doctorCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: DocSignUpInfo['email'],
              password: DocSignUpInfo['password']);
      User? doctor = doctorCredential.user;
      if (doctor != null) {
        DocSignUpInfo.addAll({
          "status": "unavailable",
        });
        doctor.updateDisplayName(DocSignUpInfo['name']);
        await dataBaseMethod.storeUserDataOnSignUp(DocSignUpInfo, doctor.uid);

        isUserLoggedIn = await _sharedPreferenceService.saveUserData(
          {
            "username": DocSignUpInfo['name'],
            "email": DocSignUpInfo['email'],
            "password": DocSignUpInfo['password'],
          },
        );
        globalDOCNAME = DocSignUpInfo['name'];
        globalDOCEMAIL = DocSignUpInfo['email'];
        globalDOCPASSWORD = DocSignUpInfo['password'];
        print("User created successfully...");
      }
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return isUserLoggedIn;
  }

  Future<bool> userLogOut() async {
    bool isUserLogOut = false;
    try {
      SharedPreferenceService preferenceService = SharedPreferenceService();
      preferenceService.removeUserData();
      _firebaseAuth.signOut();
      isUserLogOut = true;
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
    return isUserLogOut;
  }

}
