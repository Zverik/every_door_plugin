import 'package:every_door_plugin/screens/modes/definitions/base.dart';
import 'package:latlong2/latlong.dart' show LatLng;

/// Plugin events wrapper. Use this class to listen to events. Listeners
/// are automatically deactivated when the plugin is inactive. All callback
/// should be asynchronous functions, even when they don't use await.
class PluginEvents {
  /// Listen to editing mode instantiations. The [callback] is called on
  /// each mode when initializing the plugin, and then every time a new
  /// mode is added. The [callback] should be an async function.
  void onModeCreated(Function(BaseModeDefinition mode) callback) {}

  /// Invoked when the "upload" button is pressed.
  void onUpload(Function() callback) {}

  /// Invoked when the "download" button is pressed.
  void onDownload(Function(LatLng) callback) {}
}
