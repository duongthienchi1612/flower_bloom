class GameViewModel {
  List<List<bool>> grid;
  bool isWin;
  int level;
  int gridSize;
  bool isSoundOn;
  int moveCount;
  Position? lastToggled;

  GameViewModel(this.grid, this.isWin, this.level, this.gridSize, this.isSoundOn, this.moveCount, [this.lastToggled]);

  GameViewModel copyWith({
    List<List<bool>>? grid,
    bool? isWin,
    int? level,
    int? gridSize,
    bool? isSoundOn,
    int? moveCount,
    Position? lastToggled,
  }) {
    return GameViewModel(
      grid ?? this.grid,
      isWin ?? this.isWin,
      level ?? this.level,
      gridSize ?? this.gridSize,
      isSoundOn ?? this.isSoundOn,
      moveCount ?? this.moveCount,
      lastToggled ?? this.lastToggled,
    );
  }
}

class Position {
  final int row;
  final int col;

  Position(this.row, this.col);
}
