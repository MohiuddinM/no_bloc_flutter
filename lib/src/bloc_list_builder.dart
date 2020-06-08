import 'package:no_bloc/no_bloc.dart';
import 'package:flutter/widgets.dart';

import 'bloc_builder.dart';
import 'list_bloc.dart';

typedef ToWidget<T> = Widget Function(BuildContext, T);

class BlocListBuilder<R, S> extends StatelessWidget {
  final ListBloc<R, S> bloc;
  final Widget onEmpty;
  final Widget onBusy;
  final ErrorBuilder onError;
  final ToWidget<S> builder;
  final int scrollThreshold;

  BlocListBuilder({Key key, @required this.bloc, this.onEmpty, this.onBusy, @required this.builder, this.scrollThreshold = 200, this.onError}) : super(key: key) {
    bloc.load(0);
  }

  Widget _buildList(BuildContext context) {
    return ListView.separated(
      controller: bloc.controller,
      itemCount: bloc.cache.length + (bloc.maxExtentReached ? 0 : 1),
      itemBuilder: (context, i) {
        if (i == bloc.cache.length) {
          bloc.load(i);
          return onBusy;
        }

        return builder(context, bloc.cache[i]);
      },
      separatorBuilder: (context, i) => SizedBox(height: 8, width: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ListOp<S>>(
      stream: bloc.state,
      builder: (_, snapshot) {
//        final op = snapshot.data;

        if (bloc.isBusy) {
          assert(onBusy != null);
          return onBusy;
        }

        if (bloc.hasError) {
          assert(onError != null);
          return onError(context, bloc.error);
        }

        if (bloc.cache.isEmpty && bloc.maxExtentReached) {
          return onEmpty;
        }

        if (snapshot.connectionState == ConnectionState.active) {}

        return _buildList(context);
      },
    );
  }
}
