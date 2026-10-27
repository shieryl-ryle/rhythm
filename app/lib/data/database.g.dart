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

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    check: () => id.equals('me'),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('me'),
  );
  static const VerificationMeta _dailyGoalMeta = const VerificationMeta(
    'dailyGoal',
  );
  @override
  late final GeneratedColumn<int> dailyGoal = GeneratedColumn<int>(
    'daily_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _setupDoneAtMeta = const VerificationMeta(
    'setupDoneAt',
  );
  @override
  late final GeneratedColumn<DateTime> setupDoneAt = GeneratedColumn<DateTime>(
    'setup_done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [id, dailyGoal, setupDoneAt, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('daily_goal')) {
      context.handle(
        _dailyGoalMeta,
        dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta),
      );
    }
    if (data.containsKey('setup_done_at')) {
      context.handle(
        _setupDoneAtMeta,
        setupDoneAt.isAcceptableOrUnknown(
          data['setup_done_at']!,
          _setupDoneAtMeta,
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
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      dailyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal'],
      )!,
      setupDoneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}setup_done_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final int dailyGoal;
  final DateTime? setupDoneAt;
  final DateTime createdAt;
  const Profile({
    required this.id,
    required this.dailyGoal,
    this.setupDoneAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['daily_goal'] = Variable<int>(dailyGoal);
    if (!nullToAbsent || setupDoneAt != null) {
      map['setup_done_at'] = Variable<DateTime>(setupDoneAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      dailyGoal: Value(dailyGoal),
      setupDoneAt: setupDoneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(setupDoneAt),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      dailyGoal: serializer.fromJson<int>(json['dailyGoal']),
      setupDoneAt: serializer.fromJson<DateTime?>(json['setupDoneAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'dailyGoal': serializer.toJson<int>(dailyGoal),
      'setupDoneAt': serializer.toJson<DateTime?>(setupDoneAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({
    String? id,
    int? dailyGoal,
    Value<DateTime?> setupDoneAt = const Value.absent(),
    DateTime? createdAt,
  }) => Profile(
    id: id ?? this.id,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    setupDoneAt: setupDoneAt.present ? setupDoneAt.value : this.setupDoneAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
      setupDoneAt: data.setupDoneAt.present
          ? data.setupDoneAt.value
          : this.setupDoneAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('setupDoneAt: $setupDoneAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, dailyGoal, setupDoneAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.dailyGoal == this.dailyGoal &&
          other.setupDoneAt == this.setupDoneAt &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<int> dailyGoal;
  final Value<DateTime?> setupDoneAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.setupDoneAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.setupDoneAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<int>? dailyGoal,
    Expression<DateTime>? setupDoneAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
      if (setupDoneAt != null) 'setup_done_at': setupDoneAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<int>? dailyGoal,
    Value<DateTime?>? setupDoneAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      setupDoneAt: setupDoneAt ?? this.setupDoneAt,
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
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<int>(dailyGoal.value);
    }
    if (setupDoneAt.present) {
      map['setup_done_at'] = Variable<DateTime>(setupDoneAt.value);
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
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('setupDoneAt: $setupDoneAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FollowedActivitiesTable extends FollowedActivities
    with TableInfo<$FollowedActivitiesTable, FollowedActivity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FollowedActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => newId('fol'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityKind, String> activity =
      GeneratedColumn<String>(
        'activity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ActivityKind>(
        $FollowedActivitiesTable.$converteractivity,
      );
  static const VerificationMeta _customNameMeta = const VerificationMeta(
    'customName',
  );
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
    'custom_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<SetupPath, String> path =
      GeneratedColumn<String>(
        'path',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<SetupPath>($FollowedActivitiesTable.$converterpath);
  @override
  late final GeneratedColumnWithTypeConverter<Progress?, String> progress =
      GeneratedColumn<String>(
        'progress',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Progress?>($FollowedActivitiesTable.$converterprogressn);
  static const VerificationMeta _hardBecauseMeta = const VerificationMeta(
    'hardBecause',
  );
  @override
  late final GeneratedColumn<String> hardBecause = GeneratedColumn<String>(
    'hard_because',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<StoppedAgo?, String> stoppedAgo =
      GeneratedColumn<String>(
        'stopped_ago',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<StoppedAgo?>(
        $FollowedActivitiesTable.$converterstoppedAgon,
      );
  static const VerificationMeta _gotInTheWayMeta = const VerificationMeta(
    'gotInTheWay',
  );
  @override
  late final GeneratedColumn<String> gotInTheWay = GeneratedColumn<String>(
    'got_in_the_way',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _wouldHelpMeta = const VerificationMeta(
    'wouldHelp',
  );
  @override
  late final GeneratedColumn<String> wouldHelp = GeneratedColumn<String>(
    'would_help',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Familiarity?, String>
  familiarity =
      GeneratedColumn<String>(
        'familiarity',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Familiarity?>(
        $FollowedActivitiesTable.$converterfamiliarityn,
      );
  static const VerificationMeta _followedAtMeta = const VerificationMeta(
    'followedAt',
  );
  @override
  late final GeneratedColumn<DateTime> followedAt = GeneratedColumn<DateTime>(
    'followed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _unfollowedAtMeta = const VerificationMeta(
    'unfollowedAt',
  );
  @override
  late final GeneratedColumn<DateTime> unfollowedAt = GeneratedColumn<DateTime>(
    'unfollowed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activity,
    customName,
    path,
    progress,
    hardBecause,
    stoppedAgo,
    gotInTheWay,
    wouldHelp,
    familiarity,
    followedAt,
    unfollowedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'followed_activity';
  @override
  VerificationContext validateIntegrity(
    Insertable<FollowedActivity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('custom_name')) {
      context.handle(
        _customNameMeta,
        customName.isAcceptableOrUnknown(data['custom_name']!, _customNameMeta),
      );
    }
    if (data.containsKey('hard_because')) {
      context.handle(
        _hardBecauseMeta,
        hardBecause.isAcceptableOrUnknown(
          data['hard_because']!,
          _hardBecauseMeta,
        ),
      );
    }
    if (data.containsKey('got_in_the_way')) {
      context.handle(
        _gotInTheWayMeta,
        gotInTheWay.isAcceptableOrUnknown(
          data['got_in_the_way']!,
          _gotInTheWayMeta,
        ),
      );
    }
    if (data.containsKey('would_help')) {
      context.handle(
        _wouldHelpMeta,
        wouldHelp.isAcceptableOrUnknown(data['would_help']!, _wouldHelpMeta),
      );
    }
    if (data.containsKey('followed_at')) {
      context.handle(
        _followedAtMeta,
        followedAt.isAcceptableOrUnknown(data['followed_at']!, _followedAtMeta),
      );
    }
    if (data.containsKey('unfollowed_at')) {
      context.handle(
        _unfollowedAtMeta,
        unfollowedAt.isAcceptableOrUnknown(
          data['unfollowed_at']!,
          _unfollowedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FollowedActivity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FollowedActivity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      activity: $FollowedActivitiesTable.$converteractivity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}activity'],
        )!,
      ),
      customName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_name'],
      ),
      path: $FollowedActivitiesTable.$converterpath.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}path'],
        )!,
      ),
      progress: $FollowedActivitiesTable.$converterprogressn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}progress'],
        ),
      ),
      hardBecause: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hard_because'],
      ),
      stoppedAgo: $FollowedActivitiesTable.$converterstoppedAgon.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}stopped_ago'],
        ),
      ),
      gotInTheWay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}got_in_the_way'],
      ),
      wouldHelp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}would_help'],
      ),
      familiarity: $FollowedActivitiesTable.$converterfamiliarityn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}familiarity'],
        ),
      ),
      followedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}followed_at'],
      )!,
      unfollowedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}unfollowed_at'],
      ),
    );
  }

  @override
  $FollowedActivitiesTable createAlias(String alias) {
    return $FollowedActivitiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActivityKind, String, String> $converteractivity =
      const CodedEnumConverter<ActivityKind>(ActivityKind.values);
  static JsonTypeConverter2<SetupPath, String, String> $converterpath =
      const CodedEnumConverter<SetupPath>(SetupPath.values);
  static JsonTypeConverter2<Progress, String, String> $converterprogress =
      const CodedEnumConverter<Progress>(Progress.values);
  static JsonTypeConverter2<Progress?, String?, String?> $converterprogressn =
      JsonTypeConverter2.asNullable($converterprogress);
  static JsonTypeConverter2<StoppedAgo, String, String> $converterstoppedAgo =
      const CodedEnumConverter<StoppedAgo>(StoppedAgo.values);
  static JsonTypeConverter2<StoppedAgo?, String?, String?>
  $converterstoppedAgon = JsonTypeConverter2.asNullable($converterstoppedAgo);
  static JsonTypeConverter2<Familiarity, String, String> $converterfamiliarity =
      const CodedEnumConverter<Familiarity>(Familiarity.values);
  static JsonTypeConverter2<Familiarity?, String?, String?>
  $converterfamiliarityn = JsonTypeConverter2.asNullable($converterfamiliarity);
}

