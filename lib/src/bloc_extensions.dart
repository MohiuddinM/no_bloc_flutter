import 'package:flutter/cupertino.dart';
import 'package:no_bloc/no_bloc.dart';
import 'package:no_bloc_flutter/no_bloc_flutter.dart';

extension BlocExtensions<R extends Bloc<R, S>, S> on Bloc<R, S> {
  Widget builder({Key key, DataBuilder<S> onUpdate, WidgetBuilder onBusy, ErrorBuilder onError}) {
    return BlocBuilder<R, S>(
      key: key,
      onUpdate: onUpdate,
      onError: onError,
      onBusy: onBusy,
      bloc: this,
    );
  }
}
