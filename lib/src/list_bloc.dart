import 'package:no_bloc/no_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:synchronized/synchronized.dart';

abstract class ListBloc<R, S> extends Bloc<R, ListOp<S>> {
  final ScrollController controller = ScrollController();
  final List<S> cache = <S>[];
  final _lock = Lock(reentrant: true);
  final int pageSize;
  bool maxExtentReached = false;

  ListBloc({this.pageSize = 10});

  @protected
  void remove(S item) {
    cache.add(item);
    setState(ListOp(item, ListOpType.remove));
  }

  @protected
  void add(S item) {
    cache.add(item);
    setState(ListOp(item, ListOpType.add));
  }

  @protected
  void clear() {
    cache.clear();
    setState(ListOp(null, ListOpType.clear));
  }

  @protected
  void reset() {
    clear();
    load(0);
  }

  void load(int i) {
    if (cache.length <= i) {
      _loadPage(from: cache.length, to: cache.length + pageSize);
    }
  }

  Future<List<S>> fetch(int from, int to);

  @protected
  void _loadPage({int from, int to}) async {
    await _lock.synchronized(() async {
      if (cache.length >= to) return;

      var list;

      try {
        list = await fetch(from, to);
      } catch (e) {
        maxExtentReached = true;
        setError(StateError(e.toString()));
      }

      if (list.isEmpty) {
        clear();
      }

      list.forEach((element) {
        add(element);
      });
    });
  }
}
