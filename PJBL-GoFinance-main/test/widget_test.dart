import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_finance/core/utils/date_locale_init.dart';
import 'package:go_finance/features/bills/pages/bills_page.dart';
import 'package:go_finance/features/bills/providers/bill_provider.dart';
import 'package:go_finance/screens/login_screen.dart';
import 'package:go_finance/screens/onboarding_screen.dart';
import 'package:go_finance/screens/register_screen.dart';

void main() {
  setUpAll(() async {
    await initializeIndonesianDateFormatting();
  });

  testWidgets(
      'BillsPage tampil tanpa overflow pada ukuran 393x852 dan memfilter tanggal',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final provider = BillProvider(initialToday: DateTime(2026, 11, 3));

    await tester.pumpWidget(
      ChangeNotifierProvider<BillProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: BillsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Judul & 3 data awal tampil
    expect(find.text('Kalender Tagihan'), findsOneWidget);
    expect(find.text('Internet rumah'), findsOneWidget);
    expect(find.text('Listrik'), findsOneWidget);
    expect(find.text('Streaming'), findsOneWidget);

    // Filter ke tanggal 5 Nov (hanya Internet rumah)
    provider.toggleDateSelection(DateTime(2026, 11, 5));
    await tester.pumpAndSettle();
    expect(find.text('Internet rumah'), findsOneWidget);
    expect(find.text('Listrik'), findsNothing);

    // Reset filter ("Lihat semua")
    await tester.tap(find.byKey(const Key('btn_reset_date_filter')));
    await tester.pumpAndSettle();
    expect(find.text('Listrik'), findsOneWidget);

    // Tandai selesai satu tagihan -> hilang dari daftar
    await provider.markAsDone('bill_internet_rumah');
    await tester.pumpAndSettle();
    expect(find.text('Internet rumah'), findsNothing);
    expect(provider.hasUnpaidBillOn(DateTime(2026, 11, 5)), isFalse);
  });

  testWidgets(
      'Alur mobile Onboarding -> Login -> BillsPage -> Profile berjalan tanpa overflow',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(393, 852));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final provider = BillProvider(initialToday: DateTime(2026, 11, 3));

    await tester.pumpWidget(
      ChangeNotifierProvider<BillProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );
    // Majukan waktu agar delay StaggeredFadeSlide (380ms) dan durasi animasi (500ms) selesai
    await tester.pump(const Duration(milliseconds: 450));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Go Finance'), findsOneWidget);
    expect(find.text('Daftar'), findsOneWidget);

    // Pindah ke RegisterScreen dari tombol Daftar
    await tester.tap(find.text('Daftar'));
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.byType(RegisterScreen), findsOneWidget);

    // Pindah ke LoginScreen
    await tester.pumpWidget(
      ChangeNotifierProvider<BillProvider>.value(
        value: provider,
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 600));

    // Isi email dan password lalu tekan Masuk
    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));
    await tester.enterText(textFields.at(0), 'user@gofinance.id');
    await tester.enterText(textFields.at(1), 'password123');
    await tester.tap(find.text('Masuk'));
    await tester.pumpAndSettle();

    // Berhasil masuk ke BillsPage
    expect(find.text('Kalender Tagihan'), findsOneWidget);

    // Buka halaman Profil & Pengaturan dari header BillsPage
    await tester.tap(find.byKey(const Key('btn_open_profile')));
    await tester.pumpAndSettle();
    expect(find.text('Profil & Pengaturan'), findsOneWidget);
  });
}
