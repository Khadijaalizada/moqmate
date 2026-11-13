import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/widgets.dart';
import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../services/providers.dart';

/// Phase 2 placeholder shells: they prove auth, roles, mode switching and route
/// guards work. The real dashboards are built in Phase 3.
class BuyerHomeShell extends StatelessWidget {
  const BuyerHomeShell({super.key});
  @override
  Widget build(BuildContext context) => const _Shell(mode: AppMode.buyer);
}

class SupplierHomeShell extends StatelessWidget {
  const SupplierHomeShell({super.key});
  @override
  Widget build(BuildContext context) => const _Shell(mode: AppMode.supplier);
}

class _Shell extends ConsumerWidget {
  const _Shell({required this.mode});
  final AppMode mode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider).valueOrNull;
    final isBuyer = mode == AppMode.buyer;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isBuyer ? AppColors.wine : AppColors.burgundy,
        title: Text(isBuyer ? 'Buyer mode' : 'Supplier mode'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.wine)),
                      const SizedBox(height: 4),
                      Text(user.email),
                      const Divider(height: 24),
                      Text('${user.city}, ${user.country}'),
                      Text('Account type: ${user.accountType!.name}'),
                      if ((user.businessName ?? '').isNotEmpty) Text('Business: ${user.businessName}'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (user.accountType == AccountType.both)
                  FilledButton.icon(
                    icon: const Icon(Icons.swap_horiz),
                    label: Text('Switch to ${isBuyer ? 'Supplier' : 'Buyer'} mode'),
                    onPressed: () async {
                      try {
                        await ref.read(authServiceProvider).setMode(user.uid, isBuyer ? AppMode.supplier : AppMode.buyer);
                      } catch (e) {
                        if (context.mounted) showMessage(context, AuthService.messageFor(e), error: true);
                      }
                    },
                  ),
                const SizedBox(height: 16),
                const AppCard(
                  child: Text(
                    'The dashboard is not built yet. It arrives in Phase 3. '
                    'This screen only confirms that sign-in, location, role and mode switching work.',
                  ),
                ),
              ],
            ),
    );
  }
}
