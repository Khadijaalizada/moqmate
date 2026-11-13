import 'package:flutter_test/flutter_test.dart';
import 'package:moqmate/models/app_user.dart';

AppUser u(AccountType? t, {AppMode? mode, String? country = 'Bangladesh', String? city = 'Dhaka'}) => AppUser(
    uid: '1', name: 'n', email: 'e@x.co', accountType: t, activeMode: mode, country: country, city: city);

void main() {
  test('fromMap parses enums and ignores unknown values', () {
    final x = AppUser.fromMap('1', {'name': 'A', 'accountType': 'both', 'activeMode': 'supplier', 'country': 'India', 'city': 'Delhi'});
    expect(x.accountType, AccountType.both);
    expect(x.activeMode, AppMode.supplier);
    final y = AppUser.fromMap('2', {'accountType': 'admin'});
    expect(y.accountType, isNull);
  });

  test('completeness', () {
    expect(u(null).isComplete, isFalse);
    expect(u(AccountType.buyer, country: null).isComplete, isFalse);
    expect(u(AccountType.buyer).isComplete, isTrue);
  });

  test('buyer can never use supplier mode', () {
    final b = u(AccountType.buyer, mode: AppMode.supplier);
    expect(b.canUse(AppMode.supplier), isFalse);
    expect(b.effectiveMode, AppMode.buyer);
  });

  test('supplier defaults to supplier mode', () {
    expect(u(AccountType.supplier).effectiveMode, AppMode.supplier);
  });

  test('both respects activeMode', () {
    expect(u(AccountType.both, mode: AppMode.supplier).effectiveMode, AppMode.supplier);
    expect(u(AccountType.both, mode: AppMode.buyer).effectiveMode, AppMode.buyer);
  });
}
