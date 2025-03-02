import 'package:flower_bloom/dependencies.dart';
import 'package:flower_bloom/model/view/game_view_model.dart';
import 'package:flower_bloom/utilities/game_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utilities/audio_manager.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final gameStorage = injector.get<GameStorage>();
  final audioManager = injector.get<AudioManager>();

  GameBloc() : super(GameInitial()) {
    on<LoadGame>(_onLoadGame);
    on<ToggleFlower>(_onToggleFlower);
    on<ResetGame>(_onResetGame);
    on<NextLevel>(_onNextLevel);
    on<ChangeSound>(_onChangeSound);
  }

  void _onLoadGame(LoadGame event, Emitter<GameState> emit) async {
    int level = 1;
    if (event.level != null) {
      level = event.level!;
    } else {
      final levelData = await gameStorage.getLevelData();

      String? firstKeyWithZero =
          levelData.entries.firstWhere((entry) => entry.value == 0, orElse: () => MapEntry("", -1)).key;
      level = int.tryParse(firstKeyWithZero) ?? 1;
    }

    final model = GameViewModel(List.generate(level + 2, (_) => List.filled(level + 2, false)), false, level, level + 2,
        audioManager.isSoundOn, 0);

    emit(GameLoaded(model));
  }

  void _onToggleFlower(ToggleFlower event, Emitter<GameState> emit) {
    final currentState = state as GameLoaded;
    final model = currentState.model;
    List<List<bool>> newGrid = List.generate(model.gridSize, (i) => List.from(model.grid[i]));

    void toggle(int r, int c) {
      if (r >= 0 && r < model.gridSize && c >= 0 && c < model.gridSize) {
        newGrid[r][c] = !newGrid[r][c];
      }
    }

    toggle(event.row, event.col);
    toggle(event.row - 1, event.col);
    toggle(event.row + 1, event.col);
    toggle(event.row, event.col - 1);
    toggle(event.row, event.col + 1);

    bool isWin = newGrid.every((row) => row.every((flower) => flower));

    model.grid = newGrid;
    model.isWin = isWin;
    model.moveCount += 1;
    emit(GameLoaded(model));
  }

  void _onResetGame(ResetGame event, Emitter<GameState> emit) {
    final currentState = state as GameLoaded;
    final model = currentState.model;

    model.grid = List.generate(model.level + 2, (_) => List.filled(model.level + 2, false));
    model.isWin = false;

    emit(GameLoaded(model));
  }

  void _onNextLevel(NextLevel event, Emitter<GameState> emit) async {
    final currentState = state as GameLoaded;
    final model = currentState.model;

    if (model.level < 5) {
      int nextLevel = model.level + 1;
      await gameStorage.saveLevelStars(model.level, 3);

      final nextLevelModel = GameViewModel(List.generate(nextLevel + 2, (_) => List.filled(nextLevel + 2, false)),
          false, nextLevel, nextLevel + 2, audioManager.isSoundOn, 0);

      emit(GameLoaded(nextLevelModel));
    }
  }

  Future<void> _onChangeSound(ChangeSound event, Emitter<GameState> emit) async {
    final currentState = state as GameLoaded;
    final model = currentState.model;
    audioManager.toggleSound();
    model.isSoundOn = audioManager.isSoundOn;
    emit(GameLoaded(model));
  }
}
