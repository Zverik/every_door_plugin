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
  every_door_plugin: ^0.1.0
```

Add `every_door_plugin: 0.1.0` to the dependencies in `pubspec.yaml`. Also mind that those
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

## Hints for writing a plugin in Dart

Alas there is no simple way to upload your built `.edp` file to the device and
immediately open in in Every Door. Android permission system (not to speak of iOS)
forbids all the options. There are two ways for testing:

* Share the file via a messenger or a sync service like KDE Connect, and having received
  the file on the device, open it with Every Door. Always check the system log.
* Set up the [development environment](https://every-door.app/develop/build/)
  and write your plugin in the `lib/plugins/_construction.dart`. That way you would
  only need to disable-enable plugin after a hot reload. When finished, transfer
  the code to a separate repository and split it into files if needed.

The `dart_eval` compiler supports just a subset of Dart language, and often an unexpected
subset. You might need to make multiple iterations to just ensure the code compiles and
executes correctly in Every Door. Sorry about that, we are working on improving the compiler.
But compilers are hard.

Here are some hints for tracking and fixing compilation issues:

* The implied `dynamic` type is hard to work with, so please state parameter, field, and
  variable types in the code. Even for simple definitions like `final FocusNode node = FocusNode()`.
  Most execution errors come from trying to box/unbox dynamic variables.
* Generics are not always parsed properly. Which means, accessing `widget.` fields from a widget
  state may randomly fail. You might need to explicitly define the types.
* All event listeners and most other things are `async` and should return a `Future`. There is
  no `FutureOr` class in `dart_eval`.
* Loop and condition variables in list comprehension might confuse their scope. Try extracting
  loop body to a function, and localize class fields. Scopes are hard.
* Overriding of operators and sometimes `toString` doesn't yet work in `dart_eval`.

There might be other causes for errors, including incorrect wrappers built-in into the editor.
When you're stuck, contact Ilya or create an issue somewhere related, copying the relevant
code and the full exception message, including the runtime code.

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
