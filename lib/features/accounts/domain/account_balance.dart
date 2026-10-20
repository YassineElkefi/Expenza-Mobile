
import '../../../core/database/app_database.dart';

int calculateAccountBalance({
  required Account account,
  required List<Transaction> transactions,
}) {
  var balance = account.openingBalanceMillimes;

  for (final transaction in transactions) {
    if (transaction.accountId != account.id) continue;

    switch (transaction.transactionType) {
      case 'income':
      case 'transfer_in':
        balance += transaction.amountMillimes;
        break;

      case 'expense':
      case 'transfer_out':
        balance -= transaction.amountMillimes;
        break;
    }
  }

  return balance;
}
