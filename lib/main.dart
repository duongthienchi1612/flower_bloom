import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'constants.dart';
import 'preference/language_preference.dart';
import 'preference/user_reference.dart';
import 'screen/home_screen.dart';
import 'splash_screen.dart';
import 'theme/app_text_theme.dart';
import 'utilities/localization_helper.dart';
import 'utilities/route_transitions.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Lấy ngôn ngữ từ LanguagePreference, nếu không có thì lấy từ UserReference
  String initialLanguage = await LanguagePreference.getLanguageCode() ?? await UserReference().getLanguage() ?? 'vi';

  runApp(MyApp(initialLanguage: initialLanguage));
  initLocalization();
}

void initLocalization() {
  final context = navigatorKey.currentContext;
  if (context != null) {
    LocalizationHelper.init(AppLocalizations.of(context)!);
  } else {
    Future.delayed(Duration.zero, initLocalization);
  }
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
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => const SplashScreen(),
          );
        } else if (settings.name == ScreenName.home) {
          // Lấy tham số showMenu nếu có
          final showMenu = settings.arguments as bool?;

          return AppRouteTransitions.fadeScale(
            page: HomeScreen(
              changeLanguage: _changeLanguage,
              showMenu: showMenu,
            ),
            duration: const Duration(milliseconds: 800),
          );
        }
        return null;
      },
    );
  }
}
