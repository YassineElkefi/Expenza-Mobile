import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';

final installmentPurchasesProvider = StreamProvider<List<InstallmentPurchase>>((
  ref,
) {
  final database = ref.watch(databaseProvider);

  return (database.select(
    database.installmentPurchases,
  )..orderBy([(table) => OrderingTerm.desc(table.purchaseDate)])).watch();
});
