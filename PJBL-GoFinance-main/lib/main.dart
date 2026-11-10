import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/utils/date_locale_init.dart';
import 'package:go_finance/features/bills/providers/bill_provider.dart';
import 'package:go_finance/features/transactions/providers/transaction_provider.dart';
import 'package:go_finance/features/bills/services/notification_service.dart';
import 'package:go_finance/screens/splash_screen.dart';
import 'package:go_finance/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
  runApp(const GoFinanceApp());
}

class GoFinanceApp extends StatelessWidget {
  const GoFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BillProvider>(create: (_) => BillProvider()),
        ChangeNotifierProvider<TransactionProvider>(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'Go Finance',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
