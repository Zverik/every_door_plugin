The [Every Door](https://every-door.app/) OpenStreetMap editor supports plugins.
Those can be written as static files, or with Dart and Flutter code. This package
simplifies creation of a plugin (either kind), and provides models and bindings
for the development.

## Creating a static plugin

With this package, it's easy: it provides a script that can be executed from anywhere.
Install it with:

   dart pub global activate every_door_plugin

The proper way would be to create a directory for a plugin, and inside it, a `plugin`
directory with all the files, including `plugin.yaml`. When you run `edp`
(or `dart pub global run every_door_plugin` if that doesn't work), it would create
a `dist` subdirectory, in which it would put a packaged plugin.

Obviously for a static plugin, you can just use whatever archiving option you've got:
[edp files are just zip archives](https://every-door.app/plugins/metadata/).

## Creating a plugin with code

First, create a Flutter package with its generator or with Android Studio — whatever
works for you. Name it as your plugin: the title should start with a latin letter and
contain, besides those, only numbers, dashes, and underscores.

Alternatively just create a directory. For code, put this into `pubspec.yaml`:

```yaml
name: plugin_id
description: "Plugin Name"
version: 0.1.0

environment:
  sdk: ^3.6.0
  flutter: "^3.35.0"

dependencies:
  flutter:
    sdk: flutter
  every_door_plugin: ^1.2.0
```

Add `every_door_plugin: 1.2.0` to the dependencies in `pubspec.yaml`. Also mind that those
keys will be copied to the plugin metadata:

* `name` → `id`
* `description` → `name` (don't write "every door plugin" or anything like there)
* `homepage` → `homepage`
* `version` → `version`

Note that while version there follows semantic versioning,
only the first two numbers will be used for the plugin version (e.g. for `0.3.1`
the version would be `0.3`, so there is no point in using patch versions).

You can also add an `every_door` section and straight write 
[`plugin.yaml`](https://every-door.app/plugins/metadata/) contents there.
The pubspec top values still have the priority.

Note that for publishing to EDPR, you would need the `description` key, so you
can't get around adding that section. See [the example](example/pubspec.yaml).

Create a `plugin` directory for any static files you will need packaged.
When you refer a file like `icons/bus.svg`, whether from the yaml file
or from the code, it will be expected in `plugin/icons/bus.svg`.

The code goes into the `lib` directory, with the `lib/main.dart` for the main code.
It can include other dart files from the same directory or sub-directories.

Besides `flutter` and `every_door_plugin` packages, you can also use anything
listed in [this description](https://pub.dev/packages/flutter_map_eval).

## Building a plugin

Having added this package as a dependency, type this in the console (e.g. in Android Studio
terminal):

    flutter pub get
    dart run every_door_plugin

It will compile the code and create an edp file in the `dist` subdirectory with the
plugin id and version for the file name: `plugin_id_1.0.edp`. Transfer it to your phone
to test it, and upload to [the repository](https://plugins.every-door.app/) when finished.

## Author and License

Written by Ilya Zverev, published under the ISC license.

The author is sponsored by many individual contributors through [GitHub](https://github.com/sponsors/Zverik)
and [Liberapay](https://liberapay.com/zverik). Thank you everybody!

The NLNet Foundation is [sponsoring](https://nlnet.nl/project/EveryDoor/) the development in 2025
through the [NGI Commons Fund](https://nlnet.nl/commonsfund) with funds from the European Commission.

Want to sponsor the development? [Contact Ilya](mailto:ilya@zverev.info) directly or through
[his company](https://avatudkaart.ee/).
