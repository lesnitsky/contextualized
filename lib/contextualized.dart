import 'dart:collection';

import 'package:flutter/foundation.dart';

class Context<T, K> {
  /// Parent [Context] which current context was inherited from
  Context? parent;

  final HashMap<T, K> _storage;

  Context([Map<T, K>? initial]) : _storage = HashMap<T, K>.from(initial ?? {});

  /// Inherits values from other [Context] and sets [parent] value to [other]
  void inherit(Context<T, K> other) {
    parent = other;
    _storage.addAll(other._storage);
  }

  /// Adds all values from [other] context w/o setting the [parent] value
  void addAll(Context<T, K> other) {
    _storage.addAll(other._storage);
  }

  /// Sets values by [key]
  K? operator [](T key) {
    return _storage[key];
  }

  /// Sets [value] to the context at [key]
  operator []=(T key, K value) {
    _storage[key] = value;
  }

  /// Removes the value of [key]
  void remove(T key) {
    _storage.remove(key);
  }

  /// Clears all values from the context
  /// Sets [parent] to null
  void clear() {
    parent = null;
    _storage.clear();
  }

  /// Gets value by key [T] (where key is [Type])
  /// if [nullable] is true – gets a value by key where key is T?
  K? getValueByTypeKey<T>({nullable = false}) {
    var v = _storage[T];

    if (v == null && nullable) {
      return getValueByTypeKey<T?>();
    }

    return v;
  }

  Map<T, K>? debugToMap() {
    if (!kReleaseMode) {
      return Map.from(_storage);
    }
  }
}
