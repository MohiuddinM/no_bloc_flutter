import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/widgets.dart';
import 'package:no_bloc/no_bloc.dart';
import 'package:no_bloc_flutter/no_bloc_flutter.dart';

extension BlocExtensions<R extends Bloc<R, S>, S> on Bloc<R, S> {
  Widget builder({Key key, @required DataBuilder<S> onUpdate, WidgetBuilder onBusy, ErrorBuilder onError}) {
    onBusy ??= (_) => LayoutBuilder(
          builder: (context, crts) {
            if (crts.maxHeight < 10 || crts.maxWidth < 10) {
              // Size is too small to draw a CircularProgressIndicator
              return const SizedBox();
            }

            return Center(
              child: SizedBox(
                width: min(40, crts.maxWidth),
                height: min(40, crts.maxHeight),
                child: Platform.isAndroid ? mat.CircularProgressIndicator() : CupertinoActivityIndicator(),
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
