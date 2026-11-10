import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ung_dung_dat_muon_sach_thu_vien/app.dart';

void main() {
  testWidgets('Khoi dong ung dung va chuyen ngon ngu', (tester) async {
    await tester.pumpWidget(const LibraryApp());
    await tester.pumpAndSettle();

    expect(
      find.text('Chào mừng đến thư viện'),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const Key('change-language-button')),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Welcome to the library'),
      findsOneWidget,
    );
  });
}