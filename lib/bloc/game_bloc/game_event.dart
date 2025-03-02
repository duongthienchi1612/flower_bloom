part of 'game_bloc.dart';

abstract class GameEvent {
  const GameEvent();
}

class ToggleFlower extends GameEvent {
  final int row, col;
  ToggleFlower(this.row, this.col);
}

class ResetGame extends GameEvent {}

class LoadGame extends GameEvent {
  final int? level;
  LoadGame({this.level});
}

class NextLevel extends GameEvent {}

class ChangeSound extends GameEvent {
  ChangeSound();
}
