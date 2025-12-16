/// Shadows the shared_preferences module from plugins. Nothing wrong with
/// using it directly, but this allows us to track preferences by plugin.
/// Basically adds a prefix to every key, and accesses the app-wide
/// [SharedPreferencesWithCache] instance.
class PluginPreferences {
  Future<void> setString(String name, String value) async {
  }

  Future<void> setInt(String name, int value) async {}

  Future<void> setBool(String name, bool value) async {}

  Future<void> setDouble(String name, double value) async {}

  Future<void> setStringList(String name, List<String> value) async {}

  String? getString(String name) => null;

  int? getInt(String name) => null;

  bool? getBool(String name) => null;

  double? getDouble(String name) => null;

  List<String>? getStringList(String name) => null;
}
