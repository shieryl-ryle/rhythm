// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ConsentRecordsTable extends ConsentRecords
    with TableInfo<$ConsentRecordsTable, ConsentRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConsentRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _consentVersionMeta = const VerificationMeta(
    'consentVersion',
  );
  @override
  late final GeneratedColumn<String> consentVersion = GeneratedColumn<String>(
    'consent_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acceptedAtMeta = const VerificationMeta(
    'acceptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> acceptedAt = GeneratedColumn<DateTime>(
    'accepted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, consentVersion, acceptedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'consent';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConsentRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('consent_version')) {
      context.handle(
        _consentVersionMeta,
        consentVersion.isAcceptableOrUnknown(
          data['consent_version']!,
          _consentVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_consentVersionMeta);
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
        _acceptedAtMeta,
        acceptedAt.isAcceptableOrUnknown(data['accepted_at']!, _acceptedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_acceptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ConsentRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConsentRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      consentVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}consent_version'],
      )!,
      acceptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}accepted_at'],
      )!,
    );
  }

  @override
  $ConsentRecordsTable createAlias(String alias) {
    return $ConsentRecordsTable(attachedDatabase, alias);
  }
}

class ConsentRecord extends DataClass implements Insertable<ConsentRecord> {
  final int id;
  final String consentVersion;
  final DateTime acceptedAt;
  const ConsentRecord({
    required this.id,
    required this.consentVersion,
    required this.acceptedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['consent_version'] = Variable<String>(consentVersion);
    map['accepted_at'] = Variable<DateTime>(acceptedAt);
    return map;
  }

  ConsentRecordsCompanion toCompanion(bool nullToAbsent) {
    return ConsentRecordsCompanion(
      id: Value(id),
      consentVersion: Value(consentVersion),
      acceptedAt: Value(acceptedAt),
    );
  }

  factory ConsentRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConsentRecord(
      id: serializer.fromJson<int>(json['id']),
      consentVersion: serializer.fromJson<String>(json['consentVersion']),
      acceptedAt: serializer.fromJson<DateTime>(json['acceptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'consentVersion': serializer.toJson<String>(consentVersion),
      'acceptedAt': serializer.toJson<DateTime>(acceptedAt),
    };
  }

  ConsentRecord copyWith({
    int? id,
    String? consentVersion,
    DateTime? acceptedAt,
  }) => ConsentRecord(
    id: id ?? this.id,
    consentVersion: consentVersion ?? this.consentVersion,
    acceptedAt: acceptedAt ?? this.acceptedAt,
  );
  ConsentRecord copyWithCompanion(ConsentRecordsCompanion data) {
    return ConsentRecord(
      id: data.id.present ? data.id.value : this.id,
      consentVersion: data.consentVersion.present
          ? data.consentVersion.value
          : this.consentVersion,
      acceptedAt: data.acceptedAt.present
          ? data.acceptedAt.value
          : this.acceptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConsentRecord(')
          ..write('id: $id, ')
          ..write('consentVersion: $consentVersion, ')
          ..write('acceptedAt: $acceptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, consentVersion, acceptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConsentRecord &&
          other.id == this.id &&
          other.consentVersion == this.consentVersion &&
          other.acceptedAt == this.acceptedAt);
}

class ConsentRecordsCompanion extends UpdateCompanion<ConsentRecord> {
  final Value<int> id;
  final Value<String> consentVersion;
  final Value<DateTime> acceptedAt;
  const ConsentRecordsCompanion({
    this.id = const Value.absent(),
    this.consentVersion = const Value.absent(),
    this.acceptedAt = const Value.absent(),
  });
  ConsentRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String consentVersion,
    required DateTime acceptedAt,
  }) : consentVersion = Value(consentVersion),
       acceptedAt = Value(acceptedAt);
  static Insertable<ConsentRecord> custom({
    Expression<int>? id,
    Expression<String>? consentVersion,
    Expression<DateTime>? acceptedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (consentVersion != null) 'consent_version': consentVersion,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
    });
  }

  ConsentRecordsCompanion copyWith({
    Value<int>? id,
    Value<String>? consentVersion,
    Value<DateTime>? acceptedAt,
  }) {
    return ConsentRecordsCompanion(
      id: id ?? this.id,
      consentVersion: consentVersion ?? this.consentVersion,
      acceptedAt: acceptedAt ?? this.acceptedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (consentVersion.present) {
      map['consent_version'] = Variable<String>(consentVersion.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConsentRecordsCompanion(')
          ..write('id: $id, ')
          ..write('consentVersion: $consentVersion, ')
          ..write('acceptedAt: $acceptedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$LiltDatabase extends GeneratedDatabase {
  _$LiltDatabase(QueryExecutor e) : super(e);
  $LiltDatabaseManager get managers => $LiltDatabaseManager(this);
  late final $ConsentRecordsTable consentRecords = $ConsentRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [consentRecords];
}

typedef $$ConsentRecordsTableCreateCompanionBuilder =
    ConsentRecordsCompanion Function({
      Value<int> id,
      required String consentVersion,
      required DateTime acceptedAt,
    });
typedef $$ConsentRecordsTableUpdateCompanionBuilder =
    ConsentRecordsCompanion Function({
      Value<int> id,
      Value<String> consentVersion,
      Value<DateTime> acceptedAt,
    });

class $$ConsentRecordsTableFilterComposer
    extends Composer<_$LiltDatabase, $ConsentRecordsTable> {
  $$ConsentRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get consentVersion => $composableBuilder(
    column: $table.consentVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConsentRecordsTableOrderingComposer
    extends Composer<_$LiltDatabase, $ConsentRecordsTable> {
  $$ConsentRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get consentVersion => $composableBuilder(
    column: $table.consentVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConsentRecordsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $ConsentRecordsTable> {
  $$ConsentRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get consentVersion => $composableBuilder(
    column: $table.consentVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => column,
  );
}

class $$ConsentRecordsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $ConsentRecordsTable,
          ConsentRecord,
          $$ConsentRecordsTableFilterComposer,
          $$ConsentRecordsTableOrderingComposer,
          $$ConsentRecordsTableAnnotationComposer,
          $$ConsentRecordsTableCreateCompanionBuilder,
          $$ConsentRecordsTableUpdateCompanionBuilder,
          (
            ConsentRecord,
            BaseReferences<_$LiltDatabase, $ConsentRecordsTable, ConsentRecord>,
          ),
          ConsentRecord,
          PrefetchHooks Function()
        > {
  $$ConsentRecordsTableTableManager(
    _$LiltDatabase db,
    $ConsentRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConsentRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConsentRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConsentRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> consentVersion = const Value.absent(),
                Value<DateTime> acceptedAt = const Value.absent(),
              }) => ConsentRecordsCompanion(
                id: id,
                consentVersion: consentVersion,
                acceptedAt: acceptedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String consentVersion,
                required DateTime acceptedAt,
              }) => ConsentRecordsCompanion.insert(
                id: id,
                consentVersion: consentVersion,
                acceptedAt: acceptedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConsentRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $ConsentRecordsTable,
      ConsentRecord,
      $$ConsentRecordsTableFilterComposer,
      $$ConsentRecordsTableOrderingComposer,
      $$ConsentRecordsTableAnnotationComposer,
      $$ConsentRecordsTableCreateCompanionBuilder,
      $$ConsentRecordsTableUpdateCompanionBuilder,
      (
        ConsentRecord,
        BaseReferences<_$LiltDatabase, $ConsentRecordsTable, ConsentRecord>,
      ),
      ConsentRecord,
      PrefetchHooks Function()
    >;

class $LiltDatabaseManager {
  final _$LiltDatabase _db;
  $LiltDatabaseManager(this._db);
  $$ConsentRecordsTableTableManager get consentRecords =>
      $$ConsentRecordsTableTableManager(_db, _db.consentRecords);
}
