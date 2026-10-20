import 'package:expenza_flutter/core/database/app_database.dart';
import 'package:expenza_flutter/features/transactions/presentation/add_transaction_dialog.dart';
import 'package:expenza_flutter/features/transactions/presentation/transfer_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/transactions_providers.dart';

import 'package:expenza_flutter/features/accounts/data/accounts_providers.dart';

import 'package:expenza_flutter/features/transactions/presentation/edit_transaction_dialog.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedType = 'all';
  String? _selectedAccountId;
  String? _selectedCategory;
  String _selectedPeriod = 'all';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final nextMonthStart = DateTime(now.year, now.month + 1);
    final lastMonthStart = DateTime(now.year, now.month - 1);
    final query = _searchController.text.trim().toLowerCase();

    return transactions.where((transaction) {
      // Search description and category.
      final matchesSearch =
          (transaction.description ?? '').toLowerCase().contains(query) ||
          (transaction.category ?? '').toLowerCase().contains(query);

      // Filter by transaction type.
      final type = transaction.transactionType;
      final matchesType = switch (_selectedType) {
        'income' => type == 'income',
        'expense' => type == 'expense',
        'transfer' => type == 'transfer_in' || type == 'transfer_out',
        _ => true,
      };

      // Filter by account.
      final matchesAccount =
          _selectedAccountId == null ||
          transaction.accountId == _selectedAccountId;

      // Filter by category.
      final matchesCategory =
          _selectedCategory == null ||
          transaction.category == _selectedCategory;

      // Filter by date.
      final date = transaction.transactionDate;
      final matchesPeriod = switch (_selectedPeriod) {
        'thisMonth' =>
          !date.isBefore(monthStart) && date.isBefore(nextMonthStart),
        'lastMonth' =>
          !date.isBefore(lastMonthStart) && date.isBefore(monthStart),
        _ => true,
      };

      return matchesSearch &&
          matchesType &&
          matchesAccount &&
          matchesCategory &&
          matchesPeriod;
    }).toList();
  }

  List<String> _getCategories(List<Transaction> transactions) {
    final categories = transactions
        .map((transaction) => transaction.category)
        .whereType<String>()
        .where((category) => category.trim().isNotEmpty)
        .toSet()
        .toList();

    categories.sort();
    return categories;
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
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final accountsAsync = ref.watch(accountsProvider);
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

            const SizedBox(height: 20),

            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search description or category...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Clear search',
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      ),
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 170,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All types')),
                      DropdownMenuItem(value: 'income', child: Text('Income')),
                      DropdownMenuItem(
                        value: 'expense',
                        child: Text('Expenses'),
                      ),
                      DropdownMenuItem(
                        value: 'transfer',
                        child: Text('Transfers'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                ),

                SizedBox(
                  width: 170,
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedPeriod,
                    decoration: const InputDecoration(
                      labelText: 'Period',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('All time')),
                      DropdownMenuItem(
                        value: 'thisMonth',
                        child: Text('This month'),
                      ),
                      DropdownMenuItem(
                        value: 'lastMonth',
                        child: Text('Last month'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedPeriod = value);
                      }
                    },
                  ),
                ),

                SizedBox(
                  width: 200,
                  child: accountsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => const Text('Could not load accounts'),
                    data: (accounts) => DropdownButtonFormField<String>(
                      initialValue: _selectedAccountId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Account',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('All accounts'),
                        ),
                        ...accounts.map(
                          (account) => DropdownMenuItem<String>(
                            value: account.id,
                            child: Text(
                              account.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedAccountId = value);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: transactionsAsync.when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => const Text('Could not load categories'),
                    data: (transactions) {
                      final categories = _getCategories(transactions);

                      return DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All categories'),
                          ),
                          ...categories.map(
                            (category) => DropdownMenuItem<String>(
                              value: category,
                              child: Text(
                                category,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedCategory = value);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

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
                  final categories =
                      transactions
                          .map((transaction) => transaction.category)
                          .whereType<String>()
                          .where((category) => category.trim().isNotEmpty)
                          .toSet()
                          .toList()
                        ..sort();

                  final filteredTransactions = _filterTransactions(
                    transactions,
                  );

                  if (filteredTransactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.search_off, size: 48),
                          const SizedBox(height: 12),
                          const Text(
                            'No matching transactions',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          const Text('Try changing your search or filters.'),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _selectedType = 'all';
                                _selectedAccountId = null;
                                _selectedCategory = null;
                                _selectedPeriod = 'all';
                              });
                            },
                            child: const Text('Clear all filters'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredTransactions.length,
                    separatorBuilder: (_, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
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
