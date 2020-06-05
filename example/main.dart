import 'package:no_bloc_flutter/no_bloc_flutter.dart';
import 'package:flutter/material.dart';

class PersistentCounterBloc extends AutoPersistedBloc<PersistentCounterBloc, int> {
  final int counterNumber;

  PersistentCounterBloc({this.counterNumber}) : super(initialState: 0);

  void increment() => setState(value + 1, event: 'increment');

  void decrement() => setState(value - 1, event: 'decrement');
}

class CounterBloc extends Bloc<CounterBloc, int> {
  final int id;

  CounterBloc({this.id});

  void increment() => setState(value + 1);

  void decrement() => setState(value - 1);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You have pushed the button this many times:'),
              BlocBuilder(
                bloc: BlocContainer.get<CounterBloc, int>(),
                onUpdate: (context, data) => Text(data.toString(), style: Theme.of(context).textTheme.headline4),
                onBusy: (_) => Text('Working'),
                onError: (_, e) => Text('Error Occurred'),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: BlocContainer.get<CounterBloc, int>().increment,
        ),
      ),
    );
  }
}

void main() {
  BlocContainer.add<CounterBloc>((context, arg) => CounterBloc(id: arg ?? 0));
  runApp(MyApp());
}
