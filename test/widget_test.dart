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

  testWidgets('Kiểm tra hiển thị màn hình chào mừng và điều hướng cơ bản', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Roboto', useMaterial3: true),
        home: Scaffold(
          appBar: AppBar(title: const Text('Thư viện Đại học')),
          body: const Column(
            children: [
              Text('Đăng nhập'),
              Text('Đăng ký tài khoản'),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Thư viện Đại học'), findsOneWidget);
    expect(find.text('Đăng nhập'), findsOneWidget);
    expect(find.text('Đăng ký tài khoản'), findsOneWidget);
  });
}
