import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    debugPrint(
        'bloc created \n ${bloc.runtimeType} \n ==================================================================================================== \n');
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    debugPrint(
        'bloc changed \n ${bloc.runtimeType} \n $change \n ==================================================================================================== \n');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint(
        'bloc error \n ${bloc.runtimeType} \n $error \n ==================================================================================================== \n');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    debugPrint(
        'bloc closed \n ${bloc.runtimeType} \n ==================================================================================================== \n');
    super.onClose(bloc);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    debugPrint(
        'bloc transition \n ${bloc.runtimeType} \n $transition \n ==================================================================================================== \n');
    super.onTransition(bloc, transition);
  }

  @override
  onEvent(Bloc bloc, Object? event) {
    debugPrint(
        'bloc event \n ${bloc.runtimeType} \n $event ==================================================================================================== \n');
    super.onEvent(bloc, event);
  }
}
