import 'package:every_door_plugin/helpers/tags/element_kind.dart';
import 'package:every_door_plugin/helpers/geometry/geometry.dart';
import 'package:latlong2/latlong.dart' show LatLng;

/// An element type: node, way, or relation.
enum OsmElementType { node, way, relation }

/// Mapping from the enum value to strings.
const kOsmElementTypeName = <OsmElementType, String>{
  OsmElementType.node: 'node',
  OsmElementType.way: 'way',
  OsmElementType.relation: 'relation',
};

/// OSM identifier: a type and a number.
class OsmId {
  final OsmElementType type;
  final int ref;

  const OsmId(this.type, this.ref);

  /// Parses a string like "n123" into [OsmId] with the type from the letter
  /// (e.g. node for "n") and the number from the rest.
  factory OsmId.fromString(String s) {
    return OsmId(OsmElementType.node, int.parse(s.substring(1)));
  }

  /// Returns a representation like "node/123", to use in building
  /// website URLs.
  String get fullRef => '${kOsmElementTypeName[type]}/$ref';

  /// Returns a string like "n123" for a node with id=123. Can be
  /// parsed back into an [OsmId] with [OsmId.fromString].
  @override
  String toString() => '';

  @override
  bool operator ==(Object other) =>
      other is OsmId && type == other.type && ref == other.ref;

  @override
  int get hashCode => type.hashCode + ref.hashCode;
}

/// An OSM relation member. Contains of an OSM id and an optional [role].
class OsmMember {
  final OsmId id;
  final String? role;

  const OsmMember(this.id, [this.role]);

  OsmElementType get type => id.type;

  factory OsmMember.fromString(String s) {
    final idx = s.indexOf(' ');
    if (idx < 0) return OsmMember(OsmId.fromString(s));
    return OsmMember(
        OsmId.fromString(s.substring(0, idx)), s.substring(idx + 1));
  }

  @override
  String toString() {
    if (role == null) return id.toString();
    return '$id $role';
  }
}

/// Whether this object is a member of a way or a relation. Way
/// membership takes precedence.
enum IsMember { no, way, relation }

/// An OSM element downloaded from the server.
class OsmElement {
  final OsmId id;
  final Map<String, String> tags;
  final int version;
  final DateTime timestamp;
  final DateTime? downloaded;
  final LatLng? center;
  final Geometry? geometry;
  final List<int>? nodes;
  final Map<int, LatLng>? nodeLocations; // not stored to the database
  final List<OsmMember>? members;
  final IsMember isMember;

  OsmElementType get type => id.type;

  OsmElement({
    required this.id,
    required this.version,
    required this.timestamp,
    this.downloaded,
    required this.tags,
    LatLng? center,
    this.geometry,
    this.nodes,
    this.nodeLocations,
    this.members,
    this.isMember = IsMember.no,
  }) : center = center ??
            (geometry is Polygon
                ? geometry.findPointOnSurface()
                : geometry?.center);

  OsmElement copyWith(
      {Map<String, String>? tags,
      int? id,
      int? version,
      LatLng? center,
      Geometry? geometry,
      IsMember? isMember,
      List<int>? nodes,
      Map<int, LatLng>? nodeLocations,
      bool currentTimestamp = false,
      bool clearMembers = false}) {
    return OsmElement(
      id: id != null ? OsmId(this.id.type, id) : this.id,
      version: version ?? this.version,
      timestamp: currentTimestamp ? DateTime.now().toUtc() : timestamp,
      downloaded: downloaded,
      tags: tags ?? this.tags,
      center: center ?? this.center,
      geometry: geometry ?? this.geometry,
      nodes: clearMembers ? null : (nodes ?? this.nodes),
      nodeLocations: clearMembers || (nodeLocations?.isEmpty ?? false)
          ? null
          : (nodeLocations ?? this.nodeLocations),
      members: clearMembers ? null : members,
      isMember: isMember ?? this.isMember,
    );
  }

  /// Updates location and reference properties from `old`
  /// (When this element was downloaded fresh, but is missing some).
  OsmElement updateMeta(OsmElement? old) {
    if (old == null) return this;
    return OsmElement(
      id: id,
      version: version,
      timestamp: timestamp,
      downloaded: downloaded,
      tags: tags,
      center: center ?? old.center,
      geometry: geometry ?? old.geometry,
      nodes: nodes ?? old.nodes,
      nodeLocations: nodeLocations ?? old.nodeLocations,
      members: members ?? old.members,
      isMember: isMember,
    );
  }

  factory OsmElement.fromJson(Map<String, dynamic> data) {
    return OsmElement(
      id: OsmId.fromString(data['osmid']),
      version: data['version'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(data['timestamp']),
      tags: {},
    );
  }

  Map<String, dynamic> toJson() => {};

  // void toXML(XmlBuilder builder, {String? changeset, bool visible = true}) {
  // }

  bool get isPoint => id.type == OsmElementType.node;
  bool get isGood => ElementKind.everything.matchesTags(tags);
  bool get isSnapTarget =>
      id.type == OsmElementType.way;
  bool get isGeometryValid =>
      nodes != null &&
      nodes!.length >= 2 &&
      nodes!.every((element) => nodeLocations?.containsKey(element) ?? false);

  bool get isArea => false;

  String get idVersion => '${id}v$version';

  static String tagsToString(Map<String, String?> tags) => '{}';
}
