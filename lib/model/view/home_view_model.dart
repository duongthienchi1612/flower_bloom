class HomeViewModel {
  int totalLevels;
  Map<int, int> levelStars;
  Set<int> unlockedLevels;
  int totalStars;
  int currentStars;

  bool isDataLevelShow;

  HomeViewModel(
    this.totalLevels,
    this.levelStars,
    this.unlockedLevels,
    this.totalStars,
    this.currentStars,
    this.isDataLevelShow,
  );

  HomeViewModel copyWith({
    int? totalLevels,
    Map<int, int>? levelStars,
    Set<int>? unlockedLevels,
    int? totalStars,
    int? currentStars,
    bool? isSoundOn,
    bool? isDataLevelShow,
  }) {
    return HomeViewModel(
      totalLevels ?? this.totalLevels,
      levelStars ?? this.levelStars,
      unlockedLevels ?? this.unlockedLevels,
      totalStars ?? this.totalStars,
      currentStars ?? this.currentStars,
      isDataLevelShow ?? this.isDataLevelShow,
    );
  }
}
