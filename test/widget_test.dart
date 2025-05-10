import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_app/app.dart'; // Đúng file chứa SocialApp

void main() {
  testWidgets('App launches and shows expected widget', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SocialApp(),
      ),
    );

    // Thay dòng dưới bằng widget thực sự bạn muốn test (ví dụ một tiêu đề, nút, v.v.)
    expect(find.text('Welcome'), findsOneWidget); // Ví dụ có chữ "Welcome" ở Home
  });
}
