import '../models/app_user.dart';

/// Pure routing rules (unit-tested). Returns the location to redirect to, or
/// null to stay where we are.
String? resolveRedirect({
  required String location,
  required bool onboardingSeen,
  required bool authLoading,
  required bool signedIn,
  required bool profileLoading,
  required AppUser? profile,
}) {
  String? go(String target) => location == target ? null : target;

  if (authLoading) return go('/');

  if (!signedIn) {
    if (!onboardingSeen) return go('/onboarding');
    if (location == '/login' || location == '/register') return null;
    return '/login';
  }

  // Signed in: wait for the profile document.
  if (profileLoading || profile == null) return go('/');

  if (!profile.hasLocation) return go('/location');
  if (!profile.hasRole) return go('/role');

  const entry = {'/', '/login', '/register', '/onboarding', '/location', '/role'};
  final home = profile.effectiveMode == AppMode.buyer ? '/buyer' : '/supplier';
  if (entry.contains(location)) return home;

  // Role-based route guard.
  if (location.startsWith('/buyer') && profile.effectiveMode != AppMode.buyer) return '/supplier';
  if (location.startsWith('/supplier') && profile.effectiveMode != AppMode.supplier) return '/buyer';
  return null;
}
