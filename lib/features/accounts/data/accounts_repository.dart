import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class AccountsRepository {
  AccountsRepository(this._database);

  final AppDatabase _database;

  Future<List<Account>> getAll() {
    return (_database.select(
      _database.accounts,
    )..orderBy([(account) => OrderingTerm.asc(account.name)])).get();
  }

  Stream<List<Account>> watchAll() {
    return (_database.select(
      _database.accounts,
    )..orderBy([(account) => OrderingTerm.asc(account.name)])).watch();
  }

  Future<void> add({
    required String id,
    required String name,
    required String accountType,
    required int openingBalanceMillimes,
    DateTime? createdAt,
  }) async {
    await _database
        .into(_database.accounts)
        .insert(
          AccountsCompanion.insert(
            id: id,
            name: name,
            accountType: accountType,
            openingBalanceMillimes: openingBalanceMillimes,
            createdAt: Value(createdAt),
          ),
        );
  }

  Future<void> delete(String id) async {
    await (_database.delete(
      _database.accounts,
    )..where((account) => account.id.equals(id))).go();
  }
}
