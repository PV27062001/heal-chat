import 'package:heal_chat/globals/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
// late UserLoginModel userLoggedIn;

class SharedPreferenceService {
  // SharedPreferences _sharedPreferences;
  final String _sharedPreferenceUserKey = "username";
  final String _sharedPreferencePwdKey = "password";
  final String _sharedPreferenceEmailKey = "email";
  final String _sharedPreferenceDocKey = "username";
  final String _sharedPreferenceDocPwdKey = "password";
  final String _sharedPreferenceDocEmailKey = "email"; 
  final String _sharedPreferenceDocExpKey = "experience";
  final String _sharedPreferenceDocIdKey = "id"; 

  _getInstance() async {
    return SharedPreferences.getInstance();
  }

  // UserLoginModel saveDataGlobally(Map<String, dynamic> map) {
  //   return UserLoginModel(
  //     username: map['username'],
  //     email: map['email'],
  //     password: map['password'],
  //   );
  // }

  Future<bool> saveUserData(Map<String, dynamic> map) async {
    //UserLoginModel user;
    SharedPreferences _prefs = await _getInstance();
    _prefs.setString(_sharedPreferenceUserKey, map['username']);
    _prefs.setString(_sharedPreferenceEmailKey, map['email']);
    _prefs.setString(_sharedPreferencePwdKey, map['password']);

    getUserData();
    // user = UserLoginModel.formMap(map);
    // userLoggedIn = user;
    // return user;
    return true;
  }

    Future<bool> saveDocData(Map<String, dynamic> map) async {
    //UserLoginModel user;
    SharedPreferences _prefs = await _getInstance();
    _prefs.setString(_sharedPreferenceDocKey, map['username']);
    _prefs.setString(_sharedPreferenceDocEmailKey, map['email']);
    _prefs.setString(_sharedPreferenceDocPwdKey, map['password']);
    _prefs.setString(_sharedPreferenceDocExpKey, map['experience']);
    _prefs.setString(_sharedPreferenceDocIdKey, map['id']);

    getUserData();
    // user = UserLoginModel.formMap(map);
    // userLoggedIn = user;
    // return user;
    return true;
  }

  Future<bool> getUserData() async {
    // UserLoginModel user;
    SharedPreferences _prefs = await _getInstance();
    globalUSERNAME = _prefs.getString(_sharedPreferenceUserKey);
    globalEMAIL = _prefs.getString(_sharedPreferenceEmailKey);
    globalUSERPASSWORD = _prefs.getString(_sharedPreferencePwdKey);

    // Constants.usermap = map;
    // user = UserLoginModel.formMap(map); //saveDataGlobally(map);
    // userLoggedIn = user;
    return true;
  }

    Future<bool> getDocData() async {
    // UserLoginModel user;
    SharedPreferences _prefs = await _getInstance();
    globalDOCNAME = _prefs.getString(_sharedPreferenceDocKey);
    globalDOCEMAIL = _prefs.getString(_sharedPreferenceDocEmailKey);
    globalDOCPASSWORD = _prefs.getString(_sharedPreferenceDocPwdKey);
    globalDOCID = _prefs.getString(_sharedPreferenceDocIdKey);
    globalDOCEXPERIENCE = _prefs.getString(_sharedPreferenceDocExpKey);

    // Constants.usermap = map;
    // user = UserLoginModel.formMap(map); //saveDataGlobally(map);
    // userLoggedIn = user;
    return true;
  }


  Future<bool> removeUserData() async {
    SharedPreferences _prefs = await _getInstance();
    // Constants.usermap.clear();
    _prefs.remove(_sharedPreferenceUserKey);
    _prefs.remove(_sharedPreferenceEmailKey);
    _prefs.remove(_sharedPreferencePwdKey);
    return true;
  }

    Future<bool> removeDocData() async {
    SharedPreferences _prefs = await _getInstance();
    // Constants.usermap.clear();
    _prefs.remove(_sharedPreferenceDocKey);
    _prefs.remove(_sharedPreferenceDocEmailKey);
    _prefs.remove(_sharedPreferenceDocPwdKey);
    _prefs.remove(_sharedPreferenceDocIdKey);
    _prefs.remove(_sharedPreferenceDocExpKey);
    return true;
  }
}
