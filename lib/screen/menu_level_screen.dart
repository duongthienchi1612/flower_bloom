import 'package:flower_bloom/bloc/home_bloc/home_bloc.dart';
import 'package:flower_bloom/model/view/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;

import '../constants.dart';
import '../dependencies.dart';
import '../utilities/audio_manager.dart';
import '../widget/base/base_widget.dart';

class MenuLevelScreen extends StatefulWidget {
  final HomeViewModel model;
  final Function() onChangeSound;
  final Function() onBackHome;
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

class _MenuLevelScreenState extends BaseState<MenuLevelScreen> 
    with TickerProviderStateMixin {
  final audioManager = injector.get<AudioManager>();
  
  // Controllers cho các animation
  late AnimationController _screenController;
  late AnimationController _gridController;
  late Animation<double> _screenScaleAnimation;
  late Animation<double> _screenOpacityAnimation;
  late Animation<double> _starsCounterAnimation;
  
  // Danh sách các animation cho từng level
  final List<Animation<double>> _levelAnimations = [];
  
  // Danh sách để theo dõi các level đã phát âm thanh
  final Set<int> _playedSoundForLevels = {};

  @override
  void initState() {
    super.initState();
    
    // Controller cho animation toàn màn hình
    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    // Controller cho animation grid các level
    _gridController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    // Thêm listener cho _gridController để phát âm thanh khi các level xuất hiện
    _gridController.addListener(() {
      for (int i = 0; i < Constants.totalLevel; i++) {
        // Chỉ phát âm thanh khi animation đạt đến ngưỡng và chưa phát âm thanh cho level này
        if (_levelAnimations[i].value > 0.1 && !_playedSoundForLevels.contains(i)) {
          _playedSoundForLevels.add(i);
          audioManager.playSoundEffect(SoundEffect.levelAppear);
          // Dừng vòng lặp sau khi phát âm thanh cho một level
          break; // Chỉ phát một âm thanh mỗi lần để tránh chồng chéo
        }
      }
    });
    
    // Animation cho màn hình
    _screenScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _screenController, curve: Curves.easeOutBack),
    );
    
    _screenOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _screenController, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)),
    );
    
    // Animation cho số sao
    _starsCounterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _screenController, curve: const Interval(0.6, 1.0, curve: Curves.easeOut)),
    );
    
    // Tạo animation cho từng level với thời gian delay khác nhau
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
    
    // Bắt đầu các animation
    _screenController.forward();
    _gridController.forward();
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
      builder: (context, child) {
        return FadeTransition(
          opacity: _screenOpacityAnimation,
          child: ScaleTransition(
            scale: _screenScaleAnimation,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 200, vertical: 100),
                    child: GridView.builder(
                      itemCount: Constants.totalLevel,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 70,
                        mainAxisSpacing: 32,
                      ),
                      itemBuilder: (_, int index) {
                        int level = index + 1;
                        bool isLocked = !widget.model.unlockedLevels.contains(level);
                        int star = widget.model.levelStars.values.elementAt(index);
                        
                        // Áp dụng animation cho từng level
                        return Transform.scale(
                          scale: _levelAnimations[index].value.clamp(0.0, 1.0),
                          child: Transform.rotate(
                            angle: (1.0 - _levelAnimations[index].value.clamp(0.0, 1.0)) * math.pi / 10,
                            child: Opacity(
                              opacity: _levelAnimations[index].value.clamp(0.0, 1.0),
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
                                          (index + 1).toString(),
                                          style: theme.textTheme.headlineMedium,
                                        )
                                      ],
                                    ),
                                ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Animation cho số sao
                Positioned(
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
                ),
                // Animation cho nút âm thanh
                Positioned(
                  left: 24,
                  bottom: 16,
                  child: FadeTransition(
                    opacity: _starsCounterAnimation,
                    child: ScaleTransition(
                      scale: _starsCounterAnimation,
                      child: IconButton(
                        onPressed: () => widget.onChangeSound(),
                        highlightColor: Colors.transparent,
                        icon: Image.asset(
                          ImagePath.icSoundOn,
                          width: 32,
                        ),
                      ),
                    ),
                  ),
                ),
                // Animation cho nút home
                Positioned(
                  right: 24,
                  bottom: 16,
                  child: FadeTransition(
                    opacity: _starsCounterAnimation,
                    child: ScaleTransition(
                      scale: _starsCounterAnimation,
                      child: IconButton(
                        onPressed: () {
                          audioManager.playSoundEffect(SoundEffect.buttonClick);
                          widget.onBackHome();
                        },
                        icon: Image.asset(
                          ImagePath.icHome,
                          width: 32,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
