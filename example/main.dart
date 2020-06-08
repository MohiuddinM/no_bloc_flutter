import 'package:no_bloc_flutter/no_bloc_flutter.dart';
import 'package:flutter/material.dart';

class CounterBloc extends AutoPersistedBloc<CounterBloc, int> {
  final int counterNumber;

  CounterBloc({this.counterNumber}) : super(initialState: 0);

  void increment() => setState(value + 1, event: 'increment');

  void decrement() => setState(value - 1, event: 'decrement');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocContainer.get<CounterBloc, int>();

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You have pushed the button this many times:'),
              bloc.builder(
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
  BlocContainer.add<CounterBloc>((context, arg) => CounterBloc(counterNumber: arg ?? 0));
  runApp(MyApp());
}
