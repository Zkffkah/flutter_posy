import 'package:decimal/decimal.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  static const String PREF_KEY_POSITION_SIZE = "PREF_KEY_POSITION_SIZE";

  static final PrefHelper _singleton = PrefHelper._internal();

  static SharedPreferences prefs;

  factory PrefHelper() {
    return _singleton;
  }

  PrefHelper._internal();

  double getPositionSize() {
    return (Decimal.parse(prefs.getString(PREF_KEY_POSITION_SIZE)?? "1").toDouble());
  }

  Future<bool> setPositionSize(String value) async {
    return await prefs.setString(PREF_KEY_POSITION_SIZE, value);
  }
}
