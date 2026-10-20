import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../accounts/data/accounts_providers.dart';
import '../data/installment_purchases_repository_provider.dart';
import '../data/installment_purchases_provider.dart';

class AddInstallmentPurchaseDialog extends ConsumerStatefulWidget {
  const AddInstallmentPurchaseDialog({super.key});

  @override
  ConsumerState<AddInstallmentPurchaseDialog> createState() =>
      _AddInstallmentPurchaseDialogState();
}

class _AddInstallmentPurchaseDialogState
    extends ConsumerState<AddInstallmentPurchaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _countController = TextEditingController(text: '3');

  DateTime _purchaseDate = DateTime.now();
  String? _accountId;
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _countController.dispose();
    super.dispose();
  }

  Future<void> _pickPurchaseDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _purchaseDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selected != null && mounted) {
      setState(() => _purchaseDate = selected);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    final totalMillimes = (amount * 1000).round();
    final count = int.parse(_countController.text.trim());

    setState(() => _isSaving = true);

    try {
      await ref
          .read(installmentPurchasesRepositoryProvider)
          .addPurchase(
            name: _nameController.text.trim(),
            totalAmountMillimes: totalMillimes,
            purchaseDate: _purchaseDate,
            installmentCount: count,
            accountId: _accountId,
          );

      ref.invalidate(installmentPurchasesProvider);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save purchase: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return AlertDialog(
      title: const Text('Add installment purchase'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Purchase name',
                    hintText: 'e.g. Laptop',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Enter a purchase name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Total amount (TND)',
                    hintText: 'e.g. 1200.000',
                  ),
                  validator: (value) {
                    final amount = double.tryParse(
                      (value ?? '').trim().replaceAll(',', '.'),
                    );
                    if (amount == null || amount <= 0) {
                      return 'Enter a valid amount greater than zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of installments',
                  ),
                  validator: (value) {
                    final count = int.tryParse((value ?? '').trim());
                    if (count == null || count < 1 || count > 120) {
                      return 'Enter a number between 1 and 120';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                accountsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stackTrace) =>
                      const Text('Could not load accounts'),
                  data: (accounts) {
                    final accountExists = accounts.any(
                      (account) => account.id == _accountId,
                    );

                    return DropdownButtonFormField<String?>(
                      value: accountExists ? _accountId : null,
                      decoration: const InputDecoration(
                        labelText: 'Payment account (optional)',
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('No account assigned'),
                        ),
                        ...accounts.map(
                          (account) => DropdownMenuItem<String?>(
                            value: account.id,
                            child: Text(account.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _accountId = value);
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Purchase date'),
                  subtitle: Text(DateFormat.yMMMd().format(_purchaseDate)),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: _pickPurchaseDate,
                ),
                const SizedBox(height: 8),
                const Text(
                  'The first payment will be due one month after the purchase date.',
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save purchase'),
        ),
      ],
    );
  }
}
