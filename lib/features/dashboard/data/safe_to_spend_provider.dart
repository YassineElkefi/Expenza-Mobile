import 'package:expenza_flutter/features/installments/data/installment_payments_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../accounts/data/account_balances_provider.dart';
import '../../transactions/data/transactions_providers.dart';

class SafeToSpendSummary {
  const SafeToSpendSummary({
    required this.currentBalanceMillimes,
    required this.reservedInstallmentsMillimes,
  });

  final int currentBalanceMillimes;
  final int reservedInstallmentsMillimes;

  int get safeToSpendMillimes =>
      currentBalanceMillimes - reservedInstallmentsMillimes;
}

final safeToSpendProvider = FutureProvider<SafeToSpendSummary>((ref) async {
  // Recalculate when accounts or transactions change.
  ref.watch(accountBalancesProvider);
  ref.watch(transactionsProvider);

  final database = ref.watch(databaseProvider);
  final accounts = await database.select(database.accounts).get();
  final transactions = await database.select(database.transactions).get();
  final payments = await ref.watch(installmentPaymentsProvider.future);

  var totalBalanceMillimes = 0;

  for (final account in accounts) {
    totalBalanceMillimes += account.openingBalanceMillimes;
  }

  for (final transaction in transactions) {
    switch (transaction.transactionType) {
      case 'income':
      case 'transfer_in':
        totalBalanceMillimes += transaction.amountMillimes;
        break;
      case 'expense':
      case 'transfer_out':
        totalBalanceMillimes -= transaction.amountMillimes;
        break;
      default:
        break;
    }
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final cutoff = today.add(const Duration(days: 30));

  var reservedInstallmentsMillimes = 0;

  for (final payment in payments) {
    if (payment.paidAt != null) continue;
    if (payment.dueDate.isAfter(cutoff)) continue;

    // Includes overdue payments and payments due within 30 days.
    reservedInstallmentsMillimes += payment.amountMillimes;
  }

  return SafeToSpendSummary(
    currentBalanceMillimes: totalBalanceMillimes,
    reservedInstallmentsMillimes: reservedInstallmentsMillimes,
  );
});
