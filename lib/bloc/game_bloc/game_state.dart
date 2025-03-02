part of 'game_bloc.dart';

sealed class GameState {}

class GameInitial extends GameState {
  GameInitial();
}

class GameLoaded extends GameState {
  final GameViewModel model;
  GameLoaded(this.model);
}
