import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/providers/theme_provider.dart';
import 'package:go_finance/core/utils/date_locale_init.dart';
import 'package:go_finance/l10n/generated/app_localizations.dart';
import 'package:go_finance/features/bills/providers/bill_provider.dart';
import 'package:go_finance/features/savings/providers/savings_provider.dart';
import 'package:go_finance/features/transactions/providers/transaction_provider.dart';
import 'package:go_finance/features/bills/services/notification_service.dart';
import 'package:go_finance/screens/splash_screen.dart';
import 'package:go_finance/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = await ThemeProvider.load();
  await initializeIndonesianDateFormatting();
  await NotificationService.instance.init();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(GoFinanceApp(themeProvider: themeProvider));
}

class GoFinanceApp extends StatelessWidget {
  final ThemeProvider themeProvider;

  const GoFinanceApp({super.key, required this.themeProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BillProvider>(create: (_) => BillProvider()),
        ChangeNotifierProvider<SavingsProvider>(
            create: (_) => SavingsProvider()),
        ChangeNotifierProvider<TransactionProvider>(
          lazy: false,
          create: (_) => TransactionProvider(),
        ),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, _) => MaterialApp(
          title: 'Go Finance',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: theme.themeMode,
          locale: theme.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('id', 'ID'),
            Locale('en', 'US'),
          ],
          builder: (context, child) {
            final systemScale = MediaQuery.textScalerOf(context).scale(1);
            final scale = (systemScale * theme.textScale).clamp(0.0, 1.4);
            final mediaQuery = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQuery.copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            );
          },
          home: const SplashScreen(),
        ),
      ),
    );
  }
}