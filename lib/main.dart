import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:window_manager/window_manager.dart';

import 'constants.dart';
import 'preference/language_preference.dart';
import 'preference/user_reference.dart';
import 'screen/home_screen.dart';
import 'splash_screen.dart';
import 'theme/app_text_theme.dart';
import 'utilities/route_transitions.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Kiểm tra nếu không chạy trên web thì thiết lập định hướng landscape
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  } else {
    // Đối với web, thiết lập SystemUI để tối ưu trải nghiệm
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  // Cài đặt kích thước cửa sổ tối thiểu cho desktop
  if (!kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux)) {
    await windowManager.ensureInitialized();
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1024, 600),
      minimumSize: Size(800, 480),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
      title: 'Flower Bloom',
    );
    
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  // Lấy ngôn ngữ từ LanguagePreference, nếu không có thì lấy từ UserReference
  String initialLanguage = await LanguagePreference.getLanguageCode() ?? await UserReference().getLanguage() ?? 'en';

  runApp(MyApp(initialLanguage: initialLanguage));
}

class MyApp extends StatefulWidget {
  final String initialLanguage;
  const MyApp({super.key, required this.initialLanguage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = Locale(widget.initialLanguage);
  }

  void _changeLanguage(String languageCode) async {
    // Lưu ngôn ngữ vào cả hai nơi
    await LanguagePreference.setLanguageCode(languageCode);

    setState(() {
      _locale = Locale(languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      locale: _locale,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        textTheme: AppTextTheme.textTheme,
        scaffoldBackgroundColor: Colors.transparent,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              const SplashScreen(),
            transitionDuration: Duration.zero,
          );
        } else if (settings.name == ScreenName.home) {
          // Lấy tham số showMenu nếu có
          final showMenu = settings.arguments as bool?;

          return AppRouteTransitions.fadeScale(
            page: HomeScreen(
              changeLanguage: _changeLanguage,
              showMenu: showMenu ?? false,
            ),
            duration: const Duration(milliseconds: 600),
          );
        }
        return null;
      },
    );
  }
}
