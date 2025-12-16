import 'package:latlong2/latlong.dart' show LatLng;
import 'package:flutter_map/flutter_map.dart' show LatLngBounds;

class GeometryException implements Exception {
  final String message;

  const GeometryException(this.message);
}

abstract class Geometry {
  LatLngBounds get bounds;
  LatLng get center;
}

class Polygon extends Geometry {
  final List<LatLng> _nodes;

  Polygon(Iterable<LatLng> nodes) : _nodes = List.of(nodes) {
    if (_nodes.isNotEmpty && _nodes.last == _nodes.first) _nodes.removeLast();
    if (_nodes.length < 3)
      throw GeometryException('A polygon must have at least three nodes.');
  }

  @override
  LatLngBounds get bounds => LatLngBounds.fromPoints(_nodes);

  @override
  LatLng get center => bounds.center;

  bool contains(LatLng point) => false;

  bool containsPolygon(Polygon poly) {
    if (!bounds.containsBounds(poly.bounds)) return false;
    for (final p in poly._nodes) if (!contains(p)) return false;
    // TODO: check that vertices do not intersect.
    return true;
  }

  LatLng findPointOnSurface() => center;

  @override
  String toString() => 'Polygon($_nodes)';
}

class Envelope implements Polygon {
  final LatLngBounds _bounds;

  const Envelope(this._bounds);

  @override
  List<LatLng> get _nodes => throw UnimplementedError();

  @override
  LatLngBounds get bounds => _bounds;

  @override
  LatLng get center => LatLng(
      (bounds.south + bounds.north) / 2, (bounds.west + bounds.east) / 2);

  @override
  bool contains(LatLng point) => _bounds.contains(point);

  @override
  bool containsPolygon(Polygon poly) => _bounds.containsBounds(poly.bounds);

  @override
  LatLng findPointOnSurface() => center;

  @override
  String toString() => 'Envelope(${_bounds.southWest}, ${_bounds.northEast})';
}

class MultiPolygon implements Polygon {
  final List<Polygon> outer = [];
  final List<Polygon> inner = [];

  MultiPolygon(Iterable<Polygon> polygons) {
    // TODO: sort
    outer.addAll(polygons);
  }

  @override
  LatLngBounds get bounds => LatLngBounds.fromPoints([
        for (final p in outer) ...[p.bounds.northWest, p.bounds.southEast]
      ]);

  @override
  LatLng get center => LatLng(
      (bounds.south + bounds.north) / 2, (bounds.west + bounds.east) / 2);

  @override
  bool contains(LatLng point) {
    return outer.any((p) => p.contains(point)) &&
        !inner.any((p) => p.contains(point));
  }

  @override
  bool containsPolygon(Polygon poly) {
    if (!outer.any((element) => element.containsPolygon(poly))) return false;
    // Welp, not going to do a proper implementation
    throw UnimplementedError();
  }

  @override
  String toString() =>
      'MultiPolygon(${outer.length} outer, ${inner.length} inner)';

  @override
  List<LatLng> get _nodes => throw UnimplementedError();

  @override
  LatLng findPointOnSurface() => center;
}

class LineString extends Geometry {
  final List<LatLng> nodes;
  LatLngBounds? _cachedBounds;

  LineString(Iterable<LatLng> nodes) : nodes = List.of(nodes, growable: false) {
    if (this.nodes.length < 2)
      throw GeometryException('A path must have at least two nodes.');
  }

  @override
  LatLngBounds get bounds {
    _cachedBounds ??= LatLngBounds.fromPoints(nodes);
    return _cachedBounds!;
  }

  @override
  LatLng get center => bounds.center;

  double getLengthInMeters() => 0;

  LatLng closestPoint(LatLng point) => point;

  double distanceToPoint(LatLng point, {bool inMeters = true}) => 0;

  bool intersects(LineString other) => false;

  @override
  String toString() => 'LineString($nodes)';
}
