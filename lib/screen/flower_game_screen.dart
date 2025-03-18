import 'package:flower_bloom/dependencies.dart';
import 'package:flower_bloom/model/view/game_view_model.dart';
import 'package:flower_bloom/utilities/audio_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:lottie/lottie.dart';
import '../bloc/game_bloc/game_bloc.dart';
import '../constants.dart';
import '../widget/base/base_widget.dart';
import '../widget/sound_settings_dialog.dart';

class GameScreen extends StatefulWidget {
  final int? level;
  const GameScreen({super.key, this.level});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends BaseState<GameScreen> with TickerProviderStateMixin {
  final audioManager = injector.get<AudioManager>();
  final bloc = injector.get<GameBloc>();

  // Controller và animation
  late AnimationController _levelCompleteController;
  late Animation<double> _scaleAnimation;
  late AnimationController _staticFlowerController;
  late AnimationController _uiController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleUIAnimation;
  late Animation<double> _moveCountAnimation;
  late Animation<double> _levelTextAnimation;
  late Animation<double> _gridAnimation;
  late Animation<double> _buttonsAnimation;

  // Quản lý trạng thái
  final Map<String, bool> _tileAnimationStates = {};
  bool _isAnyAnimationRunning = false;
  bool _showCompletedScreen = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    audioManager.playSoundEffect(SoundEffect.gameAppear);
  }

