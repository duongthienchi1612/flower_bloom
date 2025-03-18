import 'package:flower_bloom/constants.dart';
import 'package:flower_bloom/dependencies.dart';
import 'package:flower_bloom/model/view/home_view_model.dart';
import 'package:flower_bloom/utilities/audio_manager.dart';
import 'package:flower_bloom/utilities/game_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final gameStorage = injector.get<GameStorage>();
  final audioManager = injector.get<AudioManager>();
  final totalLevel = Constants.totalLevel;

  HomeBloc() : super(HomeInitial()) {
    on<LoadData>(_onLoadData);
    on<ShowDataLevel>(_onShowDataLevel);
  }

  Future<void> _onLoadData(LoadData event, Emitter<HomeState> emit) async {
    final model = HomeViewModel(totalLevel, {}, {}, 0, 0, false);
    emit(HomeLoaded(model));
    if (event.showMenu == true) {
      add(ShowDataLevel(isShow: true));
      return;
    }
  }

  Future<void> _onShowDataLevel(ShowDataLevel event, Emitter<HomeState> emit) async {
    final currentState = state as HomeLoaded;
    final model = currentState.model;
    model.isDataLevelShow = event.isShow;

    final levelData = await gameStorage.getLevelData();

    Map<int, int> newLevelStars = {};
    Set<int> newUnlockedLevels = {1};
    int currentStars = 0;

    for (int i = 1; i <= totalLevel; i++) {
      int stars = levelData[i.toString()] ?? 0;
      newLevelStars[i] = stars;

      if (i > 1 && newLevelStars[i - 1]! > 0) {
        newUnlockedLevels.add(i);
      }
      currentStars += stars;
    }
    await gameStorage.saveLevelStars(4, 3);

    model.levelStars = newLevelStars;
    model.unlockedLevels = newUnlockedLevels;
    model.totalStars = totalLevel * 3;
    model.currentStars = currentStars;

    emit(HomeLoaded(model));
  }
}
