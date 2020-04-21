import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static SharedPreferencesManager _instance;
  static SharedPreferences _sharedPreferences;

  static const String keyAccessToken = 'access_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyIsLogin = 'is_login';
  static const String keyUsername = 'username';

  static Future<SharedPreferencesManager> getInstance() async {
    print('inside get instance');
    if (_instance == null) {
      print('inside _instance == null');
      _instance = SharedPreferencesManager();
    }
    if (_sharedPreferences == null) {
      print('inside _sharedPreferences == null');
      _sharedPreferences = await SharedPreferences.getInstance();
    }
    return _instance;
  }

  Future<bool> putBool(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  bool getBool(String key) => _sharedPreferences.getBool(key);

  Future<bool> putDouble(String key, double value) =>
      _sharedPreferences.setDouble(key, value);

  double getDouble(String key) => _sharedPreferences.getDouble(key);

  Future<bool> putInt(String key, int value) =>
      _sharedPreferences.setInt(key, value);

  int getInt(String key) => _sharedPreferences.getInt(key);

  Future<bool> putString(String key, String value) =>
      _sharedPreferences.setString(key, value);

  String getString(String key) => _sharedPreferences.getString(key);

  Future<bool> putAccessToken(String accessTokenvalue) =>
      _sharedPreferences.setString(keyAccessToken, accessTokenvalue);

  Future<bool> putRefreshToken(String refreshTokenvalue) =>
      _sharedPreferences.setString(keyRefreshToken, refreshTokenvalue);

  Future<bool> putStringList(String key, List<String> value) =>
      _sharedPreferences.setStringList(key, value);

  List<String> getStringList(String key) =>
      _sharedPreferences.getStringList(key);

  bool isKeyExists(String key) => _sharedPreferences.containsKey(key);

  Future<bool> clearKey(String key) => _sharedPreferences.remove(key);

  Future<bool> clearAll() => _sharedPreferences.clear();

  static Future<SharedPreferencesManager> getSharedPreferenceManagerInstanceFromGetIt(GetIt getIt) async{
    return getIt<SharedPreferencesManager>();
  }
}
