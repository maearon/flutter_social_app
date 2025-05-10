import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_app/core/router/app_router.dart';
import 'package:flutter_social_app/core/theme/app_theme.dart';
import 'package:flutter_social_app/features/auth/providers/auth_provider.dart';

class SocialApp extends ConsumerWidget {
  const SocialApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final authState = ref.watch(authProvider);

    // Initialize auth state when app starts
    ref.listen(authProvider.notifier, (previous, next) {
      if (previous?.initialized != true && next.initialized) {
        // Auth state initialized, we can now navigate based on auth state
        if (next.isLoggedIn) {
          router.go('/');
        }
      }
    });

    return MaterialApp.router(
      title: 'Social App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerDelegate: router.routerDelegate,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      debugShowCheckedModeBanner: false,
    );
  }
}
