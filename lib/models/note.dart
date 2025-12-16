import 'package:every_door_plugin/helpers/draw_style.dart';
import 'package:every_door_plugin/helpers/geometry/geometry.dart';
import 'package:latlong2/latlong.dart' show LatLng;

class BaseNote {
  static const kNoteGeohashPrecision = 6;

  int? id;
  final int? type;
  final LatLng location;
  final DateTime created;
  bool deleting;

  BaseNote(
      {required this.location,
      this.id,
      required this.type,
      DateTime? created,
      this.deleting = false})
      : created = created ?? DateTime.now();

  bool get isChanged => isNew || deleting;
  bool get isNew => (id ?? -1) < 0;

  /// Reverts changes if possible (except isNew) and returns true if successful.
  bool revert() {
    if (!isChanged || isNew) return false;
    if (deleting) deleting = false;
    if (isChanged)
      throw UnimplementedError('A note has a state that cannot be reverted.');
    return true;
  }

  factory BaseNote.fromJson(Map<String, dynamic> data) {
    switch (data['type']) {
      case MapNote.dbType:
        return MapNote.fromJson(data);
      case OsmNote.dbType:
        return OsmNote.fromJson(data);
      case MapDrawing.dbType:
        return MapDrawing.fromJson(data);
    }
    throw ArgumentError('Unknown note type in the database: ${data["type"]}');
  }

  Map<String, dynamic> toJson() => {};
}

class MapNote extends BaseNote {
  static const kMaxLength = 40;
  static const dbType = 1;
  final String? author;
  String message;

  MapNote(
      {super.id,
      required super.location,
      this.author,
      required this.message,
      super.deleting,
      super.created})
      : super(type: dbType);

  factory MapNote.fromJson(Map<String, dynamic> data) {
    return MapNote(
      id: data['id'],
      location: LatLng(0, 0),
      author: data['author'],
      message: data['message'],
      created: DateTime.fromMillisecondsSinceEpoch(data['created']),
      deleting: data['is_deleting'] == 1,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'author': author,
      'message': message,
    };
  }

  @override
  String toString() => 'MapNote($id, $location, "$message" by $author)';
}

class OsmNoteComment {
  final String? author;
  String message;
  final DateTime date;
  final bool isNew;

  OsmNoteComment({
    this.author,
    required this.message,
    DateTime? date,
    this.isNew = false,
  }) : date = date ?? DateTime.now();

  factory OsmNoteComment.fromJson(Map<String, dynamic> data) {
    return OsmNoteComment(
      author: data['author'],
      message: data['message'],
      date: DateTime.fromMillisecondsSinceEpoch(data['date']),
      isNew: data['isNew'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (author != null) 'author': author,
      'message': message,
      'date': date.millisecondsSinceEpoch,
      'isNew': isNew,
    };
  }

  @override
  String toString() => 'Comment(${isNew ? "new " : ""}"$message" by $author)';
}

class OsmNote extends BaseNote {
  static const dbType = 2;
  final List<OsmNoteComment> comments;

  OsmNote({
    super.id,
    required super.location,
    this.comments = const [],
    super.created,
    super.deleting,
  }) : super(type: dbType);

  String? get author => comments.isEmpty ? null : comments.first.author;
  String? get message => comments.isEmpty ? null : comments.first.message;
  bool get hasNewComments => comments.any((c) => c.isNew);

  @override
  bool get isChanged => super.isChanged || hasNewComments;

  @override
  bool revert() {
    comments.removeWhere((c) => c.isNew);
    return super.revert();
  }

  String? getNoteTitle() {
    return (message?.length ?? 0) < 100 ? message : message?.substring(0, 100);
  }

  factory OsmNote.fromJson(Map<String, dynamic> data) {
    return OsmNote(
      id: data['id'],
      location: LatLng(0, 0),
      created: DateTime.fromMillisecondsSinceEpoch(data['created']),
      deleting: data['is_deleting'] == 1,
      comments: [],
    );
  }

  @override
  Map<String, dynamic> toJson() => {};

  @override
  String toString() =>
      'OsmNote(${deleting ? "closing " : (isChanged ? "changed " : "")}$id, $location, $comments)';
}

class MapDrawing extends BaseNote {
  static const dbType = 3;
  final LineString path;
  final String? author;
  final String pathType;

  MapDrawing({
    super.id,
    required this.path,
    required this.pathType,
    this.author,
    super.created,
    super.deleting,
  }) : super(type: dbType, location: path.nodes[path.nodes.length >> 1]);

  DrawingStyle get style => kTypeStyles[pathType] ?? kUnknownStyle;

  factory MapDrawing.fromJson(Map<String, dynamic> data) {
    final coords = <LatLng>[];
    for (final part in (data['coords'] as String).split('|')) {
      final latlon =
          part.split(';').map((s) => double.parse(s.trim())).toList();
      if (latlon.length == 2) coords.add(LatLng(latlon[0], latlon[1]));
    }
    return MapDrawing(
      id: data['id'],
      pathType: data['path_type'],
      author: data['author'],
      path: LineString(coords),
      created: DateTime.fromMillisecondsSinceEpoch(data['created']),
      deleting: data['is_deleting'] == 1,
    );
  }

  @override
  Map<String, dynamic> toJson() => {};

  @override
  String toString() => 'MapDrawing($id, "$pathType", $location)';
}
