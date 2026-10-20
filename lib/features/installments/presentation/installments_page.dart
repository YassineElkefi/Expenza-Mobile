import 'package:expenza_flutter/features/installments/presentation/edit_installment_purchase_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/installment_payments_provider.dart';
import '../data/installment_payments_repository_provider.dart';
import '../data/installment_purchases_provider.dart';
import 'add_installment_purchase_dialog.dart';

class InstallmentsPage extends ConsumerWidget {
  const InstallmentsPage({super.key});

  String _money(int millimes) {
    return '${NumberFormat('#,##0.000').format(millimes / 1000)} TND';
  }

  Future<void> _markAsPaid({
    required BuildContext context,
    required WidgetRef ref,
    required String paymentId,
    required String purchaseName,
    required int amountMillimes,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mark as paid'),
        content: Text(
          'Record a payment of ${NumberFormat('#,##0.000').format(amountMillimes / 1000)} TND '
          'for "$purchaseName"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Mark as paid'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(installmentPaymentsRepositoryProvider)
          .markAsPaid(paymentId);
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not mark as paid: $error')));
    }
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
                    final purchasePayments =
                        payments
                            .where((p) => p.purchaseId == purchase.id)
                            .toList()
                          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));

                    final paidPayments = purchasePayments
                        .where((p) => p.paidAt != null)
                        .toList();

                    final paidAmount = paidPayments.fold<int>(
                      0,
                      (sum, p) => sum + p.amountMillimes,
                    );

                    final progress = purchase.totalAmountMillimes > 0
                        ? (paidAmount / purchase.totalAmountMillimes).clamp(
                            0.0,
                            1.0,
                          )
                        : 0.0;

                    // First unpaid payment
                    final nextPayment = purchasePayments
                        .where((p) => p.paidAt == null)
                        .firstOrNull;

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── Header ──────────────────────────────────
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    purchase.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  onSelected: (action) async {
                                    if (action == 'edit') {
                                      await showDialog(
                                        context: context,
                                        builder: (_) =>
                                            EditInstallmentPurchaseDialog(
                                              purchase: purchase,
                                              payments: purchasePayments,
                                            ),
                                      );
                                    } else if (action == 'delete') {
                                      // delete confirmation goes here
                                    }
                                  },
                                  itemBuilder: (_) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Text('Edit'),
                                    ),
                                    if (paidPayments.isEmpty)
                                      const PopupMenuItem(
                                        value: 'delete',
                                        child: Text('Delete'),
                                      ),
                                  ],
                                ),
                              ],
                            ),

                            // ── Total + progress ─────────────────────────
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
                            const SizedBox(height: 4),
                            Text(
                              'Paid: ${_money(paidAmount)}  •  '
                              'Remaining: ${_money(purchase.totalAmountMillimes - paidAmount)}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Purchased ${DateFormat.yMMMd().format(purchase.purchaseDate)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),

                            // ── Payment schedule ─────────────────────────
                            if (purchasePayments.isNotEmpty) ...[
                              const SizedBox(height: 16),
                              const Divider(),
                              const SizedBox(height: 4),
                              ...purchasePayments.map((payment) {
                                final isPaid = payment.paidAt != null;
                                final isNext = payment.id == nextPayment?.id;

                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                  child: Row(
                                    children: [
                                      // Status icon
                                      Icon(
                                        isPaid
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        size: 18,
                                        color: isPaid
                                            ? Colors.green
                                            : isNext
                                            ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .outline,
                                      ),
                                      const SizedBox(width: 10),

                                      // Due date
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              DateFormat.yMMMd().format(
                                                payment.dueDate,
                                              ),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.copyWith(
                                                    color: isPaid
                                                        ? Theme.of(context)
                                                              .colorScheme
                                                              .outline
                                                        : null,
                                                  ),
                                            ),
                                            if (isPaid &&
                                                payment.paidAt != null)
                                              Text(
                                                'Paid ${DateFormat.yMMMd().format(payment.paidAt!)}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: Colors.green,
                                                    ),
                                              ),
                                          ],
                                        ),
                                      ),

                                      // Amount
                                      Text(
                                        _money(payment.amountMillimes),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: isPaid
                                                  ? Theme.of(context)
                                                        .colorScheme
                                                        .outline
                                                  : null,
                                            ),
                                      ),

                                      // Mark as paid button (next unpaid only)
                                      if (isNext) ...[
                                        const SizedBox(width: 8),
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            visualDensity:
                                                VisualDensity.compact,
                                          ),
                                          onPressed: () => _markAsPaid(
                                            context: context,
                                            ref: ref,
                                            paymentId: payment.id,
                                            purchaseName: purchase.name,
                                            amountMillimes:
                                                payment.amountMillimes,
                                          ),
                                          child: const Text('Pay'),
                                        ),
                                      ],
                                    ],
                                  ),
                                );
                              }),
                            ],
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
