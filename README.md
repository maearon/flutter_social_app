# flutter_social_app

A new Flutter project.

```
flutter devices
flutter run -d emulator-5554
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

```
✅ Danh sách file/folder cần đẩy lên V0:
✅ Nên giữ lại	📄 Ghi chú
lib/	Chứa toàn bộ source code chính. Đặc biệt bạn cần giữ lib/ chứ không chỉ main.dart.
pubspec.yaml	File cấu hình khai báo dependency (giống package.json trong Node.js). Bắt buộc để chạy app.
pubspec.lock	Giữ phiên bản chính xác của các package. Không bắt buộc nhưng nên có để người khác chạy giống bạn.
android/	Cấu hình để build Android (bao gồm SDK info, launcher icon, app name...). Cần thiết nếu deploy.
ios/	Cấu hình iOS. Nếu không cần build iOS thì có thể bỏ qua.
test/	Các unit/integration test. Nếu có test thì nên giữ.
README.md	Nếu có mô tả project hoặc hướng dẫn chạy thì nên giữ.
.gitignore	Giúp không đẩy các file tạm (cache, build...) khi commit. Không bắt buộc nhưng tốt.
```

```
Please analyze the React Native TypeScript project located in the `react-native-boilerplate` directory on the right.

Then, generate a fully functional Flutter (Dart) application that replicates the entire functionality, structure, and UI behavior of this React Native app as closely as possible.

Requirements:

- The resulting Flutter app should implement the same screen structure and navigation flow as found in `react-native-boilerplate/src/screens`.
- Replicate all Zustand-based state management logic using equivalent solutions in Flutter (e.g., Riverpod, Provider, or Bloc).
- Replicate Ky-based API calls using `http`, `dio`, or any modern Flutter HTTP client.
- Ensure API behavior is preserved:
  - Automatically call the `/refresh` API endpoint on receiving a 401 Unauthorized response.
  - Call the `/revoke` API endpoint when the user logs out.
- Recreate all screens using Flutter's mobile-friendly widgets and layouts.
- Ensure all UI is fully optimized for mobile usage:
  - Safe area handling
  - Scrollable content
  - Touch-friendly UI
  - Navigation using `go_router`, `auto_route`, or other best-practice solutions
- The entire app must be in English only. Do not include Vietnamese or other languages.

You may create any necessary files, folders, or packages inside the `flutter_social_app` directory. Use Dart and Flutter best practices throughout the generated codebase.

Thank you!
```