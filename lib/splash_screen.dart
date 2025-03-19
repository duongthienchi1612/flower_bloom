import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'dependencies.dart';
import 'preference/user_reference.dart';

import 'utilities/game_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;
  final bool _startFadeOut = false;

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

    // Bắt đầu quá trình khởi tạo
    _startInitialization();
  }

  Future<void> _startInitialization() async {
    await timeSplashScreen();
    
    // Đảm bảo setState chỉ được gọi sau khi build hoàn tất
    if (mounted) {
      setState(() {
      });
      
      // Chuyển trang ngay lập tức mà không cần fade out
      Navigator.pushReplacementNamed(context, ScreenName.home);
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  Future<void> _initializeDependencies() async {
    // Kiểm tra xem dependencies đã được khởi tạo chưa
    if (!injector.isRegistered<UserReference>()) {
      await AppDependencies.initialize();
    }

    // get reference data;
    final gameStorage = injector.get<GameStorage>();
    gameStorage.initGameData(Constants.totalLevel);

    final userReference = injector.get<UserReference>();
    final isFirstTime = await userReference.getIsFirstTime();
    if (isFirstTime == null) {
      await userReference.setIsFirstTime(true);
    }
  }

  Future<void> timeSplashScreen() async {
    await Future.wait(
      [_initializeDependencies(), Future.delayed(const Duration(milliseconds: 1800))],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedOpacity(
        opacity: _startFadeOut ? 0.0 : 1.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          decoration: const BoxDecoration(
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
                    'LOADING...',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
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
      ),
    );
  }
}
