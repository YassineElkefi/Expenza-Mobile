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
    });
  }
}
