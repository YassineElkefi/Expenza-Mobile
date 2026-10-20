import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/database_provider.dart';

class ImportExportService {
  ImportExportService(this._db);

  final AppDatabase _db;

  // ── Export ──────────────────────────────────────────────────────────────────

  Future<String> exportJson({String? from, String? to}) async {
    final accounts = await _db.select(_db.accounts).get();
    final allTransactions = await _db.select(_db.transactions).get();
    final purchases = await _db.select(_db.installmentPurchases).get();
    final payments = await _db.select(_db.installmentPayments).get();

    // Compute live balance per account (mirrors what the web export does).
    Map<String, int> income = {};
    Map<String, int> expense = {};
    for (final t in allTransactions) {
      final type = t.transactionType;
      if (type == 'income' || type == 'transfer_in') {
        income[t.accountId] = (income[t.accountId] ?? 0) + t.amountMillimes;
      } else if (type == 'expense' || type == 'transfer_out') {
        expense[t.accountId] = (expense[t.accountId] ?? 0) + t.amountMillimes;
      }
    }

    // Filter transactions by date range if provided.
    final filtered = allTransactions.where((t) {
      final d = _dateString(t.transactionDate);
      if (from != null && d.compareTo(from) < 0) return false;
      if (to != null && d.compareTo(to) > 0) return false;
      return true;
    }).toList();

    final result = {
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'period': (from != null && to != null) ? {'from': from, 'to': to} : 'all',
      'accounts': accounts.map((a) {
        final inc = income[a.id] ?? 0;
        final exp = expense[a.id] ?? 0;
        return {
          'id': a.id,
          'name': a.name,
          'account_type': a.accountType,
          'opening_balance_millimes': a.openingBalanceMillimes,
          'balance_millimes': a.openingBalanceMillimes + inc - exp,
          'created_at': a.createdAt?.toUtc().toIso8601String(),
        };
      }).toList(),
      'transactions': filtered
          .map(
            (t) => {
              'id': t.id,
              'account_id': t.accountId,
              'transaction_type': t.transactionType,
              'amount_millimes': t.amountMillimes,
              'category': t.category ?? '',
              'description': t.description ?? '',
              'transaction_date': _dateString(t.transactionDate),
              'transfer_id': t.transferId,
              'obligation_id': t.obligationId,
              'created_at': t.createdAt?.toUtc().toIso8601String(),
            },
          )
          .toList(),
      'installments': {
        'purchases': purchases.map((p) {
          final purchasePayments =
              payments.where((pay) => pay.purchaseId == p.id).toList()
                ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
          final nextPayment = purchasePayments
              .where((pay) => pay.paidAt == null)
              .firstOrNull;
          final firstDue = purchasePayments.isNotEmpty
              ? _dateString(purchasePayments.first.dueDate)
              : _dateString(p.purchaseDate);
          return {
            'id': p.id,
            'name': p.name,
            'account_id': p.accountId,
            'total_amount_millimes': p.totalAmountMillimes,
            'installment_count': p.installmentCount,
            'first_due_date': firstDue,
            'next_due_date': nextPayment != null
                ? _dateString(nextPayment.dueDate)
                : null,
            'active': nextPayment != null,
            'created_at': p.createdAt?.toUtc().toIso8601String(),
          };
        }).toList(),
        'payments': payments.map((pay) {
          final number =
              payments
                  .where((p) => p.purchaseId == pay.purchaseId)
                  .toList()
                  .indexWhere((p) => p.id == pay.id) +
              1;
          return {
            'id': pay.id,
            'obligation_id': pay.purchaseId, // web calls it obligation_id
            'number': number,
            'amount_millimes': pay.amountMillimes,
            'due_date': _dateString(pay.dueDate),
            'status': pay.paidAt != null ? 'paid' : 'unpaid',
            'paid_at': pay.paidAt?.toUtc().toIso8601String(),
            'transaction_id': pay.transactionId,
          };
        }).toList(),
      },
    };

    return const JsonEncoder.withIndent('  ').convert(result);
  }

  // ── Import ──────────────────────────────────────────────────────────────────

