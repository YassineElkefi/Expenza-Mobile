import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';

class InstallmentPurchasesRepository {
  InstallmentPurchasesRepository(this._database);

  final AppDatabase _database;
  final _uuid = const Uuid();

  Future<void> addPurchase({
    required String name,
    required int totalAmountMillimes,
    required DateTime purchaseDate,
    required int installmentCount,
    String? accountId,
    List<({int amountMillimes, DateTime dueDate})>? payments, // NEW
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) throw ArgumentError('Purchase name is required.');
    if (totalAmountMillimes <= 0) throw ArgumentError('Amount must be > 0.');
    if (installmentCount <= 0) throw ArgumentError('Count must be > 0.');

    await _database.transaction(() async {
      final purchaseId = _uuid.v4();

      await _database
          .into(_database.installmentPurchases)
          .insert(
            InstallmentPurchasesCompanion.insert(
              id: purchaseId,
              name: trimmedName,
              totalAmountMillimes: totalAmountMillimes,
              purchaseDate: purchaseDate,
              installmentCount: installmentCount,
              accountId: Value(accountId),
              createdAt: Value(DateTime.now()),
            ),
          );

      if (payments != null) {
        // Validate custom schedule
        if (payments.length != installmentCount) {
          throw ArgumentError('Payment count must match installmentCount.');
        }
        final customTotal = payments.fold(
          0,
          (sum, p) => sum + p.amountMillimes,
        );
        if (customTotal != totalAmountMillimes) {
          throw ArgumentError(
            'Custom payments must sum to totalAmountMillimes.',
          );
        }
        for (var i = 0; i < payments.length; i++) {
          await _database
              .into(_database.installmentPayments)
              .insert(
                InstallmentPaymentsCompanion.insert(
                  id: _uuid.v4(),
                  purchaseId: purchaseId,
                  amountMillimes: payments[i].amountMillimes,
                  dueDate: payments[i].dueDate,
                ),
              );
        }
      } else {
        // Existing equal-split logic
        final baseAmount = totalAmountMillimes ~/ installmentCount;
        final remainder = totalAmountMillimes % installmentCount;

        for (var i = 0; i < installmentCount; i++) {
          final amount = baseAmount + (i < remainder ? 1 : 0);
          final dueDate = DateTime(
            purchaseDate.year,
            purchaseDate.month + i + 1,
            purchaseDate.day,
          );
          await _database
              .into(_database.installmentPayments)
              .insert(
                InstallmentPaymentsCompanion.insert(
                  id: _uuid.v4(),
                  purchaseId: purchaseId,
                  amountMillimes: amount,
                  dueDate: dueDate,
                ),
              );
        }
      }
    });
  }

  Future<void> updatePurchase({
    required String purchaseId,
    required String name,
    required int totalAmountMillimes,
    String? accountId,
    required List<({String id, int amountMillimes, DateTime dueDate})> payments,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) throw ArgumentError('Name is required.');
    if (totalAmountMillimes <= 0) throw ArgumentError('Amount must be > 0.');
    if (payments.isEmpty) throw ArgumentError('Payments list is empty.');

    await _database.transaction(() async {
      // 1. Load existing purchase
      final purchase = await (_database.select(
        _database.installmentPurchases,
      )..where((t) => t.id.equals(purchaseId))).getSingleOrNull();
      if (purchase == null) throw StateError('Purchase not found.');

      // 2. Load existing payments
      final existingPayments =
          await (_database.select(_database.installmentPayments)
                ..where((t) => t.purchaseId.equals(purchaseId))
                ..orderBy([(t) => OrderingTerm.asc(t.dueDate)]))
              .get();

      // 3. Block if count changed
      if (payments.length != existingPayments.length) {
        throw StateError('Installment count cannot change while editing.');
      }

      // 4. Block if any payment is in-flight (no "processing" status in
      //    the Drift schema yet, but guard anyway)
      final hasPaid = existingPayments.any((p) => p.paidAt != null);

      // 5. Block account change after a payment is recorded
      if (hasPaid && accountId != purchase.accountId) {
        throw StateError(
          'Account cannot be changed after a payment has been recorded.',
        );
      }

      // 6. Validate submitted IDs match existing
      final existingIds = existingPayments.map((p) => p.id).toSet();
      final submittedIds = payments.map((p) => p.id).toSet();
      if (submittedIds.length != payments.length ||
          !submittedIds.every(existingIds.contains)) {
        throw ArgumentError(
          'Submitted installments do not match this purchase.',
        );
      }

      // 7. Validate total
      final submittedTotal = payments.fold(
        0,
        (sum, p) => sum + p.amountMillimes,
      );
      if (submittedTotal != totalAmountMillimes) {
        throw ArgumentError('Amounts must sum to the total purchase price.');
      }

      // 8. Block editing paid payments
      for (final existing in existingPayments) {
        if (existing.paidAt == null) continue;
        final submitted = payments.firstWhere((p) => p.id == existing.id);
        if (submitted.amountMillimes != existing.amountMillimes ||
            submitted.dueDate != existing.dueDate) {
          throw StateError('Paid installments cannot be changed.');
        }
      }

      // 9. Apply updates to unpaid payments
      for (final existing in existingPayments) {
        if (existing.paidAt != null) continue;
        final submitted = payments.firstWhere((p) => p.id == existing.id);
        await (_database.update(
          _database.installmentPayments,
        )..where((t) => t.id.equals(existing.id))).write(
          InstallmentPaymentsCompanion(
            amountMillimes: Value(submitted.amountMillimes),
            dueDate: Value(submitted.dueDate),
          ),
        );
      }

      // 10. Update the purchase record
      await (_database.update(
        _database.installmentPurchases,
      )..where((t) => t.id.equals(purchaseId))).write(
        InstallmentPurchasesCompanion(
          name: Value(trimmedName),
          accountId: Value(accountId),
          totalAmountMillimes: Value(totalAmountMillimes),
        ),
      );
    });
  }

  Future<void> deletePurchase(String purchaseId) async {
    await _database.transaction(() async {
      final payments = await (_database.select(
        _database.installmentPayments,
      )..where((t) => t.purchaseId.equals(purchaseId))).get();

      final hasSettled = payments.any((p) => p.paidAt != null);
      if (hasSettled) {
        throw StateError(
          'This purchase has a paid installment and cannot be deleted. '
          'Its financial history must be preserved.',
        );
      }

      await (_database.delete(
        _database.installmentPayments,
      )..where((t) => t.purchaseId.equals(purchaseId))).go();

      await (_database.delete(
        _database.installmentPurchases,
      )..where((t) => t.id.equals(purchaseId))).go();
    });
  }
}
