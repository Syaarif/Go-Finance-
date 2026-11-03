import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_finance/screens/profile_screen.dart';

/// Memastikan semua ikon menu Profil terdaftar di pubspec dan bisa di-decode.
void main() {
  const icons = [
    'assets/icons/email.png',
    'assets/icons/timezone_globe.png',
    'assets/icons/security.png',
    'assets/icons/light.png',
    'assets/icons/font_size.png',
    'assets/icons/language.png',
    'assets/icons/notification.png',
  ];

  for (final path in icons) {
    testWidgets('ikon dapat dimuat: $path', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(home: Scaffold(body: Center(child: SettingsIcon(path)))),
        );
        final element = tester.element(find.byType(Image));
        final image = tester.widget<Image>(find.byType(Image));

        Object? loadError;
        await precacheImage(image.image, element, onError: (e, _) => loadError = e);
        expect(loadError, isNull, reason: 'Gagal memuat $path');
      });

      await tester.pump();
      final size = tester.getSize(find.byType(Image));
      expect(size, const Size(24, 24));
    });
  }
}

