import 'package:expenza_flutter/features/dashboard/data/safe_to_spend_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/dashboard_provider.dart';
import '../../accounts/data/account_balances_provider.dart';
import '../../transactions/data/transactions_providers.dart';

import 'package:fl_chart/fl_chart.dart';

import 'package:go_router/go_router.dart';

class SafeToSpendCard extends ConsumerWidget {
  const SafeToSpendCard({super.key});

  String _formatMoney(int millimes) {
    return '${NumberFormat('#,##0.000').format(millimes / 1000)} TND';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(safeToSpendProvider);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Row(
            children: [
              const Expanded(child: Text('Could not load Safe-to-Spend')),
              IconButton(
                onPressed: () => ref.invalidate(safeToSpendProvider),
                icon: const Icon(Icons.refresh),
                tooltip: 'Retry',
              ),
            ],
          ),
          data: (summary) {
            final safeToSpend = summary.safeToSpendMillimes;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text('Safe to Spend', style: theme.textTheme.titleMedium),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _formatMoney(safeToSpend),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: safeToSpend < 0
                        ? theme.colorScheme.error
                        : theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                _SafeToSpendRow(
                  label: 'Current balance',
                  amount: _formatMoney(summary.currentBalanceMillimes),
                ),
                const SizedBox(height: 8),
                _SafeToSpendRow(
                  label: 'Reserved for installments',
                  amount: _formatMoney(summary.reservedInstallmentsMillimes),
                ),
                const SizedBox(height: 8),
                Text(
                  'Includes overdue unpaid installments and '
                  'payments due within the next 30 days.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SafeToSpendRow extends StatelessWidget {
  const _SafeToSpendRow({required this.label, required this.amount});

  final String label;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        const SizedBox(width: 8),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  String _formatMoney(int millimes) {
    return NumberFormat.currency(
      locale: 'en',
      symbol: 'TND ',
      decimalDigits: 3,
    ).format(millimes / 1000);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(dashboardSummaryProvider);
    final selectedPeriod = ref.watch(dashboardPeriodProvider);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardSummaryProvider);
            ref.invalidate(transactionsProvider);
            ref.invalidate(accountBalancesProvider);
            ref.invalidate(safeToSpendProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                'Dashboard',
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your financial overview at a glance.',
                style: TextStyle(color: colors.onSurfaceVariant),
              ),

              const SizedBox(height: 20),
              SegmentedButton<DashboardPeriod>(
                segments: const [
                  ButtonSegment(
                    value: DashboardPeriod.thisMonth,
                    label: Text('This month'),
                  ),
                  ButtonSegment(
                    value: DashboardPeriod.lastMonth,
                    label: Text('Last month'),
                  ),
                  ButtonSegment(
                    value: DashboardPeriod.allTime,
                    label: Text('All time'),
                  ),
                ],
                selected: {selectedPeriod},
                onSelectionChanged: (selection) {
                  ref.read(dashboardPeriodProvider.notifier).state =
                      selection.first;
                },
              ),
              const SizedBox(height: 20),

              const SizedBox(height: 24),
              summaryAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stackTrace) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text('Failed to load dashboard: $error'),
                  ),
                ),
                data: (summary) {
                  final chartPalette = [
                    colors.primary,
                    colors.error,
                    colors.tertiary,
                    colors.secondary,
                    colors.primaryContainer,
                    colors.errorContainer,
                  ];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SummaryCard(
                        title: 'Total balance',
                        amount: _formatMoney(summary.totalBalanceMillimes),
                        icon: Icons.account_balance_wallet_outlined,
                        color: colors.primary,
                        emphasized: true,
                      ),
                      const SafeToSpendCard(),
                      const SizedBox(height: 16),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _SummaryCard(
                              title: 'Income',
                              amount: _formatMoney(summary.totalIncomeMillimes),
                              icon: Icons.trending_up,
                              color: colors.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _SummaryCard(
                              title: 'Expenses',
                              amount: _formatMoney(
                                summary.totalExpensesMillimes,
                              ),
                              icon: Icons.trending_down,
                              color: colors.error,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),
                      Text(
                        'Expenses by category',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: summary.expensesByCategory.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Center(
                                    child: Text(
                                      'No expenses to display yet.',
                                      style: TextStyle(
                                        color: colors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 220,
                                      child: PieChart(
                                        PieChartData(
                                          sectionsSpace: 3,
                                          centerSpaceRadius: 42,
                                          sections: summary
                                              .expensesByCategory
                                              .entries
                                              .toList()
                                              .asMap()
                                              .entries
                                              .map((entry) {
                                                final category =
                                                    entry.value.key;
                                                final amount =
                                                    entry.value.value;
                                                final color =
                                                    chartPalette[entry.key %
                                                        chartPalette.length];

                                                return PieChartSectionData(
                                                  value: amount.toDouble(),
                                                  color: color,
                                                  radius: 55,
                                                  title: '',
                                                );
                                              })
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...summary.expensesByCategory.entries
                                        .toList()
                                        .asMap()
                                        .entries
                                        .map((item) {
                                          final index = item.key;
                                          final entry = item.value;
                                          final percentage =
                                              summary.totalExpensesMillimes == 0
                                              ? 0.0
                                              : entry.value /
                                                    summary
                                                        .totalExpensesMillimes *
                                                    100;

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 12,
                                                  height: 12,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        chartPalette[index %
                                                            chartPalette
                                                                .length],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    entry.key,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(
                                                  '${percentage.toStringAsFixed(1)}%',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(width: 12),
                                                Text(_formatMoney(entry.value)),
                                              ],
                                            ),
                                          );
                                        }),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Recent transactions',
                              style: textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/transactions'),
                            child: const Text('View all'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (summary.recentTransactions.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.receipt_long_outlined,
                                    size: 40,
                                    color: colors.onSurfaceVariant,
                                  ),
                                  const SizedBox(height: 12),
                                  const Text('No transactions yet'),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your recent activity will appear here.',
                                    style: TextStyle(
                                      color: colors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      else
                        ...summary.recentTransactions.map((transaction) {
                          final isIncoming =
                              transaction.transactionType == 'income' ||
                              transaction.transactionType == 'transfer_in';

                          final title =
                              (transaction.description?.isNotEmpty ?? false)
                              ? transaction.description!
                              : transaction.category ??
                                    _transactionLabel(
                                      transaction.transactionType,
                                    );

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: isIncoming
                                    ? colors.primaryContainer
                                    : colors.errorContainer,
                                child: Icon(
                                  isIncoming
                                      ? Icons.arrow_downward_rounded
                                      : Icons.arrow_upward_rounded,
                                  color: isIncoming
                                      ? colors.onPrimaryContainer
                                      : colors.onErrorContainer,
                                ),
                              ),
                              title: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${_transactionLabel(transaction.transactionType)}'
                                ' · '
                                '${DateFormat.yMMMd().format(transaction.transactionDate)}',
                              ),
                              trailing: Text(
                                '${isIncoming ? '+' : '-'}'
                                '${_formatMoney(transaction.amountMillimes)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: isIncoming
                                      ? colors.primary
                                      : colors.error,
                                ),
                              ),
                            ),
                          );
                        }),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _transactionLabel(String type) {
    switch (type) {
      case 'income':
        return 'Income';
      case 'expense':
        return 'Expense';
      case 'transfer_in':
        return 'Transfer received';
      case 'transfer_out':
        return 'Transfer sent';
      default:
        return 'Transaction';
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.icon,
    required this.color,
    this.emphasized = false,
  });

  final String title;
  final String amount;
  final IconData icon;
  final Color color;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      color: emphasized ? colors.primaryContainer : colors.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: emphasized ? colors.onPrimaryContainer : color,
              size: 24,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                color: emphasized
                    ? colors.onPrimaryContainer
                    : colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              amount,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: emphasized ? colors.onPrimaryContainer : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
