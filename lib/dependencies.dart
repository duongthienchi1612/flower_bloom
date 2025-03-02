import 'package:flower_bloom/utilities/audio_manager.dart';
import 'package:flower_bloom/utilities/game_storage.dart';
import 'package:get_it/get_it.dart';
import 'bloc/bloc_dependencies.dart';
import 'preference/user_reference.dart';

final injector = GetIt.instance;

class AppDependencies {
  static Future<void> initialize() async {
    injector.registerLazySingleton<UserReference>(() => UserReference());
    injector.registerLazySingleton<GameStorage>(() => GameStorage());
    injector.registerLazySingleton<AudioManager>(() => AudioManager());

    // ModelDependencies.init(injector);
    // RepositoryDependencies.init(injector);
    // BusinessDependencies.init(injector);
    BlocDependencies.init(injector);

  }
}
