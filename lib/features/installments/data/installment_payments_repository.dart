import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';

class InstallmentPaymentsRepository {
  InstallmentPaymentsRepository(this._database);

  final AppDatabase _database;

  Future<void> markAsPaid(String paymentId) async {
    await _database.transaction(() async {
      final payment = await (_database.select(
        _database.installmentPayments,
      )..where((t) => t.id.equals(paymentId))).getSingleOrNull();

      if (payment == null) throw StateError('Payment not found.');
      if (payment.paidAt != null) return; // already paid, idempotent

      final purchase = await (_database.select(
        _database.installmentPurchases,
      )..where((t) => t.id.equals(payment.purchaseId))).getSingleOrNull();

      if (purchase == null) throw StateError('Purchase not found.');

      final now = DateTime.now();
      String? transactionId;

      if (purchase.accountId != null) {
        final uuid = const Uuid();
        final expense = await _database
            .into(_database.transactions)
            .insertReturning(
              TransactionsCompanion.insert(
                id: uuid.v4(), // generate a real ID
                accountId: purchase.accountId!,
                transactionType: 'expense',
                amountMillimes: payment.amountMillimes,
                category: const Value('Installment Payment'),
                description: Value(
                  '${purchase.name} — installment of ${purchase.installmentCount}',
                ),
                transactionDate: now,
                obligationId: Value(payment.purchaseId), // fixed
              ),
            );
        transactionId = expense.id;
      }

      await (_database.update(
        _database.installmentPayments,
      )..where((t) => t.id.equals(paymentId))).write(
        InstallmentPaymentsCompanion(
          paidAt: Value(now),
          transactionId: Value(transactionId),
        ),
      );
    });
  }
}
