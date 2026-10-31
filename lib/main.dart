import 'package:flutter/material.dart';

import 'screens/events_screen.dart';
import 'services/exchange_events_service.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoinInfoApp());
}

class CoinInfoApp extends StatelessWidget {
  const CoinInfoApp({super.key, this.eventsService});

  final ExchangeEventsService? eventsService;

  @override
  Widget build(BuildContext context) {
    final base = ColorScheme.fromSeed(
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
      title: 'CoinInfo',
      debugShowCheckedModeBanner: false,
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
          backgroundColor: AppColors.card,
          side: const BorderSide(color: AppColors.line),
          labelStyle: const TextStyle(fontWeight: FontWeight.w700),
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
