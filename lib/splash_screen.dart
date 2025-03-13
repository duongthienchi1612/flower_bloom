import 'package:flower_bloom/screen/home_screen.dart';
import 'package:flower_bloom/utilities/audio_manager.dart';
import 'package:flower_bloom/utilities/route_transitions.dart';
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

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // Khởi tạo animation controller cho thanh loading
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    
    _loadingAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );
    
    // Bắt đầu animation loading
    _loadingController.forward();
  }
  
  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
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
      [_initializeDependencies(), Future.delayed(const Duration(milliseconds: 1800))],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: timeSplashScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagePath.background),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Chữ Loading
                        Text(
                          'Loading',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        SizedBox(height: 20),
                        // Thanh loading
                        AnimatedBuilder(
                          animation: _loadingAnimation,
                          builder: (context, child) {
                            // Hiển thị hình ảnh loading dựa vào giá trị animation
                            double opacity0 = 0.0;
                            double opacity50 = 0.0;
                            double opacity100 = 0.0;
                            
                            if (_loadingAnimation.value < 0.35) {
                              opacity0 = 1.0;
                            } else if (_loadingAnimation.value < 0.75) {
                              opacity50 = 1.0;
                            } else {
                              opacity100 = 1.0;
                            }
                            
                            return SizedBox(
                              width: 200,
                              height: 30,
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: opacity0,
                                    child: Image.asset(
                                      ImagePath.imgLoading0,
                                      width: 200,
                                      height: 30,
                                    ),
                                  ),
                                  Opacity(
                                    opacity: opacity50,
                                    child: Image.asset(
                                      ImagePath.imgLoading50,
                                      width: 200,
                                      height: 30,
                                    ),
                                  ),
                                  Opacity(
                                    opacity: opacity100,
                                    child: Image.asset(
                                      ImagePath.imgLoading100,
                                      width: 200,
                                      height: 30,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacement(
                context, 
                AppRouteTransitions.fadeScale(
                  page: HomeScreen(),
                  duration: Duration(milliseconds: 800),
                ),
              );
            });
            return Container();
          }
        });
  }
}
