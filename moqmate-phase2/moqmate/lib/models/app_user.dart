enum AccountType { buyer, supplier, both }

enum AppMode { buyer, supplier }

T? _byName<T extends Enum>(List<T> values, Object? name) {
  for (final v in values) {
    if (v.name == name) return v;
  }
  return null;
}

class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    this.accountType,
    this.activeMode,
    this.country,
    this.city,
    this.businessName,
  });

  final String uid;
  final String name;
  final String email;
  final AccountType? accountType;
  final AppMode? activeMode;
  final String? country;
  final String? city;
  final String? businessName;

  bool get hasLocation => (country ?? '').isNotEmpty && (city ?? '').isNotEmpty;
  bool get hasRole => accountType != null;
  bool get isComplete => hasLocation && hasRole;

  bool canUse(AppMode m) =>
      accountType == AccountType.both ||
      (accountType == AccountType.buyer && m == AppMode.buyer) ||
      (accountType == AccountType.supplier && m == AppMode.supplier);

  /// The mode the app should currently show. Falls back to the only mode the
  /// account is allowed to use, so a buyer can never land in supplier mode.
  AppMode get effectiveMode {
    final m = activeMode;
    if (m != null && canUse(m)) return m;
    return accountType == AccountType.supplier ? AppMode.supplier : AppMode.buyer;
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic> m) => AppUser(
        uid: uid,
        name: (m['name'] as String?) ?? '',
        email: (m['email'] as String?) ?? '',
        accountType: _byName(AccountType.values, m['accountType']),
        activeMode: _byName(AppMode.values, m['activeMode']),
        country: m['country'] as String?,
        city: m['city'] as String?,
        businessName: m['businessName'] as String?,
      );
}