  void _initializeAnimations() {
    // Level complete animation
    _levelCompleteController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _levelCompleteController, curve: Curves.elasticOut),
    );

    // Static flower controller
    _staticFlowerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1),
    )..value = 0.9;

    // UI animations
    _uiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = _createAnimation(0.0, 0.6, Curves.easeOut);
    _scaleUIAnimation = _createAnimation(0.0, 0.6, Curves.easeOutBack, begin: 0.95, end: 1.0);
    _moveCountAnimation = _createAnimation(0.3, 0.7, Curves.easeOutBack);
    _levelTextAnimation = _createAnimation(0.4, 0.8, Curves.easeOutBack);
    _gridAnimation = _createAnimation(0.2, 0.9, Curves.easeOutBack);
    _buttonsAnimation = _createAnimation(0.6, 1.0, Curves.elasticOut);

    _uiController.forward();
  }

  Animation<double> _createAnimation(double beginInterval, double endInterval, Curve curve,
      {double? begin, double? end}) {
    return Tween<double>(begin: begin ?? 0.0, end: end ?? 1.0).animate(
      CurvedAnimation(
        parent: _uiController,
        curve: Interval(beginInterval, endInterval, curve: curve),
      ),
    );
  }

  @override
  void dispose() {
    _levelCompleteController.dispose();
    _staticFlowerController.dispose();
    _uiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.background),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocProvider(
          create: (context) => bloc..add(LoadGame(level: widget.level)),
          child: BlocConsumer<GameBloc, GameState>(
            listener: _onGameStateChanged,
            builder: (context, state) {
              if (state is GameLoaded) {
                return _buildGameContent(state.model);
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  void _onGameStateChanged(BuildContext context, GameState state) async {
    if (state is GameLoaded && state.model.lastToggled == null) {
      _tileAnimationStates.clear();
      _isAnyAnimationRunning = false;
      _showCompletedScreen = false;
    }

    if (state is GameLoaded && state.model.lastToggled != null) {
      final lastToggled = state.model.lastToggled!;
      final isWinState = state.model.isWin;

      _isAnyAnimationRunning = true;

      // Cập nhật trạng thái animation
      final positions = [
        'tile_${lastToggled.row}${lastToggled.col}',
        'tile_${lastToggled.row - 1}${lastToggled.col}',
        'tile_${lastToggled.row + 1}${lastToggled.col}',
        'tile_${lastToggled.row}${lastToggled.col - 1}',
        'tile_${lastToggled.row}${lastToggled.col + 1}',
      ];

      for (final tileKey in positions) {
        _tileAnimationStates[tileKey] = true;
      }

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            for (final tileKey in positions) {
              _tileAnimationStates[tileKey] = false;
            }
            _isAnyAnimationRunning = false;

            if (isWinState && !_showCompletedScreen) {
              Future.delayed(const Duration(milliseconds: 250), () {
                audioManager.playSoundEffect(SoundEffect.soundCompleted);
                if (mounted) {
                  setState(() {
                    _showCompletedScreen = true;
                    _levelCompleteController.forward(from: 0.0);
                  });
                }
              });
            }
          });
        }
      });
    }
  }

  Widget _buildGameContent(GameViewModel model) {
    return AnimatedBuilder(
      animation: _uiController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleUIAnimation,
            child: Stack(
              children: [
                // Game info
                _buildGameInfo(model),
                // Bottom controls
                _buildBottomControls(),
                // Game content
                _showCompletedScreen && model.level < Constants.totalLevel
                    ? _buildLevelCompleteScreen(model)
                    : _buildGameGrid(model),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGameInfo(GameViewModel model) {
    return Stack(
      children: [
        // Moves counter
        Positioned(
          left: 24,
          top: 16,
          child: _buildInfoText(
            text: '${localizations.moves}: ${model.moveCount}',
            animation: _moveCountAnimation,
            offset: const Offset(-0.2, 0),
          ),
        ),

        // Level indicator
        Positioned(
          right: 24,
          top: 16,
          child: _buildInfoText(
            text: '${localizations.level}: ${model.level}',
            animation: _levelTextAnimation,
            offset: const Offset(0.2, 0),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText({
    required String text,
    required Animation<double> animation,
    required Offset offset,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: offset,
        end: Offset.zero,
      ).animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            text,
            style: theme.textTheme.headlineSmall?.copyWith(
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 3,
                  offset: const Offset(1, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Stack(
      children: [
        // Sound button
        Positioned(
          left: 24,
          bottom: 16,
          child: _buildAnimatedButton(
            animation: _buttonsAnimation,
            icon: ImagePath.icSoundOn,
            onPressed: () async {
              audioManager.playSoundEffect(SoundEffect.buttonClick);
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => SoundSettingsDialog(
                  backgroundVolume: audioManager.backgroundVolume,
                  effectVolume: audioManager.effectVolume,
                ),
              );
            },
          ),
        ),

        // Home button
        Positioned(
          right: 24,
          bottom: 16,
          child: _buildAnimatedButton(
            animation: _buttonsAnimation,
            icon: ImagePath.icHome,
            onPressed: () {
              audioManager.playSoundEffect(SoundEffect.buttonClick);
              Navigator.pushReplacementNamed(context, ScreenName.home);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedButton({
    required Animation<double> animation,
    required String icon,
    required VoidCallback onPressed,
  }) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: IconButton(
          onPressed: onPressed,
          highlightColor: Colors.transparent,
          icon: Image.asset(icon, width: 32),
        ),
      ),
    );
  }

  Widget _buildGameGrid(GameViewModel model) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _gridAnimation,
            child: FadeTransition(
              opacity: _gridAnimation,
              child: _buildGrid(context, model),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCompleteScreen(GameViewModel model) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                localizations.levelComplete,
                style: theme.textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStar(model.moveCount),
                  const SizedBox(width: 12),
                  _buildStar(model.moveCount),
                  const SizedBox(width: 12),
                  _buildStar(model.moveCount),
                ],
              ),
              const SizedBox(height: 22),

              // Move count
              Text(
                '${localizations.moves}: ${model.moveCount}',
                style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 22),

              // Control buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCompletionButton(
                    icon: ImagePath.icReload,
                    onPressed: () {
                      audioManager.playSoundEffect(SoundEffect.buttonClick);
                      _showCompletedScreen = false;
                      bloc.add(ResetGame());
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildCompletionButton(
                    icon: ImagePath.icPlay,
                    onPressed: () {
                      audioManager.playSoundEffect(SoundEffect.buttonClick);
                      bloc.add(NextLevel());
                    },
                  ),
                  const SizedBox(width: 20),
                  _buildCompletionButton(
                    icon: ImagePath.icMenuLevel,
                    onPressed: () {
                      audioManager.playSoundEffect(SoundEffect.buttonClick);
                      Navigator.pushReplacementNamed(
                        context,
                        ScreenName.home,
                        arguments: true,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStar(int moveCount) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Image.asset(
            ImagePath.icStarActive,
            width: 38,
          ),
        );
      },
    );
  }

  Widget _buildCompletionButton({
    required String icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        highlightColor: Colors.transparent,
        icon: Image.asset(icon, width: 38),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, GameViewModel model) {
    final size = MediaQuery.of(context).size;
    final double maxWidth = size.width * 0.85;
    final double maxHeight = size.height * 0.85;
    final double gridSize = model.gridSize.toDouble();

    final double maxGridSize = maxWidth < maxHeight ? maxWidth : maxHeight;
    final double tileSize =
        (maxGridSize / gridSize > Constants.tiledSize) ? Constants.tiledSize : maxGridSize / gridSize;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          model.gridSize,
          (row) => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              model.gridSize,
              (col) => _buildFlowerTile(model, row, col, tileSize),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFlowerTile(GameViewModel model, int row, int col, double tileSize) {
    final bool isBlooming = model.grid[row][col];
    final String tileKey = 'tile_$row$col';
    final bool isAnimating = _tileAnimationStates[tileKey] ?? false;

    return GestureDetector(
      onTap: () {
        if (!_isAnyAnimationRunning) {
          audioManager.playSoundEffect(SoundEffect.soundFlowerBloom);
          bloc.add(ToggleFlower(row, col));
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(2),
        width: tileSize - 8,
        height: tileSize - 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isBlooming ? Colors.transparent : Colors.grey.withOpacity(0.5),
          border: Border.all(
            color: isBlooming ? Colors.green.withOpacity(0.8) : Colors.black.withOpacity(0.6),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isBlooming ? Colors.green.withOpacity(0.3) : Colors.black.withOpacity(0.1),
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _buildTileContent(isAnimating, isBlooming, row, col, tileSize),
      ),
    );
  }

  Widget _buildTileContent(bool isAnimating, bool isBlooming, int row, int col, double tileSize) {
    if (isAnimating) {
      // Animating state
      return isBlooming
          ? _buildLottieAnimation(
              ImagePath.flowerBloom,
              'bloom_$row$col${DateTime.now().millisecondsSinceEpoch}',
              tileSize,
            )
          : _buildLottieAnimation(
              ImagePath.leaf,
              'leaf_$row$col${DateTime.now().millisecondsSinceEpoch}',
              tileSize,
            );
    } else {
      // Static state
      return isBlooming
          ? _buildStaticLottie(ImagePath.flowerBloom, tileSize, _staticFlowerController)
          : _buildStaticLottie(ImagePath.leaf, tileSize, null);
    }
  }

  Widget _buildLottieAnimation(String asset, String key, double tileSize) {
    return Lottie.asset(
      asset,
      key: ValueKey(key),
      width: tileSize,
      height: tileSize,
      fit: BoxFit.contain,
      repeat: false,
      frameRate: FrameRate.max,
    );
  }

  Widget _buildStaticLottie(String asset, double tileSize, AnimationController? controller) {
    return Lottie.asset(
      asset,
      width: tileSize,
      height: tileSize,
      fit: BoxFit.contain,
      controller: controller,
      repeat: false,
      animate: false,
    );
  }
}
