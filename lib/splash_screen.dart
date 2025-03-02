import 'package:flower_bloom/utilities/audio_manager.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'dependencies.dart';
import 'preference/user_reference.dart';
import 'package:lottie/lottie.dart';

import 'utilities/audio_manager.dart';
import 'utilities/game_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _initializeDependencies() async {
    await AppDependencies.initialize();

    final audioManager = injector.get<AudioManager>();
    
    await audioManager.init();
    await audioManager.playBackgroundMusic();

    // get reference data;
    final gameStorage = injector.get<GameStorage>();
        // await gameStorage.resetData();
    gameStorage.initGameData(Constants.totalLevel);
  }

  Future<void> timeSplashScreen() async {
    await Future.wait(
      [_initializeDependencies(), Future.delayed(const Duration(seconds: 1))],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: timeSplashScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Colors.white,
              child: SafeArea(
                child: Center(),
              ),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, ScreenName.home);
            });
            return Container();
          }
        });
  }
}
