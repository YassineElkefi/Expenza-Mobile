// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingBalanceMillimesMeta =
      const VerificationMeta('openingBalanceMillimes');
  @override
  late final GeneratedColumn<int> openingBalanceMillimes = GeneratedColumn<int>(
    'opening_balance_millimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    accountType,
    openingBalanceMillimes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('opening_balance_millimes')) {
      context.handle(
        _openingBalanceMillimesMeta,
        openingBalanceMillimes.isAcceptableOrUnknown(
          data['opening_balance_millimes']!,
          _openingBalanceMillimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingBalanceMillimesMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      openingBalanceMillimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_balance_millimes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String name;
  final String accountType;
  final int openingBalanceMillimes;
  final DateTime? createdAt;
  const Account({
    required this.id,
    required this.name,
    required this.accountType,
    required this.openingBalanceMillimes,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['account_type'] = Variable<String>(accountType);
    map['opening_balance_millimes'] = Variable<int>(openingBalanceMillimes);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      name: Value(name),
      accountType: Value(accountType),
      openingBalanceMillimes: Value(openingBalanceMillimes),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      accountType: serializer.fromJson<String>(json['accountType']),
      openingBalanceMillimes: serializer.fromJson<int>(
        json['openingBalanceMillimes'],
      ),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'accountType': serializer.toJson<String>(accountType),
      'openingBalanceMillimes': serializer.toJson<int>(openingBalanceMillimes),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  Account copyWith({
    String? id,
    String? name,
    String? accountType,
    int? openingBalanceMillimes,
    Value<DateTime?> createdAt = const Value.absent(),
  }) => Account(
    id: id ?? this.id,
    name: name ?? this.name,
    accountType: accountType ?? this.accountType,
    openingBalanceMillimes:
        openingBalanceMillimes ?? this.openingBalanceMillimes,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      openingBalanceMillimes: data.openingBalanceMillimes.present
          ? data.openingBalanceMillimes.value
          : this.openingBalanceMillimes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountType: $accountType, ')
          ..write('openingBalanceMillimes: $openingBalanceMillimes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, accountType, openingBalanceMillimes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.name == this.name &&
          other.accountType == this.accountType &&
          other.openingBalanceMillimes == this.openingBalanceMillimes &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> accountType;
  final Value<int> openingBalanceMillimes;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.accountType = const Value.absent(),
    this.openingBalanceMillimes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String name,
    required String accountType,
    required int openingBalanceMillimes,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       accountType = Value(accountType),
       openingBalanceMillimes = Value(openingBalanceMillimes);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? accountType,
    Expression<int>? openingBalanceMillimes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (accountType != null) 'account_type': accountType,
      if (openingBalanceMillimes != null)
        'opening_balance_millimes': openingBalanceMillimes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? accountType,
    Value<int>? openingBalanceMillimes,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      openingBalanceMillimes:
          openingBalanceMillimes ?? this.openingBalanceMillimes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (openingBalanceMillimes.present) {
      map['opening_balance_millimes'] = Variable<int>(
        openingBalanceMillimes.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountType: $accountType, ')
          ..write('openingBalanceMillimes: $openingBalanceMillimes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMillimesMeta = const VerificationMeta(
    'amountMillimes',
  );
  @override
  late final GeneratedColumn<int> amountMillimes = GeneratedColumn<int>(
    'amount_millimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _transferIdMeta = const VerificationMeta(
    'transferId',
  );
  @override
  late final GeneratedColumn<String> transferId = GeneratedColumn<String>(
    'transfer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _obligationIdMeta = const VerificationMeta(
    'obligationId',
  );
  @override
  late final GeneratedColumn<String> obligationId = GeneratedColumn<String>(
    'obligation_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    transactionType,
    amountMillimes,
    category,
    description,
    transactionDate,
    transferId,
    obligationId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('amount_millimes')) {
      context.handle(
        _amountMillimesMeta,
        amountMillimes.isAcceptableOrUnknown(
          data['amount_millimes']!,
          _amountMillimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMillimesMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('transfer_id')) {
      context.handle(
        _transferIdMeta,
        transferId.isAcceptableOrUnknown(data['transfer_id']!, _transferIdMeta),
      );
    }
    if (data.containsKey('obligation_id')) {
      context.handle(
        _obligationIdMeta,
        obligationId.isAcceptableOrUnknown(
          data['obligation_id']!,
          _obligationIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      amountMillimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_millimes'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      transferId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_id'],
      ),
      obligationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}obligation_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String accountId;
  final String transactionType;
  final int amountMillimes;
  final String? category;
  final String? description;
  final DateTime transactionDate;
  final String? transferId;
  final String? obligationId;
  final DateTime? createdAt;
  const Transaction({
    required this.id,
    required this.accountId,
    required this.transactionType,
    required this.amountMillimes,
    this.category,
    this.description,
    required this.transactionDate,
    this.transferId,
    this.obligationId,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['transaction_type'] = Variable<String>(transactionType);
    map['amount_millimes'] = Variable<int>(amountMillimes);
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    if (!nullToAbsent || transferId != null) {
      map['transfer_id'] = Variable<String>(transferId);
    }
    if (!nullToAbsent || obligationId != null) {
      map['obligation_id'] = Variable<String>(obligationId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      transactionType: Value(transactionType),
      amountMillimes: Value(amountMillimes),
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      transactionDate: Value(transactionDate),
      transferId: transferId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferId),
      obligationId: obligationId == null && nullToAbsent
          ? const Value.absent()
          : Value(obligationId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      amountMillimes: serializer.fromJson<int>(json['amountMillimes']),
      category: serializer.fromJson<String?>(json['category']),
      description: serializer.fromJson<String?>(json['description']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      transferId: serializer.fromJson<String?>(json['transferId']),
      obligationId: serializer.fromJson<String?>(json['obligationId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'transactionType': serializer.toJson<String>(transactionType),
      'amountMillimes': serializer.toJson<int>(amountMillimes),
      'category': serializer.toJson<String?>(category),
      'description': serializer.toJson<String?>(description),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'transferId': serializer.toJson<String?>(transferId),
      'obligationId': serializer.toJson<String?>(obligationId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  Transaction copyWith({
    String? id,
    String? accountId,
    String? transactionType,
    int? amountMillimes,
    Value<String?> category = const Value.absent(),
    Value<String?> description = const Value.absent(),
    DateTime? transactionDate,
    Value<String?> transferId = const Value.absent(),
    Value<String?> obligationId = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    transactionType: transactionType ?? this.transactionType,
    amountMillimes: amountMillimes ?? this.amountMillimes,
    category: category.present ? category.value : this.category,
    description: description.present ? description.value : this.description,
    transactionDate: transactionDate ?? this.transactionDate,
    transferId: transferId.present ? transferId.value : this.transferId,
    obligationId: obligationId.present ? obligationId.value : this.obligationId,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      amountMillimes: data.amountMillimes.present
          ? data.amountMillimes.value
          : this.amountMillimes,
      category: data.category.present ? data.category.value : this.category,
      description: data.description.present
          ? data.description.value
          : this.description,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      transferId: data.transferId.present
          ? data.transferId.value
          : this.transferId,
      obligationId: data.obligationId.present
          ? data.obligationId.value
          : this.obligationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('transactionType: $transactionType, ')
          ..write('amountMillimes: $amountMillimes, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('transferId: $transferId, ')
          ..write('obligationId: $obligationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    transactionType,
    amountMillimes,
    category,
    description,
    transactionDate,
    transferId,
    obligationId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.transactionType == this.transactionType &&
          other.amountMillimes == this.amountMillimes &&
          other.category == this.category &&
          other.description == this.description &&
          other.transactionDate == this.transactionDate &&
          other.transferId == this.transferId &&
          other.obligationId == this.obligationId &&
          other.createdAt == this.createdAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> transactionType;
  final Value<int> amountMillimes;
  final Value<String?> category;
  final Value<String?> description;
  final Value<DateTime> transactionDate;
  final Value<String?> transferId;
  final Value<String?> obligationId;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.amountMillimes = const Value.absent(),
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.transferId = const Value.absent(),
    this.obligationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String accountId,
    required String transactionType,
    required int amountMillimes,
    this.category = const Value.absent(),
    this.description = const Value.absent(),
    required DateTime transactionDate,
    this.transferId = const Value.absent(),
    this.obligationId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       transactionType = Value(transactionType),
       amountMillimes = Value(amountMillimes),
       transactionDate = Value(transactionDate);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? transactionType,
    Expression<int>? amountMillimes,
    Expression<String>? category,
    Expression<String>? description,
    Expression<DateTime>? transactionDate,
    Expression<String>? transferId,
    Expression<String>? obligationId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (transactionType != null) 'transaction_type': transactionType,
      if (amountMillimes != null) 'amount_millimes': amountMillimes,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (transferId != null) 'transfer_id': transferId,
      if (obligationId != null) 'obligation_id': obligationId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? transactionType,
    Value<int>? amountMillimes,
    Value<String?>? category,
    Value<String?>? description,
    Value<DateTime>? transactionDate,
    Value<String?>? transferId,
    Value<String?>? obligationId,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      transactionType: transactionType ?? this.transactionType,
      amountMillimes: amountMillimes ?? this.amountMillimes,
      category: category ?? this.category,
      description: description ?? this.description,
      transactionDate: transactionDate ?? this.transactionDate,
      transferId: transferId ?? this.transferId,
      obligationId: obligationId ?? this.obligationId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (amountMillimes.present) {
      map['amount_millimes'] = Variable<int>(amountMillimes.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (transferId.present) {
      map['transfer_id'] = Variable<String>(transferId.value);
    }
    if (obligationId.present) {
      map['obligation_id'] = Variable<String>(obligationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('transactionType: $transactionType, ')
          ..write('amountMillimes: $amountMillimes, ')
          ..write('category: $category, ')
          ..write('description: $description, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('transferId: $transferId, ')
          ..write('obligationId: $obligationId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstallmentPurchasesTable extends InstallmentPurchases
    with TableInfo<$InstallmentPurchasesTable, InstallmentPurchase> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallmentPurchasesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMillimesMeta =
      const VerificationMeta('totalAmountMillimes');
  @override
  late final GeneratedColumn<int> totalAmountMillimes = GeneratedColumn<int>(
    'total_amount_millimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<DateTime> purchaseDate = GeneratedColumn<DateTime>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _installmentCountMeta = const VerificationMeta(
    'installmentCount',
  );
  @override
  late final GeneratedColumn<int> installmentCount = GeneratedColumn<int>(
    'installment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    totalAmountMillimes,
    purchaseDate,
    installmentCount,
    accountId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installment_purchases';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstallmentPurchase> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('total_amount_millimes')) {
      context.handle(
        _totalAmountMillimesMeta,
        totalAmountMillimes.isAcceptableOrUnknown(
          data['total_amount_millimes']!,
          _totalAmountMillimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMillimesMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('installment_count')) {
      context.handle(
        _installmentCountMeta,
        installmentCount.isAcceptableOrUnknown(
          data['installment_count']!,
          _installmentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_installmentCountMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstallmentPurchase map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstallmentPurchase(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      totalAmountMillimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_amount_millimes'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}purchase_date'],
      )!,
      installmentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_count'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      ),
    );
  }

  @override
  $InstallmentPurchasesTable createAlias(String alias) {
    return $InstallmentPurchasesTable(attachedDatabase, alias);
  }
}

class InstallmentPurchase extends DataClass
    implements Insertable<InstallmentPurchase> {
  final String id;
  final String name;
  final int totalAmountMillimes;
  final DateTime purchaseDate;
  final int installmentCount;
  final String? accountId;
  final DateTime? createdAt;
  const InstallmentPurchase({
    required this.id,
    required this.name,
    required this.totalAmountMillimes,
    required this.purchaseDate,
    required this.installmentCount,
    this.accountId,
    this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['total_amount_millimes'] = Variable<int>(totalAmountMillimes);
    map['purchase_date'] = Variable<DateTime>(purchaseDate);
    map['installment_count'] = Variable<int>(installmentCount);
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<DateTime>(createdAt);
    }
    return map;
  }

  InstallmentPurchasesCompanion toCompanion(bool nullToAbsent) {
    return InstallmentPurchasesCompanion(
      id: Value(id),
      name: Value(name),
      totalAmountMillimes: Value(totalAmountMillimes),
      purchaseDate: Value(purchaseDate),
      installmentCount: Value(installmentCount),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
    );
  }

  factory InstallmentPurchase.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstallmentPurchase(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      totalAmountMillimes: serializer.fromJson<int>(
        json['totalAmountMillimes'],
      ),
      purchaseDate: serializer.fromJson<DateTime>(json['purchaseDate']),
      installmentCount: serializer.fromJson<int>(json['installmentCount']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'totalAmountMillimes': serializer.toJson<int>(totalAmountMillimes),
      'purchaseDate': serializer.toJson<DateTime>(purchaseDate),
      'installmentCount': serializer.toJson<int>(installmentCount),
      'accountId': serializer.toJson<String?>(accountId),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
    };
  }

  InstallmentPurchase copyWith({
    String? id,
    String? name,
    int? totalAmountMillimes,
    DateTime? purchaseDate,
    int? installmentCount,
    Value<String?> accountId = const Value.absent(),
    Value<DateTime?> createdAt = const Value.absent(),
  }) => InstallmentPurchase(
    id: id ?? this.id,
    name: name ?? this.name,
    totalAmountMillimes: totalAmountMillimes ?? this.totalAmountMillimes,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    installmentCount: installmentCount ?? this.installmentCount,
    accountId: accountId.present ? accountId.value : this.accountId,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
  );
  InstallmentPurchase copyWithCompanion(InstallmentPurchasesCompanion data) {
    return InstallmentPurchase(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      totalAmountMillimes: data.totalAmountMillimes.present
          ? data.totalAmountMillimes.value
          : this.totalAmountMillimes,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      installmentCount: data.installmentCount.present
          ? data.installmentCount.value
          : this.installmentCount,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentPurchase(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('totalAmountMillimes: $totalAmountMillimes, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('installmentCount: $installmentCount, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    totalAmountMillimes,
    purchaseDate,
    installmentCount,
    accountId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstallmentPurchase &&
          other.id == this.id &&
          other.name == this.name &&
          other.totalAmountMillimes == this.totalAmountMillimes &&
          other.purchaseDate == this.purchaseDate &&
          other.installmentCount == this.installmentCount &&
          other.accountId == this.accountId &&
          other.createdAt == this.createdAt);
}

class InstallmentPurchasesCompanion
    extends UpdateCompanion<InstallmentPurchase> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> totalAmountMillimes;
  final Value<DateTime> purchaseDate;
  final Value<int> installmentCount;
  final Value<String?> accountId;
  final Value<DateTime?> createdAt;
  final Value<int> rowid;
  const InstallmentPurchasesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.totalAmountMillimes = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.installmentCount = const Value.absent(),
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstallmentPurchasesCompanion.insert({
    required String id,
    required String name,
    required int totalAmountMillimes,
    required DateTime purchaseDate,
    required int installmentCount,
    this.accountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       totalAmountMillimes = Value(totalAmountMillimes),
       purchaseDate = Value(purchaseDate),
       installmentCount = Value(installmentCount);
  static Insertable<InstallmentPurchase> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? totalAmountMillimes,
    Expression<DateTime>? purchaseDate,
    Expression<int>? installmentCount,
    Expression<String>? accountId,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (totalAmountMillimes != null)
        'total_amount_millimes': totalAmountMillimes,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (installmentCount != null) 'installment_count': installmentCount,
      if (accountId != null) 'account_id': accountId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstallmentPurchasesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? totalAmountMillimes,
    Value<DateTime>? purchaseDate,
    Value<int>? installmentCount,
    Value<String?>? accountId,
    Value<DateTime?>? createdAt,
    Value<int>? rowid,
  }) {
    return InstallmentPurchasesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      totalAmountMillimes: totalAmountMillimes ?? this.totalAmountMillimes,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      installmentCount: installmentCount ?? this.installmentCount,
      accountId: accountId ?? this.accountId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (totalAmountMillimes.present) {
      map['total_amount_millimes'] = Variable<int>(totalAmountMillimes.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<DateTime>(purchaseDate.value);
    }
    if (installmentCount.present) {
      map['installment_count'] = Variable<int>(installmentCount.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentPurchasesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('totalAmountMillimes: $totalAmountMillimes, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('installmentCount: $installmentCount, ')
          ..write('accountId: $accountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstallmentPaymentsTable extends InstallmentPayments
    with TableInfo<$InstallmentPaymentsTable, InstallmentPayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallmentPaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseIdMeta = const VerificationMeta(
    'purchaseId',
  );
  @override
  late final GeneratedColumn<String> purchaseId = GeneratedColumn<String>(
    'purchase_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMillimesMeta = const VerificationMeta(
    'amountMillimes',
  );
  @override
  late final GeneratedColumn<int> amountMillimes = GeneratedColumn<int>(
    'amount_millimes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
    'due_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    purchaseId,
    amountMillimes,
    dueDate,
    paidAt,
    transactionId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installment_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstallmentPayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('purchase_id')) {
      context.handle(
        _purchaseIdMeta,
        purchaseId.isAcceptableOrUnknown(data['purchase_id']!, _purchaseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_purchaseIdMeta);
    }
    if (data.containsKey('amount_millimes')) {
      context.handle(
        _amountMillimesMeta,
        amountMillimes.isAcceptableOrUnknown(
          data['amount_millimes']!,
          _amountMillimesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountMillimesMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstallmentPayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstallmentPayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      purchaseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purchase_id'],
      )!,
      amountMillimes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_millimes'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_date'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      ),
    );
  }

  @override
  $InstallmentPaymentsTable createAlias(String alias) {
    return $InstallmentPaymentsTable(attachedDatabase, alias);
  }
}

class InstallmentPayment extends DataClass
    implements Insertable<InstallmentPayment> {
  final String id;
  final String purchaseId;
  final int amountMillimes;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String? transactionId;
  const InstallmentPayment({
    required this.id,
    required this.purchaseId,
    required this.amountMillimes,
    required this.dueDate,
    this.paidAt,
    this.transactionId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['purchase_id'] = Variable<String>(purchaseId);
    map['amount_millimes'] = Variable<int>(amountMillimes);
    map['due_date'] = Variable<DateTime>(dueDate);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    if (!nullToAbsent || transactionId != null) {
      map['transaction_id'] = Variable<String>(transactionId);
    }
    return map;
  }

  InstallmentPaymentsCompanion toCompanion(bool nullToAbsent) {
    return InstallmentPaymentsCompanion(
      id: Value(id),
      purchaseId: Value(purchaseId),
      amountMillimes: Value(amountMillimes),
      dueDate: Value(dueDate),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
      transactionId: transactionId == null && nullToAbsent
          ? const Value.absent()
          : Value(transactionId),
    );
  }

  factory InstallmentPayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstallmentPayment(
      id: serializer.fromJson<String>(json['id']),
      purchaseId: serializer.fromJson<String>(json['purchaseId']),
      amountMillimes: serializer.fromJson<int>(json['amountMillimes']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
      transactionId: serializer.fromJson<String?>(json['transactionId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'purchaseId': serializer.toJson<String>(purchaseId),
      'amountMillimes': serializer.toJson<int>(amountMillimes),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
      'transactionId': serializer.toJson<String?>(transactionId),
    };
  }

  InstallmentPayment copyWith({
    String? id,
    String? purchaseId,
    int? amountMillimes,
    DateTime? dueDate,
    Value<DateTime?> paidAt = const Value.absent(),
    Value<String?> transactionId = const Value.absent(),
  }) => InstallmentPayment(
    id: id ?? this.id,
    purchaseId: purchaseId ?? this.purchaseId,
    amountMillimes: amountMillimes ?? this.amountMillimes,
    dueDate: dueDate ?? this.dueDate,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
    transactionId: transactionId.present
        ? transactionId.value
        : this.transactionId,
  );
  InstallmentPayment copyWithCompanion(InstallmentPaymentsCompanion data) {
    return InstallmentPayment(
      id: data.id.present ? data.id.value : this.id,
      purchaseId: data.purchaseId.present
          ? data.purchaseId.value
          : this.purchaseId,
      amountMillimes: data.amountMillimes.present
          ? data.amountMillimes.value
          : this.amountMillimes,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentPayment(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('amountMillimes: $amountMillimes, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidAt: $paidAt, ')
          ..write('transactionId: $transactionId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    purchaseId,
    amountMillimes,
    dueDate,
    paidAt,
    transactionId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstallmentPayment &&
          other.id == this.id &&
          other.purchaseId == this.purchaseId &&
          other.amountMillimes == this.amountMillimes &&
          other.dueDate == this.dueDate &&
          other.paidAt == this.paidAt &&
          other.transactionId == this.transactionId);
}

class InstallmentPaymentsCompanion extends UpdateCompanion<InstallmentPayment> {
  final Value<String> id;
  final Value<String> purchaseId;
  final Value<int> amountMillimes;
  final Value<DateTime> dueDate;
  final Value<DateTime?> paidAt;
  final Value<String?> transactionId;
  final Value<int> rowid;
  const InstallmentPaymentsCompanion({
    this.id = const Value.absent(),
    this.purchaseId = const Value.absent(),
    this.amountMillimes = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstallmentPaymentsCompanion.insert({
    required String id,
    required String purchaseId,
    required int amountMillimes,
    required DateTime dueDate,
    this.paidAt = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       purchaseId = Value(purchaseId),
       amountMillimes = Value(amountMillimes),
       dueDate = Value(dueDate);
  static Insertable<InstallmentPayment> custom({
    Expression<String>? id,
    Expression<String>? purchaseId,
    Expression<int>? amountMillimes,
    Expression<DateTime>? dueDate,
    Expression<DateTime>? paidAt,
    Expression<String>? transactionId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (purchaseId != null) 'purchase_id': purchaseId,
      if (amountMillimes != null) 'amount_millimes': amountMillimes,
      if (dueDate != null) 'due_date': dueDate,
      if (paidAt != null) 'paid_at': paidAt,
      if (transactionId != null) 'transaction_id': transactionId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstallmentPaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? purchaseId,
    Value<int>? amountMillimes,
    Value<DateTime>? dueDate,
    Value<DateTime?>? paidAt,
    Value<String?>? transactionId,
    Value<int>? rowid,
  }) {
    return InstallmentPaymentsCompanion(
      id: id ?? this.id,
      purchaseId: purchaseId ?? this.purchaseId,
      amountMillimes: amountMillimes ?? this.amountMillimes,
      dueDate: dueDate ?? this.dueDate,
      paidAt: paidAt ?? this.paidAt,
      transactionId: transactionId ?? this.transactionId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (purchaseId.present) {
      map['purchase_id'] = Variable<String>(purchaseId.value);
    }
    if (amountMillimes.present) {
      map['amount_millimes'] = Variable<int>(amountMillimes.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentPaymentsCompanion(')
          ..write('id: $id, ')
          ..write('purchaseId: $purchaseId, ')
          ..write('amountMillimes: $amountMillimes, ')
          ..write('dueDate: $dueDate, ')
          ..write('paidAt: $paidAt, ')
          ..write('transactionId: $transactionId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $InstallmentPurchasesTable installmentPurchases =
      $InstallmentPurchasesTable(this);
  late final $InstallmentPaymentsTable installmentPayments =
      $InstallmentPaymentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    transactions,
    installmentPurchases,
    installmentPayments,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder = AccountsCompanion Function({
  required String id,
  required String name,
  required String accountType,
  required int openingBalanceMillimes,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});
typedef $$AccountsTableUpdateCompanionBuilder = AccountsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> accountType,
  Value<int> openingBalanceMillimes,
  Value<DateTime?> createdAt,
  Value<int> rowid,
});

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingBalanceMillimes => $composableBuilder(
    column: $table.openingBalanceMillimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingBalanceMillimes => $composableBuilder(
    column: $table.openingBalanceMillimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get openingBalanceMillimes => $composableBuilder(
    column: $table.openingBalanceMillimes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
          Account,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<int> openingBalanceMillimes = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                name: name,
                accountType: accountType,
                openingBalanceMillimes: openingBalanceMillimes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String accountType,
                required int openingBalanceMillimes,
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                name: name,
                accountType: accountType,
                openingBalanceMillimes: openingBalanceMillimes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTable, Account>(table),
                  BaseReferences<_$AppDatabase, $AccountsTable, Account>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
      Account,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String accountId,
      required String transactionType,
      required int amountMillimes,
      Value<String?> category,
      Value<String?> description,
      required DateTime transactionDate,
      Value<String?> transferId,
      Value<String?> obligationId,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> transactionType,
      Value<int> amountMillimes,
      Value<String?> category,
      Value<String?> description,
      Value<DateTime> transactionDate,
      Value<String?> transferId,
      Value<String?> obligationId,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMillimes => $composableBuilder(
    column: $table.amountMillimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferId => $composableBuilder(
    column: $table.transferId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get obligationId => $composableBuilder(
    column: $table.obligationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMillimes => $composableBuilder(
    column: $table.amountMillimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferId => $composableBuilder(
    column: $table.transferId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get obligationId => $composableBuilder(
    column: $table.obligationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMillimes => $composableBuilder(
    column: $table.amountMillimes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transferId => $composableBuilder(
    column: $table.transferId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get obligationId => $composableBuilder(
    column: $table.obligationId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<int> amountMillimes = const Value.absent(),
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String?> transferId = const Value.absent(),
                Value<String?> obligationId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                accountId: accountId,
                transactionType: transactionType,
                amountMillimes: amountMillimes,
                category: category,
                description: description,
                transactionDate: transactionDate,
                transferId: transferId,
                obligationId: obligationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String transactionType,
                required int amountMillimes,
                Value<String?> category = const Value.absent(),
                Value<String?> description = const Value.absent(),
                required DateTime transactionDate,
                Value<String?> transferId = const Value.absent(),
                Value<String?> obligationId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                accountId: accountId,
                transactionType: transactionType,
                amountMillimes: amountMillimes,
                category: category,
                description: description,
                transactionDate: transactionDate,
                transferId: transferId,
                obligationId: obligationId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTable, Transaction>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $TransactionsTable,
                    Transaction
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$InstallmentPurchasesTableCreateCompanionBuilder =
    InstallmentPurchasesCompanion Function({
      required String id,
      required String name,
      required int totalAmountMillimes,
      required DateTime purchaseDate,
      required int installmentCount,
      Value<String?> accountId,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });
typedef $$InstallmentPurchasesTableUpdateCompanionBuilder =
    InstallmentPurchasesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> totalAmountMillimes,
      Value<DateTime> purchaseDate,
      Value<int> installmentCount,
      Value<String?> accountId,
      Value<DateTime?> createdAt,
      Value<int> rowid,
    });

class $$InstallmentPurchasesTableFilterComposer
    extends Composer<_$AppDatabase, $InstallmentPurchasesTable> {
  $$InstallmentPurchasesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAmountMillimes => $composableBuilder(
    column: $table.totalAmountMillimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstallmentPurchasesTableOrderingComposer
    extends Composer<_$AppDatabase, $InstallmentPurchasesTable> {
  $$InstallmentPurchasesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAmountMillimes => $composableBuilder(
    column: $table.totalAmountMillimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstallmentPurchasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstallmentPurchasesTable> {
  $$InstallmentPurchasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get totalAmountMillimes => $composableBuilder(
    column: $table.totalAmountMillimes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get installmentCount => $composableBuilder(
    column: $table.installmentCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$InstallmentPurchasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstallmentPurchasesTable,
          InstallmentPurchase,
          $$InstallmentPurchasesTableFilterComposer,
          $$InstallmentPurchasesTableOrderingComposer,
          $$InstallmentPurchasesTableAnnotationComposer,
          $$InstallmentPurchasesTableCreateCompanionBuilder,
          $$InstallmentPurchasesTableUpdateCompanionBuilder,
          (
            InstallmentPurchase,
            BaseReferences<
              _$AppDatabase,
              $InstallmentPurchasesTable,
              InstallmentPurchase
            >,
          ),
          InstallmentPurchase,
          PrefetchHooks Function()
        > {
  $$InstallmentPurchasesTableTableManager(
    _$AppDatabase db,
    $InstallmentPurchasesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstallmentPurchasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstallmentPurchasesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InstallmentPurchasesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> totalAmountMillimes = const Value.absent(),
                Value<DateTime> purchaseDate = const Value.absent(),
                Value<int> installmentCount = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallmentPurchasesCompanion(
                id: id,
                name: name,
                totalAmountMillimes: totalAmountMillimes,
                purchaseDate: purchaseDate,
                installmentCount: installmentCount,
                accountId: accountId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int totalAmountMillimes,
                required DateTime purchaseDate,
                required int installmentCount,
                Value<String?> accountId = const Value.absent(),
                Value<DateTime?> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallmentPurchasesCompanion.insert(
                id: id,
                name: name,
                totalAmountMillimes: totalAmountMillimes,
                purchaseDate: purchaseDate,
                installmentCount: installmentCount,
                accountId: accountId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InstallmentPurchasesTable, InstallmentPurchase>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $InstallmentPurchasesTable,
                    InstallmentPurchase
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstallmentPurchasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstallmentPurchasesTable,
      InstallmentPurchase,
      $$InstallmentPurchasesTableFilterComposer,
      $$InstallmentPurchasesTableOrderingComposer,
      $$InstallmentPurchasesTableAnnotationComposer,
      $$InstallmentPurchasesTableCreateCompanionBuilder,
      $$InstallmentPurchasesTableUpdateCompanionBuilder,
      (
        InstallmentPurchase,
        BaseReferences<
          _$AppDatabase,
          $InstallmentPurchasesTable,
          InstallmentPurchase
        >,
      ),
      InstallmentPurchase,
      PrefetchHooks Function()
    >;
typedef $$InstallmentPaymentsTableCreateCompanionBuilder =
    InstallmentPaymentsCompanion Function({
      required String id,
      required String purchaseId,
      required int amountMillimes,
      required DateTime dueDate,
      Value<DateTime?> paidAt,
      Value<String?> transactionId,
      Value<int> rowid,
    });
typedef $$InstallmentPaymentsTableUpdateCompanionBuilder =
    InstallmentPaymentsCompanion Function({
      Value<String> id,
      Value<String> purchaseId,
      Value<int> amountMillimes,
      Value<DateTime> dueDate,
      Value<DateTime?> paidAt,
      Value<String?> transactionId,
      Value<int> rowid,
    });

class $$InstallmentPaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $InstallmentPaymentsTable> {
  $$InstallmentPaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountMillimes => $composableBuilder(
    column: $table.amountMillimes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InstallmentPaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $InstallmentPaymentsTable> {
  $$InstallmentPaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountMillimes => $composableBuilder(
    column: $table.amountMillimes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InstallmentPaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstallmentPaymentsTable> {
  $$InstallmentPaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get purchaseId => $composableBuilder(
    column: $table.purchaseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get amountMillimes => $composableBuilder(
    column: $table.amountMillimes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );
}

class $$InstallmentPaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstallmentPaymentsTable,
          InstallmentPayment,
          $$InstallmentPaymentsTableFilterComposer,
          $$InstallmentPaymentsTableOrderingComposer,
          $$InstallmentPaymentsTableAnnotationComposer,
          $$InstallmentPaymentsTableCreateCompanionBuilder,
          $$InstallmentPaymentsTableUpdateCompanionBuilder,
          (
            InstallmentPayment,
            BaseReferences<
              _$AppDatabase,
              $InstallmentPaymentsTable,
              InstallmentPayment
            >,
          ),
          InstallmentPayment,
          PrefetchHooks Function()
        > {
  $$InstallmentPaymentsTableTableManager(
    _$AppDatabase db,
    $InstallmentPaymentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstallmentPaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstallmentPaymentsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InstallmentPaymentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> purchaseId = const Value.absent(),
                Value<int> amountMillimes = const Value.absent(),
                Value<DateTime> dueDate = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallmentPaymentsCompanion(
                id: id,
                purchaseId: purchaseId,
                amountMillimes: amountMillimes,
                dueDate: dueDate,
                paidAt: paidAt,
                transactionId: transactionId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String purchaseId,
                required int amountMillimes,
                required DateTime dueDate,
                Value<DateTime?> paidAt = const Value.absent(),
                Value<String?> transactionId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallmentPaymentsCompanion.insert(
                id: id,
                purchaseId: purchaseId,
                amountMillimes: amountMillimes,
                dueDate: dueDate,
                paidAt: paidAt,
                transactionId: transactionId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InstallmentPaymentsTable, InstallmentPayment>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $InstallmentPaymentsTable,
                    InstallmentPayment
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InstallmentPaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstallmentPaymentsTable,
      InstallmentPayment,
      $$InstallmentPaymentsTableFilterComposer,
      $$InstallmentPaymentsTableOrderingComposer,
      $$InstallmentPaymentsTableAnnotationComposer,
      $$InstallmentPaymentsTableCreateCompanionBuilder,
      $$InstallmentPaymentsTableUpdateCompanionBuilder,
      (
        InstallmentPayment,
        BaseReferences<
          _$AppDatabase,
          $InstallmentPaymentsTable,
          InstallmentPayment
        >,
      ),
      InstallmentPayment,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$InstallmentPurchasesTableTableManager get installmentPurchases =>
      $$InstallmentPurchasesTableTableManager(_db, _db.installmentPurchases);
  $$InstallmentPaymentsTableTableManager get installmentPayments =>
      $$InstallmentPaymentsTableTableManager(_db, _db.installmentPayments);
}
