import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_social_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_social_app/features/auth/screens/login_screen.dart';
import 'package:flutter_social_app/features/auth/screens/signup_screen.dart';
import 'package:flutter_social_app/features/home/screens/home_screen.dart';
import 'package:flutter_social_app/features/password_reset/screens/password_reset_screen.dart';
import 'package:flutter_social_app/features/password_reset/screens/password_reset_new_screen.dart';
import 'package:flutter_social_app/features/account_activation/screens/account_activation_screen.dart';
import 'package:flutter_social_app/features/account_activation/screens/account_activation_new_screen.dart';
import 'package:flutter_social_app/features/user/screens/user_profile_screen.dart';
import 'package:flutter_social_app/features/user/screens/user_edit_screen.dart';
import 'package:flutter_social_app/features/user/screens/users_screen.dart';
import 'package:flutter_social_app/features/user/screens/show_follow_screen.dart';
import 'package:flutter_social_app/features/static/screens/about_screen.dart';
import 'package:flutter_social_app/features/static/screens/contact_screen.dart';
import 'package:flutter_social_app/features/static/screens/not_found_screen.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.isLoggedIn;
      final isInitialized = authState.initialized;
      final isGoingToAuth = state.location == '/login' || 
                            state.location == '/signup' || 
                            state.location.startsWith('/password-reset') ||
                            state.location.startsWith('/account-activation');

      // If not initialized yet, don't redirect
      if (!isInitialized) {
        return null;
      }

      // If not logged in and not going to auth page, redirect to login
      if (!isLoggedIn && !isGoingToAuth) {
        return '/login';
      }

      // If logged in and going to auth page, redirect to home
      if (isLoggedIn && isGoingToAuth) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/users',
        builder: (context, state) => const UsersScreen(),
      ),
      GoRoute(
        path: '/users/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UserProfileScreen(userId: id);
        },
      ),
      GoRoute(
        path: '/users/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return UserEditScreen(userId: id);
        },
      ),
      GoRoute(
        path: '/users/:id/:type',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final type = state.pathParameters['type']!;
          return ShowFollowScreen(userId: id, type: type);
        },
      ),
      GoRoute(
        path: '/account-activation',
        builder: (context, state) => const AccountActivationNewScreen(),
      ),
      GoRoute(
        path: '/account-activation/:token',
        builder: (context, state) {
          final token = state.pathParameters['token']!;
          final email = state.uri.queryParameters['email'] ?? '';
          return AccountActivationScreen(token: token, email: email);
        },
      ),
      GoRoute(
        path: '/password-reset',
        builder: (context, state) => const PasswordResetNewScreen(),
      ),
      GoRoute(
        path: '/password-reset/:token',
        builder: (context, state) {
          final token = state.pathParameters['token']!;
          final email = state.uri.queryParameters['email'] ?? '';
          return PasswordResetScreen(token: token, email: email);
        },
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
