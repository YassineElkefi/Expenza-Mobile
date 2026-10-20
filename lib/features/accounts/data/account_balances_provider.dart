import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../transactions/data/transactions_providers.dart';
import 'accounts_providers.dart';
import '../domain/account_balance.dart';

final accountBalancesProvider = Provider<AsyncValue<List<AccountWithBalance>>>((
  ref,
) {
  final accountsAsync = ref.watch(accountsProvider);
  final transactionsAsync = ref.watch(transactionsProvider);

  if (accountsAsync.isLoading || transactionsAsync.isLoading) {
    return const AsyncLoading();
  }

  if (accountsAsync.hasError) {
    return AsyncError(accountsAsync.error!, accountsAsync.stackTrace!);
  }

  if (transactionsAsync.hasError) {
    return AsyncError(transactionsAsync.error!, transactionsAsync.stackTrace!);
  }

  final accounts = accountsAsync.value ?? [];
  final transactions = transactionsAsync.value ?? [];

  return AsyncData(
    accounts.map((account) {
      return AccountWithBalance(
        account: account,
        balanceMillimes: calculateAccountBalance(
          account: account,
          transactions: transactions,
        ),
      );
    }).toList(),
  );
});

class AccountWithBalance {
  const AccountWithBalance({
    required this.account,
    required this.balanceMillimes,
  });

  final Account account;
  final int balanceMillimes;
}
