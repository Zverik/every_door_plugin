import 'package:every_door_plugin/models/amenity.dart';

/// A class for matching tag lists against a set of rules.
/// Contains rules for individual keys (see [ValueMatcher]),
/// and lists of [good] and [missing] keys to validate.
class TagMatcher {
  /// Empty matcher that matches everything.
  static const empty = TagMatcher({});

  /// Rules for matching values for a key.
  final Map<String, ValueMatcher> rules;

  /// List of keys to be accepted without looking at the rules.
  /// Works only for the "onlyKey" parameter of [matches] and [matchesChange].
  final Set<String> good;

  /// List of keys that should be missing. If it's not empty and
  /// _any_ of the keys here are missing, and all the rules match
  /// or are skipped, then [matches] returns "true".
  /// Unlike for [good], we don't strip prefixes here for matching.
  /// This is used for matching objects that lack some additional tags.
  final Set<String> missing;

  const TagMatcher(this.rules, {this.good = const {}, this.missing = const {}});

  /// Returns "true" only if nothing has been initialized.
  bool get isEmpty => rules.isEmpty && good.isEmpty && missing.isEmpty;

  /// Tests a set of tags for a match. Pass [onlyKey] to test only
  /// rules for this single key, and also use [good] key set.
  /// A prefix in [onlyKey] is stripped, but not in other keys.
  ///
  /// For matching an [OsmChange] object, see [matchesChange].
  bool matches(Map<String, String> tags, [String? onlyKey]) {
    return false;
  }

  /// Tests an [OsmChange] object for a match. Performs exactly
  /// as [match], but doesn't call [OsmChange.getFullTags].
  bool matchesChange(OsmChange change, [String? onlyKey]) {
    return false;
  }

  /// Merges this tag matcher with another. Used internally.
  /// Rules are merged using [ValueMatcher.mergeWith], [good] keys
  /// are united, [missing] set is replaced.
  TagMatcher mergeWith(TagMatcher? another) {
    return this;
  }

  /// Builds a class instance from a structure. It expects a plain map
  /// with tag keys for keys, and [ValueMatcher] structures for values.
  /// Two keys are exceptions and should contain lists of strings:
  /// "$good" (see [good]) and "$missing" (see [missing]).
  factory TagMatcher.fromJson(Map<String, dynamic>? data) {
    if (data == null) return empty;

    final rules = data.map((k, v) => MapEntry(k, ValueMatcher.fromJson(v)));
    rules.removeWhere((k, v) => k.startsWith('\$'));

    return TagMatcher(
      rules,
      good: Set.of(data['\$good'] ?? const []),
      missing: Set.of(data['\$missing'] ?? const []),
    );
  }
}

/// This class matches tag values to a set of rules.
class ValueMatcher {
  /// Those values are forbidden, the matcher will return "false".
  final Set<String> except;

  /// If not empty, this list should include every allowed value.
  /// Keys from [when] are also considered, so they can be omitted.
  final Set<String> only;

  /// Conditional rules for some values. They allow to check other
  /// sub-tags, e.g. "recycling_type=*" for "amenity=recycling".
  /// When [only] and [except] are empty, only values in this map
  /// are accepted (it works as "only").
  final Map<String, TagMatcher> when;

  /// When updating a matcher, replace all fields or add values.
  final bool replace;

  const ValueMatcher({
    this.except = const {},
    this.only = const {},
    this.when = const {},
    this.replace = true,
  });

  /// Tests the value to match all the rules.
  bool matches(String value, Map<String, String> tags) {
    return false;
  }

  /// Tests an [OsmChange] object for a match. Performs exactly
  /// as [match], but doesn't call [OsmChange.getFullTags].
  bool matchesChange(String value, OsmChange change) {
    return false;
  }

  /// Merge two value matchers. Used internally when updating from
  /// an external source.
  ValueMatcher mergeWith(ValueMatcher another) {
    return this;
  }

  /// Builds a class instance out of a structure. The structure
  /// is straightforward: a map with "except", "only", and "when"
  /// keys that replicated this class fields.
  factory ValueMatcher.fromJson(Map<String, dynamic> data) {
    return ValueMatcher(
      except: Set.of(
        (data['except'] as Iterable<dynamic>?)?.whereType<String>() ?? const [],
      ),
      only: Set.of(
        (data['only'] as Iterable<dynamic>?)?.whereType<String>() ?? const [],
      ),
      when:
          (data['when'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, TagMatcher.fromJson(data['when'])),
          ) ??
          const {},
      replace: data['replace'] ?? true,
    );
  }
}
