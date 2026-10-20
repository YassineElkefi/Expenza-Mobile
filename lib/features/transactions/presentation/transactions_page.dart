import 'package:expenza_flutter/core/database/app_database.dart';
import 'package:expenza_flutter/features/transactions/presentation/add_transaction_dialog.dart';
import 'package:expenza_flutter/features/transactions/presentation/transfer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/transactions_providers.dart';

import 'package:expenza_flutter/features/transactions/presentation/edit_transaction_dialog.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  void _showAddTransactionDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => const AddTransactionDialog(),
    );
  }

  void _showTransferDialog(BuildContext context) {
    showDialog<void>(context: context, builder: (_) => const TransferDialog());
  }

  void _showEditTransactionDialog(
    BuildContext context,
    Transaction transaction,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => EditTransactionDialog(transaction: transaction),
    );
  }

  Future<void> _confirmDeleteTransaction(
    BuildContext context,
    WidgetRef ref,
    String transactionId,
    String transactionType,
    String? transferId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          transferId != null ? 'Delete transfer?' : 'Delete transaction?',
        ),
        content: Text(
          transferId != null
              ? 'Both sides of this transfer will be deleted, and both account balances will be updated. This cannot be undone.'
              : 'This transaction will be permanently deleted, and the account balance will be updated. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(transactionsRepositoryProvider).delete(transactionId);

      ref.invalidate(transactionsProvider);

      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Transaction deleted')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete transaction: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transactions',
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'Track your income, expenses, and transfers.',
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showTransferDialog(context),
                    icon: const Icon(Icons.swap_horiz),
                    label: const Text('Transfer'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _showAddTransactionDialog(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add transaction'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: transactionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text('Failed to load transactions: $error')),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: colors.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No transactions yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your income and expenses will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: colors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: transactions.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final isIncome =
                          transaction.transactionType == 'income' ||
                          transaction.transactionType == 'transfer_in';

                      final amount = NumberFormat.currency(
                        locale: 'en',
                        symbol: 'TND ',
                        decimalDigits: 3,
                      ).format(transaction.amountMillimes / 1000);

                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isIncome
                                ? colors.primaryContainer
                                : colors.errorContainer,
                            child: Icon(
                              isIncome
                                  ? Icons.arrow_downward_rounded
                                  : Icons.arrow_upward_rounded,
                              color: isIncome
                                  ? colors.onPrimaryContainer
                                  : colors.onErrorContainer,
                            ),
                          ),
                          title: Text(
                            (transaction.description?.isNotEmpty ?? false)
                                ? transaction.description!
                                : transaction.category ?? 'Transaction',
                          ),
                          subtitle: Text(
                            '${transaction.transactionType} · '
                            '${DateFormat.yMMMd().format(transaction.transactionDate)}',
                          ),

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${isIncome ? '+' : '-'}$amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isIncome
                                      ? colors.primary
                                      : colors.error,
                                ),
                              ),
                              if (transaction.transactionType == 'income' ||
                                  transaction.transactionType == 'expense')
                                IconButton(
                                  tooltip: 'Edit transaction',
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => _showEditTransactionDialog(
                                    context,
                                    transaction,
                                  ),
                                ),
                              IconButton(
                                tooltip: 'Delete transaction',
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () => _confirmDeleteTransaction(
                                  context,
                                  ref,
                                  transaction.id,
                                  transaction.transactionType,
                                  transaction.transferId,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
