import 'package:flower_bloom/bloc/home_bloc/home_bloc.dart';
import 'package:flower_bloom/model/view/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

class _MenuLevelScreenState extends BaseState<MenuLevelScreen> {
  final audioManager = injector.get<AudioManager>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 200, vertical: 100),
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
                return isLocked
                    ? Transform.translate(
                        offset: Offset(0, 10),
                        child: Image.asset(ImagePath.icLevelLock),
                      )
                    : GestureDetector(
                      onTap: () => widget.onSelectLevel(level),
                      child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.translate(
                              offset: Offset(0, 10),
                              child: Image.asset(ImagePath.icLevelNumber),
                            ),
                            Transform.translate(
                              offset: Offset(0, 31),
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
                    );
              },
            ),
          ),
        ),
        Positioned(
          left: 32,
          top: 24,
          child: Row(
            children: [
              Image.asset(
                ImagePath.icStarActive,
                width: 32,
              ),
              SizedBox(width: 8),
              Text(
                '${widget.model.currentStars} / ${widget.model.totalStars}',
                style: theme.textTheme.headlineMedium,
              )
            ],
          ),
        ),
        Positioned(
          left: 24,
          bottom: 16,
          child: IconButton(
            onPressed: () => widget.onChangeSound(),
            highlightColor: Colors.transparent,
            icon: Image.asset(
              widget.model.isSoundOn ? ImagePath.icSoundOn : ImagePath.icSoundOff,
              width: 32,
            ),
          ),
        ),
        Positioned(
          right: 24,
          bottom: 16,
          child: IconButton(
            onPressed: () {
              audioManager.playSoundEffect(SoundEffect.buttonClick);
              widget.onBackHome;
            },
            icon: Image.asset(
              ImagePath.icHome,
              width: 32,
            ),
          ),
        )
      ],
    );
  }
}
