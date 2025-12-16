import 'package:every_door_plugin/helpers/auth/controller.dart';
import 'package:every_door_plugin/helpers/auth/provider.dart';
import 'package:every_door_plugin/models/imagery.dart';
import 'package:every_door_plugin/models/plugin.dart';
import 'package:every_door_plugin/plugins/events.dart';
import 'package:every_door_plugin/plugins/ext_overlay.dart';
import 'package:every_door_plugin/plugins/preferences.dart';
import 'package:every_door_plugin/plugins/providers.dart';
import 'package:every_door_plugin/screens/modes/definitions/base.dart';
import 'package:logging/logging.dart';

/// This class is used by plugins to interact with the app.
/// It might be rebuilt often, and contains references to Riverpod
/// ref and BuildContext (if applicable). And also a ton of convenience
/// methods.
abstract class EveryDoorApp {
  Plugin get plugin;
  Function()? get onRepaint;

  PluginPreferences get preferences;
  PluginProviders get providers;
  PluginEvents get events;
  Logger get logger;

  // Future<Database> get database => _ref.read(pluginDatabaseProvider).database;

  /// When available, initiates the screen repaint. Useful for updating the
  /// plugin settings screen.
  void repaint();

  /// Adds an overlay layer. You only need to specify the [Imagery.id]
  /// and [Imagery.buildLayer], but also set the [Imagery.overlay] to true.
  /// For plugins, it would make sense to either use the metadata static file,
  /// or to instantiate [ExtOverlay].
  ///
  /// Unlike the specific mode-bound overlays, those appear everywhere, even
  /// in map-opening fields. If you want to add an overlay just to the main
  /// map, see [PluginEvents.onModeCreated] and [BaseModeDefinition.addOverlay].
  void addOverlay(Imagery imagery) {
    if (!imagery.overlay) {
      throw ArgumentError("Imagery should be an overlay");
    }
  }

  /// Adds an editor mode. Cannot replace existing ones, use [removeMode]
  /// for that.
  void addMode(BaseModeDefinition mode) {
  }

  /// Removes the mode. Can remove both a pre-defined mode (like "notes"),
  /// and a plugin-added one.
  void removeMode(String name) {
  }

  /// Do something with every mode installed. Useful for dynamically adding
  /// and removing buttons and layers, for example.
  void eachMode(Function(BaseModeDefinition) callback) {
  }

  /// Adds an authentication provider. It is not currently possible
  /// to override an [AuthController]. It is also not possible to
  /// replace the generic providers such as "osm", or use providers
  /// defined in other plugins (because of the mandatory prefix).
  void addAuthProvider(String name, AuthProvider provider) {
    if (provider.title == null) {
      throw ArgumentError("Title is required for a provider");
    }
  }

  /// Returns a controller for an authentication provider. Use "osm"
  /// to get OSM request headers.
  AuthController auth(String name);
}
