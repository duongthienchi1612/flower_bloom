import 'package:flower_bloom/model/view/home_view_model.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../constants.dart';
import '../dependencies.dart';
import '../utilities/audio_manager.dart';
import '../widget/base/base_widget.dart';

class MenuLevelScreen extends StatefulWidget {
  final HomeViewModel model;
  final VoidCallback onChangeSound;
  final VoidCallback onBackHome;
  final Function(int) onSelectLevel;

  const MenuLevelScreen({
    required this.model,
    super.key,
    required this.onChangeSound,
    required this.onBackHome,
    required this.onSelectLevel,
  });

  @override
  State<MenuLevelScreen> createState() => _MenuLevelScreenState();
}

class _MenuLevelScreenState extends BaseState<MenuLevelScreen> with TickerProviderStateMixin {
  final _audioManager = injector.get<AudioManager>();

  late final AnimationController _screenController;
  late final AnimationController _gridController;
  late final Animation<double> _screenScaleAnimation;
  late final Animation<double> _screenOpacityAnimation;
  late final Animation<double> _starsCounterAnimation;
  
  final List<Animation<double>> _levelAnimations = [];
  final Set<int> _playedSoundForLevels = {};

  @override
  void initState() {
    super.initState();

    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _gridController.addListener(_handleLevelSoundEffects);

    _screenScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _screenController, curve: Curves.easeOutBack),
    );

    _screenOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _screenController, 
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _starsCounterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _screenController, 
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _initializeLevelAnimations();

    _screenController.forward();
    _gridController.forward();
  }

  void _handleLevelSoundEffects() {
    for (int i = 0; i < Constants.totalLevel; i++) {
      if (_levelAnimations[i].value > 0.1 && !_playedSoundForLevels.contains(i)) {
        _playedSoundForLevels.add(i);
        _audioManager.playSoundEffect(SoundEffect.levelAppear);
        break;
      }
    }
  }

  void _initializeLevelAnimations() {
    for (int i = 0; i < Constants.totalLevel; i++) {
      final startInterval = 0.1 + (i * 0.1);
      final endInterval = startInterval + 0.2;

      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _gridController,
          curve: Interval(
            startInterval.clamp(0.0, 1.0),
            endInterval.clamp(0.0, 1.0),
            curve: Curves.easeOutBack,
          ),
        ),
      );

      _levelAnimations.add(animation);
    }
  }

  @override
  void dispose() {
    _screenController.dispose();
    _gridController.dispose();
    _playedSoundForLevels.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_screenController, _gridController]),
      builder: (context, _) => FadeTransition(
        opacity: _screenOpacityAnimation,
        child: ScaleTransition(
          scale: _screenScaleAnimation,
          child: Stack(
            children: [
              _buildLevelGrid(),
              _buildStarsCounter(),
              _buildSoundButton(),
              _buildHomeButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelGrid() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 100),
        child: GridView.builder(
          itemCount: Constants.totalLevel,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 70,
            mainAxisSpacing: 32,
          ),
          itemBuilder: (_, int index) => _buildLevelItem(index),
        ),
      ),
    );
  }

  Widget _buildLevelItem(int index) {
    final level = index + 1;
    final isLocked = !widget.model.unlockedLevels.contains(level);
    final star = widget.model.levelStars.values.elementAt(index);
    final animValue = _levelAnimations[index].value.clamp(0.0, 1.0);
    
    return Transform.scale(
      scale: animValue,
      child: Transform.rotate(
        angle: (1.0 - animValue) * math.pi / 10,
        child: Opacity(
          opacity: animValue,
          child: isLocked
              ? Transform.translate(
                  offset: const Offset(0, 10),
                  child: Image.asset(ImagePath.icLevelLock),
                )
              : GestureDetector(
                  onTap: () => widget.onSelectLevel(level),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: const Offset(0, 10),
                        child: Image.asset(ImagePath.icLevelNumber),
                      ),
                      Transform.translate(
                        offset: const Offset(0, 31),
                        child: Image.asset(
                          'assets/images/ic_star_$star.png',
                          width: 44,
                        ),
                      ),
                      Text(
                        level.toString(),
                        style: theme.textTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildStarsCounter() {
    return Positioned(
      left: 32,
      top: 24,
      child: FadeTransition(
        opacity: _starsCounterAnimation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-0.2, 0),
            end: Offset.zero,
          ).animate(_starsCounterAnimation),
          child: Row(
            children: [
              Image.asset(
                ImagePath.icStarActive,
                width: 32,
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.model.currentStars} / ${widget.model.totalStars}',
                style: theme.textTheme.headlineMedium,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSoundButton() {
    return Positioned(
      left: 24,
      bottom: 16,
      child: FadeTransition(
        opacity: _starsCounterAnimation,
        child: ScaleTransition(
          scale: _starsCounterAnimation,
          child: IconButton(
            onPressed: widget.onChangeSound,
            highlightColor: Colors.transparent,
            icon: Image.asset(
              ImagePath.icSoundOn,
              width: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHomeButton() {
    return Positioned(
      right: 24,
      bottom: 16,
      child: FadeTransition(
        opacity: _starsCounterAnimation,
        child: ScaleTransition(
          scale: _starsCounterAnimation,
          child: IconButton(
            onPressed: () {
              _audioManager.playSoundEffect(SoundEffect.buttonClick);
              widget.onBackHome();
            },
            icon: Image.asset(
              ImagePath.icHome,
              width: 32,
            ),
          ),
        ),
      ),
    );
  }
}
