import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/widgets.dart';
import 'package:no_bloc/no_bloc.dart';

import 'bloc_builder.dart';

extension BlocExtensions<R extends Bloc<R, S>, S> on Bloc<R, S> {
  Widget builder({Key key, @required DataBuilder<S> onUpdate, WidgetBuilder onBusy, ErrorBuilder onError}) {
    onBusy ??= (_) => LayoutBuilder(
          builder: (context, crts) {
            if (crts.maxHeight < 10 || crts.maxWidth < 10) {
              // Size is too small to draw a CircularProgressIndicator
              return const SizedBox();
            }

//            Widget child;
//            if (kIsWeb) {
//              child = mat.CircularProgressIndicator();
//            } else {
//              child = Platform. ? mat.CircularProgressIndicator() : CupertinoActivityIndicator();
//            }

            final child = mat.CircularProgressIndicator();

            return Center(
              child: SizedBox(
                width: min(40, crts.maxWidth),
                height: min(40, crts.maxHeight),
                child: child,
              ),
            );
          },
        );

    return BlocBuilder<R, S>(
      key: key,
      onUpdate: onUpdate,
      onError: onError,
      onBusy: onBusy,
      bloc: this,
    );
  }
}
