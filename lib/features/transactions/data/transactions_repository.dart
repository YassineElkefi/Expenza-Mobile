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
    if (amountMillimes <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }

    if (transactionType == 'expense') {
      await _database.transaction(() async {
        final balance = await _getAccountBalanceMillimes(accountId);

        if (balance < amountMillimes) {
          throw StateError(
            'Insufficient funds. Available balance: '
            '${(balance / 1000).toStringAsFixed(3)} TND.',
          );
        }

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
      });
      return;
    }

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
    await _database.transaction(() async {
      final transaction = await (_database.select(
        _database.transactions,
      )..where((row) => row.id.equals(id))).getSingleOrNull();

      if (transaction == null) return;

      final transferId = transaction.transferId;

      if (transferId != null) {
        await (_database.delete(
          _database.transactions,
        )..where((row) => row.transferId.equals(transferId))).go();
      } else {
        await (_database.delete(
          _database.transactions,
        )..where((row) => row.id.equals(id))).go();
      }
    });
  }

  Future<void> transfer({
    required String sourceAccountId,
    required String destinationAccountId,
    required int amountMillimes,
    required DateTime transactionDate,
    String? description,
  }) async {
    if (sourceAccountId == destinationAccountId) {
      throw ArgumentError('Source and destination accounts must differ.');
    }

    if (amountMillimes <= 0) {
      throw ArgumentError('Transfer amount must be greater than zero.');
    }

    final transferId = DateTime.now().microsecondsSinceEpoch.toString();
    final createdAt = DateTime.now();

    await _database.transaction(() async {
      final source =
          await (_database.select(_database.accounts)
                ..where((account) => account.id.equals(sourceAccountId)))
              .getSingleOrNull();

      final destination =
          await (_database.select(_database.accounts)
                ..where((account) => account.id.equals(destinationAccountId)))
              .getSingleOrNull();

      if (source == null || destination == null) {
        throw StateError('Source or destination account was not found.');
      }

      final sourceBalance = await _getAccountBalanceMillimes(sourceAccountId);

      if (sourceBalance < amountMillimes) {
        throw StateError(
          'Insufficient funds. Available balance: '
          '${(sourceBalance / 1000).toStringAsFixed(3)} TND.',
        );
      }

      if (sourceBalance < amountMillimes) {
        throw StateError(
          'Insufficient funds. Available balance: '
          '${sourceBalance / 1000} TND.',
        );
      }

      await _database
          .into(_database.transactions)
          .insert(
            TransactionsCompanion.insert(
              id: '${transferId}_out',
              accountId: sourceAccountId,
              transactionType: 'transfer_out',
              amountMillimes: amountMillimes,
              transactionDate: transactionDate,
              transferId: Value(transferId),
              description: Value(description),
              createdAt: Value(createdAt),
            ),
          );

      await _database
          .into(_database.transactions)
          .insert(
            TransactionsCompanion.insert(
              id: '${transferId}_in',
              accountId: destinationAccountId,
              transactionType: 'transfer_in',
              amountMillimes: amountMillimes,
              transactionDate: transactionDate,
              transferId: Value(transferId),
              description: Value(description),
              createdAt: Value(createdAt),
            ),
          );
    });
  }

  Future<int> _getAccountBalanceMillimes(String accountId) async {
    final account = await (_database.select(
      _database.accounts,
    )..where((row) => row.id.equals(accountId))).getSingleOrNull();

    if (account == null) {
      throw StateError('Account was not found.');
    }

    final transactions = await (_database.select(
      _database.transactions,
    )..where((row) => row.accountId.equals(accountId))).get();

    var balance = account.openingBalanceMillimes;

    for (final transaction in transactions) {
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
}
