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
import '../preference/user_reference.dart';
import '../theme/app_colors.dart';
import '../utilities/route_transitions.dart';
import '../utilities/audio_manager.dart';
import '../widget/tutorial_dialog.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) changeLanguage;
  final bool showMenu;

  const HomeScreen({
    super.key,
    required this.changeLanguage,
    this.showMenu = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen> with SingleTickerProviderStateMixin {
  final _audioManager = injector.get<AudioManager>();
  final _bloc = injector.get<HomeBloc>();
  bool _isFirstTime = true;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _titleAnimation;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _bloc.add(LoadData(showMenu: widget.showMenu));
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final userReference = injector.get<UserReference>();
    final isFirstTime = await userReference.getIsFirstTime();
    if (isFirstTime == null || isFirstTime == true) {
      await userReference.setIsFirstTime(false);
      setState(() {
        _isFirstTime = true;
      });
    } else {
      setState(() {
        _isFirstTime = false;
      });
    }
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _titleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutBack),
      ),
    );

    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showTutorial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const TutorialDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ImagePath.background),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocProvider(
          create: (context) => _bloc,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: _buildContent,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, HomeState state) {
    if (state is! HomeLoaded) return const SizedBox();

    return Stack(
      children: [
        state.model.isDataLevelShow ? _buildLevelMenu(state) : _buildHomeScreen(),
        _buildTopControls(),
        _buildBottomControls(state),
      ],
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      right: 24,
      top: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: _buildLanguageButton(),
        ),
      ),
    );
  }

  Widget _buildBottomControls(HomeLoaded state) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildSoundButton(),
              ),
            ),
            FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: _buildMenuButton(state),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelMenu(HomeLoaded state) {
    return MenuLevelScreen(
      model: state.model,
      onChangeSound: () {},
      onBackHome: () {},
      onSelectLevel: (level) => _navigateToGame(level: level),
    );
  }

  Widget _buildHomeScreen() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Image.asset(
                ImagePath.buttonBack,
                width: 140,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -70),
            child: _buildGameTitle(),
          ),
          _buildPlayButton(),
          Transform.translate(
            offset: const Offset(0, 35),
            child: GestureDetector(
              onTap: _showTutorial,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.help,
                  color: AppColors.iconIconColor,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameTitle() {
    return FadeTransition(
      opacity: _titleAnimation,
      child: ScaleTransition(
        scale: _titleAnimation,
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
              style: theme.textTheme.displayLarge?.copyWith(
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayButton() {
    return FadeTransition(
      opacity: _buttonAnimation,
      child: ScaleTransition(
        scale: _buttonAnimation,
        child: IconButton(
          onPressed: () => _navigateToGame(),
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                ImagePath.icBtnTheme,
                width: 100,
              ),
              Transform.translate(
                offset: const Offset(0, -2),
                child: Text(
                  appLocalizations.play,
                  style: theme.textTheme.headlineSmall?.copyWith(color: AppColors.iconTextColor),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(HomeLoaded state) {
    return IconButton(
      onPressed: () {
        _audioManager.playSoundEffect(SoundEffect.buttonClick);
        _bloc.add(ShowDataLevel(isShow: !state.model.isDataLevelShow));
      },
      icon: Image.asset(
        state.model.isDataLevelShow ? ImagePath.icHome : ImagePath.icMenuLevel,
        width: 32,
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: _showLanguageDialog,
      icon: const Icon(
        Icons.settings,
        color: AppColors.mainTextColor,
        size: 28,
      ),
    );
  }

  Widget _buildSoundButton() {
    return IconButton(
      onPressed: _showSoundDialog,
      icon: Image.asset(
        ImagePath.icSoundOn,
        width: 32,
      ),
    );
  }

  void _navigateToGame({int? level}) {
    _audioManager.playSoundEffect(SoundEffect.buttonClick);

    Navigator.pushReplacement(
      context,
      AppRouteTransitions.fadeScale(
        page: GameScreen(
          level: level,
          shouldShowTutorial: _isFirstTime,
        ),
      ),
    );

    if (_isFirstTime) {
      setState(() {
        _isFirstTime = false;
      });
    }
  }

  Future<void> _showLanguageDialog() async {
    _audioManager.playSoundEffect(SoundEffect.buttonClick);
    final currentLanguageCode = Localizations.localeOf(context).languageCode;
    final newLanguageCode = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => LanguageSettingsDialog(
        currentLanguageCode: currentLanguageCode,
      ),
    );

    if (newLanguageCode != null) {
      widget.changeLanguage(newLanguageCode);
    }
  }

  Future<void> _showSoundDialog() async {
    _audioManager.playSoundEffect(SoundEffect.buttonClick);
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => SoundSettingsDialog(
        backgroundVolume: _audioManager.backgroundVolume,
        effectVolume: _audioManager.effectVolume,
      ),
    );
  }
}
