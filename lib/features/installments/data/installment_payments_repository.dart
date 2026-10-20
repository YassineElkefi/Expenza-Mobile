import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class InstallmentPaymentsRepository {
  InstallmentPaymentsRepository(this._database);

  final AppDatabase _database;

  Future<void> markAsPaid(String paymentId) async {
    await _database.transaction(() async {
      final payment = await (_database.select(
        _database.installmentPayments,
      )..where((table) => table.id.equals(paymentId))).getSingleOrNull();

      if (payment == null) {
        throw StateError('Installment payment not found.');
      }

      // Prevent duplicate expenses when a payment is already paid.
      if (payment.paidAt != null) return;

      final purchase =
          await (_database.select(_database.installmentPurchases)
                ..where((table) => table.id.equals(payment.purchaseId)))
              .getSingleOrNull();

      if (purchase == null) {
        throw StateError('Installment purchase not found.');
      }

      final now = DateTime.now();
      String? transactionId;

      // Only create an expense when the purchase has an assigned account.
      if (purchase.accountId != null) {
        final expense = await _database
            .into(_database.transactions)
            .insertReturning(
              TransactionsCompanion.insert(
                accountId: purchase.accountId!,
                transactionType: 'expense',
                amountMillimes: payment.amountMillimes,
                category: const Value('Installment Payment'),
                description: Value(purchase.name),
                transactionDate: now,
                obligationId: Value(payment.id),
                id: '',
              ),
            );

        transactionId = expense.id;
      }

      // Link the payment to the expense and mark it paid.
      await (_database.update(
        _database.installmentPayments,
      )..where((table) => table.id.equals(paymentId))).write(
        InstallmentPaymentsCompanion(
          paidAt: Value(now),
          transactionId: Value(transactionId),
        ),
      );
    });
  }
}
