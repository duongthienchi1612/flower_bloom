import 'package:flower_bloom/bloc/home_bloc/home_bloc.dart';
import 'package:flower_bloom/constants.dart';
import 'package:flower_bloom/dependencies.dart';
import 'package:flower_bloom/screen/flower_game_screen.dart';
import 'package:flower_bloom/screen/menu_level_screen.dart';
import 'package:flower_bloom/widget/base/base_widget.dart';
import 'package:flower_bloom/widget/sound_settings_dialog.dart';
import 'package:flower_bloom/widget/language_settings_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/app_colors.dart';
import '../utilities/route_transitions.dart';

import '../utilities/audio_manager.dart';

class HomeScreen extends StatefulWidget {
  final Function(String)? changeLanguage;
  final bool? showMenu;
  const HomeScreen({Key? key, this.changeLanguage, this.showMenu}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> {
  final audioManager = injector.get<AudioManager>();
  final bloc = injector.get<HomeBloc>();

  @override
  void initState() {
    super.initState();
    bloc.add(LoadData(showMenu: widget.showMenu));
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
          create: (context) => bloc,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoaded) {
                return Stack(
                  children: [
                    state.model.isDataLevelShow
                        ? MenuLevelScreen(
                            model: state.model,
                            onChangeSound: () {},
                            onBackHome: () {},
                            onSelectLevel: (level) {
                              audioManager.playSoundEffect(SoundEffect.buttonClick);
                              Navigator.pushReplacement(
                                context,
                                AppRouteTransitions.fadeScale(
                                  page: GameScreen(level: level),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  ImagePath.buttonBack,
                                  width: 140,
                                ),
                                Transform.translate(
                                  offset: const Offset(0, -70),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Transform.translate(
                                        offset: const Offset(0, 8),
                                        child: Image.asset(
                                          ImagePath.back,
                                          width: 300,
                                        ),
                                      ),
                                      Image.asset(
                                        ImagePath.nameBack,
                                        width: 180,
                                      ),
                                      Text(
                                        'B L O O M',
                                        style: theme.textTheme.displayLarge,
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    audioManager.playSoundEffect(SoundEffect.buttonClick);
                                    Navigator.pushReplacement(
                                      context,
                                      AppRouteTransitions.fadeScale(
                                        page: const GameScreen(),
                                      ),
                                    );
                                  },
                                  highlightColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  icon: Image.asset(
                                    ImagePath.icPlayText,
                                    width: 100,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    Positioned(
                      right: 24,
                      top: 16,
                      child: _buildLanguageButton(),
                    ),
                    Positioned(
                      left: 24,
                      bottom: 16,
                      child: _buildSoundButton(),
                    ),
                    Positioned(
                      right: 24,
                      bottom: 16,
                      child: IconButton(
                        onPressed: () {
                          audioManager.playSoundEffect(SoundEffect.buttonClick);
                          bloc.add(ShowDataLevel(isShow: !state.model.isDataLevelShow));
                        },
                        icon: Image.asset(
                          state.model.isDataLevelShow ? ImagePath.icHome : ImagePath.icMenuLevel,
                          width: 32,
                        ),
                      ),
                    )
                  ],
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () async {
        audioManager.playSoundEffect(SoundEffect.buttonClick);
        final currentLanguageCode = Localizations.localeOf(context).languageCode;
        final newLanguageCode = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (context) => LanguageSettingsDialog(
            currentLanguageCode: currentLanguageCode,
          ),
        );

        if (newLanguageCode != null && widget.changeLanguage != null) {
          widget.changeLanguage!(newLanguageCode);
        }
      },
      icon: const Icon(
        Icons.settings,
        color: AppColors.mainTextColor,
        size: 28,
      ),
    );
  }

  Widget _buildSoundButton() {
    return IconButton(
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
      icon: Image.asset(
        ImagePath.icSoundOn,
        width: 32,
      ),
    );
  }
}
