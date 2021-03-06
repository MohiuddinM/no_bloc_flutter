import 'package:no_bloc_flutter/no_bloc_flutter.dart';
import 'package:flutter_test/flutter_test.dart';

class CounterBloc extends Bloc<CounterBloc, int> {
  void increment() => setState(value + 1);

  void decrement() => setState(value - 1);
}

class CounterBloc2 extends Bloc<CounterBloc2, int> {
  void increment() => setState(value + 1);

  void decrement() => setState(value - 1);
}

void main() {
  setUp(() => BlocContainer.clear());

  test('container should fetch same bloc for same arg', () {
    BlocContainer.add<CounterBloc>((context, arg) => CounterBloc());

    final CounterBloc bloc = BlocContainer.get(arg: 1);
    final CounterBloc blocx = BlocContainer.get(arg: 1);

    expect(bloc, blocx);
  });

  test('container should fetch different blocs for different args', () {
    BlocContainer.add<CounterBloc>((context, arg) => CounterBloc());

    final CounterBloc bloc = BlocContainer.get(arg: 1);
    final CounterBloc blocx = BlocContainer.get(arg: 2);

    expect(bloc, isNot(blocx));
  });

  test('container should fetch same blocs if arg is null', () {
    BlocContainer.add<CounterBloc>((context, arg) => CounterBloc());

    final CounterBloc bloc = BlocContainer.get();
    final CounterBloc blocx = BlocContainer.get();

    expect(bloc, blocx);
  });

  test('container should fetch bloc of specified type even if args are same', () {
    BlocContainer.add((context, arg) => CounterBloc());
    BlocContainer.add((context, arg) => CounterBloc2());

    final CounterBloc bloc = BlocContainer.get();
    final CounterBloc2 blocx = BlocContainer.get();

    expect(blocx.runtimeType, isNot(CounterBloc));
  });
}
