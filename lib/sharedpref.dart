import 'package:shared_preferences/shared_preferences.dart';

class ShrdPrefs {
  static String userLoggedInKey = "USERLOGGEDINKEY";
  saveUserLoggedInDetails({bool isLoggedin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(userLoggedInKey, isLoggedin);
  }

  getUserLoggedInDetails({bool isLoggedin}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getBool(userLoggedInKey);
  }
}
