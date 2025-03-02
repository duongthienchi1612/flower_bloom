class GameViewModel {
  List<List<bool>> grid;
  bool isWin;
  int level;
  int gridSize;
  bool isSoundOn;
  int moveCount;

  GameViewModel(this.grid, this.isWin, this.level, this.gridSize, this.isSoundOn, this.moveCount);

  GameViewModel copyWith({
    List<List<bool>>? grid,
    bool? isWin,
    int? level,
    int? gridSize,
    bool? isSoundOn,
    int? moveCount,
  }) {
    return GameViewModel(
      grid ?? this.grid,
      isWin ?? this.isWin,
      level ?? this.level,
      gridSize ?? this.gridSize,
      isSoundOn ?? this.isSoundOn,
      moveCount ?? this.moveCount,
    );
  }
}
