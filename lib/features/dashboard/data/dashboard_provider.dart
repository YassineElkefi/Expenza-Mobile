import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../accounts/data/account_balances_provider.dart';
import '../../transactions/data/transactions_providers.dart';

enum DashboardPeriod { thisMonth, lastMonth, allTime }

class DashboardSummary {
  const DashboardSummary({
    required this.totalBalanceMillimes,
    required this.totalIncomeMillimes,
    required this.totalExpensesMillimes,
    required this.recentTransactions,
    required this.expensesByCategory,
  });

  final int totalBalanceMillimes;
  final int totalIncomeMillimes;
  final int totalExpensesMillimes;
  final List<Transaction> recentTransactions;
  final Map<String, int> expensesByCategory;
}

class DashboardPeriodNotifier extends Notifier<DashboardPeriod> {
  @override
  DashboardPeriod build() => DashboardPeriod.thisMonth;

  void setPeriod(DashboardPeriod period) {
    state = period;
  }
}

final dashboardPeriodProvider =
    NotifierProvider<DashboardPeriodNotifier, DashboardPeriod>(
      DashboardPeriodNotifier.new,
    );

final dashboardSummaryProvider = Provider<AsyncValue<DashboardSummary>>((ref) {
  final period = ref.watch(dashboardPeriodProvider);
  final balancesAsync = ref.watch(accountBalancesProvider);
  final transactionsAsync = ref.watch(transactionsProvider);

  if (balancesAsync.isLoading || transactionsAsync.isLoading) {
    return const AsyncLoading();
  }

  if (balancesAsync.hasError) {
    return AsyncError(balancesAsync.error!, balancesAsync.stackTrace!);
  }

  if (transactionsAsync.hasError) {
    return AsyncError(transactionsAsync.error!, transactionsAsync.stackTrace!);
  }

  final accounts = balancesAsync.value!;
  final allTransactions = transactionsAsync.value!;

  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month);
  final nextMonthStart = DateTime(now.year, now.month + 1);
  final lastMonthStart = DateTime(now.year, now.month - 1);

  final filteredTransactions = allTransactions.where((transaction) {
    final date = transaction.transactionDate;

    switch (period) {
      case DashboardPeriod.thisMonth:
        return !date.isBefore(monthStart) && date.isBefore(nextMonthStart);
      case DashboardPeriod.lastMonth:
        return !date.isBefore(lastMonthStart) && date.isBefore(monthStart);
      case DashboardPeriod.allTime:
        return true;
    }
  }).toList();

  final totalBalance = accounts.fold<int>(
    0,
    (sum, account) => sum + account.balanceMillimes,
  );

  var totalIncome = 0;
  var totalExpenses = 0;
  final expensesByCategory = <String, int>{};

  for (final transaction in filteredTransactions) {
    switch (transaction.transactionType) {
      case 'income':
        totalIncome += transaction.amountMillimes;
        break;
      case 'expense':
        totalExpenses += transaction.amountMillimes;

        final category = transaction.category?.trim();
        final categoryName = (category == null || category.isEmpty)
            ? 'Uncategorized'
            : category;

        expensesByCategory.update(
          categoryName,
          (current) => current + transaction.amountMillimes,
          ifAbsent: () => transaction.amountMillimes,
        );
        break;
    }
  }

  return AsyncData(
    DashboardSummary(
      totalBalanceMillimes: totalBalance,
      totalIncomeMillimes: totalIncome,
      totalExpensesMillimes: totalExpenses,
      expensesByCategory: expensesByCategory,
      recentTransactions: filteredTransactions.take(5).toList(),
    ),
  );
});
