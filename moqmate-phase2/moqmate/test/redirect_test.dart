import 'package:flutter_test/flutter_test.dart';
import 'package:moqmate/models/app_user.dart';
import 'package:moqmate/router/redirect.dart';

String? r(String loc,
        {bool seen = true, bool authLoading = false, bool signedIn = true, bool profileLoading = false, AppUser? profile}) =>
    resolveRedirect(
        location: loc,
        onboardingSeen: seen,
        authLoading: authLoading,
        signedIn: signedIn,
        profileLoading: profileLoading,
        profile: profile);

AppUser user({AccountType? t, AppMode? m, String? country, String? city}) => AppUser(
    uid: '1', name: 'n', email: 'e@x.co', accountType: t, activeMode: m, country: country, city: city);

void main() {
  test('splash while auth loading', () {
    expect(r('/login', authLoading: true), '/');
    expect(r('/', authLoading: true), isNull);
  });

  group('signed out', () {
    test('first launch goes to onboarding', () => expect(r('/', seen: false, signedIn: false), '/onboarding'));
    test('then login', () => expect(r('/', signedIn: false), '/login'));
    test('register allowed', () => expect(r('/register', signedIn: false), isNull));
    test('protected routes blocked', () {
      expect(r('/buyer', signedIn: false), '/login');
      expect(r('/supplier', signedIn: false), '/login');
    });
  });

  group('signed in', () {
    test('waits for profile', () {
      expect(r('/login', profileLoading: true), '/');
      expect(r('/login', profile: null), '/');
    });
    test('needs location first', () => expect(r('/buyer', profile: user()), '/location'));
    test('then role', () => expect(r('/buyer', profile: user(country: 'India', city: 'Delhi')), '/role'));
    test('complete buyer goes home', () {
      final p = user(t: AccountType.buyer, country: 'India', city: 'Delhi');
      expect(r('/login', profile: p), '/buyer');
      expect(r('/buyer', profile: p), isNull);
    });
    test('buyer is blocked from supplier area', () {
      final p = user(t: AccountType.buyer, country: 'India', city: 'Delhi');
      expect(r('/supplier', profile: p), '/buyer');
    });
    test('supplier is blocked from buyer area', () {
      final p = user(t: AccountType.supplier, country: 'India', city: 'Delhi');
      expect(r('/buyer', profile: p), '/supplier');
    });
    test('both user follows active mode', () {
      final p = user(t: AccountType.both, m: AppMode.supplier, country: 'India', city: 'Delhi');
      expect(r('/buyer', profile: p), '/supplier');
      expect(r('/supplier', profile: p), isNull);
    });
  });
}
