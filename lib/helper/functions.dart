import 'package:shared_preferences/shared_preferences.dart';

class Helperfunctions {
  static String sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = "USEREMAIL";

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        Helperfunctions.sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> getUerLoggedInSharedPreference() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences
        .get(Helperfunctions.sharedPreferenceUserLoggedInKey);
  }
}
