import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/locations.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../services/auth_service.dart';
import '../../services/providers.dart';

class LocationScreen extends ConsumerStatefulWidget {
  const LocationScreen({super.key});
  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen> {
  String? _country;
  String? _city;
  bool _loading = false;

  Future<void> _save() async {
    final uid = ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null || _country == null || _city == null) return;
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).saveLocation(uid, _country!, _city!);
    } catch (e) {
      if (mounted) showMessage(context, AuthService.messageFor(e), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Where are you based?'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const AppCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: AppColors.crimson),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Group purchases stay local. You will only be matched with buyers in your own country, '
                        'preferably your city or nearby delivery area.',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _country,
                isExpanded: true,
                decoration: inputDec('Country', icon: Icons.public),
                items: [for (final c in supportedLocations.keys) DropdownMenuItem(value: c, child: Text(c))],
                onChanged: (v) => setState(() {
                  _country = v;
                  _city = null;
                }),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: ValueKey(_country),
                value: _city,
                isExpanded: true,
                decoration: inputDec('City', icon: Icons.location_city),
                items: [
                  for (final c in supportedLocations[_country] ?? const <String>[])
                    DropdownMenuItem(value: c, child: Text(c)),
                ],
                onChanged: _country == null ? null : (v) => setState(() => _city = v),
              ),
              const SizedBox(height: 28),
              AsyncButton(
                label: 'Continue',
                loading: _loading,
                onPressed: (_country != null && _city != null) ? _save : null,
              ),
              TextButton(
                onPressed: () => ref.read(authServiceProvider).signOut(),
                child: const Text('Sign out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
