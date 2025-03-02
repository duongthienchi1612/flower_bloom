import 'package:flower_bloom/bloc/home_bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';

import 'game_bloc/game_bloc.dart';


class BlocDependencies {
  static void init(GetIt injector) {
    injector.registerFactory<HomeBloc>(() => HomeBloc());
    injector.registerFactory<GameBloc>(() => GameBloc());
  }
}
