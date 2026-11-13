import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/auth/role_screen.dart';
import '../features/home/home_shells.dart';
import '../features/location/location_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/onboarding/splash_screen.dart';
import '../services/providers.dart';
import 'redirect.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, __) => refresh.value++);
  ref.listen(userProfileProvider, (_, __) => refresh.value++);
  ref.listen(onboardingSeenProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      final profile = ref.read(userProfileProvider);
      return resolveRedirect(
        location: state.matchedLocation,
        onboardingSeen: ref.read(onboardingSeenProvider),
        authLoading: auth.isLoading,
        signedIn: auth.valueOrNull != null,
        profileLoading: profile.isLoading,
        profile: profile.valueOrNull,
      );
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
      GoRoute(path: '/location', builder: (_, __) => const LocationScreen()),
      GoRoute(path: '/role', builder: (_, __) => const RoleScreen()),
      GoRoute(path: '/buyer', builder: (_, __) => const BuyerHomeShell()),
      GoRoute(path: '/supplier', builder: (_, __) => const SupplierHomeShell()),
    ],
  );
});
