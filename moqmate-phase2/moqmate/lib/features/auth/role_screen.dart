import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme.dart';
import '../../core/validators.dart';
import '../../core/widgets.dart';
import '../../models/app_user.dart';
import '../../services/auth_service.dart';
import '../../services/providers.dart';

class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});
  @override
  ConsumerState<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends ConsumerState<RoleScreen> {
  final _form = GlobalKey<FormState>();
  final _business = TextEditingController();
  AccountType? _type;
  bool _loading = false;

  static const _options = [
    (AccountType.buyer, Icons.shopping_bag_outlined, 'Buyer', 'Join group purchases and post buying requests.'),
    (AccountType.supplier, Icons.warehouse_outlined, 'Supplier', 'Publish wholesale products and fulfil group orders.'),
    (AccountType.both, Icons.swap_horiz_rounded, 'Both', 'Switch between Buyer and Supplier mode with one account.'),
  ];

  @override
  void dispose() {
    _business.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final uid = ref.read(authStateProvider).valueOrNull?.uid;
    if (uid == null || _type == null || !_form.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authServiceProvider).saveRole(uid, _type!, businessName: _business.text);
    } catch (e) {
      if (mounted) showMessage(context, AuthService.messageFor(e), error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final needsBusiness = _type == AccountType.supplier || _type == AccountType.both;
    return Scaffold(
      appBar: AppBar(title: const Text('How will you use MOQMate?'), automaticallyImplyLeading: false),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final o in _options) ...[
                  AppCard(
                    selected: _type == o.$1,
                    onTap: () => setState(() => _type = o.$1),
                    child: Row(
                      children: [
                        Icon(o.$2, size: 32, color: AppColors.crimson),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(o.$3, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.wine)),
                              const SizedBox(height: 2),
                              Text(o.$4),
                            ],
                          ),
                        ),
                        if (_type == o.$1) const Icon(Icons.check_circle, color: AppColors.crimson),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (needsBusiness) ...[
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _business,
                    textCapitalization: TextCapitalization.words,
                    decoration: inputDec('Business name', icon: Icons.business),
                    validator: (v) => Validators.required(v, 'Business name'),
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 12),
                AsyncButton(label: 'Continue', loading: _loading, onPressed: _type == null ? null : _save),
                TextButton(onPressed: () => ref.read(authServiceProvider).signOut(), child: const Text('Sign out')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
