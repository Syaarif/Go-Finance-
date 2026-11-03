import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_finance/screens/splash_screen.dart';
import 'package:go_finance/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const GoFinanceApp());
}

class GoFinanceApp extends StatelessWidget {
  const GoFinanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Finance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      builder: (context, child) {
        // Pada versi Web: Kunci canvas ke rasio presisi Figma iPhone (402 x 874).
        // Dengan FittedBox, canvas otomatis menyesuaikan (scale) tinggi & lebar layar browser
        // secara proporsional sempurna tanpa ada teks yang terpotong atau tertutup kartu putih!
        if (kIsWeb) {
          return Container(
            color: const Color(0xFF142211), // Background gelap mewah untuk presentasi
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: Container(
                width: 402,
                height: 874,
                decoration: BoxDecoration(
                  color: AppTheme.backgroundGreen,
                  borderRadius: BorderRadius.circular(48),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x99000000),
                      blurRadius: 45,
                      spreadRadius: 2,
                      offset: Offset(0, 20),
                    ),
                  ],
                  border: Border.all(
                    color: const Color(0xFF22361B),
                    width: 7,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: child ?? const SizedBox.shrink(),
              ),
            ),
          );
        }
        return child ?? const SizedBox.shrink();
      },
      home: const SplashScreen(),
    );
  }
}