class FollowedActivity extends DataClass
    implements Insertable<FollowedActivity> {
  final String id;
  final ActivityKind activity;
  final String? customName;
  final SetupPath path;
  final Progress? progress;
  final String? hardBecause;
  final StoppedAgo? stoppedAgo;
  final String? gotInTheWay;
  final String? wouldHelp;
  final Familiarity? familiarity;
  final DateTime followedAt;
  final DateTime? unfollowedAt;
  const FollowedActivity({
    required this.id,
    required this.activity,
    this.customName,
    required this.path,
    this.progress,
    this.hardBecause,
    this.stoppedAgo,
    this.gotInTheWay,
    this.wouldHelp,
    this.familiarity,
    required this.followedAt,
    this.unfollowedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['activity'] = Variable<String>(
        $FollowedActivitiesTable.$converteractivity.toSql(activity),
      );
    }
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    {
      map['path'] = Variable<String>(
        $FollowedActivitiesTable.$converterpath.toSql(path),
      );
    }
    if (!nullToAbsent || progress != null) {
      map['progress'] = Variable<String>(
        $FollowedActivitiesTable.$converterprogressn.toSql(progress),
      );
    }
    if (!nullToAbsent || hardBecause != null) {
      map['hard_because'] = Variable<String>(hardBecause);
    }
    if (!nullToAbsent || stoppedAgo != null) {
      map['stopped_ago'] = Variable<String>(
        $FollowedActivitiesTable.$converterstoppedAgon.toSql(stoppedAgo),
      );
    }
    if (!nullToAbsent || gotInTheWay != null) {
      map['got_in_the_way'] = Variable<String>(gotInTheWay);
    }
    if (!nullToAbsent || wouldHelp != null) {
      map['would_help'] = Variable<String>(wouldHelp);
    }
    if (!nullToAbsent || familiarity != null) {
      map['familiarity'] = Variable<String>(
        $FollowedActivitiesTable.$converterfamiliarityn.toSql(familiarity),
      );
    }
    map['followed_at'] = Variable<DateTime>(followedAt);
    if (!nullToAbsent || unfollowedAt != null) {
      map['unfollowed_at'] = Variable<DateTime>(unfollowedAt);
    }
    return map;
  }

  FollowedActivitiesCompanion toCompanion(bool nullToAbsent) {
    return FollowedActivitiesCompanion(
      id: Value(id),
      activity: Value(activity),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
      path: Value(path),
      progress: progress == null && nullToAbsent
          ? const Value.absent()
          : Value(progress),
      hardBecause: hardBecause == null && nullToAbsent
          ? const Value.absent()
          : Value(hardBecause),
      stoppedAgo: stoppedAgo == null && nullToAbsent
          ? const Value.absent()
          : Value(stoppedAgo),
      gotInTheWay: gotInTheWay == null && nullToAbsent
          ? const Value.absent()
          : Value(gotInTheWay),
      wouldHelp: wouldHelp == null && nullToAbsent
          ? const Value.absent()
          : Value(wouldHelp),
      familiarity: familiarity == null && nullToAbsent
          ? const Value.absent()
          : Value(familiarity),
      followedAt: Value(followedAt),
      unfollowedAt: unfollowedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(unfollowedAt),
    );
  }

  factory FollowedActivity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FollowedActivity(
      id: serializer.fromJson<String>(json['id']),
      activity: $FollowedActivitiesTable.$converteractivity.fromJson(
        serializer.fromJson<String>(json['activity']),
      ),
      customName: serializer.fromJson<String?>(json['customName']),
      path: $FollowedActivitiesTable.$converterpath.fromJson(
        serializer.fromJson<String>(json['path']),
      ),
      progress: $FollowedActivitiesTable.$converterprogressn.fromJson(
        serializer.fromJson<String?>(json['progress']),
      ),
      hardBecause: serializer.fromJson<String?>(json['hardBecause']),
      stoppedAgo: $FollowedActivitiesTable.$converterstoppedAgon.fromJson(
        serializer.fromJson<String?>(json['stoppedAgo']),
      ),
      gotInTheWay: serializer.fromJson<String?>(json['gotInTheWay']),
      wouldHelp: serializer.fromJson<String?>(json['wouldHelp']),
      familiarity: $FollowedActivitiesTable.$converterfamiliarityn.fromJson(
        serializer.fromJson<String?>(json['familiarity']),
      ),
      followedAt: serializer.fromJson<DateTime>(json['followedAt']),
      unfollowedAt: serializer.fromJson<DateTime?>(json['unfollowedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'activity': serializer.toJson<String>(
        $FollowedActivitiesTable.$converteractivity.toJson(activity),
      ),
      'customName': serializer.toJson<String?>(customName),
      'path': serializer.toJson<String>(
        $FollowedActivitiesTable.$converterpath.toJson(path),
      ),
      'progress': serializer.toJson<String?>(
        $FollowedActivitiesTable.$converterprogressn.toJson(progress),
      ),
      'hardBecause': serializer.toJson<String?>(hardBecause),
      'stoppedAgo': serializer.toJson<String?>(
        $FollowedActivitiesTable.$converterstoppedAgon.toJson(stoppedAgo),
      ),
      'gotInTheWay': serializer.toJson<String?>(gotInTheWay),
      'wouldHelp': serializer.toJson<String?>(wouldHelp),
      'familiarity': serializer.toJson<String?>(
        $FollowedActivitiesTable.$converterfamiliarityn.toJson(familiarity),
      ),
      'followedAt': serializer.toJson<DateTime>(followedAt),
      'unfollowedAt': serializer.toJson<DateTime?>(unfollowedAt),
    };
  }

  FollowedActivity copyWith({
    String? id,
    ActivityKind? activity,
    Value<String?> customName = const Value.absent(),
    SetupPath? path,
    Value<Progress?> progress = const Value.absent(),
    Value<String?> hardBecause = const Value.absent(),
    Value<StoppedAgo?> stoppedAgo = const Value.absent(),
    Value<String?> gotInTheWay = const Value.absent(),
    Value<String?> wouldHelp = const Value.absent(),
    Value<Familiarity?> familiarity = const Value.absent(),
    DateTime? followedAt,
    Value<DateTime?> unfollowedAt = const Value.absent(),
  }) => FollowedActivity(
    id: id ?? this.id,
    activity: activity ?? this.activity,
    customName: customName.present ? customName.value : this.customName,
    path: path ?? this.path,
    progress: progress.present ? progress.value : this.progress,
    hardBecause: hardBecause.present ? hardBecause.value : this.hardBecause,
    stoppedAgo: stoppedAgo.present ? stoppedAgo.value : this.stoppedAgo,
    gotInTheWay: gotInTheWay.present ? gotInTheWay.value : this.gotInTheWay,
    wouldHelp: wouldHelp.present ? wouldHelp.value : this.wouldHelp,
    familiarity: familiarity.present ? familiarity.value : this.familiarity,
    followedAt: followedAt ?? this.followedAt,
    unfollowedAt: unfollowedAt.present ? unfollowedAt.value : this.unfollowedAt,
  );
  FollowedActivity copyWithCompanion(FollowedActivitiesCompanion data) {
    return FollowedActivity(
      id: data.id.present ? data.id.value : this.id,
      activity: data.activity.present ? data.activity.value : this.activity,
      customName: data.customName.present
          ? data.customName.value
          : this.customName,
      path: data.path.present ? data.path.value : this.path,
      progress: data.progress.present ? data.progress.value : this.progress,
      hardBecause: data.hardBecause.present
          ? data.hardBecause.value
          : this.hardBecause,
      stoppedAgo: data.stoppedAgo.present
          ? data.stoppedAgo.value
          : this.stoppedAgo,
      gotInTheWay: data.gotInTheWay.present
          ? data.gotInTheWay.value
          : this.gotInTheWay,
      wouldHelp: data.wouldHelp.present ? data.wouldHelp.value : this.wouldHelp,
      familiarity: data.familiarity.present
          ? data.familiarity.value
          : this.familiarity,
      followedAt: data.followedAt.present
          ? data.followedAt.value
          : this.followedAt,
      unfollowedAt: data.unfollowedAt.present
          ? data.unfollowedAt.value
          : this.unfollowedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FollowedActivity(')
          ..write('id: $id, ')
          ..write('activity: $activity, ')
          ..write('customName: $customName, ')
          ..write('path: $path, ')
          ..write('progress: $progress, ')
          ..write('hardBecause: $hardBecause, ')
          ..write('stoppedAgo: $stoppedAgo, ')
          ..write('gotInTheWay: $gotInTheWay, ')
          ..write('wouldHelp: $wouldHelp, ')
          ..write('familiarity: $familiarity, ')
          ..write('followedAt: $followedAt, ')
          ..write('unfollowedAt: $unfollowedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activity,
    customName,
    path,
    progress,
    hardBecause,
    stoppedAgo,
    gotInTheWay,
    wouldHelp,
    familiarity,
    followedAt,
    unfollowedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FollowedActivity &&
          other.id == this.id &&
          other.activity == this.activity &&
          other.customName == this.customName &&
          other.path == this.path &&
          other.progress == this.progress &&
          other.hardBecause == this.hardBecause &&
          other.stoppedAgo == this.stoppedAgo &&
          other.gotInTheWay == this.gotInTheWay &&
          other.wouldHelp == this.wouldHelp &&
          other.familiarity == this.familiarity &&
          other.followedAt == this.followedAt &&
          other.unfollowedAt == this.unfollowedAt);
}

class FollowedActivitiesCompanion extends UpdateCompanion<FollowedActivity> {
  final Value<String> id;
  final Value<ActivityKind> activity;
  final Value<String?> customName;
  final Value<SetupPath> path;
  final Value<Progress?> progress;
  final Value<String?> hardBecause;
  final Value<StoppedAgo?> stoppedAgo;
  final Value<String?> gotInTheWay;
  final Value<String?> wouldHelp;
  final Value<Familiarity?> familiarity;
  final Value<DateTime> followedAt;
  final Value<DateTime?> unfollowedAt;
  final Value<int> rowid;
  const FollowedActivitiesCompanion({
    this.id = const Value.absent(),
    this.activity = const Value.absent(),
    this.customName = const Value.absent(),
    this.path = const Value.absent(),
    this.progress = const Value.absent(),
    this.hardBecause = const Value.absent(),
    this.stoppedAgo = const Value.absent(),
    this.gotInTheWay = const Value.absent(),
    this.wouldHelp = const Value.absent(),
    this.familiarity = const Value.absent(),
    this.followedAt = const Value.absent(),
    this.unfollowedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FollowedActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required ActivityKind activity,
    this.customName = const Value.absent(),
    required SetupPath path,
    this.progress = const Value.absent(),
    this.hardBecause = const Value.absent(),
    this.stoppedAgo = const Value.absent(),
    this.gotInTheWay = const Value.absent(),
    this.wouldHelp = const Value.absent(),
    this.familiarity = const Value.absent(),
    this.followedAt = const Value.absent(),
    this.unfollowedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : activity = Value(activity),
       path = Value(path);
  static Insertable<FollowedActivity> custom({
    Expression<String>? id,
    Expression<String>? activity,
    Expression<String>? customName,
    Expression<String>? path,
    Expression<String>? progress,
    Expression<String>? hardBecause,
    Expression<String>? stoppedAgo,
    Expression<String>? gotInTheWay,
    Expression<String>? wouldHelp,
    Expression<String>? familiarity,
    Expression<DateTime>? followedAt,
    Expression<DateTime>? unfollowedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activity != null) 'activity': activity,
      if (customName != null) 'custom_name': customName,
      if (path != null) 'path': path,
      if (progress != null) 'progress': progress,
      if (hardBecause != null) 'hard_because': hardBecause,
      if (stoppedAgo != null) 'stopped_ago': stoppedAgo,
      if (gotInTheWay != null) 'got_in_the_way': gotInTheWay,
      if (wouldHelp != null) 'would_help': wouldHelp,
      if (familiarity != null) 'familiarity': familiarity,
      if (followedAt != null) 'followed_at': followedAt,
      if (unfollowedAt != null) 'unfollowed_at': unfollowedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FollowedActivitiesCompanion copyWith({
    Value<String>? id,
    Value<ActivityKind>? activity,
    Value<String?>? customName,
    Value<SetupPath>? path,
    Value<Progress?>? progress,
    Value<String?>? hardBecause,
    Value<StoppedAgo?>? stoppedAgo,
    Value<String?>? gotInTheWay,
    Value<String?>? wouldHelp,
    Value<Familiarity?>? familiarity,
    Value<DateTime>? followedAt,
    Value<DateTime?>? unfollowedAt,
    Value<int>? rowid,
  }) {
    return FollowedActivitiesCompanion(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      customName: customName ?? this.customName,
      path: path ?? this.path,
      progress: progress ?? this.progress,
      hardBecause: hardBecause ?? this.hardBecause,
      stoppedAgo: stoppedAgo ?? this.stoppedAgo,
      gotInTheWay: gotInTheWay ?? this.gotInTheWay,
      wouldHelp: wouldHelp ?? this.wouldHelp,
      familiarity: familiarity ?? this.familiarity,
      followedAt: followedAt ?? this.followedAt,
      unfollowedAt: unfollowedAt ?? this.unfollowedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(
        $FollowedActivitiesTable.$converteractivity.toSql(activity.value),
      );
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(
        $FollowedActivitiesTable.$converterpath.toSql(path.value),
      );
    }
    if (progress.present) {
      map['progress'] = Variable<String>(
        $FollowedActivitiesTable.$converterprogressn.toSql(progress.value),
      );
    }
    if (hardBecause.present) {
      map['hard_because'] = Variable<String>(hardBecause.value);
    }
    if (stoppedAgo.present) {
      map['stopped_ago'] = Variable<String>(
        $FollowedActivitiesTable.$converterstoppedAgon.toSql(stoppedAgo.value),
      );
    }
    if (gotInTheWay.present) {
      map['got_in_the_way'] = Variable<String>(gotInTheWay.value);
    }
    if (wouldHelp.present) {
      map['would_help'] = Variable<String>(wouldHelp.value);
    }
    if (familiarity.present) {
      map['familiarity'] = Variable<String>(
        $FollowedActivitiesTable.$converterfamiliarityn.toSql(
          familiarity.value,
        ),
      );
    }
    if (followedAt.present) {
      map['followed_at'] = Variable<DateTime>(followedAt.value);
    }
    if (unfollowedAt.present) {
      map['unfollowed_at'] = Variable<DateTime>(unfollowedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FollowedActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('activity: $activity, ')
          ..write('customName: $customName, ')
          ..write('path: $path, ')
          ..write('progress: $progress, ')
          ..write('hardBecause: $hardBecause, ')
          ..write('stoppedAgo: $stoppedAgo, ')
          ..write('gotInTheWay: $gotInTheWay, ')
          ..write('wouldHelp: $wouldHelp, ')
          ..write('familiarity: $familiarity, ')
          ..write('followedAt: $followedAt, ')
          ..write('unfollowedAt: $unfollowedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => newId('pref'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PrefKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PrefKind>($PreferencesTable.$converterkind);
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preference';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {kind, value},
  ];
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: $PreferencesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PrefKind, String, String> $converterkind =
      const CodedEnumConverter<PrefKind>(PrefKind.values);
}

class Preference extends DataClass implements Insertable<Preference> {
  final String id;
  final PrefKind kind;
  final String value;
  const Preference({required this.id, required this.kind, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['kind'] = Variable<String>(
        $PreferencesTable.$converterkind.toSql(kind),
      );
    }
    map['value'] = Variable<String>(value);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      id: Value(id),
      kind: Value(kind),
      value: Value(value),
    );
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      id: serializer.fromJson<String>(json['id']),
      kind: $PreferencesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(
        $PreferencesTable.$converterkind.toJson(kind),
      ),
      'value': serializer.toJson<String>(value),
    };
  }

  Preference copyWith({String? id, PrefKind? kind, String? value}) =>
      Preference(
        id: id ?? this.id,
        kind: kind ?? this.kind,
        value: value ?? this.value,
      );
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.value == this.value);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<String> id;
  final Value<PrefKind> kind;
  final Value<String> value;
  final Value<int> rowid;
  const PreferencesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PreferencesCompanion.insert({
    this.id = const Value.absent(),
    required PrefKind kind,
    required String value,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       value = Value(value);
  static Insertable<Preference> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PreferencesCompanion copyWith({
    Value<String>? id,
    Value<PrefKind>? kind,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return PreferencesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $PreferencesTable.$converterkind.toSql(kind.value),
      );
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActionsTable extends Actions
    with TableInfo<$ActionsTable, LibraryAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityKind, String> activity =
      GeneratedColumn<String>(
        'activity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ActivityKind>($ActionsTable.$converteractivity);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinMeta = const VerificationMeta(
    'durationMin',
  );
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
    'duration_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Intensity, String> intensity =
      GeneratedColumn<String>(
        'intensity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Intensity>($ActionsTable.$converterintensity);
  @override
  late final GeneratedColumnWithTypeConverter<Energy, String> energyNeeded =
      GeneratedColumn<String>(
        'energy_needed',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Energy>($ActionsTable.$converterenergyNeeded);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _isStarterMeta = const VerificationMeta(
    'isStarter',
  );
  @override
  late final GeneratedColumn<bool> isStarter = GeneratedColumn<bool>(
    'is_starter',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_starter" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _similarToMeta = const VerificationMeta(
    'similarTo',
  );
  @override
  late final GeneratedColumn<String> similarTo = GeneratedColumn<String>(
    'similar_to',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _libraryVersionMeta = const VerificationMeta(
    'libraryVersion',
  );
  @override
  late final GeneratedColumn<String> libraryVersion = GeneratedColumn<String>(
    'library_version',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    activity,
    title,
    description,
    durationMin,
    intensity,
    energyNeeded,
    tags,
    isStarter,
    similarTo,
    libraryVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'action';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('duration_min')) {
      context.handle(
        _durationMinMeta,
        durationMin.isAcceptableOrUnknown(
          data['duration_min']!,
          _durationMinMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('is_starter')) {
      context.handle(
        _isStarterMeta,
        isStarter.isAcceptableOrUnknown(data['is_starter']!, _isStarterMeta),
      );
    }
    if (data.containsKey('similar_to')) {
      context.handle(
        _similarToMeta,
        similarTo.isAcceptableOrUnknown(data['similar_to']!, _similarToMeta),
      );
    }
    if (data.containsKey('library_version')) {
      context.handle(
        _libraryVersionMeta,
        libraryVersion.isAcceptableOrUnknown(
          data['library_version']!,
          _libraryVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_libraryVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryAction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      activity: $ActionsTable.$converteractivity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}activity'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      durationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min'],
      )!,
      intensity: $ActionsTable.$converterintensity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}intensity'],
        )!,
      ),
      energyNeeded: $ActionsTable.$converterenergyNeeded.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}energy_needed'],
        )!,
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      isStarter: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_starter'],
      )!,
      similarTo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}similar_to'],
      )!,
      libraryVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_version'],
      )!,
    );
  }

  @override
  $ActionsTable createAlias(String alias) {
    return $ActionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActivityKind, String, String> $converteractivity =
      const CodedEnumConverter<ActivityKind>(ActivityKind.values);
  static JsonTypeConverter2<Intensity, String, String> $converterintensity =
      const CodedEnumConverter<Intensity>(Intensity.values);
  static JsonTypeConverter2<Energy, String, String> $converterenergyNeeded =
      const CodedEnumConverter<Energy>(Energy.values);
}

class LibraryAction extends DataClass implements Insertable<LibraryAction> {
  final String id;
  final ActivityKind activity;
  final String title;
  final String description;
  final int durationMin;
  final Intensity intensity;
  final Energy energyNeeded;
  final String tags;
  final bool isStarter;
  final String similarTo;
  final String libraryVersion;
  const LibraryAction({
    required this.id,
    required this.activity,
    required this.title,
    required this.description,
    required this.durationMin,
    required this.intensity,
    required this.energyNeeded,
    required this.tags,
    required this.isStarter,
    required this.similarTo,
    required this.libraryVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['activity'] = Variable<String>(
        $ActionsTable.$converteractivity.toSql(activity),
      );
    }
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['duration_min'] = Variable<int>(durationMin);
    {
      map['intensity'] = Variable<String>(
        $ActionsTable.$converterintensity.toSql(intensity),
      );
    }
    {
      map['energy_needed'] = Variable<String>(
        $ActionsTable.$converterenergyNeeded.toSql(energyNeeded),
      );
    }
    map['tags'] = Variable<String>(tags);
    map['is_starter'] = Variable<bool>(isStarter);
    map['similar_to'] = Variable<String>(similarTo);
    map['library_version'] = Variable<String>(libraryVersion);
    return map;
  }

  ActionsCompanion toCompanion(bool nullToAbsent) {
    return ActionsCompanion(
      id: Value(id),
      activity: Value(activity),
      title: Value(title),
      description: Value(description),
      durationMin: Value(durationMin),
      intensity: Value(intensity),
      energyNeeded: Value(energyNeeded),
      tags: Value(tags),
      isStarter: Value(isStarter),
      similarTo: Value(similarTo),
      libraryVersion: Value(libraryVersion),
    );
  }

  factory LibraryAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryAction(
      id: serializer.fromJson<String>(json['id']),
      activity: $ActionsTable.$converteractivity.fromJson(
        serializer.fromJson<String>(json['activity']),
      ),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      durationMin: serializer.fromJson<int>(json['durationMin']),
      intensity: $ActionsTable.$converterintensity.fromJson(
        serializer.fromJson<String>(json['intensity']),
      ),
      energyNeeded: $ActionsTable.$converterenergyNeeded.fromJson(
        serializer.fromJson<String>(json['energyNeeded']),
      ),
      tags: serializer.fromJson<String>(json['tags']),
      isStarter: serializer.fromJson<bool>(json['isStarter']),
      similarTo: serializer.fromJson<String>(json['similarTo']),
      libraryVersion: serializer.fromJson<String>(json['libraryVersion']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'activity': serializer.toJson<String>(
        $ActionsTable.$converteractivity.toJson(activity),
      ),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'durationMin': serializer.toJson<int>(durationMin),
      'intensity': serializer.toJson<String>(
        $ActionsTable.$converterintensity.toJson(intensity),
      ),
      'energyNeeded': serializer.toJson<String>(
        $ActionsTable.$converterenergyNeeded.toJson(energyNeeded),
      ),
      'tags': serializer.toJson<String>(tags),
      'isStarter': serializer.toJson<bool>(isStarter),
      'similarTo': serializer.toJson<String>(similarTo),
      'libraryVersion': serializer.toJson<String>(libraryVersion),
    };
  }

  LibraryAction copyWith({
    String? id,
    ActivityKind? activity,
    String? title,
    String? description,
    int? durationMin,
    Intensity? intensity,
    Energy? energyNeeded,
    String? tags,
    bool? isStarter,
    String? similarTo,
    String? libraryVersion,
  }) => LibraryAction(
    id: id ?? this.id,
    activity: activity ?? this.activity,
    title: title ?? this.title,
    description: description ?? this.description,
    durationMin: durationMin ?? this.durationMin,
    intensity: intensity ?? this.intensity,
    energyNeeded: energyNeeded ?? this.energyNeeded,
    tags: tags ?? this.tags,
    isStarter: isStarter ?? this.isStarter,
    similarTo: similarTo ?? this.similarTo,
    libraryVersion: libraryVersion ?? this.libraryVersion,
  );
  LibraryAction copyWithCompanion(ActionsCompanion data) {
    return LibraryAction(
      id: data.id.present ? data.id.value : this.id,
      activity: data.activity.present ? data.activity.value : this.activity,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      durationMin: data.durationMin.present
          ? data.durationMin.value
          : this.durationMin,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      energyNeeded: data.energyNeeded.present
          ? data.energyNeeded.value
          : this.energyNeeded,
      tags: data.tags.present ? data.tags.value : this.tags,
      isStarter: data.isStarter.present ? data.isStarter.value : this.isStarter,
      similarTo: data.similarTo.present ? data.similarTo.value : this.similarTo,
      libraryVersion: data.libraryVersion.present
          ? data.libraryVersion.value
          : this.libraryVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryAction(')
          ..write('id: $id, ')
          ..write('activity: $activity, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('durationMin: $durationMin, ')
          ..write('intensity: $intensity, ')
          ..write('energyNeeded: $energyNeeded, ')
          ..write('tags: $tags, ')
          ..write('isStarter: $isStarter, ')
          ..write('similarTo: $similarTo, ')
          ..write('libraryVersion: $libraryVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    activity,
    title,
    description,
    durationMin,
    intensity,
    energyNeeded,
    tags,
    isStarter,
    similarTo,
    libraryVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryAction &&
          other.id == this.id &&
          other.activity == this.activity &&
          other.title == this.title &&
          other.description == this.description &&
          other.durationMin == this.durationMin &&
          other.intensity == this.intensity &&
          other.energyNeeded == this.energyNeeded &&
          other.tags == this.tags &&
          other.isStarter == this.isStarter &&
          other.similarTo == this.similarTo &&
          other.libraryVersion == this.libraryVersion);
}

class ActionsCompanion extends UpdateCompanion<LibraryAction> {
  final Value<String> id;
  final Value<ActivityKind> activity;
  final Value<String> title;
  final Value<String> description;
  final Value<int> durationMin;
  final Value<Intensity> intensity;
  final Value<Energy> energyNeeded;
  final Value<String> tags;
  final Value<bool> isStarter;
  final Value<String> similarTo;
  final Value<String> libraryVersion;
  final Value<int> rowid;
  const ActionsCompanion({
    this.id = const Value.absent(),
    this.activity = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.intensity = const Value.absent(),
    this.energyNeeded = const Value.absent(),
    this.tags = const Value.absent(),
    this.isStarter = const Value.absent(),
    this.similarTo = const Value.absent(),
    this.libraryVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActionsCompanion.insert({
    required String id,
    required ActivityKind activity,
    required String title,
    required String description,
    required int durationMin,
    required Intensity intensity,
    required Energy energyNeeded,
    this.tags = const Value.absent(),
    this.isStarter = const Value.absent(),
    this.similarTo = const Value.absent(),
    required String libraryVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       activity = Value(activity),
       title = Value(title),
       description = Value(description),
       durationMin = Value(durationMin),
       intensity = Value(intensity),
       energyNeeded = Value(energyNeeded),
       libraryVersion = Value(libraryVersion);
  static Insertable<LibraryAction> custom({
    Expression<String>? id,
    Expression<String>? activity,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? durationMin,
    Expression<String>? intensity,
    Expression<String>? energyNeeded,
    Expression<String>? tags,
    Expression<bool>? isStarter,
    Expression<String>? similarTo,
    Expression<String>? libraryVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (activity != null) 'activity': activity,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (durationMin != null) 'duration_min': durationMin,
      if (intensity != null) 'intensity': intensity,
      if (energyNeeded != null) 'energy_needed': energyNeeded,
      if (tags != null) 'tags': tags,
      if (isStarter != null) 'is_starter': isStarter,
      if (similarTo != null) 'similar_to': similarTo,
      if (libraryVersion != null) 'library_version': libraryVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActionsCompanion copyWith({
    Value<String>? id,
    Value<ActivityKind>? activity,
    Value<String>? title,
    Value<String>? description,
    Value<int>? durationMin,
    Value<Intensity>? intensity,
    Value<Energy>? energyNeeded,
    Value<String>? tags,
    Value<bool>? isStarter,
    Value<String>? similarTo,
    Value<String>? libraryVersion,
    Value<int>? rowid,
  }) {
    return ActionsCompanion(
      id: id ?? this.id,
      activity: activity ?? this.activity,
      title: title ?? this.title,
      description: description ?? this.description,
      durationMin: durationMin ?? this.durationMin,
      intensity: intensity ?? this.intensity,
      energyNeeded: energyNeeded ?? this.energyNeeded,
      tags: tags ?? this.tags,
      isStarter: isStarter ?? this.isStarter,
      similarTo: similarTo ?? this.similarTo,
      libraryVersion: libraryVersion ?? this.libraryVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(
        $ActionsTable.$converteractivity.toSql(activity.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<String>(
        $ActionsTable.$converterintensity.toSql(intensity.value),
      );
    }
    if (energyNeeded.present) {
      map['energy_needed'] = Variable<String>(
        $ActionsTable.$converterenergyNeeded.toSql(energyNeeded.value),
      );
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (isStarter.present) {
      map['is_starter'] = Variable<bool>(isStarter.value);
    }
    if (similarTo.present) {
      map['similar_to'] = Variable<String>(similarTo.value);
    }
    if (libraryVersion.present) {
      map['library_version'] = Variable<String>(libraryVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActionsCompanion(')
          ..write('id: $id, ')
          ..write('activity: $activity, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('durationMin: $durationMin, ')
          ..write('intensity: $intensity, ')
          ..write('energyNeeded: $energyNeeded, ')
          ..write('tags: $tags, ')
          ..write('isStarter: $isStarter, ')
          ..write('similarTo: $similarTo, ')
          ..write('libraryVersion: $libraryVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OptionOffersTable extends OptionOffers
    with TableInfo<$OptionOffersTable, OptionOffer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OptionOffersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => newId('off'),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionIdMeta = const VerificationMeta(
    'actionId',
  );
  @override
  late final GeneratedColumn<String> actionId = GeneratedColumn<String>(
    'action_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "action" (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _followedActivityIdMeta =
      const VerificationMeta('followedActivityId');
  @override
  late final GeneratedColumn<String> followedActivityId =
      GeneratedColumn<String>(
        'followed_activity_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES followed_activity (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _suggestedDayMeta = const VerificationMeta(
    'suggestedDay',
  );
  @override
  late final GeneratedColumn<String> suggestedDay = GeneratedColumn<String>(
    'suggested_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _suggestedTimeMeta = const VerificationMeta(
    'suggestedTime',
  );
  @override
  late final GeneratedColumn<String> suggestedTime = GeneratedColumn<String>(
    'suggested_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _swapIndexMeta = const VerificationMeta(
    'swapIndex',
  );
  @override
  late final GeneratedColumn<int> swapIndex = GeneratedColumn<int>(
    'swap_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  late final GeneratedColumnWithTypeConverter<OfferStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('offered'),
      ).withConverter<OfferStatus>($OptionOffersTable.$converterstatus);
  static const VerificationMeta _editedDurationMinMeta = const VerificationMeta(
    'editedDurationMin',
  );
  @override
  late final GeneratedColumn<int> editedDurationMin = GeneratedColumn<int>(
    'edited_duration_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editedDayMeta = const VerificationMeta(
    'editedDay',
  );
  @override
  late final GeneratedColumn<String> editedDay = GeneratedColumn<String>(
    'edited_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _editedTimeMeta = const VerificationMeta(
    'editedTime',
  );
  @override
  late final GeneratedColumn<String> editedTime = GeneratedColumn<String>(
    'edited_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timeInputMinMeta = const VerificationMeta(
    'timeInputMin',
  );
  @override
  late final GeneratedColumn<int> timeInputMin = GeneratedColumn<int>(
    'time_input_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Energy?, String> energyInput =
      GeneratedColumn<String>(
        'energy_input',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Energy?>($OptionOffersTable.$converterenergyInputn);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    actionId,
    followedActivityId,
    suggestedDay,
    suggestedTime,
    swapIndex,
    status,
    editedDurationMin,
    editedDay,
    editedTime,
    timeInputMin,
    energyInput,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'option_offer';
  @override
  VerificationContext validateIntegrity(
    Insertable<OptionOffer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('action_id')) {
      context.handle(
        _actionIdMeta,
        actionId.isAcceptableOrUnknown(data['action_id']!, _actionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actionIdMeta);
    }
    if (data.containsKey('followed_activity_id')) {
      context.handle(
        _followedActivityIdMeta,
        followedActivityId.isAcceptableOrUnknown(
          data['followed_activity_id']!,
          _followedActivityIdMeta,
        ),
      );
    }
    if (data.containsKey('suggested_day')) {
      context.handle(
        _suggestedDayMeta,
        suggestedDay.isAcceptableOrUnknown(
          data['suggested_day']!,
          _suggestedDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_suggestedDayMeta);
    }
    if (data.containsKey('suggested_time')) {
      context.handle(
        _suggestedTimeMeta,
        suggestedTime.isAcceptableOrUnknown(
          data['suggested_time']!,
          _suggestedTimeMeta,
        ),
      );
    }
    if (data.containsKey('swap_index')) {
      context.handle(
        _swapIndexMeta,
        swapIndex.isAcceptableOrUnknown(data['swap_index']!, _swapIndexMeta),
      );
    }
    if (data.containsKey('edited_duration_min')) {
      context.handle(
        _editedDurationMinMeta,
        editedDurationMin.isAcceptableOrUnknown(
          data['edited_duration_min']!,
          _editedDurationMinMeta,
        ),
      );
    }
    if (data.containsKey('edited_day')) {
      context.handle(
        _editedDayMeta,
        editedDay.isAcceptableOrUnknown(data['edited_day']!, _editedDayMeta),
      );
    }
    if (data.containsKey('edited_time')) {
      context.handle(
        _editedTimeMeta,
        editedTime.isAcceptableOrUnknown(data['edited_time']!, _editedTimeMeta),
      );
    }
    if (data.containsKey('time_input_min')) {
      context.handle(
        _timeInputMinMeta,
        timeInputMin.isAcceptableOrUnknown(
          data['time_input_min']!,
          _timeInputMinMeta,
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {day, followedActivityId, swapIndex},
  ];
  @override
  OptionOffer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OptionOffer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      actionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_id'],
      )!,
      followedActivityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}followed_activity_id'],
      ),
      suggestedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_day'],
      )!,
      suggestedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}suggested_time'],
      ),
      swapIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}swap_index'],
      )!,
      status: $OptionOffersTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      editedDurationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}edited_duration_min'],
      ),
      editedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edited_day'],
      ),
      editedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}edited_time'],
      ),
      timeInputMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_input_min'],
      ),
      energyInput: $OptionOffersTable.$converterenergyInputn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}energy_input'],
        ),
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $OptionOffersTable createAlias(String alias) {
    return $OptionOffersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OfferStatus, String, String> $converterstatus =
      const CodedEnumConverter<OfferStatus>(OfferStatus.values);
  static JsonTypeConverter2<Energy, String, String> $converterenergyInput =
      const CodedEnumConverter<Energy>(Energy.values);
  static JsonTypeConverter2<Energy?, String?, String?> $converterenergyInputn =
      JsonTypeConverter2.asNullable($converterenergyInput);
}

class OptionOffer extends DataClass implements Insertable<OptionOffer> {
  final String id;
  final String day;
  final String actionId;
  final String? followedActivityId;
  final String suggestedDay;
  final String? suggestedTime;
  final int swapIndex;
  final OfferStatus status;
  final int? editedDurationMin;
  final String? editedDay;
  final String? editedTime;
  final int? timeInputMin;
  final Energy? energyInput;
  final DateTime createdAt;
  const OptionOffer({
    required this.id,
    required this.day,
    required this.actionId,
    this.followedActivityId,
    required this.suggestedDay,
    this.suggestedTime,
    required this.swapIndex,
    required this.status,
    this.editedDurationMin,
    this.editedDay,
    this.editedTime,
    this.timeInputMin,
    this.energyInput,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['day'] = Variable<String>(day);
    map['action_id'] = Variable<String>(actionId);
    if (!nullToAbsent || followedActivityId != null) {
      map['followed_activity_id'] = Variable<String>(followedActivityId);
    }
    map['suggested_day'] = Variable<String>(suggestedDay);
    if (!nullToAbsent || suggestedTime != null) {
      map['suggested_time'] = Variable<String>(suggestedTime);
    }
    map['swap_index'] = Variable<int>(swapIndex);
    {
      map['status'] = Variable<String>(
        $OptionOffersTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || editedDurationMin != null) {
      map['edited_duration_min'] = Variable<int>(editedDurationMin);
    }
    if (!nullToAbsent || editedDay != null) {
      map['edited_day'] = Variable<String>(editedDay);
    }
    if (!nullToAbsent || editedTime != null) {
      map['edited_time'] = Variable<String>(editedTime);
    }
    if (!nullToAbsent || timeInputMin != null) {
      map['time_input_min'] = Variable<int>(timeInputMin);
    }
    if (!nullToAbsent || energyInput != null) {
      map['energy_input'] = Variable<String>(
        $OptionOffersTable.$converterenergyInputn.toSql(energyInput),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  OptionOffersCompanion toCompanion(bool nullToAbsent) {
    return OptionOffersCompanion(
      id: Value(id),
      day: Value(day),
      actionId: Value(actionId),
      followedActivityId: followedActivityId == null && nullToAbsent
          ? const Value.absent()
          : Value(followedActivityId),
      suggestedDay: Value(suggestedDay),
      suggestedTime: suggestedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedTime),
      swapIndex: Value(swapIndex),
      status: Value(status),
      editedDurationMin: editedDurationMin == null && nullToAbsent
          ? const Value.absent()
          : Value(editedDurationMin),
      editedDay: editedDay == null && nullToAbsent
          ? const Value.absent()
          : Value(editedDay),
      editedTime: editedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(editedTime),
      timeInputMin: timeInputMin == null && nullToAbsent
          ? const Value.absent()
          : Value(timeInputMin),
      energyInput: energyInput == null && nullToAbsent
          ? const Value.absent()
          : Value(energyInput),
      createdAt: Value(createdAt),
    );
  }

  factory OptionOffer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OptionOffer(
      id: serializer.fromJson<String>(json['id']),
      day: serializer.fromJson<String>(json['day']),
      actionId: serializer.fromJson<String>(json['actionId']),
      followedActivityId: serializer.fromJson<String?>(
        json['followedActivityId'],
      ),
      suggestedDay: serializer.fromJson<String>(json['suggestedDay']),
      suggestedTime: serializer.fromJson<String?>(json['suggestedTime']),
      swapIndex: serializer.fromJson<int>(json['swapIndex']),
      status: $OptionOffersTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      editedDurationMin: serializer.fromJson<int?>(json['editedDurationMin']),
      editedDay: serializer.fromJson<String?>(json['editedDay']),
      editedTime: serializer.fromJson<String?>(json['editedTime']),
      timeInputMin: serializer.fromJson<int?>(json['timeInputMin']),
      energyInput: $OptionOffersTable.$converterenergyInputn.fromJson(
        serializer.fromJson<String?>(json['energyInput']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'day': serializer.toJson<String>(day),
      'actionId': serializer.toJson<String>(actionId),
      'followedActivityId': serializer.toJson<String?>(followedActivityId),
      'suggestedDay': serializer.toJson<String>(suggestedDay),
      'suggestedTime': serializer.toJson<String?>(suggestedTime),
      'swapIndex': serializer.toJson<int>(swapIndex),
      'status': serializer.toJson<String>(
        $OptionOffersTable.$converterstatus.toJson(status),
      ),
      'editedDurationMin': serializer.toJson<int?>(editedDurationMin),
      'editedDay': serializer.toJson<String?>(editedDay),
      'editedTime': serializer.toJson<String?>(editedTime),
      'timeInputMin': serializer.toJson<int?>(timeInputMin),
      'energyInput': serializer.toJson<String?>(
        $OptionOffersTable.$converterenergyInputn.toJson(energyInput),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  OptionOffer copyWith({
    String? id,
    String? day,
    String? actionId,
    Value<String?> followedActivityId = const Value.absent(),
    String? suggestedDay,
    Value<String?> suggestedTime = const Value.absent(),
    int? swapIndex,
    OfferStatus? status,
    Value<int?> editedDurationMin = const Value.absent(),
    Value<String?> editedDay = const Value.absent(),
    Value<String?> editedTime = const Value.absent(),
    Value<int?> timeInputMin = const Value.absent(),
    Value<Energy?> energyInput = const Value.absent(),
    DateTime? createdAt,
  }) => OptionOffer(
    id: id ?? this.id,
    day: day ?? this.day,
    actionId: actionId ?? this.actionId,
    followedActivityId: followedActivityId.present
        ? followedActivityId.value
        : this.followedActivityId,
    suggestedDay: suggestedDay ?? this.suggestedDay,
    suggestedTime: suggestedTime.present
        ? suggestedTime.value
        : this.suggestedTime,
    swapIndex: swapIndex ?? this.swapIndex,
    status: status ?? this.status,
    editedDurationMin: editedDurationMin.present
        ? editedDurationMin.value
        : this.editedDurationMin,
    editedDay: editedDay.present ? editedDay.value : this.editedDay,
    editedTime: editedTime.present ? editedTime.value : this.editedTime,
    timeInputMin: timeInputMin.present ? timeInputMin.value : this.timeInputMin,
    energyInput: energyInput.present ? energyInput.value : this.energyInput,
    createdAt: createdAt ?? this.createdAt,
  );
  OptionOffer copyWithCompanion(OptionOffersCompanion data) {
    return OptionOffer(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      actionId: data.actionId.present ? data.actionId.value : this.actionId,
      followedActivityId: data.followedActivityId.present
          ? data.followedActivityId.value
          : this.followedActivityId,
      suggestedDay: data.suggestedDay.present
          ? data.suggestedDay.value
          : this.suggestedDay,
      suggestedTime: data.suggestedTime.present
          ? data.suggestedTime.value
          : this.suggestedTime,
      swapIndex: data.swapIndex.present ? data.swapIndex.value : this.swapIndex,
      status: data.status.present ? data.status.value : this.status,
      editedDurationMin: data.editedDurationMin.present
          ? data.editedDurationMin.value
          : this.editedDurationMin,
      editedDay: data.editedDay.present ? data.editedDay.value : this.editedDay,
      editedTime: data.editedTime.present
          ? data.editedTime.value
          : this.editedTime,
      timeInputMin: data.timeInputMin.present
          ? data.timeInputMin.value
          : this.timeInputMin,
      energyInput: data.energyInput.present
          ? data.energyInput.value
          : this.energyInput,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OptionOffer(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('actionId: $actionId, ')
          ..write('followedActivityId: $followedActivityId, ')
          ..write('suggestedDay: $suggestedDay, ')
          ..write('suggestedTime: $suggestedTime, ')
          ..write('swapIndex: $swapIndex, ')
          ..write('status: $status, ')
          ..write('editedDurationMin: $editedDurationMin, ')
          ..write('editedDay: $editedDay, ')
          ..write('editedTime: $editedTime, ')
          ..write('timeInputMin: $timeInputMin, ')
          ..write('energyInput: $energyInput, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    day,
    actionId,
    followedActivityId,
    suggestedDay,
    suggestedTime,
    swapIndex,
    status,
    editedDurationMin,
    editedDay,
    editedTime,
    timeInputMin,
    energyInput,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OptionOffer &&
          other.id == this.id &&
          other.day == this.day &&
          other.actionId == this.actionId &&
          other.followedActivityId == this.followedActivityId &&
          other.suggestedDay == this.suggestedDay &&
          other.suggestedTime == this.suggestedTime &&
          other.swapIndex == this.swapIndex &&
          other.status == this.status &&
          other.editedDurationMin == this.editedDurationMin &&
          other.editedDay == this.editedDay &&
          other.editedTime == this.editedTime &&
          other.timeInputMin == this.timeInputMin &&
          other.energyInput == this.energyInput &&
          other.createdAt == this.createdAt);
}

class OptionOffersCompanion extends UpdateCompanion<OptionOffer> {
  final Value<String> id;
  final Value<String> day;
  final Value<String> actionId;
  final Value<String?> followedActivityId;
  final Value<String> suggestedDay;
  final Value<String?> suggestedTime;
  final Value<int> swapIndex;
  final Value<OfferStatus> status;
  final Value<int?> editedDurationMin;
  final Value<String?> editedDay;
  final Value<String?> editedTime;
  final Value<int?> timeInputMin;
  final Value<Energy?> energyInput;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const OptionOffersCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.actionId = const Value.absent(),
    this.followedActivityId = const Value.absent(),
    this.suggestedDay = const Value.absent(),
    this.suggestedTime = const Value.absent(),
    this.swapIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.editedDurationMin = const Value.absent(),
    this.editedDay = const Value.absent(),
    this.editedTime = const Value.absent(),
    this.timeInputMin = const Value.absent(),
    this.energyInput = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OptionOffersCompanion.insert({
    this.id = const Value.absent(),
    required String day,
    required String actionId,
    this.followedActivityId = const Value.absent(),
    required String suggestedDay,
    this.suggestedTime = const Value.absent(),
    this.swapIndex = const Value.absent(),
    this.status = const Value.absent(),
    this.editedDurationMin = const Value.absent(),
    this.editedDay = const Value.absent(),
    this.editedTime = const Value.absent(),
    this.timeInputMin = const Value.absent(),
    this.energyInput = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : day = Value(day),
       actionId = Value(actionId),
       suggestedDay = Value(suggestedDay);
  static Insertable<OptionOffer> custom({
    Expression<String>? id,
    Expression<String>? day,
    Expression<String>? actionId,
    Expression<String>? followedActivityId,
    Expression<String>? suggestedDay,
    Expression<String>? suggestedTime,
    Expression<int>? swapIndex,
    Expression<String>? status,
    Expression<int>? editedDurationMin,
    Expression<String>? editedDay,
    Expression<String>? editedTime,
    Expression<int>? timeInputMin,
    Expression<String>? energyInput,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (actionId != null) 'action_id': actionId,
      if (followedActivityId != null)
        'followed_activity_id': followedActivityId,
      if (suggestedDay != null) 'suggested_day': suggestedDay,
      if (suggestedTime != null) 'suggested_time': suggestedTime,
      if (swapIndex != null) 'swap_index': swapIndex,
      if (status != null) 'status': status,
      if (editedDurationMin != null) 'edited_duration_min': editedDurationMin,
      if (editedDay != null) 'edited_day': editedDay,
      if (editedTime != null) 'edited_time': editedTime,
      if (timeInputMin != null) 'time_input_min': timeInputMin,
      if (energyInput != null) 'energy_input': energyInput,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OptionOffersCompanion copyWith({
    Value<String>? id,
    Value<String>? day,
    Value<String>? actionId,
    Value<String?>? followedActivityId,
    Value<String>? suggestedDay,
    Value<String?>? suggestedTime,
    Value<int>? swapIndex,
    Value<OfferStatus>? status,
    Value<int?>? editedDurationMin,
    Value<String?>? editedDay,
    Value<String?>? editedTime,
    Value<int?>? timeInputMin,
    Value<Energy?>? energyInput,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return OptionOffersCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      actionId: actionId ?? this.actionId,
      followedActivityId: followedActivityId ?? this.followedActivityId,
      suggestedDay: suggestedDay ?? this.suggestedDay,
      suggestedTime: suggestedTime ?? this.suggestedTime,
      swapIndex: swapIndex ?? this.swapIndex,
      status: status ?? this.status,
      editedDurationMin: editedDurationMin ?? this.editedDurationMin,
      editedDay: editedDay ?? this.editedDay,
      editedTime: editedTime ?? this.editedTime,
      timeInputMin: timeInputMin ?? this.timeInputMin,
      energyInput: energyInput ?? this.energyInput,
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
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (actionId.present) {
      map['action_id'] = Variable<String>(actionId.value);
    }
    if (followedActivityId.present) {
      map['followed_activity_id'] = Variable<String>(followedActivityId.value);
    }
    if (suggestedDay.present) {
      map['suggested_day'] = Variable<String>(suggestedDay.value);
    }
    if (suggestedTime.present) {
      map['suggested_time'] = Variable<String>(suggestedTime.value);
    }
    if (swapIndex.present) {
      map['swap_index'] = Variable<int>(swapIndex.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $OptionOffersTable.$converterstatus.toSql(status.value),
      );
    }
    if (editedDurationMin.present) {
      map['edited_duration_min'] = Variable<int>(editedDurationMin.value);
    }
    if (editedDay.present) {
      map['edited_day'] = Variable<String>(editedDay.value);
    }
    if (editedTime.present) {
      map['edited_time'] = Variable<String>(editedTime.value);
    }
    if (timeInputMin.present) {
      map['time_input_min'] = Variable<int>(timeInputMin.value);
    }
    if (energyInput.present) {
      map['energy_input'] = Variable<String>(
        $OptionOffersTable.$converterenergyInputn.toSql(energyInput.value),
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
    return (StringBuffer('OptionOffersCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('actionId: $actionId, ')
          ..write('followedActivityId: $followedActivityId, ')
          ..write('suggestedDay: $suggestedDay, ')
          ..write('suggestedTime: $suggestedTime, ')
          ..write('swapIndex: $swapIndex, ')
          ..write('status: $status, ')
          ..write('editedDurationMin: $editedDurationMin, ')
          ..write('editedDay: $editedDay, ')
          ..write('editedTime: $editedTime, ')
          ..write('timeInputMin: $timeInputMin, ')
          ..write('energyInput: $energyInput, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfferReasonsTable extends OfferReasons
    with TableInfo<$OfferReasonsTable, OfferReason> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfferReasonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _offerIdMeta = const VerificationMeta(
    'offerId',
  );
  @override
  late final GeneratedColumn<String> offerId = GeneratedColumn<String>(
    'offer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES option_offer (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<int> rank = GeneratedColumn<int>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonCodeMeta = const VerificationMeta(
    'reasonCode',
  );
  @override
  late final GeneratedColumn<String> reasonCode = GeneratedColumn<String>(
    'reason_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonTextMeta = const VerificationMeta(
    'reasonText',
  );
  @override
  late final GeneratedColumn<String> reasonText = GeneratedColumn<String>(
    'reason_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [offerId, rank, reasonCode, reasonText];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offer_reason';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfferReason> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('offer_id')) {
      context.handle(
        _offerIdMeta,
        offerId.isAcceptableOrUnknown(data['offer_id']!, _offerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_offerIdMeta);
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    } else if (isInserting) {
      context.missing(_rankMeta);
    }
    if (data.containsKey('reason_code')) {
      context.handle(
        _reasonCodeMeta,
        reasonCode.isAcceptableOrUnknown(data['reason_code']!, _reasonCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonCodeMeta);
    }
    if (data.containsKey('reason_text')) {
      context.handle(
        _reasonTextMeta,
        reasonText.isAcceptableOrUnknown(data['reason_text']!, _reasonTextMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonTextMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {offerId, rank};
  @override
  OfferReason map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfferReason(
      offerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}offer_id'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rank'],
      )!,
      reasonCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_code'],
      )!,
      reasonText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason_text'],
      )!,
    );
  }

  @override
  $OfferReasonsTable createAlias(String alias) {
    return $OfferReasonsTable(attachedDatabase, alias);
  }
}

class OfferReason extends DataClass implements Insertable<OfferReason> {
  final String offerId;
  final int rank;
  final String reasonCode;
  final String reasonText;
  const OfferReason({
    required this.offerId,
    required this.rank,
    required this.reasonCode,
    required this.reasonText,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['offer_id'] = Variable<String>(offerId);
    map['rank'] = Variable<int>(rank);
    map['reason_code'] = Variable<String>(reasonCode);
    map['reason_text'] = Variable<String>(reasonText);
    return map;
  }

  OfferReasonsCompanion toCompanion(bool nullToAbsent) {
    return OfferReasonsCompanion(
      offerId: Value(offerId),
      rank: Value(rank),
      reasonCode: Value(reasonCode),
      reasonText: Value(reasonText),
    );
  }

  factory OfferReason.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfferReason(
      offerId: serializer.fromJson<String>(json['offerId']),
      rank: serializer.fromJson<int>(json['rank']),
      reasonCode: serializer.fromJson<String>(json['reasonCode']),
      reasonText: serializer.fromJson<String>(json['reasonText']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'offerId': serializer.toJson<String>(offerId),
      'rank': serializer.toJson<int>(rank),
      'reasonCode': serializer.toJson<String>(reasonCode),
      'reasonText': serializer.toJson<String>(reasonText),
    };
  }

  OfferReason copyWith({
    String? offerId,
    int? rank,
    String? reasonCode,
    String? reasonText,
  }) => OfferReason(
    offerId: offerId ?? this.offerId,
    rank: rank ?? this.rank,
    reasonCode: reasonCode ?? this.reasonCode,
    reasonText: reasonText ?? this.reasonText,
  );
  OfferReason copyWithCompanion(OfferReasonsCompanion data) {
    return OfferReason(
      offerId: data.offerId.present ? data.offerId.value : this.offerId,
      rank: data.rank.present ? data.rank.value : this.rank,
      reasonCode: data.reasonCode.present
          ? data.reasonCode.value
          : this.reasonCode,
      reasonText: data.reasonText.present
          ? data.reasonText.value
          : this.reasonText,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfferReason(')
          ..write('offerId: $offerId, ')
          ..write('rank: $rank, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('reasonText: $reasonText')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(offerId, rank, reasonCode, reasonText);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfferReason &&
          other.offerId == this.offerId &&
          other.rank == this.rank &&
          other.reasonCode == this.reasonCode &&
          other.reasonText == this.reasonText);
}

class OfferReasonsCompanion extends UpdateCompanion<OfferReason> {
  final Value<String> offerId;
  final Value<int> rank;
  final Value<String> reasonCode;
  final Value<String> reasonText;
  final Value<int> rowid;
  const OfferReasonsCompanion({
    this.offerId = const Value.absent(),
    this.rank = const Value.absent(),
    this.reasonCode = const Value.absent(),
    this.reasonText = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfferReasonsCompanion.insert({
    required String offerId,
    required int rank,
    required String reasonCode,
    required String reasonText,
    this.rowid = const Value.absent(),
  }) : offerId = Value(offerId),
       rank = Value(rank),
       reasonCode = Value(reasonCode),
       reasonText = Value(reasonText);
  static Insertable<OfferReason> custom({
    Expression<String>? offerId,
    Expression<int>? rank,
    Expression<String>? reasonCode,
    Expression<String>? reasonText,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (offerId != null) 'offer_id': offerId,
      if (rank != null) 'rank': rank,
      if (reasonCode != null) 'reason_code': reasonCode,
      if (reasonText != null) 'reason_text': reasonText,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfferReasonsCompanion copyWith({
    Value<String>? offerId,
    Value<int>? rank,
    Value<String>? reasonCode,
    Value<String>? reasonText,
    Value<int>? rowid,
  }) {
    return OfferReasonsCompanion(
      offerId: offerId ?? this.offerId,
      rank: rank ?? this.rank,
      reasonCode: reasonCode ?? this.reasonCode,
      reasonText: reasonText ?? this.reasonText,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (offerId.present) {
      map['offer_id'] = Variable<String>(offerId.value);
    }
    if (rank.present) {
      map['rank'] = Variable<int>(rank.value);
    }
    if (reasonCode.present) {
      map['reason_code'] = Variable<String>(reasonCode.value);
    }
    if (reasonText.present) {
      map['reason_text'] = Variable<String>(reasonText.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfferReasonsCompanion(')
          ..write('offerId: $offerId, ')
          ..write('rank: $rank, ')
          ..write('reasonCode: $reasonCode, ')
          ..write('reasonText: $reasonText, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanItemsTable extends PlanItems
    with TableInfo<$PlanItemsTable, PlanItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => newId('plan'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PlanSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PlanSource>($PlanItemsTable.$convertersource);
  static const VerificationMeta _offerIdMeta = const VerificationMeta(
    'offerId',
  );
  @override
  late final GeneratedColumn<String> offerId = GeneratedColumn<String>(
    'offer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES option_offer (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _actionIdMeta = const VerificationMeta(
    'actionId',
  );
  @override
  late final GeneratedColumn<String> actionId = GeneratedColumn<String>(
    'action_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "action" (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ActivityKind, String> activity =
      GeneratedColumn<String>(
        'activity',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ActivityKind>($PlanItemsTable.$converteractivity);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedDayMeta = const VerificationMeta(
    'plannedDay',
  );
  @override
  late final GeneratedColumn<String> plannedDay = GeneratedColumn<String>(
    'planned_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plannedTimeMeta = const VerificationMeta(
    'plannedTime',
  );
  @override
  late final GeneratedColumn<String> plannedTime = GeneratedColumn<String>(
    'planned_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMinMeta = const VerificationMeta(
    'durationMin',
  );
  @override
  late final GeneratedColumn<int> durationMin = GeneratedColumn<int>(
    'duration_min',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WithWhom, String> withWhom =
      GeneratedColumn<String>(
        'with_whom',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('solo'),
      ).withConverter<WithWhom>($PlanItemsTable.$converterwithWhom);
  static const VerificationMeta _togetherEventIdMeta = const VerificationMeta(
    'togetherEventId',
  );
  @override
  late final GeneratedColumn<String> togetherEventId = GeneratedColumn<String>(
    'together_event_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _detailTextMeta = const VerificationMeta(
    'detailText',
  );
  @override
  late final GeneratedColumn<String> detailText = GeneratedColumn<String>(
    'detail_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    source,
    offerId,
    actionId,
    activity,
    title,
    plannedDay,
    plannedTime,
    durationMin,
    withWhom,
    togetherEventId,
    detailText,
    startedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_item';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('offer_id')) {
      context.handle(
        _offerIdMeta,
        offerId.isAcceptableOrUnknown(data['offer_id']!, _offerIdMeta),
      );
    }
    if (data.containsKey('action_id')) {
      context.handle(
        _actionIdMeta,
        actionId.isAcceptableOrUnknown(data['action_id']!, _actionIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('planned_day')) {
      context.handle(
        _plannedDayMeta,
        plannedDay.isAcceptableOrUnknown(data['planned_day']!, _plannedDayMeta),
      );
    } else if (isInserting) {
      context.missing(_plannedDayMeta);
    }
    if (data.containsKey('planned_time')) {
      context.handle(
        _plannedTimeMeta,
        plannedTime.isAcceptableOrUnknown(
          data['planned_time']!,
          _plannedTimeMeta,
        ),
      );
    }
    if (data.containsKey('duration_min')) {
      context.handle(
        _durationMinMeta,
        durationMin.isAcceptableOrUnknown(
          data['duration_min']!,
          _durationMinMeta,
        ),
      );
    }
    if (data.containsKey('together_event_id')) {
      context.handle(
        _togetherEventIdMeta,
        togetherEventId.isAcceptableOrUnknown(
          data['together_event_id']!,
          _togetherEventIdMeta,
        ),
      );
    }
    if (data.containsKey('detail_text')) {
      context.handle(
        _detailTextMeta,
        detailText.isAcceptableOrUnknown(data['detail_text']!, _detailTextMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
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
  PlanItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      source: $PlanItemsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      offerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}offer_id'],
      ),
      actionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_id'],
      ),
      activity: $PlanItemsTable.$converteractivity.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}activity'],
        )!,
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      plannedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned_day'],
      )!,
      plannedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}planned_time'],
      ),
      durationMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min'],
      ),
      withWhom: $PlanItemsTable.$converterwithWhom.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}with_whom'],
        )!,
      ),
      togetherEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}together_event_id'],
      ),
      detailText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail_text'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PlanItemsTable createAlias(String alias) {
    return $PlanItemsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PlanSource, String, String> $convertersource =
      const CodedEnumConverter<PlanSource>(PlanSource.values);
  static JsonTypeConverter2<ActivityKind, String, String> $converteractivity =
      const CodedEnumConverter<ActivityKind>(ActivityKind.values);
  static JsonTypeConverter2<WithWhom, String, String> $converterwithWhom =
      const CodedEnumConverter<WithWhom>(WithWhom.values);
}

class PlanItem extends DataClass implements Insertable<PlanItem> {
  final String id;
  final PlanSource source;
  final String? offerId;
  final String? actionId;
  final ActivityKind activity;
  final String title;
  final String plannedDay;
  final String? plannedTime;
  final int? durationMin;
  final WithWhom withWhom;
  final String? togetherEventId;
  final String? detailText;
  final DateTime? startedAt;
  final DateTime createdAt;
  const PlanItem({
    required this.id,
    required this.source,
    this.offerId,
    this.actionId,
    required this.activity,
    required this.title,
    required this.plannedDay,
    this.plannedTime,
    this.durationMin,
    required this.withWhom,
    this.togetherEventId,
    this.detailText,
    this.startedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['source'] = Variable<String>(
        $PlanItemsTable.$convertersource.toSql(source),
      );
    }
    if (!nullToAbsent || offerId != null) {
      map['offer_id'] = Variable<String>(offerId);
    }
    if (!nullToAbsent || actionId != null) {
      map['action_id'] = Variable<String>(actionId);
    }
    {
      map['activity'] = Variable<String>(
        $PlanItemsTable.$converteractivity.toSql(activity),
      );
    }
    map['title'] = Variable<String>(title);
    map['planned_day'] = Variable<String>(plannedDay);
    if (!nullToAbsent || plannedTime != null) {
      map['planned_time'] = Variable<String>(plannedTime);
    }
    if (!nullToAbsent || durationMin != null) {
      map['duration_min'] = Variable<int>(durationMin);
    }
    {
      map['with_whom'] = Variable<String>(
        $PlanItemsTable.$converterwithWhom.toSql(withWhom),
      );
    }
    if (!nullToAbsent || togetherEventId != null) {
      map['together_event_id'] = Variable<String>(togetherEventId);
    }
    if (!nullToAbsent || detailText != null) {
      map['detail_text'] = Variable<String>(detailText);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PlanItemsCompanion toCompanion(bool nullToAbsent) {
    return PlanItemsCompanion(
      id: Value(id),
      source: Value(source),
      offerId: offerId == null && nullToAbsent
          ? const Value.absent()
          : Value(offerId),
      actionId: actionId == null && nullToAbsent
          ? const Value.absent()
          : Value(actionId),
      activity: Value(activity),
      title: Value(title),
      plannedDay: Value(plannedDay),
      plannedTime: plannedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedTime),
      durationMin: durationMin == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMin),
      withWhom: Value(withWhom),
      togetherEventId: togetherEventId == null && nullToAbsent
          ? const Value.absent()
          : Value(togetherEventId),
      detailText: detailText == null && nullToAbsent
          ? const Value.absent()
          : Value(detailText),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      createdAt: Value(createdAt),
    );
  }

  factory PlanItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanItem(
      id: serializer.fromJson<String>(json['id']),
      source: $PlanItemsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      offerId: serializer.fromJson<String?>(json['offerId']),
      actionId: serializer.fromJson<String?>(json['actionId']),
      activity: $PlanItemsTable.$converteractivity.fromJson(
        serializer.fromJson<String>(json['activity']),
      ),
      title: serializer.fromJson<String>(json['title']),
      plannedDay: serializer.fromJson<String>(json['plannedDay']),
      plannedTime: serializer.fromJson<String?>(json['plannedTime']),
      durationMin: serializer.fromJson<int?>(json['durationMin']),
      withWhom: $PlanItemsTable.$converterwithWhom.fromJson(
        serializer.fromJson<String>(json['withWhom']),
      ),
      togetherEventId: serializer.fromJson<String?>(json['togetherEventId']),
      detailText: serializer.fromJson<String?>(json['detailText']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'source': serializer.toJson<String>(
        $PlanItemsTable.$convertersource.toJson(source),
      ),
      'offerId': serializer.toJson<String?>(offerId),
      'actionId': serializer.toJson<String?>(actionId),
      'activity': serializer.toJson<String>(
        $PlanItemsTable.$converteractivity.toJson(activity),
      ),
      'title': serializer.toJson<String>(title),
      'plannedDay': serializer.toJson<String>(plannedDay),
      'plannedTime': serializer.toJson<String?>(plannedTime),
      'durationMin': serializer.toJson<int?>(durationMin),
      'withWhom': serializer.toJson<String>(
        $PlanItemsTable.$converterwithWhom.toJson(withWhom),
      ),
      'togetherEventId': serializer.toJson<String?>(togetherEventId),
      'detailText': serializer.toJson<String?>(detailText),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PlanItem copyWith({
    String? id,
    PlanSource? source,
    Value<String?> offerId = const Value.absent(),
    Value<String?> actionId = const Value.absent(),
    ActivityKind? activity,
    String? title,
    String? plannedDay,
    Value<String?> plannedTime = const Value.absent(),
    Value<int?> durationMin = const Value.absent(),
    WithWhom? withWhom,
    Value<String?> togetherEventId = const Value.absent(),
    Value<String?> detailText = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    DateTime? createdAt,
  }) => PlanItem(
    id: id ?? this.id,
    source: source ?? this.source,
    offerId: offerId.present ? offerId.value : this.offerId,
    actionId: actionId.present ? actionId.value : this.actionId,
    activity: activity ?? this.activity,
    title: title ?? this.title,
    plannedDay: plannedDay ?? this.plannedDay,
    plannedTime: plannedTime.present ? plannedTime.value : this.plannedTime,
    durationMin: durationMin.present ? durationMin.value : this.durationMin,
    withWhom: withWhom ?? this.withWhom,
    togetherEventId: togetherEventId.present
        ? togetherEventId.value
        : this.togetherEventId,
    detailText: detailText.present ? detailText.value : this.detailText,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  PlanItem copyWithCompanion(PlanItemsCompanion data) {
    return PlanItem(
      id: data.id.present ? data.id.value : this.id,
      source: data.source.present ? data.source.value : this.source,
      offerId: data.offerId.present ? data.offerId.value : this.offerId,
      actionId: data.actionId.present ? data.actionId.value : this.actionId,
      activity: data.activity.present ? data.activity.value : this.activity,
      title: data.title.present ? data.title.value : this.title,
      plannedDay: data.plannedDay.present
          ? data.plannedDay.value
          : this.plannedDay,
      plannedTime: data.plannedTime.present
          ? data.plannedTime.value
          : this.plannedTime,
      durationMin: data.durationMin.present
          ? data.durationMin.value
          : this.durationMin,
      withWhom: data.withWhom.present ? data.withWhom.value : this.withWhom,
      togetherEventId: data.togetherEventId.present
          ? data.togetherEventId.value
          : this.togetherEventId,
      detailText: data.detailText.present
          ? data.detailText.value
          : this.detailText,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanItem(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('offerId: $offerId, ')
          ..write('actionId: $actionId, ')
          ..write('activity: $activity, ')
          ..write('title: $title, ')
          ..write('plannedDay: $plannedDay, ')
          ..write('plannedTime: $plannedTime, ')
          ..write('durationMin: $durationMin, ')
          ..write('withWhom: $withWhom, ')
          ..write('togetherEventId: $togetherEventId, ')
          ..write('detailText: $detailText, ')
          ..write('startedAt: $startedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    source,
    offerId,
    actionId,
    activity,
    title,
    plannedDay,
    plannedTime,
    durationMin,
    withWhom,
    togetherEventId,
    detailText,
    startedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanItem &&
          other.id == this.id &&
          other.source == this.source &&
          other.offerId == this.offerId &&
          other.actionId == this.actionId &&
          other.activity == this.activity &&
          other.title == this.title &&
          other.plannedDay == this.plannedDay &&
          other.plannedTime == this.plannedTime &&
          other.durationMin == this.durationMin &&
          other.withWhom == this.withWhom &&
          other.togetherEventId == this.togetherEventId &&
          other.detailText == this.detailText &&
          other.startedAt == this.startedAt &&
          other.createdAt == this.createdAt);
}

class PlanItemsCompanion extends UpdateCompanion<PlanItem> {
  final Value<String> id;
  final Value<PlanSource> source;
  final Value<String?> offerId;
  final Value<String?> actionId;
  final Value<ActivityKind> activity;
  final Value<String> title;
  final Value<String> plannedDay;
  final Value<String?> plannedTime;
  final Value<int?> durationMin;
  final Value<WithWhom> withWhom;
  final Value<String?> togetherEventId;
  final Value<String?> detailText;
  final Value<DateTime?> startedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PlanItemsCompanion({
    this.id = const Value.absent(),
    this.source = const Value.absent(),
    this.offerId = const Value.absent(),
    this.actionId = const Value.absent(),
    this.activity = const Value.absent(),
    this.title = const Value.absent(),
    this.plannedDay = const Value.absent(),
    this.plannedTime = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.withWhom = const Value.absent(),
    this.togetherEventId = const Value.absent(),
    this.detailText = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanItemsCompanion.insert({
    this.id = const Value.absent(),
    required PlanSource source,
    this.offerId = const Value.absent(),
    this.actionId = const Value.absent(),
    required ActivityKind activity,
    required String title,
    required String plannedDay,
    this.plannedTime = const Value.absent(),
    this.durationMin = const Value.absent(),
    this.withWhom = const Value.absent(),
    this.togetherEventId = const Value.absent(),
    this.detailText = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : source = Value(source),
       activity = Value(activity),
       title = Value(title),
       plannedDay = Value(plannedDay);
  static Insertable<PlanItem> custom({
    Expression<String>? id,
    Expression<String>? source,
    Expression<String>? offerId,
    Expression<String>? actionId,
    Expression<String>? activity,
    Expression<String>? title,
    Expression<String>? plannedDay,
    Expression<String>? plannedTime,
    Expression<int>? durationMin,
    Expression<String>? withWhom,
    Expression<String>? togetherEventId,
    Expression<String>? detailText,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (source != null) 'source': source,
      if (offerId != null) 'offer_id': offerId,
      if (actionId != null) 'action_id': actionId,
      if (activity != null) 'activity': activity,
      if (title != null) 'title': title,
      if (plannedDay != null) 'planned_day': plannedDay,
      if (plannedTime != null) 'planned_time': plannedTime,
      if (durationMin != null) 'duration_min': durationMin,
      if (withWhom != null) 'with_whom': withWhom,
      if (togetherEventId != null) 'together_event_id': togetherEventId,
      if (detailText != null) 'detail_text': detailText,
      if (startedAt != null) 'started_at': startedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanItemsCompanion copyWith({
    Value<String>? id,
    Value<PlanSource>? source,
    Value<String?>? offerId,
    Value<String?>? actionId,
    Value<ActivityKind>? activity,
    Value<String>? title,
    Value<String>? plannedDay,
    Value<String?>? plannedTime,
    Value<int?>? durationMin,
    Value<WithWhom>? withWhom,
    Value<String?>? togetherEventId,
    Value<String?>? detailText,
    Value<DateTime?>? startedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PlanItemsCompanion(
      id: id ?? this.id,
      source: source ?? this.source,
      offerId: offerId ?? this.offerId,
      actionId: actionId ?? this.actionId,
      activity: activity ?? this.activity,
      title: title ?? this.title,
      plannedDay: plannedDay ?? this.plannedDay,
      plannedTime: plannedTime ?? this.plannedTime,
      durationMin: durationMin ?? this.durationMin,
      withWhom: withWhom ?? this.withWhom,
      togetherEventId: togetherEventId ?? this.togetherEventId,
      detailText: detailText ?? this.detailText,
      startedAt: startedAt ?? this.startedAt,
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
    if (source.present) {
      map['source'] = Variable<String>(
        $PlanItemsTable.$convertersource.toSql(source.value),
      );
    }
    if (offerId.present) {
      map['offer_id'] = Variable<String>(offerId.value);
    }
    if (actionId.present) {
      map['action_id'] = Variable<String>(actionId.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(
        $PlanItemsTable.$converteractivity.toSql(activity.value),
      );
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (plannedDay.present) {
      map['planned_day'] = Variable<String>(plannedDay.value);
    }
    if (plannedTime.present) {
      map['planned_time'] = Variable<String>(plannedTime.value);
    }
    if (durationMin.present) {
      map['duration_min'] = Variable<int>(durationMin.value);
    }
    if (withWhom.present) {
      map['with_whom'] = Variable<String>(
        $PlanItemsTable.$converterwithWhom.toSql(withWhom.value),
      );
    }
    if (togetherEventId.present) {
      map['together_event_id'] = Variable<String>(togetherEventId.value);
    }
    if (detailText.present) {
      map['detail_text'] = Variable<String>(detailText.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
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
    return (StringBuffer('PlanItemsCompanion(')
          ..write('id: $id, ')
          ..write('source: $source, ')
          ..write('offerId: $offerId, ')
          ..write('actionId: $actionId, ')
          ..write('activity: $activity, ')
          ..write('title: $title, ')
          ..write('plannedDay: $plannedDay, ')
          ..write('plannedTime: $plannedTime, ')
          ..write('durationMin: $durationMin, ')
          ..write('withWhom: $withWhom, ')
          ..write('togetherEventId: $togetherEventId, ')
          ..write('detailText: $detailText, ')
          ..write('startedAt: $startedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReflectionsTable extends Reflections
    with TableInfo<$ReflectionsTable, Reflection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReflectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => newId('ref'),
  );
  static const VerificationMeta _planItemIdMeta = const VerificationMeta(
    'planItemId',
  );
  @override
  late final GeneratedColumn<String> planItemId = GeneratedColumn<String>(
    'plan_item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_item (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReflectionStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unknown'),
      ).withConverter<ReflectionStatus>($ReflectionsTable.$converterstatus);
  static const VerificationMeta _enjoymentMeta = const VerificationMeta(
    'enjoyment',
  );
  @override
  late final GeneratedColumn<int> enjoyment = GeneratedColumn<int>(
    'enjoyment',
    aliasedName,
    true,
    check: () => ComparableExpr(enjoyment).isBetweenValues(1, 3),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Barrier?, String> barrier =
      GeneratedColumn<String>(
        'barrier',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Barrier?>($ReflectionsTable.$converterbarriern);
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    planItemId,
    status,
    enjoyment,
    barrier,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reflection';
  @override
  VerificationContext validateIntegrity(
    Insertable<Reflection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('plan_item_id')) {
      context.handle(
        _planItemIdMeta,
        planItemId.isAcceptableOrUnknown(
          data['plan_item_id']!,
          _planItemIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_planItemIdMeta);
    }
    if (data.containsKey('enjoyment')) {
      context.handle(
        _enjoymentMeta,
        enjoyment.isAcceptableOrUnknown(data['enjoyment']!, _enjoymentMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {planItemId},
  ];
  @override
  Reflection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Reflection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      planItemId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_item_id'],
      )!,
      status: $ReflectionsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      enjoyment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}enjoyment'],
      ),
      barrier: $ReflectionsTable.$converterbarriern.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}barrier'],
        ),
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReflectionsTable createAlias(String alias) {
    return $ReflectionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReflectionStatus, String, String> $converterstatus =
      const CodedEnumConverter<ReflectionStatus>(ReflectionStatus.values);
  static JsonTypeConverter2<Barrier, String, String> $converterbarrier =
      const CodedEnumConverter<Barrier>(Barrier.values);
  static JsonTypeConverter2<Barrier?, String?, String?> $converterbarriern =
      JsonTypeConverter2.asNullable($converterbarrier);
}

class Reflection extends DataClass implements Insertable<Reflection> {
  final String id;
  final String planItemId;
  final ReflectionStatus status;
  final int? enjoyment;
  final Barrier? barrier;
  final DateTime updatedAt;
  const Reflection({
    required this.id,
    required this.planItemId,
    required this.status,
    this.enjoyment,
    this.barrier,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plan_item_id'] = Variable<String>(planItemId);
    {
      map['status'] = Variable<String>(
        $ReflectionsTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || enjoyment != null) {
      map['enjoyment'] = Variable<int>(enjoyment);
    }
    if (!nullToAbsent || barrier != null) {
      map['barrier'] = Variable<String>(
        $ReflectionsTable.$converterbarriern.toSql(barrier),
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ReflectionsCompanion toCompanion(bool nullToAbsent) {
    return ReflectionsCompanion(
      id: Value(id),
      planItemId: Value(planItemId),
      status: Value(status),
      enjoyment: enjoyment == null && nullToAbsent
          ? const Value.absent()
          : Value(enjoyment),
      barrier: barrier == null && nullToAbsent
          ? const Value.absent()
          : Value(barrier),
      updatedAt: Value(updatedAt),
    );
  }

  factory Reflection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Reflection(
      id: serializer.fromJson<String>(json['id']),
      planItemId: serializer.fromJson<String>(json['planItemId']),
      status: $ReflectionsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      enjoyment: serializer.fromJson<int?>(json['enjoyment']),
      barrier: $ReflectionsTable.$converterbarriern.fromJson(
        serializer.fromJson<String?>(json['barrier']),
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'planItemId': serializer.toJson<String>(planItemId),
      'status': serializer.toJson<String>(
        $ReflectionsTable.$converterstatus.toJson(status),
      ),
      'enjoyment': serializer.toJson<int?>(enjoyment),
      'barrier': serializer.toJson<String?>(
        $ReflectionsTable.$converterbarriern.toJson(barrier),
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Reflection copyWith({
    String? id,
    String? planItemId,
    ReflectionStatus? status,
    Value<int?> enjoyment = const Value.absent(),
    Value<Barrier?> barrier = const Value.absent(),
    DateTime? updatedAt,
  }) => Reflection(
    id: id ?? this.id,
    planItemId: planItemId ?? this.planItemId,
    status: status ?? this.status,
    enjoyment: enjoyment.present ? enjoyment.value : this.enjoyment,
    barrier: barrier.present ? barrier.value : this.barrier,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Reflection copyWithCompanion(ReflectionsCompanion data) {
    return Reflection(
      id: data.id.present ? data.id.value : this.id,
      planItemId: data.planItemId.present
          ? data.planItemId.value
          : this.planItemId,
      status: data.status.present ? data.status.value : this.status,
      enjoyment: data.enjoyment.present ? data.enjoyment.value : this.enjoyment,
      barrier: data.barrier.present ? data.barrier.value : this.barrier,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Reflection(')
          ..write('id: $id, ')
          ..write('planItemId: $planItemId, ')
          ..write('status: $status, ')
          ..write('enjoyment: $enjoyment, ')
          ..write('barrier: $barrier, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, planItemId, status, enjoyment, barrier, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Reflection &&
          other.id == this.id &&
          other.planItemId == this.planItemId &&
          other.status == this.status &&
          other.enjoyment == this.enjoyment &&
          other.barrier == this.barrier &&
          other.updatedAt == this.updatedAt);
}

class ReflectionsCompanion extends UpdateCompanion<Reflection> {
  final Value<String> id;
  final Value<String> planItemId;
  final Value<ReflectionStatus> status;
  final Value<int?> enjoyment;
  final Value<Barrier?> barrier;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ReflectionsCompanion({
    this.id = const Value.absent(),
    this.planItemId = const Value.absent(),
    this.status = const Value.absent(),
    this.enjoyment = const Value.absent(),
    this.barrier = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReflectionsCompanion.insert({
    this.id = const Value.absent(),
    required String planItemId,
    this.status = const Value.absent(),
    this.enjoyment = const Value.absent(),
    this.barrier = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : planItemId = Value(planItemId);
  static Insertable<Reflection> custom({
    Expression<String>? id,
    Expression<String>? planItemId,
    Expression<String>? status,
    Expression<int>? enjoyment,
    Expression<String>? barrier,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (planItemId != null) 'plan_item_id': planItemId,
      if (status != null) 'status': status,
      if (enjoyment != null) 'enjoyment': enjoyment,
      if (barrier != null) 'barrier': barrier,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReflectionsCompanion copyWith({
    Value<String>? id,
    Value<String>? planItemId,
    Value<ReflectionStatus>? status,
    Value<int?>? enjoyment,
    Value<Barrier?>? barrier,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ReflectionsCompanion(
      id: id ?? this.id,
      planItemId: planItemId ?? this.planItemId,
      status: status ?? this.status,
      enjoyment: enjoyment ?? this.enjoyment,
      barrier: barrier ?? this.barrier,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (planItemId.present) {
      map['plan_item_id'] = Variable<String>(planItemId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ReflectionsTable.$converterstatus.toSql(status.value),
      );
    }
    if (enjoyment.present) {
      map['enjoyment'] = Variable<int>(enjoyment.value);
    }
    if (barrier.present) {
      map['barrier'] = Variable<String>(
        $ReflectionsTable.$converterbarriern.toSql(barrier.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionsCompanion(')
          ..write('id: $id, ')
          ..write('planItemId: $planItemId, ')
          ..write('status: $status, ')
          ..write('enjoyment: $enjoyment, ')
          ..write('barrier: $barrier, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PausesTable extends Pauses with TableInfo<$PausesTable, Pause> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PausesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => newId('pau'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PauseKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<PauseKind>($PausesTable.$converterkind);
  static const VerificationMeta _startDayMeta = const VerificationMeta(
    'startDay',
  );
  @override
  late final GeneratedColumn<String> startDay = GeneratedColumn<String>(
    'start_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDayMeta = const VerificationMeta('endDay');
  @override
  late final GeneratedColumn<String> endDay = GeneratedColumn<String>(
    'end_day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, startDay, endDay];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pause';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pause> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('start_day')) {
      context.handle(
        _startDayMeta,
        startDay.isAcceptableOrUnknown(data['start_day']!, _startDayMeta),
      );
    } else if (isInserting) {
      context.missing(_startDayMeta);
    }
    if (data.containsKey('end_day')) {
      context.handle(
        _endDayMeta,
        endDay.isAcceptableOrUnknown(data['end_day']!, _endDayMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pause map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pause(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: $PausesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      startDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}start_day'],
      )!,
      endDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}end_day'],
      ),
    );
  }

  @override
  $PausesTable createAlias(String alias) {
    return $PausesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PauseKind, String, String> $converterkind =
      const CodedEnumConverter<PauseKind>(PauseKind.values);
}

class Pause extends DataClass implements Insertable<Pause> {
  final String id;
  final PauseKind kind;
  final String startDay;
  final String? endDay;
  const Pause({
    required this.id,
    required this.kind,
    required this.startDay,
    this.endDay,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['kind'] = Variable<String>($PausesTable.$converterkind.toSql(kind));
    }
    map['start_day'] = Variable<String>(startDay);
    if (!nullToAbsent || endDay != null) {
      map['end_day'] = Variable<String>(endDay);
    }
    return map;
  }

  PausesCompanion toCompanion(bool nullToAbsent) {
    return PausesCompanion(
      id: Value(id),
      kind: Value(kind),
      startDay: Value(startDay),
      endDay: endDay == null && nullToAbsent
          ? const Value.absent()
          : Value(endDay),
    );
  }

  factory Pause.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pause(
      id: serializer.fromJson<String>(json['id']),
      kind: $PausesTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      startDay: serializer.fromJson<String>(json['startDay']),
      endDay: serializer.fromJson<String?>(json['endDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(
        $PausesTable.$converterkind.toJson(kind),
      ),
      'startDay': serializer.toJson<String>(startDay),
      'endDay': serializer.toJson<String?>(endDay),
    };
  }

  Pause copyWith({
    String? id,
    PauseKind? kind,
    String? startDay,
    Value<String?> endDay = const Value.absent(),
  }) => Pause(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    startDay: startDay ?? this.startDay,
    endDay: endDay.present ? endDay.value : this.endDay,
  );
  Pause copyWithCompanion(PausesCompanion data) {
    return Pause(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      startDay: data.startDay.present ? data.startDay.value : this.startDay,
      endDay: data.endDay.present ? data.endDay.value : this.endDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pause(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('startDay: $startDay, ')
          ..write('endDay: $endDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, startDay, endDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pause &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.startDay == this.startDay &&
          other.endDay == this.endDay);
}

class PausesCompanion extends UpdateCompanion<Pause> {
  final Value<String> id;
  final Value<PauseKind> kind;
  final Value<String> startDay;
  final Value<String?> endDay;
  final Value<int> rowid;
  const PausesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.startDay = const Value.absent(),
    this.endDay = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PausesCompanion.insert({
    this.id = const Value.absent(),
    required PauseKind kind,
    required String startDay,
    this.endDay = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       startDay = Value(startDay);
  static Insertable<Pause> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<String>? startDay,
    Expression<String>? endDay,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (startDay != null) 'start_day': startDay,
      if (endDay != null) 'end_day': endDay,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PausesCompanion copyWith({
    Value<String>? id,
    Value<PauseKind>? kind,
    Value<String>? startDay,
    Value<String?>? endDay,
    Value<int>? rowid,
  }) {
    return PausesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      startDay: startDay ?? this.startDay,
      endDay: endDay ?? this.endDay,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $PausesTable.$converterkind.toSql(kind.value),
      );
    }
    if (startDay.present) {
      map['start_day'] = Variable<String>(startDay.value);
    }
    if (endDay.present) {
      map['end_day'] = Variable<String>(endDay.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PausesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('startDay: $startDay, ')
          ..write('endDay: $endDay, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ObservationsTable extends Observations
    with TableInfo<$ObservationsTable, Observation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ObservationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => newId('obs'),
  );
  static const VerificationMeta _text_Meta = const VerificationMeta('text_');
  @override
  late final GeneratedColumn<String> text_ = GeneratedColumn<String>(
    'text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ObsSource, String> source =
      GeneratedColumn<String>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ObsSource>($ObservationsTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<ObsStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('proposed'),
      ).withConverter<ObsStatus>($ObservationsTable.$converterstatus);
  static const VerificationMeta _patternKeyMeta = const VerificationMeta(
    'patternKey',
  );
  @override
  late final GeneratedColumn<String> patternKey = GeneratedColumn<String>(
    'pattern_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _confirmedAtMeta = const VerificationMeta(
    'confirmedAt',
  );
  @override
  late final GeneratedColumn<DateTime> confirmedAt = GeneratedColumn<DateTime>(
    'confirmed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    text_,
    source,
    status,
    patternKey,
    createdAt,
    confirmedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'observation';
  @override
  VerificationContext validateIntegrity(
    Insertable<Observation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('text')) {
      context.handle(
        _text_Meta,
        text_.isAcceptableOrUnknown(data['text']!, _text_Meta),
      );
    } else if (isInserting) {
      context.missing(_text_Meta);
    }
    if (data.containsKey('pattern_key')) {
      context.handle(
        _patternKeyMeta,
        patternKey.isAcceptableOrUnknown(data['pattern_key']!, _patternKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_patternKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('confirmed_at')) {
      context.handle(
        _confirmedAtMeta,
        confirmedAt.isAcceptableOrUnknown(
          data['confirmed_at']!,
          _confirmedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Observation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Observation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      text_: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}text'],
      )!,
      source: $ObservationsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source'],
        )!,
      ),
      status: $ObservationsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      patternKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pattern_key'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      confirmedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}confirmed_at'],
      ),
    );
  }

  @override
  $ObservationsTable createAlias(String alias) {
    return $ObservationsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ObsSource, String, String> $convertersource =
      const CodedEnumConverter<ObsSource>(ObsSource.values);
  static JsonTypeConverter2<ObsStatus, String, String> $converterstatus =
      const CodedEnumConverter<ObsStatus>(ObsStatus.values);
}

class Observation extends DataClass implements Insertable<Observation> {
  final String id;
  final String text_;
  final ObsSource source;
  final ObsStatus status;
  final String patternKey;
  final DateTime createdAt;
  final DateTime? confirmedAt;
  const Observation({
    required this.id,
    required this.text_,
    required this.source,
    required this.status,
    required this.patternKey,
    required this.createdAt,
    this.confirmedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['text'] = Variable<String>(text_);
    {
      map['source'] = Variable<String>(
        $ObservationsTable.$convertersource.toSql(source),
      );
    }
    {
      map['status'] = Variable<String>(
        $ObservationsTable.$converterstatus.toSql(status),
      );
    }
    map['pattern_key'] = Variable<String>(patternKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || confirmedAt != null) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt);
    }
    return map;
  }

  ObservationsCompanion toCompanion(bool nullToAbsent) {
    return ObservationsCompanion(
      id: Value(id),
      text_: Value(text_),
      source: Value(source),
      status: Value(status),
      patternKey: Value(patternKey),
      createdAt: Value(createdAt),
      confirmedAt: confirmedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedAt),
    );
  }

  factory Observation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Observation(
      id: serializer.fromJson<String>(json['id']),
      text_: serializer.fromJson<String>(json['text_']),
      source: $ObservationsTable.$convertersource.fromJson(
        serializer.fromJson<String>(json['source']),
      ),
      status: $ObservationsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      patternKey: serializer.fromJson<String>(json['patternKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      confirmedAt: serializer.fromJson<DateTime?>(json['confirmedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'text_': serializer.toJson<String>(text_),
      'source': serializer.toJson<String>(
        $ObservationsTable.$convertersource.toJson(source),
      ),
      'status': serializer.toJson<String>(
        $ObservationsTable.$converterstatus.toJson(status),
      ),
      'patternKey': serializer.toJson<String>(patternKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'confirmedAt': serializer.toJson<DateTime?>(confirmedAt),
    };
  }

  Observation copyWith({
    String? id,
    String? text_,
    ObsSource? source,
    ObsStatus? status,
    String? patternKey,
    DateTime? createdAt,
    Value<DateTime?> confirmedAt = const Value.absent(),
  }) => Observation(
    id: id ?? this.id,
    text_: text_ ?? this.text_,
    source: source ?? this.source,
    status: status ?? this.status,
    patternKey: patternKey ?? this.patternKey,
    createdAt: createdAt ?? this.createdAt,
    confirmedAt: confirmedAt.present ? confirmedAt.value : this.confirmedAt,
  );
  Observation copyWithCompanion(ObservationsCompanion data) {
    return Observation(
      id: data.id.present ? data.id.value : this.id,
      text_: data.text_.present ? data.text_.value : this.text_,
      source: data.source.present ? data.source.value : this.source,
      status: data.status.present ? data.status.value : this.status,
      patternKey: data.patternKey.present
          ? data.patternKey.value
          : this.patternKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      confirmedAt: data.confirmedAt.present
          ? data.confirmedAt.value
          : this.confirmedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Observation(')
          ..write('id: $id, ')
          ..write('text_: $text_, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('patternKey: $patternKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('confirmedAt: $confirmedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    text_,
    source,
    status,
    patternKey,
    createdAt,
    confirmedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Observation &&
          other.id == this.id &&
          other.text_ == this.text_ &&
          other.source == this.source &&
          other.status == this.status &&
          other.patternKey == this.patternKey &&
          other.createdAt == this.createdAt &&
          other.confirmedAt == this.confirmedAt);
}

class ObservationsCompanion extends UpdateCompanion<Observation> {
  final Value<String> id;
  final Value<String> text_;
  final Value<ObsSource> source;
  final Value<ObsStatus> status;
  final Value<String> patternKey;
  final Value<DateTime> createdAt;
  final Value<DateTime?> confirmedAt;
  final Value<int> rowid;
  const ObservationsCompanion({
    this.id = const Value.absent(),
    this.text_ = const Value.absent(),
    this.source = const Value.absent(),
    this.status = const Value.absent(),
    this.patternKey = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ObservationsCompanion.insert({
    this.id = const Value.absent(),
    required String text_,
    required ObsSource source,
    this.status = const Value.absent(),
    required String patternKey,
    this.createdAt = const Value.absent(),
    this.confirmedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : text_ = Value(text_),
       source = Value(source),
       patternKey = Value(patternKey);
  static Insertable<Observation> custom({
    Expression<String>? id,
    Expression<String>? text_,
    Expression<String>? source,
    Expression<String>? status,
    Expression<String>? patternKey,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? confirmedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (text_ != null) 'text': text_,
      if (source != null) 'source': source,
      if (status != null) 'status': status,
      if (patternKey != null) 'pattern_key': patternKey,
      if (createdAt != null) 'created_at': createdAt,
      if (confirmedAt != null) 'confirmed_at': confirmedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ObservationsCompanion copyWith({
    Value<String>? id,
    Value<String>? text_,
    Value<ObsSource>? source,
    Value<ObsStatus>? status,
    Value<String>? patternKey,
    Value<DateTime>? createdAt,
    Value<DateTime?>? confirmedAt,
    Value<int>? rowid,
  }) {
    return ObservationsCompanion(
      id: id ?? this.id,
      text_: text_ ?? this.text_,
      source: source ?? this.source,
      status: status ?? this.status,
      patternKey: patternKey ?? this.patternKey,
      createdAt: createdAt ?? this.createdAt,
      confirmedAt: confirmedAt ?? this.confirmedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (text_.present) {
      map['text'] = Variable<String>(text_.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(
        $ObservationsTable.$convertersource.toSql(source.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $ObservationsTable.$converterstatus.toSql(status.value),
      );
    }
    if (patternKey.present) {
      map['pattern_key'] = Variable<String>(patternKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (confirmedAt.present) {
      map['confirmed_at'] = Variable<DateTime>(confirmedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ObservationsCompanion(')
          ..write('id: $id, ')
          ..write('text_: $text_, ')
          ..write('source: $source, ')
          ..write('status: $status, ')
          ..write('patternKey: $patternKey, ')
          ..write('createdAt: $createdAt, ')
          ..write('confirmedAt: $confirmedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavedActionsTable extends SavedActions
    with TableInfo<$SavedActionsTable, SavedAction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavedActionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _actionIdMeta = const VerificationMeta(
    'actionId',
  );
  @override
  late final GeneratedColumn<String> actionId = GeneratedColumn<String>(
    'action_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "action" (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _savedAtMeta = const VerificationMeta(
    'savedAt',
  );
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
    'saved_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  @override
  List<GeneratedColumn> get $columns => [actionId, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'saved_action';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavedAction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('action_id')) {
      context.handle(
        _actionIdMeta,
        actionId.isAcceptableOrUnknown(data['action_id']!, _actionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actionIdMeta);
    }
    if (data.containsKey('saved_at')) {
      context.handle(
        _savedAtMeta,
        savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {actionId};
  @override
  SavedAction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavedAction(
      actionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_id'],
      )!,
      savedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}saved_at'],
      )!,
    );
  }

  @override
  $SavedActionsTable createAlias(String alias) {
    return $SavedActionsTable(attachedDatabase, alias);
  }
}

class SavedAction extends DataClass implements Insertable<SavedAction> {
  final String actionId;
  final DateTime savedAt;
  const SavedAction({required this.actionId, required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['action_id'] = Variable<String>(actionId);
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  SavedActionsCompanion toCompanion(bool nullToAbsent) {
    return SavedActionsCompanion(
      actionId: Value(actionId),
      savedAt: Value(savedAt),
    );
  }

  factory SavedAction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavedAction(
      actionId: serializer.fromJson<String>(json['actionId']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'actionId': serializer.toJson<String>(actionId),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  SavedAction copyWith({String? actionId, DateTime? savedAt}) => SavedAction(
    actionId: actionId ?? this.actionId,
    savedAt: savedAt ?? this.savedAt,
  );
  SavedAction copyWithCompanion(SavedActionsCompanion data) {
    return SavedAction(
      actionId: data.actionId.present ? data.actionId.value : this.actionId,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavedAction(')
          ..write('actionId: $actionId, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(actionId, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavedAction &&
          other.actionId == this.actionId &&
          other.savedAt == this.savedAt);
}

class SavedActionsCompanion extends UpdateCompanion<SavedAction> {
  final Value<String> actionId;
  final Value<DateTime> savedAt;
  final Value<int> rowid;
  const SavedActionsCompanion({
    this.actionId = const Value.absent(),
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavedActionsCompanion.insert({
    required String actionId,
    this.savedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : actionId = Value(actionId);
  static Insertable<SavedAction> custom({
    Expression<String>? actionId,
    Expression<DateTime>? savedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (actionId != null) 'action_id': actionId,
      if (savedAt != null) 'saved_at': savedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavedActionsCompanion copyWith({
    Value<String>? actionId,
    Value<DateTime>? savedAt,
    Value<int>? rowid,
  }) {
    return SavedActionsCompanion(
      actionId: actionId ?? this.actionId,
      savedAt: savedAt ?? this.savedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (actionId.present) {
      map['action_id'] = Variable<String>(actionId.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavedActionsCompanion(')
          ..write('actionId: $actionId, ')
          ..write('savedAt: $savedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReturnEventsTable extends ReturnEvents
    with TableInfo<$ReturnEventsTable, ReturnEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReturnEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => newId('ret'),
  );
  static const VerificationMeta _lapseStartDayMeta = const VerificationMeta(
    'lapseStartDay',
  );
  @override
  late final GeneratedColumn<String> lapseStartDay = GeneratedColumn<String>(
    'lapse_start_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnDayMeta = const VerificationMeta(
    'returnDay',
  );
  @override
  late final GeneratedColumn<String> returnDay = GeneratedColumn<String>(
    'return_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _whatChangedMeta = const VerificationMeta(
    'whatChanged',
  );
  @override
  late final GeneratedColumn<String> whatChanged = GeneratedColumn<String>(
    'what_changed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ReturnApproach?, String>
  approach = GeneratedColumn<String>(
    'approach',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<ReturnApproach?>($ReturnEventsTable.$converterapproachn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    lapseStartDay,
    returnDay,
    whatChanged,
    approach,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'return_event';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReturnEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lapse_start_day')) {
      context.handle(
        _lapseStartDayMeta,
        lapseStartDay.isAcceptableOrUnknown(
          data['lapse_start_day']!,
          _lapseStartDayMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lapseStartDayMeta);
    }
    if (data.containsKey('return_day')) {
      context.handle(
        _returnDayMeta,
        returnDay.isAcceptableOrUnknown(data['return_day']!, _returnDayMeta),
      );
    } else if (isInserting) {
      context.missing(_returnDayMeta);
    }
    if (data.containsKey('what_changed')) {
      context.handle(
        _whatChangedMeta,
        whatChanged.isAcceptableOrUnknown(
          data['what_changed']!,
          _whatChangedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReturnEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReturnEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lapseStartDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lapse_start_day'],
      )!,
      returnDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}return_day'],
      )!,
      whatChanged: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}what_changed'],
      ),
      approach: $ReturnEventsTable.$converterapproachn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}approach'],
        ),
      ),
    );
  }

  @override
  $ReturnEventsTable createAlias(String alias) {
    return $ReturnEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ReturnApproach, String, String> $converterapproach =
      const CodedEnumConverter<ReturnApproach>(ReturnApproach.values);
  static JsonTypeConverter2<ReturnApproach?, String?, String?>
  $converterapproachn = JsonTypeConverter2.asNullable($converterapproach);
}

class ReturnEvent extends DataClass implements Insertable<ReturnEvent> {
  final String id;
  final String lapseStartDay;
  final String returnDay;
  final String? whatChanged;
  final ReturnApproach? approach;
  const ReturnEvent({
    required this.id,
    required this.lapseStartDay,
    required this.returnDay,
    this.whatChanged,
    this.approach,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['lapse_start_day'] = Variable<String>(lapseStartDay);
    map['return_day'] = Variable<String>(returnDay);
    if (!nullToAbsent || whatChanged != null) {
      map['what_changed'] = Variable<String>(whatChanged);
    }
    if (!nullToAbsent || approach != null) {
      map['approach'] = Variable<String>(
        $ReturnEventsTable.$converterapproachn.toSql(approach),
      );
    }
    return map;
  }

  ReturnEventsCompanion toCompanion(bool nullToAbsent) {
    return ReturnEventsCompanion(
      id: Value(id),
      lapseStartDay: Value(lapseStartDay),
      returnDay: Value(returnDay),
      whatChanged: whatChanged == null && nullToAbsent
          ? const Value.absent()
          : Value(whatChanged),
      approach: approach == null && nullToAbsent
          ? const Value.absent()
          : Value(approach),
    );
  }

  factory ReturnEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReturnEvent(
      id: serializer.fromJson<String>(json['id']),
      lapseStartDay: serializer.fromJson<String>(json['lapseStartDay']),
      returnDay: serializer.fromJson<String>(json['returnDay']),
      whatChanged: serializer.fromJson<String?>(json['whatChanged']),
      approach: $ReturnEventsTable.$converterapproachn.fromJson(
        serializer.fromJson<String?>(json['approach']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lapseStartDay': serializer.toJson<String>(lapseStartDay),
      'returnDay': serializer.toJson<String>(returnDay),
      'whatChanged': serializer.toJson<String?>(whatChanged),
      'approach': serializer.toJson<String?>(
        $ReturnEventsTable.$converterapproachn.toJson(approach),
      ),
    };
  }

  ReturnEvent copyWith({
    String? id,
    String? lapseStartDay,
    String? returnDay,
    Value<String?> whatChanged = const Value.absent(),
    Value<ReturnApproach?> approach = const Value.absent(),
  }) => ReturnEvent(
    id: id ?? this.id,
    lapseStartDay: lapseStartDay ?? this.lapseStartDay,
    returnDay: returnDay ?? this.returnDay,
    whatChanged: whatChanged.present ? whatChanged.value : this.whatChanged,
    approach: approach.present ? approach.value : this.approach,
  );
  ReturnEvent copyWithCompanion(ReturnEventsCompanion data) {
    return ReturnEvent(
      id: data.id.present ? data.id.value : this.id,
      lapseStartDay: data.lapseStartDay.present
          ? data.lapseStartDay.value
          : this.lapseStartDay,
      returnDay: data.returnDay.present ? data.returnDay.value : this.returnDay,
      whatChanged: data.whatChanged.present
          ? data.whatChanged.value
          : this.whatChanged,
      approach: data.approach.present ? data.approach.value : this.approach,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReturnEvent(')
          ..write('id: $id, ')
          ..write('lapseStartDay: $lapseStartDay, ')
          ..write('returnDay: $returnDay, ')
          ..write('whatChanged: $whatChanged, ')
          ..write('approach: $approach')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, lapseStartDay, returnDay, whatChanged, approach);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReturnEvent &&
          other.id == this.id &&
          other.lapseStartDay == this.lapseStartDay &&
          other.returnDay == this.returnDay &&
          other.whatChanged == this.whatChanged &&
          other.approach == this.approach);
}

class ReturnEventsCompanion extends UpdateCompanion<ReturnEvent> {
  final Value<String> id;
  final Value<String> lapseStartDay;
  final Value<String> returnDay;
  final Value<String?> whatChanged;
  final Value<ReturnApproach?> approach;
  final Value<int> rowid;
  const ReturnEventsCompanion({
    this.id = const Value.absent(),
    this.lapseStartDay = const Value.absent(),
    this.returnDay = const Value.absent(),
    this.whatChanged = const Value.absent(),
    this.approach = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReturnEventsCompanion.insert({
    this.id = const Value.absent(),
    required String lapseStartDay,
    required String returnDay,
    this.whatChanged = const Value.absent(),
    this.approach = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : lapseStartDay = Value(lapseStartDay),
       returnDay = Value(returnDay);
  static Insertable<ReturnEvent> custom({
    Expression<String>? id,
    Expression<String>? lapseStartDay,
    Expression<String>? returnDay,
    Expression<String>? whatChanged,
    Expression<String>? approach,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lapseStartDay != null) 'lapse_start_day': lapseStartDay,
      if (returnDay != null) 'return_day': returnDay,
      if (whatChanged != null) 'what_changed': whatChanged,
      if (approach != null) 'approach': approach,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReturnEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? lapseStartDay,
    Value<String>? returnDay,
    Value<String?>? whatChanged,
    Value<ReturnApproach?>? approach,
    Value<int>? rowid,
  }) {
    return ReturnEventsCompanion(
      id: id ?? this.id,
      lapseStartDay: lapseStartDay ?? this.lapseStartDay,
      returnDay: returnDay ?? this.returnDay,
      whatChanged: whatChanged ?? this.whatChanged,
      approach: approach ?? this.approach,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lapseStartDay.present) {
      map['lapse_start_day'] = Variable<String>(lapseStartDay.value);
    }
    if (returnDay.present) {
      map['return_day'] = Variable<String>(returnDay.value);
    }
    if (whatChanged.present) {
      map['what_changed'] = Variable<String>(whatChanged.value);
    }
    if (approach.present) {
      map['approach'] = Variable<String>(
        $ReturnEventsTable.$converterapproachn.toSql(approach.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReturnEventsCompanion(')
          ..write('id: $id, ')
          ..write('lapseStartDay: $lapseStartDay, ')
          ..write('returnDay: $returnDay, ')
          ..write('whatChanged: $whatChanged, ')
          ..write('approach: $approach, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AchievementsEarnedTable extends AchievementsEarned
    with TableInfo<$AchievementsEarnedTable, AchievementEarned> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AchievementsEarnedTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _earnedDayMeta = const VerificationMeta(
    'earnedDay',
  );
  @override
  late final GeneratedColumn<String> earnedDay = GeneratedColumn<String>(
    'earned_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _celebratedMeta = const VerificationMeta(
    'celebrated',
  );
  @override
  late final GeneratedColumn<bool> celebrated = GeneratedColumn<bool>(
    'celebrated',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("celebrated" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [code, earnedDay, celebrated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'achievement_earned';
  @override
  VerificationContext validateIntegrity(
    Insertable<AchievementEarned> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('earned_day')) {
      context.handle(
        _earnedDayMeta,
        earnedDay.isAcceptableOrUnknown(data['earned_day']!, _earnedDayMeta),
      );
    } else if (isInserting) {
      context.missing(_earnedDayMeta);
    }
    if (data.containsKey('celebrated')) {
      context.handle(
        _celebratedMeta,
        celebrated.isAcceptableOrUnknown(data['celebrated']!, _celebratedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {code};
  @override
  AchievementEarned map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AchievementEarned(
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      earnedDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}earned_day'],
      )!,
      celebrated: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}celebrated'],
      )!,
    );
  }

  @override
  $AchievementsEarnedTable createAlias(String alias) {
    return $AchievementsEarnedTable(attachedDatabase, alias);
  }
}

class AchievementEarned extends DataClass
    implements Insertable<AchievementEarned> {
  final String code;
  final String earnedDay;
  final bool celebrated;
  const AchievementEarned({
    required this.code,
    required this.earnedDay,
    required this.celebrated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    map['earned_day'] = Variable<String>(earnedDay);
    map['celebrated'] = Variable<bool>(celebrated);
    return map;
  }

  AchievementsEarnedCompanion toCompanion(bool nullToAbsent) {
    return AchievementsEarnedCompanion(
      code: Value(code),
      earnedDay: Value(earnedDay),
      celebrated: Value(celebrated),
    );
  }

  factory AchievementEarned.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AchievementEarned(
      code: serializer.fromJson<String>(json['code']),
      earnedDay: serializer.fromJson<String>(json['earnedDay']),
      celebrated: serializer.fromJson<bool>(json['celebrated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'earnedDay': serializer.toJson<String>(earnedDay),
      'celebrated': serializer.toJson<bool>(celebrated),
    };
  }

  AchievementEarned copyWith({
    String? code,
    String? earnedDay,
    bool? celebrated,
  }) => AchievementEarned(
    code: code ?? this.code,
    earnedDay: earnedDay ?? this.earnedDay,
    celebrated: celebrated ?? this.celebrated,
  );
  AchievementEarned copyWithCompanion(AchievementsEarnedCompanion data) {
    return AchievementEarned(
      code: data.code.present ? data.code.value : this.code,
      earnedDay: data.earnedDay.present ? data.earnedDay.value : this.earnedDay,
      celebrated: data.celebrated.present
          ? data.celebrated.value
          : this.celebrated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AchievementEarned(')
          ..write('code: $code, ')
          ..write('earnedDay: $earnedDay, ')
          ..write('celebrated: $celebrated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(code, earnedDay, celebrated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AchievementEarned &&
          other.code == this.code &&
          other.earnedDay == this.earnedDay &&
          other.celebrated == this.celebrated);
}

class AchievementsEarnedCompanion extends UpdateCompanion<AchievementEarned> {
  final Value<String> code;
  final Value<String> earnedDay;
  final Value<bool> celebrated;
  final Value<int> rowid;
  const AchievementsEarnedCompanion({
    this.code = const Value.absent(),
    this.earnedDay = const Value.absent(),
    this.celebrated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AchievementsEarnedCompanion.insert({
    required String code,
    required String earnedDay,
    this.celebrated = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : code = Value(code),
       earnedDay = Value(earnedDay);
  static Insertable<AchievementEarned> custom({
    Expression<String>? code,
    Expression<String>? earnedDay,
    Expression<bool>? celebrated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (earnedDay != null) 'earned_day': earnedDay,
      if (celebrated != null) 'celebrated': celebrated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AchievementsEarnedCompanion copyWith({
    Value<String>? code,
    Value<String>? earnedDay,
    Value<bool>? celebrated,
    Value<int>? rowid,
  }) {
    return AchievementsEarnedCompanion(
      code: code ?? this.code,
      earnedDay: earnedDay ?? this.earnedDay,
      celebrated: celebrated ?? this.celebrated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (earnedDay.present) {
      map['earned_day'] = Variable<String>(earnedDay.value);
    }
    if (celebrated.present) {
      map['celebrated'] = Variable<bool>(celebrated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AchievementsEarnedCompanion(')
          ..write('code: $code, ')
          ..write('earnedDay: $earnedDay, ')
          ..write('celebrated: $celebrated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationSettingsTable extends NotificationSettings
    with TableInfo<$NotificationSettingsTable, NotificationSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    check: () => id.equals('me'),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('me'),
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('before_free_time'),
  );
  static const VerificationMeta _fixedTimeMeta = const VerificationMeta(
    'fixedTime',
  );
  @override
  late final GeneratedColumn<String> fixedTime = GeneratedColumn<String>(
    'fixed_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _leadMinMeta = const VerificationMeta(
    'leadMin',
  );
  @override
  late final GeneratedColumn<int> leadMin = GeneratedColumn<int>(
    'lead_min',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _quietStartMeta = const VerificationMeta(
    'quietStart',
  );
  @override
  late final GeneratedColumn<String> quietStart = GeneratedColumn<String>(
    'quiet_start',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('21:00'),
  );
  static const VerificationMeta _quietEndMeta = const VerificationMeta(
    'quietEnd',
  );
  @override
  late final GeneratedColumn<String> quietEnd = GeneratedColumn<String>(
    'quiet_end',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('07:00'),
  );
  static const VerificationMeta _lapseCheckinEnabledMeta =
      const VerificationMeta('lapseCheckinEnabled');
  @override
  late final GeneratedColumn<bool> lapseCheckinEnabled = GeneratedColumn<bool>(
    'lapse_checkin_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("lapse_checkin_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    enabled,
    mode,
    fixedTime,
    leadMin,
    quietStart,
    quietEnd,
    lapseCheckinEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_setting';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    }
    if (data.containsKey('fixed_time')) {
      context.handle(
        _fixedTimeMeta,
        fixedTime.isAcceptableOrUnknown(data['fixed_time']!, _fixedTimeMeta),
      );
    }
    if (data.containsKey('lead_min')) {
      context.handle(
        _leadMinMeta,
        leadMin.isAcceptableOrUnknown(data['lead_min']!, _leadMinMeta),
      );
    }
    if (data.containsKey('quiet_start')) {
      context.handle(
        _quietStartMeta,
        quietStart.isAcceptableOrUnknown(data['quiet_start']!, _quietStartMeta),
      );
    }
    if (data.containsKey('quiet_end')) {
      context.handle(
        _quietEndMeta,
        quietEnd.isAcceptableOrUnknown(data['quiet_end']!, _quietEndMeta),
      );
    }
    if (data.containsKey('lapse_checkin_enabled')) {
      context.handle(
        _lapseCheckinEnabledMeta,
        lapseCheckinEnabled.isAcceptableOrUnknown(
          data['lapse_checkin_enabled']!,
          _lapseCheckinEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      fixedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fixed_time'],
      ),
      leadMin: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lead_min'],
      )!,
      quietStart: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiet_start'],
      )!,
      quietEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quiet_end'],
      )!,
      lapseCheckinEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}lapse_checkin_enabled'],
      )!,
    );
  }

  @override
  $NotificationSettingsTable createAlias(String alias) {
    return $NotificationSettingsTable(attachedDatabase, alias);
  }
}

class NotificationSetting extends DataClass
    implements Insertable<NotificationSetting> {
  final String id;
  final bool enabled;
  final String mode;
  final String? fixedTime;
  final int leadMin;
  final String quietStart;
  final String quietEnd;
  final bool lapseCheckinEnabled;
  const NotificationSetting({
    required this.id,
    required this.enabled,
    required this.mode,
    this.fixedTime,
    required this.leadMin,
    required this.quietStart,
    required this.quietEnd,
    required this.lapseCheckinEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['enabled'] = Variable<bool>(enabled);
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || fixedTime != null) {
      map['fixed_time'] = Variable<String>(fixedTime);
    }
    map['lead_min'] = Variable<int>(leadMin);
    map['quiet_start'] = Variable<String>(quietStart);
    map['quiet_end'] = Variable<String>(quietEnd);
    map['lapse_checkin_enabled'] = Variable<bool>(lapseCheckinEnabled);
    return map;
  }

  NotificationSettingsCompanion toCompanion(bool nullToAbsent) {
    return NotificationSettingsCompanion(
      id: Value(id),
      enabled: Value(enabled),
      mode: Value(mode),
      fixedTime: fixedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(fixedTime),
      leadMin: Value(leadMin),
      quietStart: Value(quietStart),
      quietEnd: Value(quietEnd),
      lapseCheckinEnabled: Value(lapseCheckinEnabled),
    );
  }

  factory NotificationSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationSetting(
      id: serializer.fromJson<String>(json['id']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      mode: serializer.fromJson<String>(json['mode']),
      fixedTime: serializer.fromJson<String?>(json['fixedTime']),
      leadMin: serializer.fromJson<int>(json['leadMin']),
      quietStart: serializer.fromJson<String>(json['quietStart']),
      quietEnd: serializer.fromJson<String>(json['quietEnd']),
      lapseCheckinEnabled: serializer.fromJson<bool>(
        json['lapseCheckinEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'enabled': serializer.toJson<bool>(enabled),
      'mode': serializer.toJson<String>(mode),
      'fixedTime': serializer.toJson<String?>(fixedTime),
      'leadMin': serializer.toJson<int>(leadMin),
      'quietStart': serializer.toJson<String>(quietStart),
      'quietEnd': serializer.toJson<String>(quietEnd),
      'lapseCheckinEnabled': serializer.toJson<bool>(lapseCheckinEnabled),
    };
  }

  NotificationSetting copyWith({
    String? id,
    bool? enabled,
    String? mode,
    Value<String?> fixedTime = const Value.absent(),
    int? leadMin,
    String? quietStart,
    String? quietEnd,
    bool? lapseCheckinEnabled,
  }) => NotificationSetting(
    id: id ?? this.id,
    enabled: enabled ?? this.enabled,
    mode: mode ?? this.mode,
    fixedTime: fixedTime.present ? fixedTime.value : this.fixedTime,
    leadMin: leadMin ?? this.leadMin,
    quietStart: quietStart ?? this.quietStart,
    quietEnd: quietEnd ?? this.quietEnd,
    lapseCheckinEnabled: lapseCheckinEnabled ?? this.lapseCheckinEnabled,
  );
  NotificationSetting copyWithCompanion(NotificationSettingsCompanion data) {
    return NotificationSetting(
      id: data.id.present ? data.id.value : this.id,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      mode: data.mode.present ? data.mode.value : this.mode,
      fixedTime: data.fixedTime.present ? data.fixedTime.value : this.fixedTime,
      leadMin: data.leadMin.present ? data.leadMin.value : this.leadMin,
      quietStart: data.quietStart.present
          ? data.quietStart.value
          : this.quietStart,
      quietEnd: data.quietEnd.present ? data.quietEnd.value : this.quietEnd,
      lapseCheckinEnabled: data.lapseCheckinEnabled.present
          ? data.lapseCheckinEnabled.value
          : this.lapseCheckinEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSetting(')
          ..write('id: $id, ')
          ..write('enabled: $enabled, ')
          ..write('mode: $mode, ')
          ..write('fixedTime: $fixedTime, ')
          ..write('leadMin: $leadMin, ')
          ..write('quietStart: $quietStart, ')
          ..write('quietEnd: $quietEnd, ')
          ..write('lapseCheckinEnabled: $lapseCheckinEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    enabled,
    mode,
    fixedTime,
    leadMin,
    quietStart,
    quietEnd,
    lapseCheckinEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationSetting &&
          other.id == this.id &&
          other.enabled == this.enabled &&
          other.mode == this.mode &&
          other.fixedTime == this.fixedTime &&
          other.leadMin == this.leadMin &&
          other.quietStart == this.quietStart &&
          other.quietEnd == this.quietEnd &&
          other.lapseCheckinEnabled == this.lapseCheckinEnabled);
}

class NotificationSettingsCompanion
    extends UpdateCompanion<NotificationSetting> {
  final Value<String> id;
  final Value<bool> enabled;
  final Value<String> mode;
  final Value<String?> fixedTime;
  final Value<int> leadMin;
  final Value<String> quietStart;
  final Value<String> quietEnd;
  final Value<bool> lapseCheckinEnabled;
  final Value<int> rowid;
  const NotificationSettingsCompanion({
    this.id = const Value.absent(),
    this.enabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.fixedTime = const Value.absent(),
    this.leadMin = const Value.absent(),
    this.quietStart = const Value.absent(),
    this.quietEnd = const Value.absent(),
    this.lapseCheckinEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.enabled = const Value.absent(),
    this.mode = const Value.absent(),
    this.fixedTime = const Value.absent(),
    this.leadMin = const Value.absent(),
    this.quietStart = const Value.absent(),
    this.quietEnd = const Value.absent(),
    this.lapseCheckinEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<NotificationSetting> custom({
    Expression<String>? id,
    Expression<bool>? enabled,
    Expression<String>? mode,
    Expression<String>? fixedTime,
    Expression<int>? leadMin,
    Expression<String>? quietStart,
    Expression<String>? quietEnd,
    Expression<bool>? lapseCheckinEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (enabled != null) 'enabled': enabled,
      if (mode != null) 'mode': mode,
      if (fixedTime != null) 'fixed_time': fixedTime,
      if (leadMin != null) 'lead_min': leadMin,
      if (quietStart != null) 'quiet_start': quietStart,
      if (quietEnd != null) 'quiet_end': quietEnd,
      if (lapseCheckinEnabled != null)
        'lapse_checkin_enabled': lapseCheckinEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationSettingsCompanion copyWith({
    Value<String>? id,
    Value<bool>? enabled,
    Value<String>? mode,
    Value<String?>? fixedTime,
    Value<int>? leadMin,
    Value<String>? quietStart,
    Value<String>? quietEnd,
    Value<bool>? lapseCheckinEnabled,
    Value<int>? rowid,
  }) {
    return NotificationSettingsCompanion(
      id: id ?? this.id,
      enabled: enabled ?? this.enabled,
      mode: mode ?? this.mode,
      fixedTime: fixedTime ?? this.fixedTime,
      leadMin: leadMin ?? this.leadMin,
      quietStart: quietStart ?? this.quietStart,
      quietEnd: quietEnd ?? this.quietEnd,
      lapseCheckinEnabled: lapseCheckinEnabled ?? this.lapseCheckinEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (fixedTime.present) {
      map['fixed_time'] = Variable<String>(fixedTime.value);
    }
    if (leadMin.present) {
      map['lead_min'] = Variable<int>(leadMin.value);
    }
    if (quietStart.present) {
      map['quiet_start'] = Variable<String>(quietStart.value);
    }
    if (quietEnd.present) {
      map['quiet_end'] = Variable<String>(quietEnd.value);
    }
    if (lapseCheckinEnabled.present) {
      map['lapse_checkin_enabled'] = Variable<bool>(lapseCheckinEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationSettingsCompanion(')
          ..write('id: $id, ')
          ..write('enabled: $enabled, ')
          ..write('mode: $mode, ')
          ..write('fixedTime: $fixedTime, ')
          ..write('leadMin: $leadMin, ')
          ..write('quietStart: $quietStart, ')
          ..write('quietEnd: $quietEnd, ')
          ..write('lapseCheckinEnabled: $lapseCheckinEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LiltDatabase extends GeneratedDatabase {
  _$LiltDatabase(QueryExecutor e) : super(e);
  $LiltDatabaseManager get managers => $LiltDatabaseManager(this);
  late final $ConsentRecordsTable consentRecords = $ConsentRecordsTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $FollowedActivitiesTable followedActivities =
      $FollowedActivitiesTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  late final $ActionsTable actions = $ActionsTable(this);
  late final $OptionOffersTable optionOffers = $OptionOffersTable(this);
  late final $OfferReasonsTable offerReasons = $OfferReasonsTable(this);
  late final $PlanItemsTable planItems = $PlanItemsTable(this);
  late final $ReflectionsTable reflections = $ReflectionsTable(this);
  late final $PausesTable pauses = $PausesTable(this);
  late final $ObservationsTable observations = $ObservationsTable(this);
  late final $SavedActionsTable savedActions = $SavedActionsTable(this);
  late final $ReturnEventsTable returnEvents = $ReturnEventsTable(this);
  late final $AchievementsEarnedTable achievementsEarned =
      $AchievementsEarnedTable(this);
  late final $NotificationSettingsTable notificationSettings =
      $NotificationSettingsTable(this);
  late final Index followedActivityUnfollowed = Index(
    'followed_activity_unfollowed',
    'CREATE INDEX followed_activity_unfollowed ON followed_activity (unfollowed_at)',
  );
  late final Index optionOfferDay = Index(
    'option_offer_day',
    'CREATE INDEX option_offer_day ON option_offer (day)',
  );
  late final Index optionOfferNewSwap = Index(
    'option_offer_new_swap',
    'CREATE UNIQUE INDEX option_offer_new_swap ON option_offer (day, swap_index) WHERE followed_activity_id IS NULL',
  );
  late final Index planItemDay = Index(
    'plan_item_day',
    'CREATE INDEX plan_item_day ON plan_item (planned_day)',
  );
  late final Index planItemOffer = Index(
    'plan_item_offer',
    'CREATE UNIQUE INDEX plan_item_offer ON plan_item (offer_id)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    consentRecords,
    profiles,
    followedActivities,
    preferences,
    actions,
    optionOffers,
    offerReasons,
    planItems,
    reflections,
    pauses,
    observations,
    savedActions,
    returnEvents,
    achievementsEarned,
    notificationSettings,
    followedActivityUnfollowed,
    optionOfferDay,
    optionOfferNewSwap,
    planItemDay,
    planItemOffer,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'followed_activity',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('option_offer', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'option_offer',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('offer_reason', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'option_offer',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('plan_item', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'plan_item',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reflection', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'action',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('saved_action', kind: UpdateKind.delete)],
    ),
  ]);
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
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
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<int> dailyGoal,
      Value<DateTime?> setupDoneAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> id,
      Value<int> dailyGoal,
      Value<DateTime?> setupDoneAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$LiltDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get setupDoneAt => $composableBuilder(
    column: $table.setupDoneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$LiltDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<int> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get setupDoneAt => $composableBuilder(
    column: $table.setupDoneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$LiltDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);

  GeneratedColumn<DateTime> get setupDoneAt => $composableBuilder(
    column: $table.setupDoneAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$LiltDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$LiltDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<DateTime?> setupDoneAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                dailyGoal: dailyGoal,
                setupDoneAt: setupDoneAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> dailyGoal = const Value.absent(),
                Value<DateTime?> setupDoneAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                dailyGoal: dailyGoal,
                setupDoneAt: setupDoneAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$LiltDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$FollowedActivitiesTableCreateCompanionBuilder =
    FollowedActivitiesCompanion Function({
      Value<String> id,
      required ActivityKind activity,
      Value<String?> customName,
      required SetupPath path,
      Value<Progress?> progress,
      Value<String?> hardBecause,
      Value<StoppedAgo?> stoppedAgo,
      Value<String?> gotInTheWay,
      Value<String?> wouldHelp,
      Value<Familiarity?> familiarity,
      Value<DateTime> followedAt,
      Value<DateTime?> unfollowedAt,
      Value<int> rowid,
    });
typedef $$FollowedActivitiesTableUpdateCompanionBuilder =
    FollowedActivitiesCompanion Function({
      Value<String> id,
      Value<ActivityKind> activity,
      Value<String?> customName,
      Value<SetupPath> path,
      Value<Progress?> progress,
      Value<String?> hardBecause,
      Value<StoppedAgo?> stoppedAgo,
      Value<String?> gotInTheWay,
      Value<String?> wouldHelp,
      Value<Familiarity?> familiarity,
      Value<DateTime> followedAt,
      Value<DateTime?> unfollowedAt,
      Value<int> rowid,
    });

final class $$FollowedActivitiesTableReferences
    extends
        BaseReferences<
          _$LiltDatabase,
          $FollowedActivitiesTable,
          FollowedActivity
        > {
  $$FollowedActivitiesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$OptionOffersTable, List<OptionOffer>>
  _optionOffersRefsTable(_$LiltDatabase db) => MultiTypedResultKey.fromTable(
    db.optionOffers,
    aliasName: 'followed_activity__id__option_offer__followed_activity_id',
  );

  $$OptionOffersTableProcessedTableManager get optionOffersRefs {
    final manager = $$OptionOffersTableTableManager($_db, $_db.optionOffers)
        .filter(
          (f) => f.followedActivityId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_optionOffersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FollowedActivitiesTableFilterComposer
    extends Composer<_$LiltDatabase, $FollowedActivitiesTable> {
  $$FollowedActivitiesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<ActivityKind, ActivityKind, String>
  get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<SetupPath, SetupPath, String> get path =>
      $composableBuilder(
        column: $table.path,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Progress?, Progress, String> get progress =>
      $composableBuilder(
        column: $table.progress,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get hardBecause => $composableBuilder(
    column: $table.hardBecause,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<StoppedAgo?, StoppedAgo, String>
  get stoppedAgo => $composableBuilder(
    column: $table.stoppedAgo,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get gotInTheWay => $composableBuilder(
    column: $table.gotInTheWay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wouldHelp => $composableBuilder(
    column: $table.wouldHelp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Familiarity?, Familiarity, String>
  get familiarity => $composableBuilder(
    column: $table.familiarity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get followedAt => $composableBuilder(
    column: $table.followedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get unfollowedAt => $composableBuilder(
    column: $table.unfollowedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> optionOffersRefs(
    Expression<bool> Function($$OptionOffersTableFilterComposer f) f,
  ) {
    final $$OptionOffersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.followedActivityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableFilterComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FollowedActivitiesTableOrderingComposer
    extends Composer<_$LiltDatabase, $FollowedActivitiesTable> {
  $$FollowedActivitiesTableOrderingComposer({
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

  ColumnOrderings<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hardBecause => $composableBuilder(
    column: $table.hardBecause,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stoppedAgo => $composableBuilder(
    column: $table.stoppedAgo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gotInTheWay => $composableBuilder(
    column: $table.gotInTheWay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wouldHelp => $composableBuilder(
    column: $table.wouldHelp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get familiarity => $composableBuilder(
    column: $table.familiarity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get followedAt => $composableBuilder(
    column: $table.followedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get unfollowedAt => $composableBuilder(
    column: $table.unfollowedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FollowedActivitiesTableAnnotationComposer
    extends Composer<_$LiltDatabase, $FollowedActivitiesTable> {
  $$FollowedActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityKind, String> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<SetupPath, String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Progress?, String> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<String> get hardBecause => $composableBuilder(
    column: $table.hardBecause,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<StoppedAgo?, String> get stoppedAgo =>
      $composableBuilder(
        column: $table.stoppedAgo,
        builder: (column) => column,
      );

  GeneratedColumn<String> get gotInTheWay => $composableBuilder(
    column: $table.gotInTheWay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get wouldHelp =>
      $composableBuilder(column: $table.wouldHelp, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Familiarity?, String> get familiarity =>
      $composableBuilder(
        column: $table.familiarity,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get followedAt => $composableBuilder(
    column: $table.followedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get unfollowedAt => $composableBuilder(
    column: $table.unfollowedAt,
    builder: (column) => column,
  );

  Expression<T> optionOffersRefs<T extends Object>(
    Expression<T> Function($$OptionOffersTableAnnotationComposer a) f,
  ) {
    final $$OptionOffersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.followedActivityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableAnnotationComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FollowedActivitiesTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $FollowedActivitiesTable,
          FollowedActivity,
          $$FollowedActivitiesTableFilterComposer,
          $$FollowedActivitiesTableOrderingComposer,
          $$FollowedActivitiesTableAnnotationComposer,
          $$FollowedActivitiesTableCreateCompanionBuilder,
          $$FollowedActivitiesTableUpdateCompanionBuilder,
          (FollowedActivity, $$FollowedActivitiesTableReferences),
          FollowedActivity,
          PrefetchHooks Function({bool optionOffersRefs})
        > {
  $$FollowedActivitiesTableTableManager(
    _$LiltDatabase db,
    $FollowedActivitiesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FollowedActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FollowedActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FollowedActivitiesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<ActivityKind> activity = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                Value<SetupPath> path = const Value.absent(),
                Value<Progress?> progress = const Value.absent(),
                Value<String?> hardBecause = const Value.absent(),
                Value<StoppedAgo?> stoppedAgo = const Value.absent(),
                Value<String?> gotInTheWay = const Value.absent(),
                Value<String?> wouldHelp = const Value.absent(),
                Value<Familiarity?> familiarity = const Value.absent(),
                Value<DateTime> followedAt = const Value.absent(),
                Value<DateTime?> unfollowedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FollowedActivitiesCompanion(
                id: id,
                activity: activity,
                customName: customName,
                path: path,
                progress: progress,
                hardBecause: hardBecause,
                stoppedAgo: stoppedAgo,
                gotInTheWay: gotInTheWay,
                wouldHelp: wouldHelp,
                familiarity: familiarity,
                followedAt: followedAt,
                unfollowedAt: unfollowedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required ActivityKind activity,
                Value<String?> customName = const Value.absent(),
                required SetupPath path,
                Value<Progress?> progress = const Value.absent(),
                Value<String?> hardBecause = const Value.absent(),
                Value<StoppedAgo?> stoppedAgo = const Value.absent(),
                Value<String?> gotInTheWay = const Value.absent(),
                Value<String?> wouldHelp = const Value.absent(),
                Value<Familiarity?> familiarity = const Value.absent(),
                Value<DateTime> followedAt = const Value.absent(),
                Value<DateTime?> unfollowedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FollowedActivitiesCompanion.insert(
                id: id,
                activity: activity,
                customName: customName,
                path: path,
                progress: progress,
                hardBecause: hardBecause,
                stoppedAgo: stoppedAgo,
                gotInTheWay: gotInTheWay,
                wouldHelp: wouldHelp,
                familiarity: familiarity,
                followedAt: followedAt,
                unfollowedAt: unfollowedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FollowedActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({optionOffersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (optionOffersRefs) db.optionOffers],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (optionOffersRefs)
                    await $_getPrefetchedData<
                      FollowedActivity,
                      $FollowedActivitiesTable,
                      OptionOffer
                    >(
                      currentTable: table,
                      referencedTable: $$FollowedActivitiesTableReferences
                          ._optionOffersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FollowedActivitiesTableReferences(
                            db,
                            table,
                            p0,
                          ).optionOffersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.followedActivityId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FollowedActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $FollowedActivitiesTable,
      FollowedActivity,
      $$FollowedActivitiesTableFilterComposer,
      $$FollowedActivitiesTableOrderingComposer,
      $$FollowedActivitiesTableAnnotationComposer,
      $$FollowedActivitiesTableCreateCompanionBuilder,
      $$FollowedActivitiesTableUpdateCompanionBuilder,
      (FollowedActivity, $$FollowedActivitiesTableReferences),
      FollowedActivity,
      PrefetchHooks Function({bool optionOffersRefs})
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      Value<String> id,
      required PrefKind kind,
      required String value,
      Value<int> rowid,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<String> id,
      Value<PrefKind> kind,
      Value<String> value,
      Value<int> rowid,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$LiltDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<PrefKind, PrefKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$LiltDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$LiltDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PrefKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$LiltDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$LiltDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<PrefKind> kind = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion(
                id: id,
                kind: kind,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required PrefKind kind,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => PreferencesCompanion.insert(
                id: id,
                kind: kind,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$LiltDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
      PrefetchHooks Function()
    >;
typedef $$ActionsTableCreateCompanionBuilder =
    ActionsCompanion Function({
      required String id,
      required ActivityKind activity,
      required String title,
      required String description,
      required int durationMin,
      required Intensity intensity,
      required Energy energyNeeded,
      Value<String> tags,
      Value<bool> isStarter,
      Value<String> similarTo,
      required String libraryVersion,
      Value<int> rowid,
    });
typedef $$ActionsTableUpdateCompanionBuilder =
    ActionsCompanion Function({
      Value<String> id,
      Value<ActivityKind> activity,
      Value<String> title,
      Value<String> description,
      Value<int> durationMin,
      Value<Intensity> intensity,
      Value<Energy> energyNeeded,
      Value<String> tags,
      Value<bool> isStarter,
      Value<String> similarTo,
      Value<String> libraryVersion,
      Value<int> rowid,
    });

final class $$ActionsTableReferences
    extends BaseReferences<_$LiltDatabase, $ActionsTable, LibraryAction> {
  $$ActionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OptionOffersTable, List<OptionOffer>>
  _optionOffersRefsTable(_$LiltDatabase db) => MultiTypedResultKey.fromTable(
    db.optionOffers,
    aliasName: 'action__id__option_offer__action_id',
  );

  $$OptionOffersTableProcessedTableManager get optionOffersRefs {
    final manager = $$OptionOffersTableTableManager(
      $_db,
      $_db.optionOffers,
    ).filter((f) => f.actionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_optionOffersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlanItemsTable, List<PlanItem>>
  _planItemsRefsTable(_$LiltDatabase db) => MultiTypedResultKey.fromTable(
    db.planItems,
    aliasName: 'action__id__plan_item__action_id',
  );

  $$PlanItemsTableProcessedTableManager get planItemsRefs {
    final manager = $$PlanItemsTableTableManager(
      $_db,
      $_db.planItems,
    ).filter((f) => f.actionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SavedActionsTable, List<SavedAction>>
  _savedActionsRefsTable(_$LiltDatabase db) => MultiTypedResultKey.fromTable(
    db.savedActions,
    aliasName: 'action__id__saved_action__action_id',
  );

  $$SavedActionsTableProcessedTableManager get savedActionsRefs {
    final manager = $$SavedActionsTableTableManager(
      $_db,
      $_db.savedActions,
    ).filter((f) => f.actionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_savedActionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActionsTableFilterComposer
    extends Composer<_$LiltDatabase, $ActionsTable> {
  $$ActionsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<ActivityKind, ActivityKind, String>
  get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Intensity, Intensity, String> get intensity =>
      $composableBuilder(
        column: $table.intensity,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Energy, Energy, String> get energyNeeded =>
      $composableBuilder(
        column: $table.energyNeeded,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStarter => $composableBuilder(
    column: $table.isStarter,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get similarTo => $composableBuilder(
    column: $table.similarTo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libraryVersion => $composableBuilder(
    column: $table.libraryVersion,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> optionOffersRefs(
    Expression<bool> Function($$OptionOffersTableFilterComposer f) f,
  ) {
    final $$OptionOffersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.actionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableFilterComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> planItemsRefs(
    Expression<bool> Function($$PlanItemsTableFilterComposer f) f,
  ) {
    final $$PlanItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.actionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableFilterComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> savedActionsRefs(
    Expression<bool> Function($$SavedActionsTableFilterComposer f) f,
  ) {
    final $$SavedActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedActions,
      getReferencedColumn: (t) => t.actionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedActionsTableFilterComposer(
            $db: $db,
            $table: $db.savedActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActionsTableOrderingComposer
    extends Composer<_$LiltDatabase, $ActionsTable> {
  $$ActionsTableOrderingComposer({
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

  ColumnOrderings<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get energyNeeded => $composableBuilder(
    column: $table.energyNeeded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStarter => $composableBuilder(
    column: $table.isStarter,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get similarTo => $composableBuilder(
    column: $table.similarTo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libraryVersion => $composableBuilder(
    column: $table.libraryVersion,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActionsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $ActionsTable> {
  $$ActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityKind, String> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Intensity, String> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Energy, String> get energyNeeded =>
      $composableBuilder(
        column: $table.energyNeeded,
        builder: (column) => column,
      );

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get isStarter =>
      $composableBuilder(column: $table.isStarter, builder: (column) => column);

  GeneratedColumn<String> get similarTo =>
      $composableBuilder(column: $table.similarTo, builder: (column) => column);

  GeneratedColumn<String> get libraryVersion => $composableBuilder(
    column: $table.libraryVersion,
    builder: (column) => column,
  );

  Expression<T> optionOffersRefs<T extends Object>(
    Expression<T> Function($$OptionOffersTableAnnotationComposer a) f,
  ) {
    final $$OptionOffersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.actionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableAnnotationComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> planItemsRefs<T extends Object>(
    Expression<T> Function($$PlanItemsTableAnnotationComposer a) f,
  ) {
    final $$PlanItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.actionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> savedActionsRefs<T extends Object>(
    Expression<T> Function($$SavedActionsTableAnnotationComposer a) f,
  ) {
    final $$SavedActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savedActions,
      getReferencedColumn: (t) => t.actionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavedActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.savedActions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActionsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $ActionsTable,
          LibraryAction,
          $$ActionsTableFilterComposer,
          $$ActionsTableOrderingComposer,
          $$ActionsTableAnnotationComposer,
          $$ActionsTableCreateCompanionBuilder,
          $$ActionsTableUpdateCompanionBuilder,
          (LibraryAction, $$ActionsTableReferences),
          LibraryAction,
          PrefetchHooks Function({
            bool optionOffersRefs,
            bool planItemsRefs,
            bool savedActionsRefs,
          })
        > {
  $$ActionsTableTableManager(_$LiltDatabase db, $ActionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<ActivityKind> activity = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> durationMin = const Value.absent(),
                Value<Intensity> intensity = const Value.absent(),
                Value<Energy> energyNeeded = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<bool> isStarter = const Value.absent(),
                Value<String> similarTo = const Value.absent(),
                Value<String> libraryVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActionsCompanion(
                id: id,
                activity: activity,
                title: title,
                description: description,
                durationMin: durationMin,
                intensity: intensity,
                energyNeeded: energyNeeded,
                tags: tags,
                isStarter: isStarter,
                similarTo: similarTo,
                libraryVersion: libraryVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required ActivityKind activity,
                required String title,
                required String description,
                required int durationMin,
                required Intensity intensity,
                required Energy energyNeeded,
                Value<String> tags = const Value.absent(),
                Value<bool> isStarter = const Value.absent(),
                Value<String> similarTo = const Value.absent(),
                required String libraryVersion,
                Value<int> rowid = const Value.absent(),
              }) => ActionsCompanion.insert(
                id: id,
                activity: activity,
                title: title,
                description: description,
                durationMin: durationMin,
                intensity: intensity,
                energyNeeded: energyNeeded,
                tags: tags,
                isStarter: isStarter,
                similarTo: similarTo,
                libraryVersion: libraryVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                optionOffersRefs = false,
                planItemsRefs = false,
                savedActionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (optionOffersRefs) db.optionOffers,
                    if (planItemsRefs) db.planItems,
                    if (savedActionsRefs) db.savedActions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (optionOffersRefs)
                        await $_getPrefetchedData<
                          LibraryAction,
                          $ActionsTable,
                          OptionOffer
                        >(
                          currentTable: table,
                          referencedTable: $$ActionsTableReferences
                              ._optionOffersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActionsTableReferences(
                                db,
                                table,
                                p0,
                              ).optionOffersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (planItemsRefs)
                        await $_getPrefetchedData<
                          LibraryAction,
                          $ActionsTable,
                          PlanItem
                        >(
                          currentTable: table,
                          referencedTable: $$ActionsTableReferences
                              ._planItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActionsTableReferences(
                                db,
                                table,
                                p0,
                              ).planItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actionId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (savedActionsRefs)
                        await $_getPrefetchedData<
                          LibraryAction,
                          $ActionsTable,
                          SavedAction
                        >(
                          currentTable: table,
                          referencedTable: $$ActionsTableReferences
                              ._savedActionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActionsTableReferences(
                                db,
                                table,
                                p0,
                              ).savedActionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.actionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $ActionsTable,
      LibraryAction,
      $$ActionsTableFilterComposer,
      $$ActionsTableOrderingComposer,
      $$ActionsTableAnnotationComposer,
      $$ActionsTableCreateCompanionBuilder,
      $$ActionsTableUpdateCompanionBuilder,
      (LibraryAction, $$ActionsTableReferences),
      LibraryAction,
      PrefetchHooks Function({
        bool optionOffersRefs,
        bool planItemsRefs,
        bool savedActionsRefs,
      })
    >;
typedef $$OptionOffersTableCreateCompanionBuilder =
    OptionOffersCompanion Function({
      Value<String> id,
      required String day,
      required String actionId,
      Value<String?> followedActivityId,
      required String suggestedDay,
      Value<String?> suggestedTime,
      Value<int> swapIndex,
      Value<OfferStatus> status,
      Value<int?> editedDurationMin,
      Value<String?> editedDay,
      Value<String?> editedTime,
      Value<int?> timeInputMin,
      Value<Energy?> energyInput,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$OptionOffersTableUpdateCompanionBuilder =
    OptionOffersCompanion Function({
      Value<String> id,
      Value<String> day,
      Value<String> actionId,
      Value<String?> followedActivityId,
      Value<String> suggestedDay,
      Value<String?> suggestedTime,
      Value<int> swapIndex,
      Value<OfferStatus> status,
      Value<int?> editedDurationMin,
      Value<String?> editedDay,
      Value<String?> editedTime,
      Value<int?> timeInputMin,
      Value<Energy?> energyInput,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$OptionOffersTableReferences
    extends BaseReferences<_$LiltDatabase, $OptionOffersTable, OptionOffer> {
  $$OptionOffersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActionsTable _actionIdTable(_$LiltDatabase db) =>
      db.actions.createAlias('option_offer__action_id__action__id');

  $$ActionsTableProcessedTableManager get actionId {
    final $_column = $_itemColumn<String>('action_id')!;

    final manager = $$ActionsTableTableManager(
      $_db,
      $_db.actions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FollowedActivitiesTable _followedActivityIdTable(_$LiltDatabase db) =>
      db.followedActivities.createAlias(
        'option_offer__followed_activity_id__followed_activity__id',
      );

  $$FollowedActivitiesTableProcessedTableManager? get followedActivityId {
    final $_column = $_itemColumn<String>('followed_activity_id');
    if ($_column == null) return null;
    final manager = $$FollowedActivitiesTableTableManager(
      $_db,
      $_db.followedActivities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_followedActivityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OfferReasonsTable, List<OfferReason>>
  _offerReasonsRefsTable(_$LiltDatabase db) => MultiTypedResultKey.fromTable(
    db.offerReasons,
    aliasName: 'option_offer__id__offer_reason__offer_id',
  );

  $$OfferReasonsTableProcessedTableManager get offerReasonsRefs {
    final manager = $$OfferReasonsTableTableManager(
      $_db,
      $_db.offerReasons,
    ).filter((f) => f.offerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_offerReasonsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlanItemsTable, List<PlanItem>>
  _planItemsRefsTable(_$LiltDatabase db) => MultiTypedResultKey.fromTable(
    db.planItems,
    aliasName: 'option_offer__id__plan_item__offer_id',
  );

  $$PlanItemsTableProcessedTableManager get planItemsRefs {
    final manager = $$PlanItemsTableTableManager(
      $_db,
      $_db.planItems,
    ).filter((f) => f.offerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OptionOffersTableFilterComposer
    extends Composer<_$LiltDatabase, $OptionOffersTable> {
  $$OptionOffersTableFilterComposer({
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

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedDay => $composableBuilder(
    column: $table.suggestedDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get suggestedTime => $composableBuilder(
    column: $table.suggestedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get swapIndex => $composableBuilder(
    column: $table.swapIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<OfferStatus, OfferStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get editedDurationMin => $composableBuilder(
    column: $table.editedDurationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editedDay => $composableBuilder(
    column: $table.editedDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get editedTime => $composableBuilder(
    column: $table.editedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeInputMin => $composableBuilder(
    column: $table.timeInputMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Energy?, Energy, String> get energyInput =>
      $composableBuilder(
        column: $table.energyInput,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ActionsTableFilterComposer get actionId {
    final $$ActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableFilterComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FollowedActivitiesTableFilterComposer get followedActivityId {
    final $$FollowedActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.followedActivityId,
      referencedTable: $db.followedActivities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FollowedActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.followedActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> offerReasonsRefs(
    Expression<bool> Function($$OfferReasonsTableFilterComposer f) f,
  ) {
    final $$OfferReasonsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offerReasons,
      getReferencedColumn: (t) => t.offerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfferReasonsTableFilterComposer(
            $db: $db,
            $table: $db.offerReasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> planItemsRefs(
    Expression<bool> Function($$PlanItemsTableFilterComposer f) f,
  ) {
    final $$PlanItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.offerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableFilterComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OptionOffersTableOrderingComposer
    extends Composer<_$LiltDatabase, $OptionOffersTable> {
  $$OptionOffersTableOrderingComposer({
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

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedDay => $composableBuilder(
    column: $table.suggestedDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get suggestedTime => $composableBuilder(
    column: $table.suggestedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get swapIndex => $composableBuilder(
    column: $table.swapIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get editedDurationMin => $composableBuilder(
    column: $table.editedDurationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editedDay => $composableBuilder(
    column: $table.editedDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get editedTime => $composableBuilder(
    column: $table.editedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeInputMin => $composableBuilder(
    column: $table.timeInputMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get energyInput => $composableBuilder(
    column: $table.energyInput,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActionsTableOrderingComposer get actionId {
    final $$ActionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableOrderingComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FollowedActivitiesTableOrderingComposer get followedActivityId {
    final $$FollowedActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.followedActivityId,
      referencedTable: $db.followedActivities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FollowedActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.followedActivities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OptionOffersTableAnnotationComposer
    extends Composer<_$LiltDatabase, $OptionOffersTable> {
  $$OptionOffersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get suggestedDay => $composableBuilder(
    column: $table.suggestedDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get suggestedTime => $composableBuilder(
    column: $table.suggestedTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get swapIndex =>
      $composableBuilder(column: $table.swapIndex, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OfferStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get editedDurationMin => $composableBuilder(
    column: $table.editedDurationMin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get editedDay =>
      $composableBuilder(column: $table.editedDay, builder: (column) => column);

  GeneratedColumn<String> get editedTime => $composableBuilder(
    column: $table.editedTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeInputMin => $composableBuilder(
    column: $table.timeInputMin,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Energy?, String> get energyInput =>
      $composableBuilder(
        column: $table.energyInput,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ActionsTableAnnotationComposer get actionId {
    final $$ActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FollowedActivitiesTableAnnotationComposer get followedActivityId {
    final $$FollowedActivitiesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.followedActivityId,
          referencedTable: $db.followedActivities,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FollowedActivitiesTableAnnotationComposer(
                $db: $db,
                $table: $db.followedActivities,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> offerReasonsRefs<T extends Object>(
    Expression<T> Function($$OfferReasonsTableAnnotationComposer a) f,
  ) {
    final $$OfferReasonsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.offerReasons,
      getReferencedColumn: (t) => t.offerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OfferReasonsTableAnnotationComposer(
            $db: $db,
            $table: $db.offerReasons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> planItemsRefs<T extends Object>(
    Expression<T> Function($$PlanItemsTableAnnotationComposer a) f,
  ) {
    final $$PlanItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.offerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OptionOffersTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $OptionOffersTable,
          OptionOffer,
          $$OptionOffersTableFilterComposer,
          $$OptionOffersTableOrderingComposer,
          $$OptionOffersTableAnnotationComposer,
          $$OptionOffersTableCreateCompanionBuilder,
          $$OptionOffersTableUpdateCompanionBuilder,
          (OptionOffer, $$OptionOffersTableReferences),
          OptionOffer,
          PrefetchHooks Function({
            bool actionId,
            bool followedActivityId,
            bool offerReasonsRefs,
            bool planItemsRefs,
          })
        > {
  $$OptionOffersTableTableManager(_$LiltDatabase db, $OptionOffersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OptionOffersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OptionOffersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OptionOffersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String> actionId = const Value.absent(),
                Value<String?> followedActivityId = const Value.absent(),
                Value<String> suggestedDay = const Value.absent(),
                Value<String?> suggestedTime = const Value.absent(),
                Value<int> swapIndex = const Value.absent(),
                Value<OfferStatus> status = const Value.absent(),
                Value<int?> editedDurationMin = const Value.absent(),
                Value<String?> editedDay = const Value.absent(),
                Value<String?> editedTime = const Value.absent(),
                Value<int?> timeInputMin = const Value.absent(),
                Value<Energy?> energyInput = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OptionOffersCompanion(
                id: id,
                day: day,
                actionId: actionId,
                followedActivityId: followedActivityId,
                suggestedDay: suggestedDay,
                suggestedTime: suggestedTime,
                swapIndex: swapIndex,
                status: status,
                editedDurationMin: editedDurationMin,
                editedDay: editedDay,
                editedTime: editedTime,
                timeInputMin: timeInputMin,
                energyInput: energyInput,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String day,
                required String actionId,
                Value<String?> followedActivityId = const Value.absent(),
                required String suggestedDay,
                Value<String?> suggestedTime = const Value.absent(),
                Value<int> swapIndex = const Value.absent(),
                Value<OfferStatus> status = const Value.absent(),
                Value<int?> editedDurationMin = const Value.absent(),
                Value<String?> editedDay = const Value.absent(),
                Value<String?> editedTime = const Value.absent(),
                Value<int?> timeInputMin = const Value.absent(),
                Value<Energy?> energyInput = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OptionOffersCompanion.insert(
                id: id,
                day: day,
                actionId: actionId,
                followedActivityId: followedActivityId,
                suggestedDay: suggestedDay,
                suggestedTime: suggestedTime,
                swapIndex: swapIndex,
                status: status,
                editedDurationMin: editedDurationMin,
                editedDay: editedDay,
                editedTime: editedTime,
                timeInputMin: timeInputMin,
                energyInput: energyInput,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OptionOffersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                actionId = false,
                followedActivityId = false,
                offerReasonsRefs = false,
                planItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (offerReasonsRefs) db.offerReasons,
                    if (planItemsRefs) db.planItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (actionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.actionId,
                                    referencedTable:
                                        $$OptionOffersTableReferences
                                            ._actionIdTable(db),
                                    referencedColumn:
                                        $$OptionOffersTableReferences
                                            ._actionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (followedActivityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.followedActivityId,
                                    referencedTable:
                                        $$OptionOffersTableReferences
                                            ._followedActivityIdTable(db),
                                    referencedColumn:
                                        $$OptionOffersTableReferences
                                            ._followedActivityIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (offerReasonsRefs)
                        await $_getPrefetchedData<
                          OptionOffer,
                          $OptionOffersTable,
                          OfferReason
                        >(
                          currentTable: table,
                          referencedTable: $$OptionOffersTableReferences
                              ._offerReasonsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OptionOffersTableReferences(
                                db,
                                table,
                                p0,
                              ).offerReasonsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.offerId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (planItemsRefs)
                        await $_getPrefetchedData<
                          OptionOffer,
                          $OptionOffersTable,
                          PlanItem
                        >(
                          currentTable: table,
                          referencedTable: $$OptionOffersTableReferences
                              ._planItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OptionOffersTableReferences(
                                db,
                                table,
                                p0,
                              ).planItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.offerId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OptionOffersTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $OptionOffersTable,
      OptionOffer,
      $$OptionOffersTableFilterComposer,
      $$OptionOffersTableOrderingComposer,
      $$OptionOffersTableAnnotationComposer,
      $$OptionOffersTableCreateCompanionBuilder,
      $$OptionOffersTableUpdateCompanionBuilder,
      (OptionOffer, $$OptionOffersTableReferences),
      OptionOffer,
      PrefetchHooks Function({
        bool actionId,
        bool followedActivityId,
        bool offerReasonsRefs,
        bool planItemsRefs,
      })
    >;
typedef $$OfferReasonsTableCreateCompanionBuilder =
    OfferReasonsCompanion Function({
      required String offerId,
      required int rank,
      required String reasonCode,
      required String reasonText,
      Value<int> rowid,
    });
typedef $$OfferReasonsTableUpdateCompanionBuilder =
    OfferReasonsCompanion Function({
      Value<String> offerId,
      Value<int> rank,
      Value<String> reasonCode,
      Value<String> reasonText,
      Value<int> rowid,
    });

final class $$OfferReasonsTableReferences
    extends BaseReferences<_$LiltDatabase, $OfferReasonsTable, OfferReason> {
  $$OfferReasonsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OptionOffersTable _offerIdTable(_$LiltDatabase db) =>
      db.optionOffers.createAlias('offer_reason__offer_id__option_offer__id');

  $$OptionOffersTableProcessedTableManager get offerId {
    final $_column = $_itemColumn<String>('offer_id')!;

    final manager = $$OptionOffersTableTableManager(
      $_db,
      $_db.optionOffers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_offerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OfferReasonsTableFilterComposer
    extends Composer<_$LiltDatabase, $OfferReasonsTable> {
  $$OfferReasonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => ColumnFilters(column),
  );

  $$OptionOffersTableFilterComposer get offerId {
    final $$OptionOffersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableFilterComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfferReasonsTableOrderingComposer
    extends Composer<_$LiltDatabase, $OfferReasonsTable> {
  $$OfferReasonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => ColumnOrderings(column),
  );

  $$OptionOffersTableOrderingComposer get offerId {
    final $$OptionOffersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableOrderingComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfferReasonsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $OfferReasonsTable> {
  $$OfferReasonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumn<String> get reasonCode => $composableBuilder(
    column: $table.reasonCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reasonText => $composableBuilder(
    column: $table.reasonText,
    builder: (column) => column,
  );

  $$OptionOffersTableAnnotationComposer get offerId {
    final $$OptionOffersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableAnnotationComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OfferReasonsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $OfferReasonsTable,
          OfferReason,
          $$OfferReasonsTableFilterComposer,
          $$OfferReasonsTableOrderingComposer,
          $$OfferReasonsTableAnnotationComposer,
          $$OfferReasonsTableCreateCompanionBuilder,
          $$OfferReasonsTableUpdateCompanionBuilder,
          (OfferReason, $$OfferReasonsTableReferences),
          OfferReason,
          PrefetchHooks Function({bool offerId})
        > {
  $$OfferReasonsTableTableManager(_$LiltDatabase db, $OfferReasonsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfferReasonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfferReasonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfferReasonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> offerId = const Value.absent(),
                Value<int> rank = const Value.absent(),
                Value<String> reasonCode = const Value.absent(),
                Value<String> reasonText = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfferReasonsCompanion(
                offerId: offerId,
                rank: rank,
                reasonCode: reasonCode,
                reasonText: reasonText,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String offerId,
                required int rank,
                required String reasonCode,
                required String reasonText,
                Value<int> rowid = const Value.absent(),
              }) => OfferReasonsCompanion.insert(
                offerId: offerId,
                rank: rank,
                reasonCode: reasonCode,
                reasonText: reasonText,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OfferReasonsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({offerId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (offerId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.offerId,
                                referencedTable: $$OfferReasonsTableReferences
                                    ._offerIdTable(db),
                                referencedColumn: $$OfferReasonsTableReferences
                                    ._offerIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OfferReasonsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $OfferReasonsTable,
      OfferReason,
      $$OfferReasonsTableFilterComposer,
      $$OfferReasonsTableOrderingComposer,
      $$OfferReasonsTableAnnotationComposer,
      $$OfferReasonsTableCreateCompanionBuilder,
      $$OfferReasonsTableUpdateCompanionBuilder,
      (OfferReason, $$OfferReasonsTableReferences),
      OfferReason,
      PrefetchHooks Function({bool offerId})
    >;
typedef $$PlanItemsTableCreateCompanionBuilder =
    PlanItemsCompanion Function({
      Value<String> id,
      required PlanSource source,
      Value<String?> offerId,
      Value<String?> actionId,
      required ActivityKind activity,
      required String title,
      required String plannedDay,
      Value<String?> plannedTime,
      Value<int?> durationMin,
      Value<WithWhom> withWhom,
      Value<String?> togetherEventId,
      Value<String?> detailText,
      Value<DateTime?> startedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PlanItemsTableUpdateCompanionBuilder =
    PlanItemsCompanion Function({
      Value<String> id,
      Value<PlanSource> source,
      Value<String?> offerId,
      Value<String?> actionId,
      Value<ActivityKind> activity,
      Value<String> title,
      Value<String> plannedDay,
      Value<String?> plannedTime,
      Value<int?> durationMin,
      Value<WithWhom> withWhom,
      Value<String?> togetherEventId,
      Value<String?> detailText,
      Value<DateTime?> startedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$PlanItemsTableReferences
    extends BaseReferences<_$LiltDatabase, $PlanItemsTable, PlanItem> {
  $$PlanItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OptionOffersTable _offerIdTable(_$LiltDatabase db) =>
      db.optionOffers.createAlias('plan_item__offer_id__option_offer__id');

  $$OptionOffersTableProcessedTableManager? get offerId {
    final $_column = $_itemColumn<String>('offer_id');
    if ($_column == null) return null;
    final manager = $$OptionOffersTableTableManager(
      $_db,
      $_db.optionOffers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_offerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ActionsTable _actionIdTable(_$LiltDatabase db) =>
      db.actions.createAlias('plan_item__action_id__action__id');

  $$ActionsTableProcessedTableManager? get actionId {
    final $_column = $_itemColumn<String>('action_id');
    if ($_column == null) return null;
    final manager = $$ActionsTableTableManager(
      $_db,
      $_db.actions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReflectionsTable, List<Reflection>>
  _reflectionsRefsTable(_$LiltDatabase db) => MultiTypedResultKey.fromTable(
    db.reflections,
    aliasName: 'plan_item__id__reflection__plan_item_id',
  );

  $$ReflectionsTableProcessedTableManager get reflectionsRefs {
    final manager = $$ReflectionsTableTableManager(
      $_db,
      $_db.reflections,
    ).filter((f) => f.planItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_reflectionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlanItemsTableFilterComposer
    extends Composer<_$LiltDatabase, $PlanItemsTable> {
  $$PlanItemsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<PlanSource, PlanSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ActivityKind, ActivityKind, String>
  get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plannedDay => $composableBuilder(
    column: $table.plannedDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plannedTime => $composableBuilder(
    column: $table.plannedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WithWhom, WithWhom, String> get withWhom =>
      $composableBuilder(
        column: $table.withWhom,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get togetherEventId => $composableBuilder(
    column: $table.togetherEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailText => $composableBuilder(
    column: $table.detailText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OptionOffersTableFilterComposer get offerId {
    final $$OptionOffersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableFilterComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActionsTableFilterComposer get actionId {
    final $$ActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableFilterComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> reflectionsRefs(
    Expression<bool> Function($$ReflectionsTableFilterComposer f) f,
  ) {
    final $$ReflectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reflections,
      getReferencedColumn: (t) => t.planItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReflectionsTableFilterComposer(
            $db: $db,
            $table: $db.reflections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanItemsTableOrderingComposer
    extends Composer<_$LiltDatabase, $PlanItemsTable> {
  $$PlanItemsTableOrderingComposer({
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

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plannedDay => $composableBuilder(
    column: $table.plannedDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plannedTime => $composableBuilder(
    column: $table.plannedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get withWhom => $composableBuilder(
    column: $table.withWhom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get togetherEventId => $composableBuilder(
    column: $table.togetherEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailText => $composableBuilder(
    column: $table.detailText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OptionOffersTableOrderingComposer get offerId {
    final $$OptionOffersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableOrderingComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActionsTableOrderingComposer get actionId {
    final $$ActionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableOrderingComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanItemsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $PlanItemsTable> {
  $$PlanItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PlanSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ActivityKind, String> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get plannedDay => $composableBuilder(
    column: $table.plannedDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get plannedTime => $composableBuilder(
    column: $table.plannedTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMin => $composableBuilder(
    column: $table.durationMin,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<WithWhom, String> get withWhom =>
      $composableBuilder(column: $table.withWhom, builder: (column) => column);

  GeneratedColumn<String> get togetherEventId => $composableBuilder(
    column: $table.togetherEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get detailText => $composableBuilder(
    column: $table.detailText,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$OptionOffersTableAnnotationComposer get offerId {
    final $$OptionOffersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.offerId,
      referencedTable: $db.optionOffers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OptionOffersTableAnnotationComposer(
            $db: $db,
            $table: $db.optionOffers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActionsTableAnnotationComposer get actionId {
    final $$ActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> reflectionsRefs<T extends Object>(
    Expression<T> Function($$ReflectionsTableAnnotationComposer a) f,
  ) {
    final $$ReflectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reflections,
      getReferencedColumn: (t) => t.planItemId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReflectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.reflections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanItemsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $PlanItemsTable,
          PlanItem,
          $$PlanItemsTableFilterComposer,
          $$PlanItemsTableOrderingComposer,
          $$PlanItemsTableAnnotationComposer,
          $$PlanItemsTableCreateCompanionBuilder,
          $$PlanItemsTableUpdateCompanionBuilder,
          (PlanItem, $$PlanItemsTableReferences),
          PlanItem,
          PrefetchHooks Function({
            bool offerId,
            bool actionId,
            bool reflectionsRefs,
          })
        > {
  $$PlanItemsTableTableManager(_$LiltDatabase db, $PlanItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<PlanSource> source = const Value.absent(),
                Value<String?> offerId = const Value.absent(),
                Value<String?> actionId = const Value.absent(),
                Value<ActivityKind> activity = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> plannedDay = const Value.absent(),
                Value<String?> plannedTime = const Value.absent(),
                Value<int?> durationMin = const Value.absent(),
                Value<WithWhom> withWhom = const Value.absent(),
                Value<String?> togetherEventId = const Value.absent(),
                Value<String?> detailText = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanItemsCompanion(
                id: id,
                source: source,
                offerId: offerId,
                actionId: actionId,
                activity: activity,
                title: title,
                plannedDay: plannedDay,
                plannedTime: plannedTime,
                durationMin: durationMin,
                withWhom: withWhom,
                togetherEventId: togetherEventId,
                detailText: detailText,
                startedAt: startedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required PlanSource source,
                Value<String?> offerId = const Value.absent(),
                Value<String?> actionId = const Value.absent(),
                required ActivityKind activity,
                required String title,
                required String plannedDay,
                Value<String?> plannedTime = const Value.absent(),
                Value<int?> durationMin = const Value.absent(),
                Value<WithWhom> withWhom = const Value.absent(),
                Value<String?> togetherEventId = const Value.absent(),
                Value<String?> detailText = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanItemsCompanion.insert(
                id: id,
                source: source,
                offerId: offerId,
                actionId: actionId,
                activity: activity,
                title: title,
                plannedDay: plannedDay,
                plannedTime: plannedTime,
                durationMin: durationMin,
                withWhom: withWhom,
                togetherEventId: togetherEventId,
                detailText: detailText,
                startedAt: startedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PlanItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({offerId = false, actionId = false, reflectionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (reflectionsRefs) db.reflections,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (offerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.offerId,
                                    referencedTable: $$PlanItemsTableReferences
                                        ._offerIdTable(db),
                                    referencedColumn: $$PlanItemsTableReferences
                                        ._offerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (actionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.actionId,
                                    referencedTable: $$PlanItemsTableReferences
                                        ._actionIdTable(db),
                                    referencedColumn: $$PlanItemsTableReferences
                                        ._actionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (reflectionsRefs)
                        await $_getPrefetchedData<
                          PlanItem,
                          $PlanItemsTable,
                          Reflection
                        >(
                          currentTable: table,
                          referencedTable: $$PlanItemsTableReferences
                              ._reflectionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlanItemsTableReferences(
                                db,
                                table,
                                p0,
                              ).reflectionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.planItemId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlanItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $PlanItemsTable,
      PlanItem,
      $$PlanItemsTableFilterComposer,
      $$PlanItemsTableOrderingComposer,
      $$PlanItemsTableAnnotationComposer,
      $$PlanItemsTableCreateCompanionBuilder,
      $$PlanItemsTableUpdateCompanionBuilder,
      (PlanItem, $$PlanItemsTableReferences),
      PlanItem,
      PrefetchHooks Function({
        bool offerId,
        bool actionId,
        bool reflectionsRefs,
      })
    >;
typedef $$ReflectionsTableCreateCompanionBuilder =
    ReflectionsCompanion Function({
      Value<String> id,
      required String planItemId,
      Value<ReflectionStatus> status,
      Value<int?> enjoyment,
      Value<Barrier?> barrier,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$ReflectionsTableUpdateCompanionBuilder =
    ReflectionsCompanion Function({
      Value<String> id,
      Value<String> planItemId,
      Value<ReflectionStatus> status,
      Value<int?> enjoyment,
      Value<Barrier?> barrier,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ReflectionsTableReferences
    extends BaseReferences<_$LiltDatabase, $ReflectionsTable, Reflection> {
  $$ReflectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PlanItemsTable _planItemIdTable(_$LiltDatabase db) =>
      db.planItems.createAlias('reflection__plan_item_id__plan_item__id');

  $$PlanItemsTableProcessedTableManager get planItemId {
    final $_column = $_itemColumn<String>('plan_item_id')!;

    final manager = $$PlanItemsTableTableManager(
      $_db,
      $_db.planItems,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReflectionsTableFilterComposer
    extends Composer<_$LiltDatabase, $ReflectionsTable> {
  $$ReflectionsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<ReflectionStatus, ReflectionStatus, String>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get enjoyment => $composableBuilder(
    column: $table.enjoyment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Barrier?, Barrier, String> get barrier =>
      $composableBuilder(
        column: $table.barrier,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PlanItemsTableFilterComposer get planItemId {
    final $$PlanItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planItemId,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableFilterComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReflectionsTableOrderingComposer
    extends Composer<_$LiltDatabase, $ReflectionsTable> {
  $$ReflectionsTableOrderingComposer({
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

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get enjoyment => $composableBuilder(
    column: $table.enjoyment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barrier => $composableBuilder(
    column: $table.barrier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlanItemsTableOrderingComposer get planItemId {
    final $$PlanItemsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planItemId,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableOrderingComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReflectionsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $ReflectionsTable> {
  $$ReflectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ReflectionStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get enjoyment =>
      $composableBuilder(column: $table.enjoyment, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Barrier?, String> get barrier =>
      $composableBuilder(column: $table.barrier, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PlanItemsTableAnnotationComposer get planItemId {
    final $$PlanItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planItemId,
      referencedTable: $db.planItems,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.planItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReflectionsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $ReflectionsTable,
          Reflection,
          $$ReflectionsTableFilterComposer,
          $$ReflectionsTableOrderingComposer,
          $$ReflectionsTableAnnotationComposer,
          $$ReflectionsTableCreateCompanionBuilder,
          $$ReflectionsTableUpdateCompanionBuilder,
          (Reflection, $$ReflectionsTableReferences),
          Reflection,
          PrefetchHooks Function({bool planItemId})
        > {
  $$ReflectionsTableTableManager(_$LiltDatabase db, $ReflectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReflectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReflectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReflectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> planItemId = const Value.absent(),
                Value<ReflectionStatus> status = const Value.absent(),
                Value<int?> enjoyment = const Value.absent(),
                Value<Barrier?> barrier = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReflectionsCompanion(
                id: id,
                planItemId: planItemId,
                status: status,
                enjoyment: enjoyment,
                barrier: barrier,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String planItemId,
                Value<ReflectionStatus> status = const Value.absent(),
                Value<int?> enjoyment = const Value.absent(),
                Value<Barrier?> barrier = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReflectionsCompanion.insert(
                id: id,
                planItemId: planItemId,
                status: status,
                enjoyment: enjoyment,
                barrier: barrier,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReflectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({planItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (planItemId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.planItemId,
                                referencedTable: $$ReflectionsTableReferences
                                    ._planItemIdTable(db),
                                referencedColumn: $$ReflectionsTableReferences
                                    ._planItemIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReflectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $ReflectionsTable,
      Reflection,
      $$ReflectionsTableFilterComposer,
      $$ReflectionsTableOrderingComposer,
      $$ReflectionsTableAnnotationComposer,
      $$ReflectionsTableCreateCompanionBuilder,
      $$ReflectionsTableUpdateCompanionBuilder,
      (Reflection, $$ReflectionsTableReferences),
      Reflection,
      PrefetchHooks Function({bool planItemId})
    >;
typedef $$PausesTableCreateCompanionBuilder =
    PausesCompanion Function({
      Value<String> id,
      required PauseKind kind,
      required String startDay,
      Value<String?> endDay,
      Value<int> rowid,
    });
typedef $$PausesTableUpdateCompanionBuilder =
    PausesCompanion Function({
      Value<String> id,
      Value<PauseKind> kind,
      Value<String> startDay,
      Value<String?> endDay,
      Value<int> rowid,
    });

class $$PausesTableFilterComposer
    extends Composer<_$LiltDatabase, $PausesTable> {
  $$PausesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<PauseKind, PauseKind, String> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get endDay => $composableBuilder(
    column: $table.endDay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PausesTableOrderingComposer
    extends Composer<_$LiltDatabase, $PausesTable> {
  $$PausesTableOrderingComposer({
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

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get startDay => $composableBuilder(
    column: $table.startDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get endDay => $composableBuilder(
    column: $table.endDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PausesTableAnnotationComposer
    extends Composer<_$LiltDatabase, $PausesTable> {
  $$PausesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PauseKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get startDay =>
      $composableBuilder(column: $table.startDay, builder: (column) => column);

  GeneratedColumn<String> get endDay =>
      $composableBuilder(column: $table.endDay, builder: (column) => column);
}

class $$PausesTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $PausesTable,
          Pause,
          $$PausesTableFilterComposer,
          $$PausesTableOrderingComposer,
          $$PausesTableAnnotationComposer,
          $$PausesTableCreateCompanionBuilder,
          $$PausesTableUpdateCompanionBuilder,
          (Pause, BaseReferences<_$LiltDatabase, $PausesTable, Pause>),
          Pause,
          PrefetchHooks Function()
        > {
  $$PausesTableTableManager(_$LiltDatabase db, $PausesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PausesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PausesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PausesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<PauseKind> kind = const Value.absent(),
                Value<String> startDay = const Value.absent(),
                Value<String?> endDay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PausesCompanion(
                id: id,
                kind: kind,
                startDay: startDay,
                endDay: endDay,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required PauseKind kind,
                required String startDay,
                Value<String?> endDay = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PausesCompanion.insert(
                id: id,
                kind: kind,
                startDay: startDay,
                endDay: endDay,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PausesTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $PausesTable,
      Pause,
      $$PausesTableFilterComposer,
      $$PausesTableOrderingComposer,
      $$PausesTableAnnotationComposer,
      $$PausesTableCreateCompanionBuilder,
      $$PausesTableUpdateCompanionBuilder,
      (Pause, BaseReferences<_$LiltDatabase, $PausesTable, Pause>),
      Pause,
      PrefetchHooks Function()
    >;
typedef $$ObservationsTableCreateCompanionBuilder =
    ObservationsCompanion Function({
      Value<String> id,
      required String text_,
      required ObsSource source,
      Value<ObsStatus> status,
      required String patternKey,
      Value<DateTime> createdAt,
      Value<DateTime?> confirmedAt,
      Value<int> rowid,
    });
typedef $$ObservationsTableUpdateCompanionBuilder =
    ObservationsCompanion Function({
      Value<String> id,
      Value<String> text_,
      Value<ObsSource> source,
      Value<ObsStatus> status,
      Value<String> patternKey,
      Value<DateTime> createdAt,
      Value<DateTime?> confirmedAt,
      Value<int> rowid,
    });

class $$ObservationsTableFilterComposer
    extends Composer<_$LiltDatabase, $ObservationsTable> {
  $$ObservationsTableFilterComposer({
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

  ColumnFilters<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ObsSource, ObsSource, String> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<ObsStatus, ObsStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get patternKey => $composableBuilder(
    column: $table.patternKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ObservationsTableOrderingComposer
    extends Composer<_$LiltDatabase, $ObservationsTable> {
  $$ObservationsTableOrderingComposer({
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

  ColumnOrderings<String> get text_ => $composableBuilder(
    column: $table.text_,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patternKey => $composableBuilder(
    column: $table.patternKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ObservationsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $ObservationsTable> {
  $$ObservationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get text_ =>
      $composableBuilder(column: $table.text_, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ObsSource, String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ObsStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get patternKey => $composableBuilder(
    column: $table.patternKey,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get confirmedAt => $composableBuilder(
    column: $table.confirmedAt,
    builder: (column) => column,
  );
}

class $$ObservationsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $ObservationsTable,
          Observation,
          $$ObservationsTableFilterComposer,
          $$ObservationsTableOrderingComposer,
          $$ObservationsTableAnnotationComposer,
          $$ObservationsTableCreateCompanionBuilder,
          $$ObservationsTableUpdateCompanionBuilder,
          (
            Observation,
            BaseReferences<_$LiltDatabase, $ObservationsTable, Observation>,
          ),
          Observation,
          PrefetchHooks Function()
        > {
  $$ObservationsTableTableManager(_$LiltDatabase db, $ObservationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ObservationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ObservationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ObservationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> text_ = const Value.absent(),
                Value<ObsSource> source = const Value.absent(),
                Value<ObsStatus> status = const Value.absent(),
                Value<String> patternKey = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> confirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObservationsCompanion(
                id: id,
                text_: text_,
                source: source,
                status: status,
                patternKey: patternKey,
                createdAt: createdAt,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String text_,
                required ObsSource source,
                Value<ObsStatus> status = const Value.absent(),
                required String patternKey,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> confirmedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ObservationsCompanion.insert(
                id: id,
                text_: text_,
                source: source,
                status: status,
                patternKey: patternKey,
                createdAt: createdAt,
                confirmedAt: confirmedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ObservationsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $ObservationsTable,
      Observation,
      $$ObservationsTableFilterComposer,
      $$ObservationsTableOrderingComposer,
      $$ObservationsTableAnnotationComposer,
      $$ObservationsTableCreateCompanionBuilder,
      $$ObservationsTableUpdateCompanionBuilder,
      (
        Observation,
        BaseReferences<_$LiltDatabase, $ObservationsTable, Observation>,
      ),
      Observation,
      PrefetchHooks Function()
    >;
typedef $$SavedActionsTableCreateCompanionBuilder =
    SavedActionsCompanion Function({
      required String actionId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });
typedef $$SavedActionsTableUpdateCompanionBuilder =
    SavedActionsCompanion Function({
      Value<String> actionId,
      Value<DateTime> savedAt,
      Value<int> rowid,
    });

final class $$SavedActionsTableReferences
    extends BaseReferences<_$LiltDatabase, $SavedActionsTable, SavedAction> {
  $$SavedActionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActionsTable _actionIdTable(_$LiltDatabase db) =>
      db.actions.createAlias('saved_action__action_id__action__id');

  $$ActionsTableProcessedTableManager get actionId {
    final $_column = $_itemColumn<String>('action_id')!;

    final manager = $$ActionsTableTableManager(
      $_db,
      $_db.actions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_actionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SavedActionsTableFilterComposer
    extends Composer<_$LiltDatabase, $SavedActionsTable> {
  $$SavedActionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ActionsTableFilterComposer get actionId {
    final $$ActionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableFilterComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedActionsTableOrderingComposer
    extends Composer<_$LiltDatabase, $SavedActionsTable> {
  $$SavedActionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get savedAt => $composableBuilder(
    column: $table.savedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActionsTableOrderingComposer get actionId {
    final $$ActionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableOrderingComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedActionsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $SavedActionsTable> {
  $$SavedActionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get savedAt =>
      $composableBuilder(column: $table.savedAt, builder: (column) => column);

  $$ActionsTableAnnotationComposer get actionId {
    final $$ActionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.actionId,
      referencedTable: $db.actions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActionsTableAnnotationComposer(
            $db: $db,
            $table: $db.actions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavedActionsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $SavedActionsTable,
          SavedAction,
          $$SavedActionsTableFilterComposer,
          $$SavedActionsTableOrderingComposer,
          $$SavedActionsTableAnnotationComposer,
          $$SavedActionsTableCreateCompanionBuilder,
          $$SavedActionsTableUpdateCompanionBuilder,
          (SavedAction, $$SavedActionsTableReferences),
          SavedAction,
          PrefetchHooks Function({bool actionId})
        > {
  $$SavedActionsTableTableManager(_$LiltDatabase db, $SavedActionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavedActionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavedActionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavedActionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> actionId = const Value.absent(),
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedActionsCompanion(
                actionId: actionId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String actionId,
                Value<DateTime> savedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavedActionsCompanion.insert(
                actionId: actionId,
                savedAt: savedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SavedActionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({actionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (actionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.actionId,
                                referencedTable: $$SavedActionsTableReferences
                                    ._actionIdTable(db),
                                referencedColumn: $$SavedActionsTableReferences
                                    ._actionIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SavedActionsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $SavedActionsTable,
      SavedAction,
      $$SavedActionsTableFilterComposer,
      $$SavedActionsTableOrderingComposer,
      $$SavedActionsTableAnnotationComposer,
      $$SavedActionsTableCreateCompanionBuilder,
      $$SavedActionsTableUpdateCompanionBuilder,
      (SavedAction, $$SavedActionsTableReferences),
      SavedAction,
      PrefetchHooks Function({bool actionId})
    >;
typedef $$ReturnEventsTableCreateCompanionBuilder =
    ReturnEventsCompanion Function({
      Value<String> id,
      required String lapseStartDay,
      required String returnDay,
      Value<String?> whatChanged,
      Value<ReturnApproach?> approach,
      Value<int> rowid,
    });
typedef $$ReturnEventsTableUpdateCompanionBuilder =
    ReturnEventsCompanion Function({
      Value<String> id,
      Value<String> lapseStartDay,
      Value<String> returnDay,
      Value<String?> whatChanged,
      Value<ReturnApproach?> approach,
      Value<int> rowid,
    });

class $$ReturnEventsTableFilterComposer
    extends Composer<_$LiltDatabase, $ReturnEventsTable> {
  $$ReturnEventsTableFilterComposer({
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

  ColumnFilters<String> get lapseStartDay => $composableBuilder(
    column: $table.lapseStartDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get returnDay => $composableBuilder(
    column: $table.returnDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get whatChanged => $composableBuilder(
    column: $table.whatChanged,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ReturnApproach?, ReturnApproach, String>
  get approach => $composableBuilder(
    column: $table.approach,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$ReturnEventsTableOrderingComposer
    extends Composer<_$LiltDatabase, $ReturnEventsTable> {
  $$ReturnEventsTableOrderingComposer({
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

  ColumnOrderings<String> get lapseStartDay => $composableBuilder(
    column: $table.lapseStartDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get returnDay => $composableBuilder(
    column: $table.returnDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get whatChanged => $composableBuilder(
    column: $table.whatChanged,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get approach => $composableBuilder(
    column: $table.approach,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReturnEventsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $ReturnEventsTable> {
  $$ReturnEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lapseStartDay => $composableBuilder(
    column: $table.lapseStartDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get returnDay =>
      $composableBuilder(column: $table.returnDay, builder: (column) => column);

  GeneratedColumn<String> get whatChanged => $composableBuilder(
    column: $table.whatChanged,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ReturnApproach?, String> get approach =>
      $composableBuilder(column: $table.approach, builder: (column) => column);
}

class $$ReturnEventsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $ReturnEventsTable,
          ReturnEvent,
          $$ReturnEventsTableFilterComposer,
          $$ReturnEventsTableOrderingComposer,
          $$ReturnEventsTableAnnotationComposer,
          $$ReturnEventsTableCreateCompanionBuilder,
          $$ReturnEventsTableUpdateCompanionBuilder,
          (
            ReturnEvent,
            BaseReferences<_$LiltDatabase, $ReturnEventsTable, ReturnEvent>,
          ),
          ReturnEvent,
          PrefetchHooks Function()
        > {
  $$ReturnEventsTableTableManager(_$LiltDatabase db, $ReturnEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReturnEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReturnEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReturnEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lapseStartDay = const Value.absent(),
                Value<String> returnDay = const Value.absent(),
                Value<String?> whatChanged = const Value.absent(),
                Value<ReturnApproach?> approach = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnEventsCompanion(
                id: id,
                lapseStartDay: lapseStartDay,
                returnDay: returnDay,
                whatChanged: whatChanged,
                approach: approach,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String lapseStartDay,
                required String returnDay,
                Value<String?> whatChanged = const Value.absent(),
                Value<ReturnApproach?> approach = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReturnEventsCompanion.insert(
                id: id,
                lapseStartDay: lapseStartDay,
                returnDay: returnDay,
                whatChanged: whatChanged,
                approach: approach,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReturnEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $ReturnEventsTable,
      ReturnEvent,
      $$ReturnEventsTableFilterComposer,
      $$ReturnEventsTableOrderingComposer,
      $$ReturnEventsTableAnnotationComposer,
      $$ReturnEventsTableCreateCompanionBuilder,
      $$ReturnEventsTableUpdateCompanionBuilder,
      (
        ReturnEvent,
        BaseReferences<_$LiltDatabase, $ReturnEventsTable, ReturnEvent>,
      ),
      ReturnEvent,
      PrefetchHooks Function()
    >;
typedef $$AchievementsEarnedTableCreateCompanionBuilder =
    AchievementsEarnedCompanion Function({
      required String code,
      required String earnedDay,
      Value<bool> celebrated,
      Value<int> rowid,
    });
typedef $$AchievementsEarnedTableUpdateCompanionBuilder =
    AchievementsEarnedCompanion Function({
      Value<String> code,
      Value<String> earnedDay,
      Value<bool> celebrated,
      Value<int> rowid,
    });

class $$AchievementsEarnedTableFilterComposer
    extends Composer<_$LiltDatabase, $AchievementsEarnedTable> {
  $$AchievementsEarnedTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get earnedDay => $composableBuilder(
    column: $table.earnedDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get celebrated => $composableBuilder(
    column: $table.celebrated,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AchievementsEarnedTableOrderingComposer
    extends Composer<_$LiltDatabase, $AchievementsEarnedTable> {
  $$AchievementsEarnedTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get earnedDay => $composableBuilder(
    column: $table.earnedDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get celebrated => $composableBuilder(
    column: $table.celebrated,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AchievementsEarnedTableAnnotationComposer
    extends Composer<_$LiltDatabase, $AchievementsEarnedTable> {
  $$AchievementsEarnedTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get earnedDay =>
      $composableBuilder(column: $table.earnedDay, builder: (column) => column);

  GeneratedColumn<bool> get celebrated => $composableBuilder(
    column: $table.celebrated,
    builder: (column) => column,
  );
}

class $$AchievementsEarnedTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $AchievementsEarnedTable,
          AchievementEarned,
          $$AchievementsEarnedTableFilterComposer,
          $$AchievementsEarnedTableOrderingComposer,
          $$AchievementsEarnedTableAnnotationComposer,
          $$AchievementsEarnedTableCreateCompanionBuilder,
          $$AchievementsEarnedTableUpdateCompanionBuilder,
          (
            AchievementEarned,
            BaseReferences<
              _$LiltDatabase,
              $AchievementsEarnedTable,
              AchievementEarned
            >,
          ),
          AchievementEarned,
          PrefetchHooks Function()
        > {
  $$AchievementsEarnedTableTableManager(
    _$LiltDatabase db,
    $AchievementsEarnedTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AchievementsEarnedTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AchievementsEarnedTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AchievementsEarnedTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> code = const Value.absent(),
                Value<String> earnedDay = const Value.absent(),
                Value<bool> celebrated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsEarnedCompanion(
                code: code,
                earnedDay: earnedDay,
                celebrated: celebrated,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String code,
                required String earnedDay,
                Value<bool> celebrated = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AchievementsEarnedCompanion.insert(
                code: code,
                earnedDay: earnedDay,
                celebrated: celebrated,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AchievementsEarnedTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $AchievementsEarnedTable,
      AchievementEarned,
      $$AchievementsEarnedTableFilterComposer,
      $$AchievementsEarnedTableOrderingComposer,
      $$AchievementsEarnedTableAnnotationComposer,
      $$AchievementsEarnedTableCreateCompanionBuilder,
      $$AchievementsEarnedTableUpdateCompanionBuilder,
      (
        AchievementEarned,
        BaseReferences<
          _$LiltDatabase,
          $AchievementsEarnedTable,
          AchievementEarned
        >,
      ),
      AchievementEarned,
      PrefetchHooks Function()
    >;
typedef $$NotificationSettingsTableCreateCompanionBuilder =
    NotificationSettingsCompanion Function({
      Value<String> id,
      Value<bool> enabled,
      Value<String> mode,
      Value<String?> fixedTime,
      Value<int> leadMin,
      Value<String> quietStart,
      Value<String> quietEnd,
      Value<bool> lapseCheckinEnabled,
      Value<int> rowid,
    });
typedef $$NotificationSettingsTableUpdateCompanionBuilder =
    NotificationSettingsCompanion Function({
      Value<String> id,
      Value<bool> enabled,
      Value<String> mode,
      Value<String?> fixedTime,
      Value<int> leadMin,
      Value<String> quietStart,
      Value<String> quietEnd,
      Value<bool> lapseCheckinEnabled,
      Value<int> rowid,
    });

class $$NotificationSettingsTableFilterComposer
    extends Composer<_$LiltDatabase, $NotificationSettingsTable> {
  $$NotificationSettingsTableFilterComposer({
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

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fixedTime => $composableBuilder(
    column: $table.fixedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leadMin => $composableBuilder(
    column: $table.leadMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quietStart => $composableBuilder(
    column: $table.quietStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quietEnd => $composableBuilder(
    column: $table.quietEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lapseCheckinEnabled => $composableBuilder(
    column: $table.lapseCheckinEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationSettingsTableOrderingComposer
    extends Composer<_$LiltDatabase, $NotificationSettingsTable> {
  $$NotificationSettingsTableOrderingComposer({
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

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fixedTime => $composableBuilder(
    column: $table.fixedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leadMin => $composableBuilder(
    column: $table.leadMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quietStart => $composableBuilder(
    column: $table.quietStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quietEnd => $composableBuilder(
    column: $table.quietEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lapseCheckinEnabled => $composableBuilder(
    column: $table.lapseCheckinEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationSettingsTableAnnotationComposer
    extends Composer<_$LiltDatabase, $NotificationSettingsTable> {
  $$NotificationSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<String> get fixedTime =>
      $composableBuilder(column: $table.fixedTime, builder: (column) => column);

  GeneratedColumn<int> get leadMin =>
      $composableBuilder(column: $table.leadMin, builder: (column) => column);

  GeneratedColumn<String> get quietStart => $composableBuilder(
    column: $table.quietStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get quietEnd =>
      $composableBuilder(column: $table.quietEnd, builder: (column) => column);

  GeneratedColumn<bool> get lapseCheckinEnabled => $composableBuilder(
    column: $table.lapseCheckinEnabled,
    builder: (column) => column,
  );
}

class $$NotificationSettingsTableTableManager
    extends
        RootTableManager<
          _$LiltDatabase,
          $NotificationSettingsTable,
          NotificationSetting,
          $$NotificationSettingsTableFilterComposer,
          $$NotificationSettingsTableOrderingComposer,
          $$NotificationSettingsTableAnnotationComposer,
          $$NotificationSettingsTableCreateCompanionBuilder,
          $$NotificationSettingsTableUpdateCompanionBuilder,
          (
            NotificationSetting,
            BaseReferences<
              _$LiltDatabase,
              $NotificationSettingsTable,
              NotificationSetting
            >,
          ),
          NotificationSetting,
          PrefetchHooks Function()
        > {
  $$NotificationSettingsTableTableManager(
    _$LiltDatabase db,
    $NotificationSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationSettingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> fixedTime = const Value.absent(),
                Value<int> leadMin = const Value.absent(),
                Value<String> quietStart = const Value.absent(),
                Value<String> quietEnd = const Value.absent(),
                Value<bool> lapseCheckinEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationSettingsCompanion(
                id: id,
                enabled: enabled,
                mode: mode,
                fixedTime: fixedTime,
                leadMin: leadMin,
                quietStart: quietStart,
                quietEnd: quietEnd,
                lapseCheckinEnabled: lapseCheckinEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<String?> fixedTime = const Value.absent(),
                Value<int> leadMin = const Value.absent(),
                Value<String> quietStart = const Value.absent(),
                Value<String> quietEnd = const Value.absent(),
                Value<bool> lapseCheckinEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationSettingsCompanion.insert(
                id: id,
                enabled: enabled,
                mode: mode,
                fixedTime: fixedTime,
                leadMin: leadMin,
                quietStart: quietStart,
                quietEnd: quietEnd,
                lapseCheckinEnabled: lapseCheckinEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$LiltDatabase,
      $NotificationSettingsTable,
      NotificationSetting,
      $$NotificationSettingsTableFilterComposer,
      $$NotificationSettingsTableOrderingComposer,
      $$NotificationSettingsTableAnnotationComposer,
      $$NotificationSettingsTableCreateCompanionBuilder,
      $$NotificationSettingsTableUpdateCompanionBuilder,
      (
        NotificationSetting,
        BaseReferences<
          _$LiltDatabase,
          $NotificationSettingsTable,
          NotificationSetting
        >,
      ),
      NotificationSetting,
      PrefetchHooks Function()
    >;

class $LiltDatabaseManager {
  final _$LiltDatabase _db;
  $LiltDatabaseManager(this._db);
  $$ConsentRecordsTableTableManager get consentRecords =>
      $$ConsentRecordsTableTableManager(_db, _db.consentRecords);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$FollowedActivitiesTableTableManager get followedActivities =>
      $$FollowedActivitiesTableTableManager(_db, _db.followedActivities);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
  $$ActionsTableTableManager get actions =>
      $$ActionsTableTableManager(_db, _db.actions);
  $$OptionOffersTableTableManager get optionOffers =>
      $$OptionOffersTableTableManager(_db, _db.optionOffers);
  $$OfferReasonsTableTableManager get offerReasons =>
      $$OfferReasonsTableTableManager(_db, _db.offerReasons);
  $$PlanItemsTableTableManager get planItems =>
      $$PlanItemsTableTableManager(_db, _db.planItems);
  $$ReflectionsTableTableManager get reflections =>
      $$ReflectionsTableTableManager(_db, _db.reflections);
  $$PausesTableTableManager get pauses =>
      $$PausesTableTableManager(_db, _db.pauses);
  $$ObservationsTableTableManager get observations =>
      $$ObservationsTableTableManager(_db, _db.observations);
  $$SavedActionsTableTableManager get savedActions =>
      $$SavedActionsTableTableManager(_db, _db.savedActions);
  $$ReturnEventsTableTableManager get returnEvents =>
      $$ReturnEventsTableTableManager(_db, _db.returnEvents);
  $$AchievementsEarnedTableTableManager get achievementsEarned =>
      $$AchievementsEarnedTableTableManager(_db, _db.achievementsEarned);
  $$NotificationSettingsTableTableManager get notificationSettings =>
      $$NotificationSettingsTableTableManager(_db, _db.notificationSettings);
}
