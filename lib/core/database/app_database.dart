
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Accounts extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get accountType => text().named('account_type')();
  IntColumn get openingBalanceMillimes =>
      integer().named('opening_balance_millimes')();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get accountId => text().named('account_id')();
  TextColumn get transactionType =>
      text().named('transaction_type')();
  IntColumn get amountMillimes =>
      integer().named('amount_millimes')();
  TextColumn get category => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get transactionDate =>
      dateTime().named('transaction_date')();
  TextColumn get transferId =>
      text().named('transfer_id').nullable()();
  TextColumn get obligationId =>
      text().named('obligation_id').nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class InstallmentPurchases extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  IntColumn get totalAmountMillimes =>
      integer().named('total_amount_millimes')();
  DateTimeColumn get purchaseDate =>
      dateTime().named('purchase_date')();
  IntColumn get installmentCount =>
      integer().named('installment_count')();
  TextColumn get accountId =>
      text().named('account_id').nullable()();
  DateTimeColumn get createdAt =>
      dateTime().named('created_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class InstallmentPayments extends Table {
  TextColumn get id => text()();
  TextColumn get purchaseId => text().named('purchase_id')();
  IntColumn get amountMillimes =>
      integer().named('amount_millimes')();
  DateTimeColumn get dueDate => dateTime().named('due_date')();
  DateTimeColumn get paidAt =>
      dateTime().named('paid_at').nullable()();
  TextColumn get transactionId =>
      text().named('transaction_id').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Accounts,
    Transactions,
    InstallmentPurchases,
    InstallmentPayments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'expenza');
}
