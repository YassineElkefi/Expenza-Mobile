import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import 'installment_purchases_repository.dart';

final installmentPurchasesRepositoryProvider =
    Provider<InstallmentPurchasesRepository>((ref) {
      return InstallmentPurchasesRepository(ref.watch(databaseProvider));
    });
