# Flutter Social App Implementation

I've created a comprehensive Flutter application that replicates the functionality, structure, and UI behavior of the React Native app. The Flutter app follows modern Flutter development practices and includes all the features from the original app.

## Key Features Implemented

1. **State Management**

1. Used Riverpod for state management, replacing Zustand
2. Implemented proper authentication state handling with token management



2. **API Communication**

1. Used Dio for API calls, replacing Ky
2. Implemented automatic token refresh on 401 errors
3. Added token revocation on logout



3. **Navigation**

1. Implemented navigation using go_router
2. Created a comprehensive routing system with protected routes



4. **Screens**

1. Home screen with micropost feed
2. User profile and edit screens
3. Authentication screens (login, signup)
4. Password reset and account activation
5. Static pages (about, contact)



5. **Components**

1. Reusable widgets for common UI elements
2. Micropost form and item components
3. User info and stats components
4. Follow button component



6. **Security**

1. Secure storage for tokens
2. Proper error handling
3. Form validation





## Project Structure

The project follows a feature-based architecture:

- **core**: Contains shared utilities, models, services, and widgets
- **features**: Contains feature-specific code organized by domain

- **auth**: Authentication-related screens and services
- **home**: Home screen and related components
- **micropost**: Micropost-related components and services
- **user**: User-related screens, components, and services
- **static**: Static pages like About and Contact





## Getting Started

To run the app:

1. Make sure you have Flutter installed
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the app

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

**The Flutter project where the generated code should be added is named `flutter_social_app`. Its structure is already initialized with default folders (`lib/`, `android/`, `ios/`, etc.) and a main entry file `lib/main.dart`. You may safely create new files or folders inside this project.**

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