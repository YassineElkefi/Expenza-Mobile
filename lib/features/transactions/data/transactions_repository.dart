import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class TransactionsRepository {
  TransactionsRepository(this._database);

  final AppDatabase _database;

  Future<List<Transaction>> getAll() {
    return (_database.select(_database.transactions)..orderBy([
          (transaction) => OrderingTerm.desc(transaction.transactionDate),
        ]))
        .get();
  }

  Stream<List<Transaction>> watchAll() {
    return (_database.select(_database.transactions)..orderBy([
          (transaction) => OrderingTerm.desc(transaction.transactionDate),
        ]))
        .watch();
  }

  Future<void> add({
    required String id,
    required String accountId,
    required String transactionType,
    required int amountMillimes,
    required DateTime transactionDate,
    String? category,
    String? description,
    String? transferId,
    String? obligationId,
    DateTime? createdAt,
  }) async {
    await _database
        .into(_database.transactions)
        .insert(
          TransactionsCompanion.insert(
            id: id,
            accountId: accountId,
            transactionType: transactionType,
            amountMillimes: amountMillimes,
            transactionDate: transactionDate,
            category: Value(category),
            description: Value(description),
            transferId: Value(transferId),
            obligationId: Value(obligationId),
            createdAt: Value(createdAt),
          ),
        );
  }

  Future<void> delete(String id) async {
    await (_database.delete(
      _database.transactions,
    )..where((transaction) => transaction.id.equals(id))).go();
  }
}
