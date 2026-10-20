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
  bool _customSchedule = false;

  // One controller pair per installment row (built when count changes)
  List<TextEditingController> _installmentAmountControllers = [];
  List<DateTime> _installmentDueDates = [];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _countController.dispose();
    for (final c in _installmentAmountControllers) {
      c.dispose();
    }
    super.dispose();
  }

  // Rebuild custom rows whenever count or total changes
  void _syncCustomRows() {
    final count = int.tryParse(_countController.text.trim()) ?? 0;
    final total =
        double.tryParse(_amountController.text.trim().replaceAll(',', '.')) ??
        0;
    final totalMillimes = (total * 1000).round();

    // Dispose old controllers that are no longer needed
    for (var i = count; i < _installmentAmountControllers.length; i++) {
      _installmentAmountControllers[i].dispose();
    }

    final newControllers = List<TextEditingController>.generate(count, (i) {
      if (i < _installmentAmountControllers.length) {
        return _installmentAmountControllers[i];
      }
      return TextEditingController();
    });

    // Pre-fill amounts with equal split
    if (totalMillimes > 0 && count > 0) {
      final base = totalMillimes ~/ count;
      final remainder = totalMillimes % count;
      for (var i = 0; i < count; i++) {
        final amount = (base + (i < remainder ? 1 : 0)) / 1000;
        newControllers[i].text = amount.toStringAsFixed(3);
      }
    }

    final newDates = List<DateTime>.generate(count, (i) {
      if (i < _installmentDueDates.length) return _installmentDueDates[i];
      return DateTime(
        _purchaseDate.year,
        _purchaseDate.month + i + 1,
        _purchaseDate.day,
      );
    });

    setState(() {
      _installmentAmountControllers = newControllers;
      _installmentDueDates = newDates;
    });
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
      if (_customSchedule) _syncCustomRows();
    }
  }

  Future<void> _pickInstallmentDate(int index) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _installmentDueDates[index],
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selected != null && mounted) {
      setState(() => _installmentDueDates[index] = selected);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    final totalMillimes = (amount * 1000).round();
    final count = int.parse(_countController.text.trim());

    // Validate custom schedule totals
    if (_customSchedule) {
      final customTotal = _installmentAmountControllers.fold<int>(0, (sum, c) {
        final v = double.tryParse(c.text.trim().replaceAll(',', '.')) ?? 0;
        return sum + (v * 1000).round();
      });
      if (customTotal != totalMillimes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Installment amounts must add up to the total purchase price.',
            ),
          ),
        );
        return;
      }
    }

    setState(() => _isSaving = true);

    try {
      final customPayments = _customSchedule
          ? List.generate(count, (i) {
              final v = double.parse(
                _installmentAmountControllers[i].text.trim().replaceAll(
                  ',',
                  '.',
                ),
              );
              return (
                amountMillimes: (v * 1000).round(),
                dueDate: _installmentDueDates[i],
              );
            })
          : null;

      await ref
          .read(installmentPurchasesRepositoryProvider)
          .addPurchase(
            name: _nameController.text.trim(),
            totalAmountMillimes: totalMillimes,
            purchaseDate: _purchaseDate,
            installmentCount: count,
            accountId: _accountId,
            payments: customPayments,
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
      if (mounted) setState(() => _isSaving = false);
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
                // ── Name ────────────────────────────────────────────────
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

                // ── Total amount ─────────────────────────────────────────
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Total amount (TND)',
                    hintText: 'e.g. 1200.000',
                  ),
                  onChanged: (_) {
                    if (_customSchedule) _syncCustomRows();
                  },
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

                // ── Count ────────────────────────────────────────────────
                TextFormField(
                  controller: _countController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Number of installments',
                  ),
                  onChanged: (_) {
                    if (_customSchedule) _syncCustomRows();
                  },
                  validator: (value) {
                    final count = int.tryParse((value ?? '').trim());
                    if (count == null || count < 1 || count > 120) {
                      return 'Enter a number between 1 and 120';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // ── Account ──────────────────────────────────────────────
                accountsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (_, __) => const Text('Could not load accounts'),
                  data: (accounts) {
                    final accountExists = accounts.any(
                      (a) => a.id == _accountId,
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
                          (a) => DropdownMenuItem<String?>(
                            value: a.id,
                            child: Text(a.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _accountId = value),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // ── Purchase date ────────────────────────────────────────
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Purchase date'),
                  subtitle: Text(DateFormat.yMMMd().format(_purchaseDate)),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: _pickPurchaseDate,
                ),

                // ── Custom schedule toggle ───────────────────────────────
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Custom schedule'),
                  subtitle: const Text(
                    'Set a different amount or date per installment',
                  ),
                  value: _customSchedule,
                  onChanged: (value) {
                    setState(() => _customSchedule = value);
                    if (value) _syncCustomRows();
                  },
                ),

                // ── Per-installment rows ─────────────────────────────────
                if (_customSchedule) ...[
                  const Divider(),
                  const SizedBox(height: 4),
                  ...List.generate(_installmentAmountControllers.length, (i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Installment number
                          Padding(
                            padding: const EdgeInsets.only(top: 16, right: 8),
                            child: Text(
                              '${i + 1}.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),

                          // Amount field
                          Expanded(
                            child: TextFormField(
                              controller: _installmentAmountControllers[i],
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Amount (TND)',
                                isDense: true,
                              ),
                              validator: (value) {
                                final v = double.tryParse(
                                  (value ?? '').trim().replaceAll(',', '.'),
                                );
                                if (v == null || v <= 0) return 'Invalid';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Date picker
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickInstallmentDate(i),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Due date',
                                  isDense: true,
                                  suffixIcon: Icon(
                                    Icons.calendar_month,
                                    size: 16,
                                  ),
                                ),
                                child: Text(
                                  DateFormat.yMMMd().format(
                                    _installmentDueDates[i],
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ] else ...[
                  const SizedBox(height: 8),
                  const Text(
                    'The first payment will be due one month after the purchase date.',
                  ),
                ],
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