  Future<ImportResult> importJson(String jsonString) async {
    final Map<String, dynamic> data;
    try {
      data = json.decode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      throw FormatException('Invalid JSON file.');
    }

    var accountsImported = 0;
    var transactionsImported = 0;
    var purchasesImported = 0;
    var paymentsImported = 0;

    await _db.transaction(() async {
      // ── Accounts ────────────────────────────────────────────────────────
      final rawAccounts = data['accounts'] as List<dynamic>? ?? [];
      for (final raw in rawAccounts) {
        final a = raw as Map<String, dynamic>;
        final id = a['id'] as String;

        // Skip if already exists (idempotent import).
        final existing = await (_db.select(
          _db.accounts,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (existing != null) continue;

        await _db
            .into(_db.accounts)
            .insert(
              AccountsCompanion.insert(
                id: id,
                name: a['name'] as String,
                accountType: a['account_type'] as String,
                openingBalanceMillimes: a['opening_balance_millimes'] as int,
                createdAt: Value(_parseIso(a['created_at'] as String?)),
              ),
            );
        accountsImported++;
      }

      // ── Transactions ─────────────────────────────────────────────────────
      final rawTx = data['transactions'] as List<dynamic>? ?? [];
      for (final raw in rawTx) {
        final t = raw as Map<String, dynamic>;
        final id = t['id'] as String;

        final existing = await (_db.select(
          _db.transactions,
        )..where((row) => row.id.equals(id))).getSingleOrNull();
        if (existing != null) continue;

        await _db
            .into(_db.transactions)
            .insert(
              TransactionsCompanion.insert(
                id: id,
                accountId: t['account_id'] as String,
                transactionType: t['transaction_type'] as String,
                amountMillimes: t['amount_millimes'] as int,
                // transaction_date is stored as a date-only string on the web;
                // parse it to midnight UTC so comparisons stay consistent.
                transactionDate: _parseDateOnly(
                  t['transaction_date'] as String,
                ),
                category: Value((t['category'] as String?)?.trim()),
                description: Value((t['description'] as String?)?.trim()),
                transferId: Value(t['transfer_id'] as String?),
                obligationId: Value(t['obligation_id'] as String?),
                createdAt: Value(_parseIso(t['created_at'] as String?)),
              ),
            );
        transactionsImported++;
      }

      // ── Installments ─────────────────────────────────────────────────────
      final installments = data['installments'] as Map<String, dynamic>? ?? {};

      final rawPurchases = installments['purchases'] as List<dynamic>? ?? [];
      for (final raw in rawPurchases) {
        final p = raw as Map<String, dynamic>;
        final id = p['id'] as String;

        final existing = await (_db.select(
          _db.installmentPurchases,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (existing != null) continue;

        // Use first_due_date as a proxy for purchaseDate (one month before).
        final firstDue = _parseDateOnly(p['first_due_date'] as String);
        final purchaseDate = DateTime(
          firstDue.year,
          firstDue.month - 1,
          firstDue.day,
        );

        await _db
            .into(_db.installmentPurchases)
            .insert(
              InstallmentPurchasesCompanion.insert(
                id: id,
                name: p['name'] as String,
                totalAmountMillimes: p['total_amount_millimes'] as int,
                purchaseDate: purchaseDate,
                installmentCount: p['installment_count'] as int,
                accountId: Value(p['account_id'] as String?),
                createdAt: Value(_parseIso(p['created_at'] as String?)),
              ),
            );
        purchasesImported++;
      }

      final rawPayments = installments['payments'] as List<dynamic>? ?? [];
      for (final raw in rawPayments) {
        final p = raw as Map<String, dynamic>;
        final id = p['id'] as String;

        final existing = await (_db.select(
          _db.installmentPayments,
        )..where((t) => t.id.equals(id))).getSingleOrNull();
        if (existing != null) continue;

        // Web uses 'obligation_id' to mean the purchase ID.
        final purchaseId = p['obligation_id'] as String;

        await _db
            .into(_db.installmentPayments)
            .insert(
              InstallmentPaymentsCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                amountMillimes: p['amount_millimes'] as int,
                dueDate: _parseDateOnly(p['due_date'] as String),
                paidAt: Value(_parseIso(p['paid_at'] as String?)),
                transactionId: Value(p['transaction_id'] as String?),
              ),
            );
        paymentsImported++;
      }
    });

    return ImportResult(
      accountsImported: accountsImported,
      transactionsImported: transactionsImported,
      purchasesImported: purchasesImported,
      paymentsImported: paymentsImported,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  /// Formats a DateTime as "YYYY-MM-DD" (matching the web format).
  String _dateString(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}'
      '-${date.month.toString().padLeft(2, '0')}'
      '-${date.day.toString().padLeft(2, '0')}';

  /// Parses a "YYYY-MM-DD" string to midnight UTC.
  DateTime _parseDateOnly(String s) {
    final parts = s.split('-');
    return DateTime.utc(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  /// Parses a nullable ISO-8601 string; returns null if absent.
  DateTime? _parseIso(String? s) =>
      s == null ? null : DateTime.parse(s).toLocal();
}

class ImportResult {
  const ImportResult({
    required this.accountsImported,
    required this.transactionsImported,
    required this.purchasesImported,
    required this.paymentsImported,
  });

  final int accountsImported;
  final int transactionsImported;
  final int purchasesImported;
  final int paymentsImported;

  @override
  String toString() =>
      'Imported: $accountsImported accounts, $transactionsImported transactions, '
      '$purchasesImported purchases, $paymentsImported payments.';
}

final importExportServiceProvider = Provider<ImportExportService>((ref) {
  return ImportExportService(ref.watch(databaseProvider));
});
