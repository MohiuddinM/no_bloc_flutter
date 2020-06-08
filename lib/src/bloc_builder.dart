import 'package:no_bloc/no_bloc.dart';
import 'package:flutter/widgets.dart';


/// This function takes a context and [data] of type [T] and returns a widget
///
/// Used when bloc updates its state and widget needs to rebuild with new data
typedef DataBuilder<T> = Widget Function(BuildContext context, T data);

/// This function takes a context and a [StateError] [error] and returns a widget
///
/// Used when bloc sets an error and an error widget should be built to show that error
typedef ErrorBuilder = Widget Function(BuildContext context, StateError error);

class BlocBuilder<R extends Bloc<R, S>, S> extends StatelessWidget {
  /// Bloc whose broadcasts  this builder listens to
  final Bloc<R, S> bloc;

  /// This is called when ever there is a valid state update in the provided bloc (setState)
  final DataBuilder<S> onUpdate;

  /// This is called whenever the bloc set its onBusy flag (setBusy)
  final WidgetBuilder onBusy;

  /// This is called whenever the bloc sets an error (setError)
  final ErrorBuilder onError;

  const BlocBuilder({Key key, @required this.bloc, @required this.onUpdate, this.onBusy, this.onError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      initialData: bloc.value,
      stream: bloc.state,
      builder: (context, snapshot) {
        if (bloc.isBusy || snapshot.connectionState == ConnectionState.waiting) {
          assert(onBusy != null, 'you must define onBusy function if your bloc uses "setBusy()"');
          return onBusy(context);
        }

        if (bloc.hasError) {
          assert(onError != null, 'you must define onError if your bloc uses "setError()"');
          return onError(context, bloc.error);
        }

        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot?.data == null) {
            assert(onError != null);
            return onError(context, StateError('null data was sent on an active connection'));
          }

          return onUpdate.call(context, snapshot.data);
        }

        throw StateError('${snapshot?.connectionState}, ${snapshot?.data}, ${snapshot?.error}');
      },
    );
  }
}
