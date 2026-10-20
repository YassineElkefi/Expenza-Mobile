import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/installment_payments_provider.dart';
import '../data/installment_purchases_provider.dart';
import 'add_installment_purchase_dialog.dart';

class InstallmentsPage extends ConsumerWidget {
  const InstallmentsPage({super.key});

  String _money(int millimes) {
    return '${NumberFormat('#,##0.000').format(millimes / 1000)} TND';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchasesAsync = ref.watch(installmentPurchasesProvider);
    final paymentsAsync = ref.watch(installmentPaymentsProvider);

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await showDialog<bool>(
            context: context,
            builder: (_) => const AddInstallmentPurchaseDialog(),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add purchase'),
      ),
      appBar: AppBar(title: const Text('Installments')),
      body: purchasesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) =>
            Center(child: Text('Failed to load purchases: $error')),
        data: (purchases) {
          if (purchases.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 56),
                    SizedBox(height: 16),
                    Text(
                      'No installment purchases yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add a purchase to track its payment schedule.',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return paymentsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) =>
                Center(child: Text('Failed to load payments: $error')),
            data: (payments) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(installmentPurchasesProvider);
                  ref.invalidate(installmentPaymentsProvider);
                  await Future.wait([
                    ref.read(installmentPurchasesProvider.future),
                    ref.read(installmentPaymentsProvider.future),
                  ]);
                },
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: purchases.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final purchase = purchases[index];
                    final purchasePayments = payments
                        .where((p) => p.purchaseId == purchase.id)
                        .toList();

                    final paidPayments = purchasePayments
                        .where((p) => p.paidAt != null)
                        .toList();

                    final paidAmount = paidPayments.fold<int>(
                      0,
                      (sum, payment) => sum + payment.amountMillimes,
                    );

                    final progress = purchase.totalAmountMillimes > 0
                        ? (paidAmount / purchase.totalAmountMillimes).clamp(
                            0.0,
                            1.0,
                          )
                        : 0.0;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              purchase.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              _money(purchase.totalAmountMillimes),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(value: progress),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${paidPayments.length} of '
                                    '${purchase.installmentCount} payments paid',
                                  ),
                                ),
                                Text('${(progress * 100).round()}%'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Paid: ${_money(paidAmount)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              'Remaining: ${_money(purchase.totalAmountMillimes - paidAmount)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Purchased ${DateFormat.yMMMd().format(purchase.purchaseDate)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
