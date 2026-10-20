import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import 'installment_payments_repository.dart';

final installmentPaymentsRepositoryProvider =
    Provider<InstallmentPaymentsRepository>((ref) {
      return InstallmentPaymentsRepository(ref.watch(databaseProvider));
    });
