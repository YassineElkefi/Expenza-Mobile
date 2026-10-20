import 'package:expenza_flutter/core/database/app_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../accounts/data/accounts_providers.dart';
import '../data/installment_payments_provider.dart';
import '../data/installment_purchases_repository_provider.dart';
import '../data/installment_purchases_provider.dart';

class EditInstallmentPurchaseDialog extends ConsumerStatefulWidget {
  const EditInstallmentPurchaseDialog({
    super.key,
    required this.purchase,
    required this.payments,
  });

  final InstallmentPurchase purchase;
  final List<InstallmentPayment> payments;

  @override
  ConsumerState<EditInstallmentPurchaseDialog> createState() =>
      _EditInstallmentPurchaseDialogState();
}

class _EditInstallmentPurchaseDialogState
    extends ConsumerState<EditInstallmentPurchaseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  late final List<InstallmentPayment> _payments;
  String? _accountId;
  bool _isSaving = false;

  int get _paidAmountMillimes => _payments
      .where((payment) => payment.paidAt != null)
      .fold(0, (sum, payment) => sum + payment.amountMillimes);

  bool get _hasPaidPayments =>
      _payments.any((payment) => payment.paidAt != null);

  @override
  void initState() {
    super.initState();
    _payments = [...widget.payments]
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    _nameController.text = widget.purchase.name;
    _amountController.text = (widget.purchase.totalAmountMillimes / 1000)
        .toStringAsFixed(3);
    _accountId = widget.purchase.accountId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  List<({String id, int amountMillimes, DateTime dueDate})> _paymentsForTotal(
    int totalAmountMillimes,
  ) {
    final unpaidPayments = _payments
        .where((payment) => payment.paidAt == null)
        .toList();

    if (unpaidPayments.isEmpty) {
      return _payments
          .map(
            (payment) => (
              id: payment.id,
              amountMillimes: payment.amountMillimes,
              dueDate: payment.dueDate,
            ),
          )
          .toList();
    }

    final amountToDistribute = totalAmountMillimes - _paidAmountMillimes;
    final baseAmount = amountToDistribute ~/ unpaidPayments.length;
    final remainder = amountToDistribute % unpaidPayments.length;
    var unpaidIndex = 0;

    return _payments.map((payment) {
      if (payment.paidAt != null) {
        return (
          id: payment.id,
          amountMillimes: payment.amountMillimes,
          dueDate: payment.dueDate,
        );
      }

      final amountMillimes = baseAmount + (unpaidIndex < remainder ? 1 : 0);
      unpaidIndex++;
      return (
        id: payment.id,
        amountMillimes: amountMillimes,
        dueDate: payment.dueDate,
      );
    }).toList();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    final totalMillimes = (amount * 1000).round();

    setState(() => _isSaving = true);

    try {
      await ref
          .read(installmentPurchasesRepositoryProvider)
          .updatePurchase(
            purchaseId: widget.purchase.id,
            name: _nameController.text.trim(),
            totalAmountMillimes: totalMillimes,
            accountId: _accountId,
            payments: _paymentsForTotal(totalMillimes),
          );

      ref.invalidate(installmentPurchasesProvider);
      ref.invalidate(installmentPaymentsProvider);

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not update purchase: $error')),
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
    final purchase = widget.purchase;

    return AlertDialog(
      title: const Text('Edit installment purchase'),
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
                    if (amount == null || !amount.isFinite || amount <= 0) {
                      return 'Enter a valid amount greater than zero';
                    }
                    final totalMillimes = (amount * 1000).round();
                    final unpaidCount = _payments
                        .where((payment) => payment.paidAt == null)
                        .length;
                    if (totalMillimes < _paidAmountMillimes + unpaidCount) {
                      return 'Total must cover the amount paid and each unpaid installment';
                    }
                    if (unpaidCount == 0 &&
                        totalMillimes != purchase.totalAmountMillimes) {
                      return 'Total cannot change after all installments are paid';
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
                      initialValue: accountExists ? _accountId : null,
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
                      onChanged: _hasPaidPayments
                          ? null
                          : (value) {
                              setState(() => _accountId = value);
                            },
                    );
                  },
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Number of installments'),
                  subtitle: Text('${purchase.installmentCount}'),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Purchase date'),
                  subtitle: Text(
                    DateFormat.yMMMd().format(purchase.purchaseDate),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Installment count, purchase date, and paid payments cannot be changed.',
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
              : const Text('Save changes'),
        ),
      ],
    );
  }
}
