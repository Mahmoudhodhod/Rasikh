import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/theme.dart';
import 'features/auth/screen/login_options_screen.dart';
import 'features/auth/screen/login_screen.dart';
import 'features/auth/screen/onboarding_screen.dart';
import 'features/auth/screen/register_screen.dart';
import 'features/contact_us/contact_screen.dart';
import 'features/home/home_screen.dart';
import 'features/profile/profile_screen.dart';
import 'l10n/app_localizations.dart';
import 'features/auth/repository/auth_repository.dart'
    hide secureStorageProvider;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String loginOptions = '/login-options';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String contactUs = '/contact-us';
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});
final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());
final initialAppStateProvider = FutureProvider<String>((ref) async {
  final prefs = ref.read(sharedPreferencesProvider);
  final secureStorage = ref.read(secureStorageProvider);

  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
  final token = await secureStorage.read(key: 'auth_token');
  final isGuest = await secureStorage.read(key: 'is_guest') == 'true';

  if (!hasSeenOnboarding) {
    return AppRoutes.onboarding;
  } else if ((token != null && token.isNotEmpty) || isGuest) {
    return AppRoutes.home;
  } else {
    return AppRoutes.loginOptions;
  }
});

final localeProvider = StateProvider<Locale>((ref) {
  return const Locale('ar');
});
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();

  FlutterError.onError = (FlutterErrorDetails details) {
    debugPrint('═══ FLUTTER ERROR ═══');
    debugPrint('${details.exception}');
    debugPrint('${details.stack}');
    debugPrint('═══════════════════');
  };

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyAppLoader(),
    ),
  );
}

class MyAppLoader extends ConsumerWidget {
  const MyAppLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStateAsync = ref.watch(initialAppStateProvider);
    final authState = ref.watch(authStateProvider);

    if (authState == AuthStatus.unknown) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    return appStateAsync.when(
      data: (initialRoute) {
        return MyApp(initialRoute: initialRoute);
      },
      loading: () => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (err, stack) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Center(child: Text('Error loading app'))),
      ),
    );
  }
}

class MyApp extends ConsumerWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'Rasikh',

      locale: currentLocale,
      supportedLocales: const [Locale('en', ''), Locale('ar', '')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      builder: (context, child) {
        if (child == null) return const SizedBox.shrink();
        if (AppLocalizations.of(context) == null) {
          return const Directionality(
            textDirection: TextDirection.rtl,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final textScale = MediaQuery.of(
          context,
        ).textScaleFactor.clamp(0.9, 1.1);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: textScale),
          child: child,
        );
      },

      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        final routes = <String, WidgetBuilder>{
          AppRoutes.onboarding: (context) => const OnboardingScreen(),
          AppRoutes.loginOptions: (context) => const LoginOptionsScreen(),
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.register: (context) => const RegisterScreen(),
          AppRoutes.profile: (context) => const ProfileScreen(),
          AppRoutes.contactUs: (context) =>
              const ContactUsScreen(isLoggedIn: false),
        };

        final routeName = settings.name ?? initialRoute;
        final builder = routes[routeName];
        if (builder == null) {
          return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Page not found'))),
          );
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (context) {
            if (AppLocalizations.of(context) == null) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return builder(context);
          },
        );
      },
    );
  }
}
