import 'dart:ui';

import 'package:every_door_plugin/models/osm_element.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class OsmChange extends ChangeNotifier implements Comparable {
  static const kCheckedKey = 'check_date';

  final OsmElement? element;

  Map<String, String?> newTags;
  LatLng? newLocation;
  List<int>? newNodes; // WARNING: Not stored to the database!
  bool _deleted;
  String? error;
  final String databaseId;
  String? _mainKey;
  DateTime updated;
  int? newId; // Not stored: used only during uploading.

  OsmChange(
    OsmElement element, {
    Map<String, String?>? newTags,
    this.newLocation,
    bool hardDeleted = false,
    this.error,
    DateTime? updated,
    this.newNodes,
    String? databaseId,
  }) : newTags = newTags ?? {},
       _deleted = hardDeleted,
       updated = updated ?? DateTime.now(),
       // ignore: prefer_initializing_formals
       element = element, // Force non-null initialization
       databaseId = databaseId ?? element.id.toString();

  OsmChange.create({
    required Map<String, String> tags,
    required LatLng location,
    DateTime? updated,
    String? databaseId,
    this.error,
    this.newId,
  }) : newTags = Map<String, String?>.of(tags),
       newLocation = location,
       element = null,
       _deleted = false,
       updated = updated ?? DateTime.now(),
       databaseId = databaseId ?? '';

  OsmChange copy() {
    if (element == null) {
      return OsmChange.create(
        tags: Map.of(newTags.cast<String, String>()),
        location: newLocation!,
        error: error,
        updated: updated,
        databaseId: databaseId,
        newId: newId,
      );
    }

    return OsmChange(
      element!,
      newTags: Map.of(newTags),
      newLocation: newLocation,
      hardDeleted: _deleted,
      error: error,
      updated: updated,
      newNodes: newNodes,
      databaseId: databaseId,
    );
  }

  // Location and modification
  LatLng get location => newLocation ?? element!.center!;
  set location(LatLng loc) {
    newLocation = loc;
    notifyListeners();
  }

  OsmId get id {
    if (element == null) throw StateError('Trying to get id for a new amenity');
    return element!.id;
  }

  bool get deleted => _deleted;
  bool get hardDeleted => _deleted;
  bool get isModified =>
      newTags.isNotEmpty ||
      newLocation != null ||
      newNodes != null ||
      hardDeleted;
  bool get isConfirmed =>
      !deleted && (newTags.length == 1 && newTags.keys.first == kCheckedKey);
  bool get isNew => element == null;
  bool get isArea => element?.isArea ?? false;
  bool get isPoint => element?.isPoint ?? true;
  bool get canDelete =>
      (element?.isPoint ?? true) &&
      (element == null || element?.isMember == IsMember.no);
  bool get canMove =>
      (element?.isPoint ?? true) && (element?.isMember != IsMember.way);
  String? get mainKey => _mainKey;

  void revert() {
  }

  // Tags management
  String? operator [](String k) =>
      newTags.containsKey(k) ? newTags[k] : element?.tags[k];

  void operator []=(String k, String? v) {
  }

  void removeTag(String key) {
  }

  void undoTagChange(String key) {
  }

  bool hasTag(String key) => this[key] != null;
  bool changedTag(String key) => newTags.containsKey(key);

  int calculateAge(String? value) => DateTime.now()
      .difference(
        DateTime.tryParse(value ?? '2020-01-01') ?? DateTime(2020, 1, 1),
      )
      .inDays;

  // Check date management.
  int get age => calculateAge(this[kCheckedKey]);
  int get baseAge => calculateAge(element?.tags[kCheckedKey]);
  bool get isOld => isCountedOld(age);
  bool get wasOld =>
      !isNew && isCountedOld(calculateAge(element?.tags[kCheckedKey]));
  bool get isCheckedToday => age <= 1;

  bool isCountedOld(int age) => false;

  void check() {}

  void uncheck() {}

  void toggleCheck() {}

  set deleted(bool value) {}

  factory OsmChange.fromJson(Map<String, dynamic> data) {
    return OsmChange.create(tags: {}, location: LatLng(0, 0));
  }

  Map<String, dynamic> toJson() => {};

  /// Constructs a new element from this change after the object has been uploaded.
  /// Or for uploading.
  OsmElement toElement({int? newId, int? newVersion}) {
    throw UnimplementedError();
  }

  /// Updates the underlying [OsmElement].
  OsmChange mergeNewElement(OsmElement newElement) {
    throw UnimplementedError();
  }

  // Helper methods

  bool get isDisused => false;

  void togglePrefix(String prefix) {}

  void toggleDisused() {}

  String? get name => getAnyName() ?? this['operator'] ?? this['brand'];

  String? getAnyName() {
    return null;
  }

  String? getLocalName(Locale locale) => this['name'];

  String? getContact(String key) => this[key];

  void setContact(String key, String value) {}

  void removeOpeningHoursSigned() {}

  bool get hasPayment => false;

  bool get acceptsCards => false;

  bool get cashOnly => false;

  bool get hasWebsite => false;

  String? get descriptiveTag => mainKey;

  String get typeAndName => 'type';

  String? get address => null;

  bool isFixmeNote() => false;

  // Helper methods

  /// Returns a map with complete object tags. All changes are applied,
  /// deleted tags are removed. Set `clearDisused` to `true` to remove
  /// the `disused:` prefix from the main tag.
  Map<String, String> getFullTags([bool clearDisused = false]) => {};

  @override
  bool operator ==(other) {
    if (other is! OsmChange) return false;
    if (element != other.element) return false;
    if (databaseId != other.databaseId) return false;
    if (_deleted != other._deleted) return false;
    if (newLocation != other.newLocation) return false;
    if (!mapEquals(newTags, other.newTags)) return false;
    return true;
  }

  @override
  int get hashCode => databaseId.hashCode;

  @override
  int compareTo(other) => 0;
}
