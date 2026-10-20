import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../accounts/data/accounts_providers.dart';
import '../data/transactions_providers.dart';

class EditTransactionDialog extends ConsumerStatefulWidget {
  const EditTransactionDialog({required this.transaction, super.key});

  final Transaction transaction;

  @override
  ConsumerState<EditTransactionDialog> createState() =>
      _EditTransactionDialogState();
}

class _EditTransactionDialogState extends ConsumerState<EditTransactionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;

  late String _transactionType;
  late String? _accountId;
  late DateTime _transactionDate;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final transaction = widget.transaction;
    _transactionType = transaction.transactionType;
    _accountId = transaction.accountId;
    _transactionDate = transaction.transactionDate;

    _amountController = TextEditingController(
      text: (transaction.amountMillimes / 1000).toStringAsFixed(3),
    );
    _descriptionController = TextEditingController(
      text: transaction.description ?? '',
    );
    _categoryController = TextEditingController(
      text: transaction.category ?? '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final accountId = _accountId;
    if (accountId == null) return;

    final amount = double.tryParse(
      _amountController.text.trim().replaceAll(',', '.'),
    );

    if (amount == null || !amount.isFinite || amount <= 0) return;

    setState(() => _isSaving = true);

    try {
      await ref
          .read(transactionsRepositoryProvider)
          .update(
            id: widget.transaction.id,
            accountId: accountId,
            transactionType: _transactionType,
            amountMillimes: (amount * 1000).round(),
            transactionDate: _transactionDate,
            category: _categoryController.text.trim().isEmpty
                ? null
                : _categoryController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
          );

      ref.invalidate(transactionsProvider);

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Transaction updated')));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update transaction: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(accountsProvider);

    return AlertDialog(
      title: const Text('Edit transaction'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _transactionType,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: const [
                    DropdownMenuItem(value: 'income', child: Text('Income')),
                    DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  ],
                  onChanged: _isSaving
                      ? null
                      : (value) {
                          if (value != null) {
                            setState(() => _transactionType = value);
                          }
                        },
                ),
                const SizedBox(height: 12),
                accountsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stack) =>
                      Text('Failed to load accounts: $error'),
                  data: (accounts) {
                    final selectedAccountExists = accounts.any(
                      (account) => account.id == _accountId,
                    );

                    return DropdownButtonFormField<String>(
                      initialValue: selectedAccountExists ? _accountId : null,
                      decoration: const InputDecoration(labelText: 'Account'),
                      items: accounts
                          .map(
                            (account) => DropdownMenuItem(
                              value: account.id,
                              child: Text(account.name),
                            ),
                          )
                          .toList(),
                      validator: (value) =>
                          value == null ? 'Select an account' : null,
                      onChanged: _isSaving
                          ? null
                          : (value) => setState(() => _accountId = value),
                    );
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount (TND)'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (value) {
                    final amount = double.tryParse(
                      (value ?? '').trim().replaceAll(',', '.'),
                    );
                    if (amount == null || !amount.isFinite || amount <= 0) {
                      return 'Enter a valid amount greater than zero';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Transaction date'),
                  subtitle: Text(DateFormat.yMMMd().format(_transactionDate)),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: _isSaving
                      ? null
                      : () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: _transactionDate,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (selectedDate != null && mounted) {
                            setState(() {
                              _transactionDate = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                _transactionDate.hour,
                                _transactionDate.minute,
                              );
                            });
                          }
                        },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
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
