import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../../../core/database/app_database.dart';

final installmentPaymentsProvider = StreamProvider<List<InstallmentPayment>>((
  ref,
) {
  final database = ref.watch(databaseProvider);

  return database.select(database.installmentPayments).watch();
});
