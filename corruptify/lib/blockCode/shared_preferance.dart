import 'package:shared_preferences/shared_preferences.dart';

class SessionData {
  static bool isDark = false;
  static bool? isAdmin;
  static double? pending;
  static double? resolved;
  static double? resived;

  static Future<void> storeSessionData({
    bool? darkMode,
    bool? isAdmin,
    double? pending,
    double? resolved,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //set Data

    if (darkMode != null) {
      await sharedPreferences.setBool("darkMode", darkMode);
    }

    if (isAdmin != null) {
      await sharedPreferences.setBool("isAdmin", isAdmin);
    }

    if (pending != null) {
      await sharedPreferences.setDouble("pending", pending);
    }

    if (resolved != null) {
      await sharedPreferences.setDouble("resolved", resolved);
    }
  }

  static Future<void> getSessionData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    isDark = sharedPreferences.getBool("darkMode") ?? false;
    isAdmin = sharedPreferences.getBool("isAdmin") ?? false;
    pending = sharedPreferences.getDouble("pending") ?? 0;
    resolved = sharedPreferences.getDouble("resolved") ?? 0;
  }
}
