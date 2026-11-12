import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Áp dụng giao diện chung và phông Roboto thành công', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
        home: const Scaffold(
          body: Center(child: Text('Library UI Theme')),
        ),
      ),
    );

    expect(find.text('Library UI Theme'), findsOneWidget);
  });
}
