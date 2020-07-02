Helper widgets to work with [`no_bloc`](https://pub.dev/packages/no_bloc) library

## Bloc Builder
Keeps your UI in sync with the State of your app. It's StatelessWidget widget which only rebuilds the relative child, instead of rebuilding entire page.
```dart
BlocBuilder<BlocType, BlocStateType>(
  bloc: bloc
  onUpdate: (context, data) => Text(data.toString()),
  onBusy: (_) => Text('Working'),
  onError: (_, e) => Text('Error Occurred'),
)
```

Or a simpler version (extension method sugar):
```dart
bloc.builder(
  onUpdate: (context, data) => Text(data.toString()),
  onError: (_, e) => Text('Error Occurred: $e'),
)
```

for details [see example](https://pub.dev/packages/no_bloc_flutter#-example-tab-)

## Bloc Container
A container where you can store all your blocs on app startup, and then access them anywhere in your app independently of the widget tree.
```dart
void main() {
  BlocContainer.add((context, args) => CounterBloc(args));
  final counterBloc = BlocContainer.get(arg: 0);
}
```
[see example](https://pub.dev/packages/no_bloc_flutter#-example-tab-)

## Bloc List Builder
A builder which builds a ListView widget backed by a data source e.g. an infinite scrollable list backed by a rest api
*example coming soon*

## Contribution ❤
Issues and pull requests are welcome

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/MohiuddinM/no_bloc