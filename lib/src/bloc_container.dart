import 'package:no_bloc/no_bloc.dart';
import 'package:flutter/widgets.dart';

/// Takes [context] and [arg], return a [Bloc]
///
/// Used by [BlocContainer] to instantiate blocs on demand
/// [arg] must implement equality
typedef BlocWithArgBuilder<T> = T Function(BuildContext context, dynamic arg);

/// Acts as a key for bloc container cache
///
/// For cache to return cache value, both type and arg must match with a stored version
class TypeAndArg {
  final Type type;
  final arg;

  TypeAndArg(this.type, this.arg);

  @override
  bool operator ==(Object other) => other is TypeAndArg && other.type == type && other.arg == arg;

  @override
  int get hashCode => type.hashCode + arg.hashCode;
}

/// Builds, saves and provides [Bloc] independent of the build tree
///
/// Generally, applications would [add] all the blocs which would be required any where in the application.
/// And then [get] them whenever they are needed
class BlocContainer {
  static final Map<Type, BlocWithArgBuilder> _blocs = {};
  static final Map<TypeAndArg, Bloc> _cache = {};

  /// Adds a blocs to internal resolver
  ///
  /// Takes a [builder] to build a [Bloc] of type [T]
  static void add<T>(BlocWithArgBuilder<T> builder) {
    assert(T != dynamic, 'Type must be defined');
    assert(!_blocs.containsKey(T));
    _blocs[T] = builder;
  }

  /// Called whenever an application needs an already added [Bloc]
  ///
  /// The blocs which are once instantiated, can also be cached using the [useCache] option
  /// The bloc type [T] and the provided arg are both matched to return the cached bloc
  static R get<R extends Bloc<R, S>, S>({BuildContext context, arg, bool useCache = true}) {
    assert(arg == null || implementsEquality(arg), '${arg.runtimeType} does not implement equality ');
    final cacheKey = TypeAndArg(R, arg);

    if (_cache.containsKey(cacheKey) && useCache) {
      return _cache[cacheKey];
    }
    return _cache[cacheKey] = _blocs[R](context, arg);
  }

  /// Clears the entire container, including the already cached blocs
  static void clear() {
    _blocs.clear();
    _cache.clear();
  }
}
