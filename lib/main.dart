import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'l10n/app_localizations.dart';
import 'screens/events_screen.dart';
import 'services/ad_gate.dart';
import 'services/exchange_events_service.dart';
import 'services/exchange_referral.dart';
import 'services/push_notification_service.dart';
import 'theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final apiBase = ExchangeEventsService.productionApiBaseUrl;
  await Future.wait([
    AdGate.initialize(apiBase),
    ExchangeReferral.load(apiBaseUrl: apiBase),
    PushNotificationService.instance.initialize(),
  ]);
  runApp(const ExoraApp());
}

class ExoraApp extends StatelessWidget {
  const ExoraApp({super.key, this.eventsService});

  final ExchangeEventsService? eventsService;

  @override
  Widget build(BuildContext context) {
    final base =
        ColorScheme.fromSeed(
          seedColor: AppColors.brand,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.brand,
          onPrimary: Colors.white,
          surface: AppColors.card,
          onSurface: AppColors.ink,
        );

    const textTheme = TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        height: 1.3,
        color: AppColors.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        height: 1.35,
        color: AppColors.ink,
      ),
      bodyLarge: TextStyle(fontSize: 16, height: 1.45, color: AppColors.ink),
      bodyMedium: TextStyle(fontSize: 15, height: 1.45, color: AppColors.ink),
      bodySmall: TextStyle(fontSize: 13, height: 1.4, color: AppColors.muted),
      labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );

    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      debugShowCheckedModeBanner: false,
      // Keep designed type sizes; ignore OS accessibility text scaling.
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: base,
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.page,
        textTheme: textTheme,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: AppColors.card,
          foregroundColor: AppColors.ink,
          elevation: 0,
          scrolledUnderElevation: 0.5,
          titleTextStyle: TextStyle(
            color: AppColors.ink,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        chipTheme: ChipThemeData(
          selectedColor: AppColors.brand,
          backgroundColor: AppColors.chipIdle,
          disabledColor: AppColors.chipIdle,
          side: const BorderSide(color: AppColors.line),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.muted,
          ),
          secondaryLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: AppColors.line),
          ),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.brand,
          foregroundColor: Colors.white,
        ),
      ),
      home: EventsScreen(service: eventsService),
    );
  }
}
