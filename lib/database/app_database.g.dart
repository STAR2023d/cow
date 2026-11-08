// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CowTable extends Cow with TableInfo<$CowTable, CowData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CowTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _breedMeta = const VerificationMeta('breed');
  @override
  late final GeneratedColumn<String> breed = GeneratedColumn<String>(
    'breed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _parentCowIdMeta = const VerificationMeta(
    'parentCowId',
  );
  @override
  late final GeneratedColumn<int> parentCowId = GeneratedColumn<int>(
    'parent_cow_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cow (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    tag,
    breed,
    age,
    imagePath,
    parentCowId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cow';
  @override
  VerificationContext validateIntegrity(
    Insertable<CowData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    }
    if (data.containsKey('breed')) {
      context.handle(
        _breedMeta,
        breed.isAcceptableOrUnknown(data['breed']!, _breedMeta),
      );
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('parent_cow_id')) {
      context.handle(
        _parentCowIdMeta,
        parentCowId.isAcceptableOrUnknown(
          data['parent_cow_id']!,
          _parentCowIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CowData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CowData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      ),
      breed: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}breed'],
      ),
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      parentCowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_cow_id'],
      ),
    );
  }

  @override
  $CowTable createAlias(String alias) {
    return $CowTable(attachedDatabase, alias);
  }
}

class CowData extends DataClass implements Insertable<CowData> {
  final int id;
  final String name;
  final String? tag;
  final String? breed;
  final int? age;
  final String? imagePath;
  final int? parentCowId;
  const CowData({
    required this.id,
    required this.name,
    this.tag,
    this.breed,
    this.age,
    this.imagePath,
    this.parentCowId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || tag != null) {
      map['tag'] = Variable<String>(tag);
    }
    if (!nullToAbsent || breed != null) {
      map['breed'] = Variable<String>(breed);
    }
    if (!nullToAbsent || age != null) {
      map['age'] = Variable<int>(age);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || parentCowId != null) {
      map['parent_cow_id'] = Variable<int>(parentCowId);
    }
    return map;
  }

  CowCompanion toCompanion(bool nullToAbsent) {
    return CowCompanion(
      id: Value(id),
      name: Value(name),
      tag: tag == null && nullToAbsent ? const Value.absent() : Value(tag),
      breed: breed == null && nullToAbsent
          ? const Value.absent()
          : Value(breed),
      age: age == null && nullToAbsent ? const Value.absent() : Value(age),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      parentCowId: parentCowId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentCowId),
    );
  }

  factory CowData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CowData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      tag: serializer.fromJson<String?>(json['tag']),
      breed: serializer.fromJson<String?>(json['breed']),
      age: serializer.fromJson<int?>(json['age']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      parentCowId: serializer.fromJson<int?>(json['parentCowId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'tag': serializer.toJson<String?>(tag),
      'breed': serializer.toJson<String?>(breed),
      'age': serializer.toJson<int?>(age),
      'imagePath': serializer.toJson<String?>(imagePath),
      'parentCowId': serializer.toJson<int?>(parentCowId),
    };
  }

  CowData copyWith({
    int? id,
    String? name,
    Value<String?> tag = const Value.absent(),
    Value<String?> breed = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<int?> parentCowId = const Value.absent(),
  }) => CowData(
    id: id ?? this.id,
    name: name ?? this.name,
    tag: tag.present ? tag.value : this.tag,
    breed: breed.present ? breed.value : this.breed,
    age: age.present ? age.value : this.age,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    parentCowId: parentCowId.present ? parentCowId.value : this.parentCowId,
  );
  CowData copyWithCompanion(CowCompanion data) {
    return CowData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      tag: data.tag.present ? data.tag.value : this.tag,
      breed: data.breed.present ? data.breed.value : this.breed,
      age: data.age.present ? data.age.value : this.age,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      parentCowId: data.parentCowId.present
          ? data.parentCowId.value
          : this.parentCowId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CowData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tag: $tag, ')
          ..write('breed: $breed, ')
          ..write('age: $age, ')
          ..write('imagePath: $imagePath, ')
          ..write('parentCowId: $parentCowId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, tag, breed, age, imagePath, parentCowId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CowData &&
          other.id == this.id &&
          other.name == this.name &&
          other.tag == this.tag &&
          other.breed == this.breed &&
          other.age == this.age &&
          other.imagePath == this.imagePath &&
          other.parentCowId == this.parentCowId);
}

class CowCompanion extends UpdateCompanion<CowData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> tag;
  final Value<String?> breed;
  final Value<int?> age;
  final Value<String?> imagePath;
  final Value<int?> parentCowId;
  const CowCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.tag = const Value.absent(),
    this.breed = const Value.absent(),
    this.age = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.parentCowId = const Value.absent(),
  });
  CowCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.tag = const Value.absent(),
    this.breed = const Value.absent(),
    this.age = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.parentCowId = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CowData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? tag,
    Expression<String>? breed,
    Expression<int>? age,
    Expression<String>? imagePath,
    Expression<int>? parentCowId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (tag != null) 'tag': tag,
      if (breed != null) 'breed': breed,
      if (age != null) 'age': age,
      if (imagePath != null) 'image_path': imagePath,
      if (parentCowId != null) 'parent_cow_id': parentCowId,
    });
  }

  CowCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? tag,
    Value<String?>? breed,
    Value<int?>? age,
    Value<String?>? imagePath,
    Value<int?>? parentCowId,
  }) {
    return CowCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      tag: tag ?? this.tag,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      imagePath: imagePath ?? this.imagePath,
      parentCowId: parentCowId ?? this.parentCowId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    if (breed.present) {
      map['breed'] = Variable<String>(breed.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (parentCowId.present) {
      map['parent_cow_id'] = Variable<int>(parentCowId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CowCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('tag: $tag, ')
          ..write('breed: $breed, ')
          ..write('age: $age, ')
          ..write('imagePath: $imagePath, ')
          ..write('parentCowId: $parentCowId')
          ..write(')'))
        .toString();
  }
}

class $MilkTableTable extends MilkTable
    with TableInfo<$MilkTableTable, MilkTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilkTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entryDateMeta = const VerificationMeta(
    'entryDate',
  );
  @override
  late final GeneratedColumn<DateTime> entryDate = GeneratedColumn<DateTime>(
    'entry_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionMeta = const VerificationMeta(
    'session',
  );
  @override
  late final GeneratedColumn<String> session = GeneratedColumn<String>(
    'session',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cowIdMeta = const VerificationMeta('cowId');
  @override
  late final GeneratedColumn<int> cowId = GeneratedColumn<int>(
    'cow_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cow (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryDate, session, amount, cowId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milk_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilkTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entry_date')) {
      context.handle(
        _entryDateMeta,
        entryDate.isAcceptableOrUnknown(data['entry_date']!, _entryDateMeta),
      );
    } else if (isInserting) {
      context.missing(_entryDateMeta);
    }
    if (data.containsKey('session')) {
      context.handle(
        _sessionMeta,
        session.isAcceptableOrUnknown(data['session']!, _sessionMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('cow_id')) {
      context.handle(
        _cowIdMeta,
        cowId.isAcceptableOrUnknown(data['cow_id']!, _cowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cowIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MilkTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilkTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entryDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}entry_date'],
      )!,
      session: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      cowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cow_id'],
      )!,
    );
  }

  @override
  $MilkTableTable createAlias(String alias) {
    return $MilkTableTable(attachedDatabase, alias);
  }
}

class MilkTableData extends DataClass implements Insertable<MilkTableData> {
  final String id;
  final DateTime entryDate;
  final String session;
  final double amount;
  final int cowId;
  const MilkTableData({
    required this.id,
    required this.entryDate,
    required this.session,
    required this.amount,
    required this.cowId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entry_date'] = Variable<DateTime>(entryDate);
    map['session'] = Variable<String>(session);
    map['amount'] = Variable<double>(amount);
    map['cow_id'] = Variable<int>(cowId);
    return map;
  }

  MilkTableCompanion toCompanion(bool nullToAbsent) {
    return MilkTableCompanion(
      id: Value(id),
      entryDate: Value(entryDate),
      session: Value(session),
      amount: Value(amount),
      cowId: Value(cowId),
    );
  }

  factory MilkTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilkTableData(
      id: serializer.fromJson<String>(json['id']),
      entryDate: serializer.fromJson<DateTime>(json['entryDate']),
      session: serializer.fromJson<String>(json['session']),
      amount: serializer.fromJson<double>(json['amount']),
      cowId: serializer.fromJson<int>(json['cowId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entryDate': serializer.toJson<DateTime>(entryDate),
      'session': serializer.toJson<String>(session),
      'amount': serializer.toJson<double>(amount),
      'cowId': serializer.toJson<int>(cowId),
    };
  }

  MilkTableData copyWith({
    String? id,
    DateTime? entryDate,
    String? session,
    double? amount,
    int? cowId,
  }) => MilkTableData(
    id: id ?? this.id,
    entryDate: entryDate ?? this.entryDate,
    session: session ?? this.session,
    amount: amount ?? this.amount,
    cowId: cowId ?? this.cowId,
  );
  MilkTableData copyWithCompanion(MilkTableCompanion data) {
    return MilkTableData(
      id: data.id.present ? data.id.value : this.id,
      entryDate: data.entryDate.present ? data.entryDate.value : this.entryDate,
      session: data.session.present ? data.session.value : this.session,
      amount: data.amount.present ? data.amount.value : this.amount,
      cowId: data.cowId.present ? data.cowId.value : this.cowId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilkTableData(')
          ..write('id: $id, ')
          ..write('entryDate: $entryDate, ')
          ..write('session: $session, ')
          ..write('amount: $amount, ')
          ..write('cowId: $cowId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, entryDate, session, amount, cowId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilkTableData &&
          other.id == this.id &&
          other.entryDate == this.entryDate &&
          other.session == this.session &&
          other.amount == this.amount &&
          other.cowId == this.cowId);
}

class MilkTableCompanion extends UpdateCompanion<MilkTableData> {
  final Value<String> id;
  final Value<DateTime> entryDate;
  final Value<String> session;
  final Value<double> amount;
  final Value<int> cowId;
  final Value<int> rowid;
  const MilkTableCompanion({
    this.id = const Value.absent(),
    this.entryDate = const Value.absent(),
    this.session = const Value.absent(),
    this.amount = const Value.absent(),
    this.cowId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MilkTableCompanion.insert({
    required String id,
    required DateTime entryDate,
    required String session,
    required double amount,
    required int cowId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entryDate = Value(entryDate),
       session = Value(session),
       amount = Value(amount),
       cowId = Value(cowId);
  static Insertable<MilkTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? entryDate,
    Expression<String>? session,
    Expression<double>? amount,
    Expression<int>? cowId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryDate != null) 'entry_date': entryDate,
      if (session != null) 'session': session,
      if (amount != null) 'amount': amount,
      if (cowId != null) 'cow_id': cowId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MilkTableCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? entryDate,
    Value<String>? session,
    Value<double>? amount,
    Value<int>? cowId,
    Value<int>? rowid,
  }) {
    return MilkTableCompanion(
      id: id ?? this.id,
      entryDate: entryDate ?? this.entryDate,
      session: session ?? this.session,
      amount: amount ?? this.amount,
      cowId: cowId ?? this.cowId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entryDate.present) {
      map['entry_date'] = Variable<DateTime>(entryDate.value);
    }
    if (session.present) {
      map['session'] = Variable<String>(session.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (cowId.present) {
      map['cow_id'] = Variable<int>(cowId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilkTableCompanion(')
          ..write('id: $id, ')
          ..write('entryDate: $entryDate, ')
          ..write('session: $session, ')
          ..write('amount: $amount, ')
          ..write('cowId: $cowId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PriceSettingsTable extends PriceSettings
    with TableInfo<$PriceSettingsTable, PriceSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PriceSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _effectiveDateMeta = const VerificationMeta(
    'effectiveDate',
  );
  @override
  late final GeneratedColumn<DateTime> effectiveDate =
      GeneratedColumn<DateTime>(
        'effective_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _pricePerLitreMeta = const VerificationMeta(
    'pricePerLitre',
  );
  @override
  late final GeneratedColumn<double> pricePerLitre = GeneratedColumn<double>(
    'price_per_litre',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, effectiveDate, pricePerLitre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'price_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<PriceSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('effective_date')) {
      context.handle(
        _effectiveDateMeta,
        effectiveDate.isAcceptableOrUnknown(
          data['effective_date']!,
          _effectiveDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_effectiveDateMeta);
    }
    if (data.containsKey('price_per_litre')) {
      context.handle(
        _pricePerLitreMeta,
        pricePerLitre.isAcceptableOrUnknown(
          data['price_per_litre']!,
          _pricePerLitreMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pricePerLitreMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PriceSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PriceSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      effectiveDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}effective_date'],
      )!,
      pricePerLitre: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_litre'],
      )!,
    );
  }

  @override
  $PriceSettingsTable createAlias(String alias) {
    return $PriceSettingsTable(attachedDatabase, alias);
  }
}

class PriceSetting extends DataClass implements Insertable<PriceSetting> {
  final int id;
  final DateTime effectiveDate;
  final double pricePerLitre;
  const PriceSetting({
    required this.id,
    required this.effectiveDate,
    required this.pricePerLitre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['effective_date'] = Variable<DateTime>(effectiveDate);
    map['price_per_litre'] = Variable<double>(pricePerLitre);
    return map;
  }

  PriceSettingsCompanion toCompanion(bool nullToAbsent) {
    return PriceSettingsCompanion(
      id: Value(id),
      effectiveDate: Value(effectiveDate),
      pricePerLitre: Value(pricePerLitre),
    );
  }

  factory PriceSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PriceSetting(
      id: serializer.fromJson<int>(json['id']),
      effectiveDate: serializer.fromJson<DateTime>(json['effectiveDate']),
      pricePerLitre: serializer.fromJson<double>(json['pricePerLitre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'effectiveDate': serializer.toJson<DateTime>(effectiveDate),
      'pricePerLitre': serializer.toJson<double>(pricePerLitre),
    };
  }

  PriceSetting copyWith({
    int? id,
    DateTime? effectiveDate,
    double? pricePerLitre,
  }) => PriceSetting(
    id: id ?? this.id,
    effectiveDate: effectiveDate ?? this.effectiveDate,
    pricePerLitre: pricePerLitre ?? this.pricePerLitre,
  );
  PriceSetting copyWithCompanion(PriceSettingsCompanion data) {
    return PriceSetting(
      id: data.id.present ? data.id.value : this.id,
      effectiveDate: data.effectiveDate.present
          ? data.effectiveDate.value
          : this.effectiveDate,
      pricePerLitre: data.pricePerLitre.present
          ? data.pricePerLitre.value
          : this.pricePerLitre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PriceSetting(')
          ..write('id: $id, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('pricePerLitre: $pricePerLitre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, effectiveDate, pricePerLitre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PriceSetting &&
          other.id == this.id &&
          other.effectiveDate == this.effectiveDate &&
          other.pricePerLitre == this.pricePerLitre);
}

class PriceSettingsCompanion extends UpdateCompanion<PriceSetting> {
  final Value<int> id;
  final Value<DateTime> effectiveDate;
  final Value<double> pricePerLitre;
  const PriceSettingsCompanion({
    this.id = const Value.absent(),
    this.effectiveDate = const Value.absent(),
    this.pricePerLitre = const Value.absent(),
  });
  PriceSettingsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime effectiveDate,
    required double pricePerLitre,
  }) : effectiveDate = Value(effectiveDate),
       pricePerLitre = Value(pricePerLitre);
  static Insertable<PriceSetting> custom({
    Expression<int>? id,
    Expression<DateTime>? effectiveDate,
    Expression<double>? pricePerLitre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (effectiveDate != null) 'effective_date': effectiveDate,
      if (pricePerLitre != null) 'price_per_litre': pricePerLitre,
    });
  }

  PriceSettingsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? effectiveDate,
    Value<double>? pricePerLitre,
  }) {
    return PriceSettingsCompanion(
      id: id ?? this.id,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      pricePerLitre: pricePerLitre ?? this.pricePerLitre,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (effectiveDate.present) {
      map['effective_date'] = Variable<DateTime>(effectiveDate.value);
    }
    if (pricePerLitre.present) {
      map['price_per_litre'] = Variable<double>(pricePerLitre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PriceSettingsCompanion(')
          ..write('id: $id, ')
          ..write('effectiveDate: $effectiveDate, ')
          ..write('pricePerLitre: $pricePerLitre')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('other'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    description,
    amount,
    category,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
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
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final DateTime date;
  final String description;
  final double amount;
  final String category;
  const Expense({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
    required this.category,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    map['category'] = Variable<String>(category);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      description: Value(description),
      amount: Value(amount),
      category: Value(category),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      description: serializer.fromJson<String>(json['description']),
      amount: serializer.fromJson<double>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'description': serializer.toJson<String>(description),
      'amount': serializer.toJson<double>(amount),
      'category': serializer.toJson<String>(category),
    };
  }

  Expense copyWith({
    int? id,
    DateTime? date,
    String? description,
    double? amount,
    String? category,
  }) => Expense(
    id: id ?? this.id,
    date: date ?? this.date,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    category: category ?? this.category,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, description, amount, category);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.description == this.description &&
          other.amount == this.amount &&
          other.category == this.category);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> description;
  final Value<double> amount;
  final Value<String> category;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String description,
    required double amount,
    this.category = const Value.absent(),
  }) : date = Value(date),
       description = Value(description),
       amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<double>? amount,
    Expression<String>? category,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? description,
    Value<double>? amount,
    Value<String>? category,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('amount: $amount, ')
          ..write('category: $category')
          ..write(')'))
        .toString();
  }
}

class $FeedingLogTable extends FeedingLog
    with TableInfo<$FeedingLogTable, FeedingLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeedingLogTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feedTypeMeta = const VerificationMeta(
    'feedType',
  );
  @override
  late final GeneratedColumn<String> feedType = GeneratedColumn<String>(
    'feed_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityKgMeta = const VerificationMeta(
    'quantityKg',
  );
  @override
  late final GeneratedColumn<double> quantityKg = GeneratedColumn<double>(
    'quantity_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cowIdMeta = const VerificationMeta('cowId');
  @override
  late final GeneratedColumn<int> cowId = GeneratedColumn<int>(
    'cow_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cow (id)',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    feedType,
    quantityKg,
    cowId,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feeding_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeedingLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('feed_type')) {
      context.handle(
        _feedTypeMeta,
        feedType.isAcceptableOrUnknown(data['feed_type']!, _feedTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_feedTypeMeta);
    }
    if (data.containsKey('quantity_kg')) {
      context.handle(
        _quantityKgMeta,
        quantityKg.isAcceptableOrUnknown(data['quantity_kg']!, _quantityKgMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityKgMeta);
    }
    if (data.containsKey('cow_id')) {
      context.handle(
        _cowIdMeta,
        cowId.isAcceptableOrUnknown(data['cow_id']!, _cowIdMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeedingLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeedingLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      feedType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feed_type'],
      )!,
      quantityKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_kg'],
      )!,
      cowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cow_id'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $FeedingLogTable createAlias(String alias) {
    return $FeedingLogTable(attachedDatabase, alias);
  }
}

class FeedingLogData extends DataClass implements Insertable<FeedingLogData> {
  final int id;
  final DateTime date;
  final String feedType;
  final double quantityKg;
  final int? cowId;
  final String? notes;
  const FeedingLogData({
    required this.id,
    required this.date,
    required this.feedType,
    required this.quantityKg,
    this.cowId,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['feed_type'] = Variable<String>(feedType);
    map['quantity_kg'] = Variable<double>(quantityKg);
    if (!nullToAbsent || cowId != null) {
      map['cow_id'] = Variable<int>(cowId);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  FeedingLogCompanion toCompanion(bool nullToAbsent) {
    return FeedingLogCompanion(
      id: Value(id),
      date: Value(date),
      feedType: Value(feedType),
      quantityKg: Value(quantityKg),
      cowId: cowId == null && nullToAbsent
          ? const Value.absent()
          : Value(cowId),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory FeedingLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeedingLogData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      feedType: serializer.fromJson<String>(json['feedType']),
      quantityKg: serializer.fromJson<double>(json['quantityKg']),
      cowId: serializer.fromJson<int?>(json['cowId']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'feedType': serializer.toJson<String>(feedType),
      'quantityKg': serializer.toJson<double>(quantityKg),
      'cowId': serializer.toJson<int?>(cowId),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  FeedingLogData copyWith({
    int? id,
    DateTime? date,
    String? feedType,
    double? quantityKg,
    Value<int?> cowId = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => FeedingLogData(
    id: id ?? this.id,
    date: date ?? this.date,
    feedType: feedType ?? this.feedType,
    quantityKg: quantityKg ?? this.quantityKg,
    cowId: cowId.present ? cowId.value : this.cowId,
    notes: notes.present ? notes.value : this.notes,
  );
  FeedingLogData copyWithCompanion(FeedingLogCompanion data) {
    return FeedingLogData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      feedType: data.feedType.present ? data.feedType.value : this.feedType,
      quantityKg: data.quantityKg.present
          ? data.quantityKg.value
          : this.quantityKg,
      cowId: data.cowId.present ? data.cowId.value : this.cowId,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeedingLogData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('feedType: $feedType, ')
          ..write('quantityKg: $quantityKg, ')
          ..write('cowId: $cowId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, feedType, quantityKg, cowId, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeedingLogData &&
          other.id == this.id &&
          other.date == this.date &&
          other.feedType == this.feedType &&
          other.quantityKg == this.quantityKg &&
          other.cowId == this.cowId &&
          other.notes == this.notes);
}

class FeedingLogCompanion extends UpdateCompanion<FeedingLogData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> feedType;
  final Value<double> quantityKg;
  final Value<int?> cowId;
  final Value<String?> notes;
  const FeedingLogCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.feedType = const Value.absent(),
    this.quantityKg = const Value.absent(),
    this.cowId = const Value.absent(),
    this.notes = const Value.absent(),
  });
  FeedingLogCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String feedType,
    required double quantityKg,
    this.cowId = const Value.absent(),
    this.notes = const Value.absent(),
  }) : date = Value(date),
       feedType = Value(feedType),
       quantityKg = Value(quantityKg);
  static Insertable<FeedingLogData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? feedType,
    Expression<double>? quantityKg,
    Expression<int>? cowId,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (feedType != null) 'feed_type': feedType,
      if (quantityKg != null) 'quantity_kg': quantityKg,
      if (cowId != null) 'cow_id': cowId,
      if (notes != null) 'notes': notes,
    });
  }

  FeedingLogCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? feedType,
    Value<double>? quantityKg,
    Value<int?>? cowId,
    Value<String?>? notes,
  }) {
    return FeedingLogCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      feedType: feedType ?? this.feedType,
      quantityKg: quantityKg ?? this.quantityKg,
      cowId: cowId ?? this.cowId,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (feedType.present) {
      map['feed_type'] = Variable<String>(feedType.value);
    }
    if (quantityKg.present) {
      map['quantity_kg'] = Variable<double>(quantityKg.value);
    }
    if (cowId.present) {
      map['cow_id'] = Variable<int>(cowId.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeedingLogCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('feedType: $feedType, ')
          ..write('quantityKg: $quantityKg, ')
          ..write('cowId: $cowId, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $HealthRecordTable extends HealthRecord
    with TableInfo<$HealthRecordTable, HealthRecordData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HealthRecordTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cowIdMeta = const VerificationMeta('cowId');
  @override
  late final GeneratedColumn<int> cowId = GeneratedColumn<int>(
    'cow_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cow (id)',
    ),
  );
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
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
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 300,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _followUpDateMeta = const VerificationMeta(
    'followUpDate',
  );
  @override
  late final GeneratedColumn<DateTime> followUpDate = GeneratedColumn<DateTime>(
    'follow_up_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    cowId,
    recordType,
    description,
    followUpDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'health_record';
  @override
  VerificationContext validateIntegrity(
    Insertable<HealthRecordData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('cow_id')) {
      context.handle(
        _cowIdMeta,
        cowId.isAcceptableOrUnknown(data['cow_id']!, _cowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cowIdMeta);
    }
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
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
    if (data.containsKey('follow_up_date')) {
      context.handle(
        _followUpDateMeta,
        followUpDate.isAcceptableOrUnknown(
          data['follow_up_date']!,
          _followUpDateMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HealthRecordData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HealthRecordData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      cowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cow_id'],
      )!,
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      followUpDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}follow_up_date'],
      ),
    );
  }

  @override
  $HealthRecordTable createAlias(String alias) {
    return $HealthRecordTable(attachedDatabase, alias);
  }
}

class HealthRecordData extends DataClass
    implements Insertable<HealthRecordData> {
  final int id;
  final DateTime date;
  final int cowId;
  final String recordType;
  final String description;
  final DateTime? followUpDate;
  const HealthRecordData({
    required this.id,
    required this.date,
    required this.cowId,
    required this.recordType,
    required this.description,
    this.followUpDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['cow_id'] = Variable<int>(cowId);
    map['record_type'] = Variable<String>(recordType);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || followUpDate != null) {
      map['follow_up_date'] = Variable<DateTime>(followUpDate);
    }
    return map;
  }

  HealthRecordCompanion toCompanion(bool nullToAbsent) {
    return HealthRecordCompanion(
      id: Value(id),
      date: Value(date),
      cowId: Value(cowId),
      recordType: Value(recordType),
      description: Value(description),
      followUpDate: followUpDate == null && nullToAbsent
          ? const Value.absent()
          : Value(followUpDate),
    );
  }

  factory HealthRecordData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HealthRecordData(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      cowId: serializer.fromJson<int>(json['cowId']),
      recordType: serializer.fromJson<String>(json['recordType']),
      description: serializer.fromJson<String>(json['description']),
      followUpDate: serializer.fromJson<DateTime?>(json['followUpDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'cowId': serializer.toJson<int>(cowId),
      'recordType': serializer.toJson<String>(recordType),
      'description': serializer.toJson<String>(description),
      'followUpDate': serializer.toJson<DateTime?>(followUpDate),
    };
  }

  HealthRecordData copyWith({
    int? id,
    DateTime? date,
    int? cowId,
    String? recordType,
    String? description,
    Value<DateTime?> followUpDate = const Value.absent(),
  }) => HealthRecordData(
    id: id ?? this.id,
    date: date ?? this.date,
    cowId: cowId ?? this.cowId,
    recordType: recordType ?? this.recordType,
    description: description ?? this.description,
    followUpDate: followUpDate.present ? followUpDate.value : this.followUpDate,
  );
  HealthRecordData copyWithCompanion(HealthRecordCompanion data) {
    return HealthRecordData(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      cowId: data.cowId.present ? data.cowId.value : this.cowId,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      description: data.description.present
          ? data.description.value
          : this.description,
      followUpDate: data.followUpDate.present
          ? data.followUpDate.value
          : this.followUpDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordData(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('cowId: $cowId, ')
          ..write('recordType: $recordType, ')
          ..write('description: $description, ')
          ..write('followUpDate: $followUpDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, date, cowId, recordType, description, followUpDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HealthRecordData &&
          other.id == this.id &&
          other.date == this.date &&
          other.cowId == this.cowId &&
          other.recordType == this.recordType &&
          other.description == this.description &&
          other.followUpDate == this.followUpDate);
}

class HealthRecordCompanion extends UpdateCompanion<HealthRecordData> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<int> cowId;
  final Value<String> recordType;
  final Value<String> description;
  final Value<DateTime?> followUpDate;
  const HealthRecordCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.cowId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.description = const Value.absent(),
    this.followUpDate = const Value.absent(),
  });
  HealthRecordCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required int cowId,
    required String recordType,
    required String description,
    this.followUpDate = const Value.absent(),
  }) : date = Value(date),
       cowId = Value(cowId),
       recordType = Value(recordType),
       description = Value(description);
  static Insertable<HealthRecordData> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<int>? cowId,
    Expression<String>? recordType,
    Expression<String>? description,
    Expression<DateTime>? followUpDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (cowId != null) 'cow_id': cowId,
      if (recordType != null) 'record_type': recordType,
      if (description != null) 'description': description,
      if (followUpDate != null) 'follow_up_date': followUpDate,
    });
  }

  HealthRecordCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<int>? cowId,
    Value<String>? recordType,
    Value<String>? description,
    Value<DateTime?>? followUpDate,
  }) {
    return HealthRecordCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      cowId: cowId ?? this.cowId,
      recordType: recordType ?? this.recordType,
      description: description ?? this.description,
      followUpDate: followUpDate ?? this.followUpDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (cowId.present) {
      map['cow_id'] = Variable<int>(cowId.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (followUpDate.present) {
      map['follow_up_date'] = Variable<DateTime>(followUpDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HealthRecordCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('cowId: $cowId, ')
          ..write('recordType: $recordType, ')
          ..write('description: $description, ')
          ..write('followUpDate: $followUpDate')
          ..write(')'))
        .toString();
  }
}

class $BreedingCyclesTable extends BreedingCycles
    with TableInfo<$BreedingCyclesTable, BreedingCycle> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BreedingCyclesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cowIdMeta = const VerificationMeta('cowId');
  @override
  late final GeneratedColumn<int> cowId = GeneratedColumn<int>(
    'cow_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cow (id)',
    ),
  );
  static const VerificationMeta _heatDateMeta = const VerificationMeta(
    'heatDate',
  );
  @override
  late final GeneratedColumn<DateTime> heatDate = GeneratedColumn<DateTime>(
    'heat_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serviceDateMeta = const VerificationMeta(
    'serviceDate',
  );
  @override
  late final GeneratedColumn<DateTime> serviceDate = GeneratedColumn<DateTime>(
    'service_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _check1DateMeta = const VerificationMeta(
    'check1Date',
  );
  @override
  late final GeneratedColumn<DateTime> check1Date = GeneratedColumn<DateTime>(
    'check1_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _check1ResultMeta = const VerificationMeta(
    'check1Result',
  );
  @override
  late final GeneratedColumn<bool> check1Result = GeneratedColumn<bool>(
    'check1_result',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("check1_result" IN (0, 1))',
    ),
  );
  static const VerificationMeta _check2DateMeta = const VerificationMeta(
    'check2Date',
  );
  @override
  late final GeneratedColumn<DateTime> check2Date = GeneratedColumn<DateTime>(
    'check2_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _check2ResultMeta = const VerificationMeta(
    'check2Result',
  );
  @override
  late final GeneratedColumn<bool> check2Result = GeneratedColumn<bool>(
    'check2_result',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("check2_result" IN (0, 1))',
    ),
  );
  static const VerificationMeta _check3DateMeta = const VerificationMeta(
    'check3Date',
  );
  @override
  late final GeneratedColumn<DateTime> check3Date = GeneratedColumn<DateTime>(
    'check3_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _check3ResultMeta = const VerificationMeta(
    'check3Result',
  );
  @override
  late final GeneratedColumn<bool> check3Result = GeneratedColumn<bool>(
    'check3_result',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("check3_result" IN (0, 1))',
    ),
  );
  static const VerificationMeta _gestationDaysMeta = const VerificationMeta(
    'gestationDays',
  );
  @override
  late final GeneratedColumn<int> gestationDays = GeneratedColumn<int>(
    'gestation_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(283),
  );
  static const VerificationMeta _expectedCalvingDateMeta =
      const VerificationMeta('expectedCalvingDate');
  @override
  late final GeneratedColumn<DateTime> expectedCalvingDate =
      GeneratedColumn<DateTime>(
        'expected_calving_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _actualCalvingDateMeta = const VerificationMeta(
    'actualCalvingDate',
  );
  @override
  late final GeneratedColumn<DateTime> actualCalvingDate =
      GeneratedColumn<DateTime>(
        'actual_calving_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _calfSexMeta = const VerificationMeta(
    'calfSex',
  );
  @override
  late final GeneratedColumn<String> calfSex = GeneratedColumn<String>(
    'calf_sex',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _calfCowIdMeta = const VerificationMeta(
    'calfCowId',
  );
  @override
  late final GeneratedColumn<int> calfCowId = GeneratedColumn<int>(
    'calf_cow_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cow (id)',
    ),
  );
  static const VerificationMeta _soldMeta = const VerificationMeta('sold');
  @override
  late final GeneratedColumn<bool> sold = GeneratedColumn<bool>(
    'sold',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sold" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _saleAmountMeta = const VerificationMeta(
    'saleAmount',
  );
  @override
  late final GeneratedColumn<double> saleAmount = GeneratedColumn<double>(
    'sale_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saleDateMeta = const VerificationMeta(
    'saleDate',
  );
  @override
  late final GeneratedColumn<DateTime> saleDate = GeneratedColumn<DateTime>(
    'sale_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<BreedingStage, int> stage =
      GeneratedColumn<int>(
        'stage',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<BreedingStage>($BreedingCyclesTable.$converterstage);
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cowId,
    heatDate,
    serviceDate,
    check1Date,
    check1Result,
    check2Date,
    check2Result,
    check3Date,
    check3Result,
    gestationDays,
    expectedCalvingDate,
    actualCalvingDate,
    calfSex,
    calfCowId,
    sold,
    saleAmount,
    saleDate,
    stage,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'breeding_cycles';
  @override
  VerificationContext validateIntegrity(
    Insertable<BreedingCycle> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cow_id')) {
      context.handle(
        _cowIdMeta,
        cowId.isAcceptableOrUnknown(data['cow_id']!, _cowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cowIdMeta);
    }
    if (data.containsKey('heat_date')) {
      context.handle(
        _heatDateMeta,
        heatDate.isAcceptableOrUnknown(data['heat_date']!, _heatDateMeta),
      );
    } else if (isInserting) {
      context.missing(_heatDateMeta);
    }
    if (data.containsKey('service_date')) {
      context.handle(
        _serviceDateMeta,
        serviceDate.isAcceptableOrUnknown(
          data['service_date']!,
          _serviceDateMeta,
        ),
      );
    }
    if (data.containsKey('check1_date')) {
      context.handle(
        _check1DateMeta,
        check1Date.isAcceptableOrUnknown(data['check1_date']!, _check1DateMeta),
      );
    }
    if (data.containsKey('check1_result')) {
      context.handle(
        _check1ResultMeta,
        check1Result.isAcceptableOrUnknown(
          data['check1_result']!,
          _check1ResultMeta,
        ),
      );
    }
    if (data.containsKey('check2_date')) {
      context.handle(
        _check2DateMeta,
        check2Date.isAcceptableOrUnknown(data['check2_date']!, _check2DateMeta),
      );
    }
    if (data.containsKey('check2_result')) {
      context.handle(
        _check2ResultMeta,
        check2Result.isAcceptableOrUnknown(
          data['check2_result']!,
          _check2ResultMeta,
        ),
      );
    }
    if (data.containsKey('check3_date')) {
      context.handle(
        _check3DateMeta,
        check3Date.isAcceptableOrUnknown(data['check3_date']!, _check3DateMeta),
      );
    }
    if (data.containsKey('check3_result')) {
      context.handle(
        _check3ResultMeta,
        check3Result.isAcceptableOrUnknown(
          data['check3_result']!,
          _check3ResultMeta,
        ),
      );
    }
    if (data.containsKey('gestation_days')) {
      context.handle(
        _gestationDaysMeta,
        gestationDays.isAcceptableOrUnknown(
          data['gestation_days']!,
          _gestationDaysMeta,
        ),
      );
    }
    if (data.containsKey('expected_calving_date')) {
      context.handle(
        _expectedCalvingDateMeta,
        expectedCalvingDate.isAcceptableOrUnknown(
          data['expected_calving_date']!,
          _expectedCalvingDateMeta,
        ),
      );
    }
    if (data.containsKey('actual_calving_date')) {
      context.handle(
        _actualCalvingDateMeta,
        actualCalvingDate.isAcceptableOrUnknown(
          data['actual_calving_date']!,
          _actualCalvingDateMeta,
        ),
      );
    }
    if (data.containsKey('calf_sex')) {
      context.handle(
        _calfSexMeta,
        calfSex.isAcceptableOrUnknown(data['calf_sex']!, _calfSexMeta),
      );
    }
    if (data.containsKey('calf_cow_id')) {
      context.handle(
        _calfCowIdMeta,
        calfCowId.isAcceptableOrUnknown(data['calf_cow_id']!, _calfCowIdMeta),
      );
    }
    if (data.containsKey('sold')) {
      context.handle(
        _soldMeta,
        sold.isAcceptableOrUnknown(data['sold']!, _soldMeta),
      );
    }
    if (data.containsKey('sale_amount')) {
      context.handle(
        _saleAmountMeta,
        saleAmount.isAcceptableOrUnknown(data['sale_amount']!, _saleAmountMeta),
      );
    }
    if (data.containsKey('sale_date')) {
      context.handle(
        _saleDateMeta,
        saleDate.isAcceptableOrUnknown(data['sale_date']!, _saleDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
  BreedingCycle map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BreedingCycle(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cow_id'],
      )!,
      heatDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}heat_date'],
      )!,
      serviceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}service_date'],
      ),
      check1Date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check1_date'],
      ),
      check1Result: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}check1_result'],
      ),
      check2Date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check2_date'],
      ),
      check2Result: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}check2_result'],
      ),
      check3Date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}check3_date'],
      ),
      check3Result: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}check3_result'],
      ),
      gestationDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gestation_days'],
      )!,
      expectedCalvingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expected_calving_date'],
      ),
      actualCalvingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_calving_date'],
      ),
      calfSex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calf_sex'],
      ),
      calfCowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calf_cow_id'],
      ),
      sold: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sold'],
      )!,
      saleAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}sale_amount'],
      ),
      saleDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sale_date'],
      ),
      stage: $BreedingCyclesTable.$converterstage.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}stage'],
        )!,
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BreedingCyclesTable createAlias(String alias) {
    return $BreedingCyclesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<BreedingStage, int, int> $converterstage =
      const EnumIndexConverter<BreedingStage>(BreedingStage.values);
}

class BreedingCycle extends DataClass implements Insertable<BreedingCycle> {
  final int id;

  /// The dam (mother) going through this cycle.
  final int cowId;
  final DateTime heatDate;
  final DateTime? serviceDate;
  final DateTime? check1Date;
  final bool? check1Result;
  final DateTime? check2Date;
  final bool? check2Result;
  final DateTime? check3Date;
  final bool? check3Result;

  /// Average dairy gestation is ~283 days — NOT on your chart, so this is
  /// my assumption. Kept per-cycle (not hardcoded) so you can tune it per
  /// breed later instead of it being buried in code.
  final int gestationDays;
  final DateTime? expectedCalvingDate;
  final DateTime? actualCalvingDate;
  final String? calfSex;
  final int? calfCowId;
  final bool sold;
  final double? saleAmount;
  final DateTime? saleDate;
  final BreedingStage stage;

  /// False once the cycle ends (calved+resolved, or failed a check).
  /// Keeping failed/finished rows instead of overwriting them gives you a
  /// full breeding history per cow (conception rate, days-open, etc.) —
  /// the flowchart's loop-back arrow doesn't show this, but you'll want it.
  final bool isActive;
  final DateTime createdAt;
  const BreedingCycle({
    required this.id,
    required this.cowId,
    required this.heatDate,
    this.serviceDate,
    this.check1Date,
    this.check1Result,
    this.check2Date,
    this.check2Result,
    this.check3Date,
    this.check3Result,
    required this.gestationDays,
    this.expectedCalvingDate,
    this.actualCalvingDate,
    this.calfSex,
    this.calfCowId,
    required this.sold,
    this.saleAmount,
    this.saleDate,
    required this.stage,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cow_id'] = Variable<int>(cowId);
    map['heat_date'] = Variable<DateTime>(heatDate);
    if (!nullToAbsent || serviceDate != null) {
      map['service_date'] = Variable<DateTime>(serviceDate);
    }
    if (!nullToAbsent || check1Date != null) {
      map['check1_date'] = Variable<DateTime>(check1Date);
    }
    if (!nullToAbsent || check1Result != null) {
      map['check1_result'] = Variable<bool>(check1Result);
    }
    if (!nullToAbsent || check2Date != null) {
      map['check2_date'] = Variable<DateTime>(check2Date);
    }
    if (!nullToAbsent || check2Result != null) {
      map['check2_result'] = Variable<bool>(check2Result);
    }
    if (!nullToAbsent || check3Date != null) {
      map['check3_date'] = Variable<DateTime>(check3Date);
    }
    if (!nullToAbsent || check3Result != null) {
      map['check3_result'] = Variable<bool>(check3Result);
    }
    map['gestation_days'] = Variable<int>(gestationDays);
    if (!nullToAbsent || expectedCalvingDate != null) {
      map['expected_calving_date'] = Variable<DateTime>(expectedCalvingDate);
    }
    if (!nullToAbsent || actualCalvingDate != null) {
      map['actual_calving_date'] = Variable<DateTime>(actualCalvingDate);
    }
    if (!nullToAbsent || calfSex != null) {
      map['calf_sex'] = Variable<String>(calfSex);
    }
    if (!nullToAbsent || calfCowId != null) {
      map['calf_cow_id'] = Variable<int>(calfCowId);
    }
    map['sold'] = Variable<bool>(sold);
    if (!nullToAbsent || saleAmount != null) {
      map['sale_amount'] = Variable<double>(saleAmount);
    }
    if (!nullToAbsent || saleDate != null) {
      map['sale_date'] = Variable<DateTime>(saleDate);
    }
    {
      map['stage'] = Variable<int>(
        $BreedingCyclesTable.$converterstage.toSql(stage),
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BreedingCyclesCompanion toCompanion(bool nullToAbsent) {
    return BreedingCyclesCompanion(
      id: Value(id),
      cowId: Value(cowId),
      heatDate: Value(heatDate),
      serviceDate: serviceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceDate),
      check1Date: check1Date == null && nullToAbsent
          ? const Value.absent()
          : Value(check1Date),
      check1Result: check1Result == null && nullToAbsent
          ? const Value.absent()
          : Value(check1Result),
      check2Date: check2Date == null && nullToAbsent
          ? const Value.absent()
          : Value(check2Date),
      check2Result: check2Result == null && nullToAbsent
          ? const Value.absent()
          : Value(check2Result),
      check3Date: check3Date == null && nullToAbsent
          ? const Value.absent()
          : Value(check3Date),
      check3Result: check3Result == null && nullToAbsent
          ? const Value.absent()
          : Value(check3Result),
      gestationDays: Value(gestationDays),
      expectedCalvingDate: expectedCalvingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(expectedCalvingDate),
      actualCalvingDate: actualCalvingDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actualCalvingDate),
      calfSex: calfSex == null && nullToAbsent
          ? const Value.absent()
          : Value(calfSex),
      calfCowId: calfCowId == null && nullToAbsent
          ? const Value.absent()
          : Value(calfCowId),
      sold: Value(sold),
      saleAmount: saleAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(saleAmount),
      saleDate: saleDate == null && nullToAbsent
          ? const Value.absent()
          : Value(saleDate),
      stage: Value(stage),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory BreedingCycle.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BreedingCycle(
      id: serializer.fromJson<int>(json['id']),
      cowId: serializer.fromJson<int>(json['cowId']),
      heatDate: serializer.fromJson<DateTime>(json['heatDate']),
      serviceDate: serializer.fromJson<DateTime?>(json['serviceDate']),
      check1Date: serializer.fromJson<DateTime?>(json['check1Date']),
      check1Result: serializer.fromJson<bool?>(json['check1Result']),
      check2Date: serializer.fromJson<DateTime?>(json['check2Date']),
      check2Result: serializer.fromJson<bool?>(json['check2Result']),
      check3Date: serializer.fromJson<DateTime?>(json['check3Date']),
      check3Result: serializer.fromJson<bool?>(json['check3Result']),
      gestationDays: serializer.fromJson<int>(json['gestationDays']),
      expectedCalvingDate: serializer.fromJson<DateTime?>(
        json['expectedCalvingDate'],
      ),
      actualCalvingDate: serializer.fromJson<DateTime?>(
        json['actualCalvingDate'],
      ),
      calfSex: serializer.fromJson<String?>(json['calfSex']),
      calfCowId: serializer.fromJson<int?>(json['calfCowId']),
      sold: serializer.fromJson<bool>(json['sold']),
      saleAmount: serializer.fromJson<double?>(json['saleAmount']),
      saleDate: serializer.fromJson<DateTime?>(json['saleDate']),
      stage: $BreedingCyclesTable.$converterstage.fromJson(
        serializer.fromJson<int>(json['stage']),
      ),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cowId': serializer.toJson<int>(cowId),
      'heatDate': serializer.toJson<DateTime>(heatDate),
      'serviceDate': serializer.toJson<DateTime?>(serviceDate),
      'check1Date': serializer.toJson<DateTime?>(check1Date),
      'check1Result': serializer.toJson<bool?>(check1Result),
      'check2Date': serializer.toJson<DateTime?>(check2Date),
      'check2Result': serializer.toJson<bool?>(check2Result),
      'check3Date': serializer.toJson<DateTime?>(check3Date),
      'check3Result': serializer.toJson<bool?>(check3Result),
      'gestationDays': serializer.toJson<int>(gestationDays),
      'expectedCalvingDate': serializer.toJson<DateTime?>(expectedCalvingDate),
      'actualCalvingDate': serializer.toJson<DateTime?>(actualCalvingDate),
      'calfSex': serializer.toJson<String?>(calfSex),
      'calfCowId': serializer.toJson<int?>(calfCowId),
      'sold': serializer.toJson<bool>(sold),
      'saleAmount': serializer.toJson<double?>(saleAmount),
      'saleDate': serializer.toJson<DateTime?>(saleDate),
      'stage': serializer.toJson<int>(
        $BreedingCyclesTable.$converterstage.toJson(stage),
      ),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BreedingCycle copyWith({
    int? id,
    int? cowId,
    DateTime? heatDate,
    Value<DateTime?> serviceDate = const Value.absent(),
    Value<DateTime?> check1Date = const Value.absent(),
    Value<bool?> check1Result = const Value.absent(),
    Value<DateTime?> check2Date = const Value.absent(),
    Value<bool?> check2Result = const Value.absent(),
    Value<DateTime?> check3Date = const Value.absent(),
    Value<bool?> check3Result = const Value.absent(),
    int? gestationDays,
    Value<DateTime?> expectedCalvingDate = const Value.absent(),
    Value<DateTime?> actualCalvingDate = const Value.absent(),
    Value<String?> calfSex = const Value.absent(),
    Value<int?> calfCowId = const Value.absent(),
    bool? sold,
    Value<double?> saleAmount = const Value.absent(),
    Value<DateTime?> saleDate = const Value.absent(),
    BreedingStage? stage,
    bool? isActive,
    DateTime? createdAt,
  }) => BreedingCycle(
    id: id ?? this.id,
    cowId: cowId ?? this.cowId,
    heatDate: heatDate ?? this.heatDate,
    serviceDate: serviceDate.present ? serviceDate.value : this.serviceDate,
    check1Date: check1Date.present ? check1Date.value : this.check1Date,
    check1Result: check1Result.present ? check1Result.value : this.check1Result,
    check2Date: check2Date.present ? check2Date.value : this.check2Date,
    check2Result: check2Result.present ? check2Result.value : this.check2Result,
    check3Date: check3Date.present ? check3Date.value : this.check3Date,
    check3Result: check3Result.present ? check3Result.value : this.check3Result,
    gestationDays: gestationDays ?? this.gestationDays,
    expectedCalvingDate: expectedCalvingDate.present
        ? expectedCalvingDate.value
        : this.expectedCalvingDate,
    actualCalvingDate: actualCalvingDate.present
        ? actualCalvingDate.value
        : this.actualCalvingDate,
    calfSex: calfSex.present ? calfSex.value : this.calfSex,
    calfCowId: calfCowId.present ? calfCowId.value : this.calfCowId,
    sold: sold ?? this.sold,
    saleAmount: saleAmount.present ? saleAmount.value : this.saleAmount,
    saleDate: saleDate.present ? saleDate.value : this.saleDate,
    stage: stage ?? this.stage,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  BreedingCycle copyWithCompanion(BreedingCyclesCompanion data) {
    return BreedingCycle(
      id: data.id.present ? data.id.value : this.id,
      cowId: data.cowId.present ? data.cowId.value : this.cowId,
      heatDate: data.heatDate.present ? data.heatDate.value : this.heatDate,
      serviceDate: data.serviceDate.present
          ? data.serviceDate.value
          : this.serviceDate,
      check1Date: data.check1Date.present
          ? data.check1Date.value
          : this.check1Date,
      check1Result: data.check1Result.present
          ? data.check1Result.value
          : this.check1Result,
      check2Date: data.check2Date.present
          ? data.check2Date.value
          : this.check2Date,
      check2Result: data.check2Result.present
          ? data.check2Result.value
          : this.check2Result,
      check3Date: data.check3Date.present
          ? data.check3Date.value
          : this.check3Date,
      check3Result: data.check3Result.present
          ? data.check3Result.value
          : this.check3Result,
      gestationDays: data.gestationDays.present
          ? data.gestationDays.value
          : this.gestationDays,
      expectedCalvingDate: data.expectedCalvingDate.present
          ? data.expectedCalvingDate.value
          : this.expectedCalvingDate,
      actualCalvingDate: data.actualCalvingDate.present
          ? data.actualCalvingDate.value
          : this.actualCalvingDate,
      calfSex: data.calfSex.present ? data.calfSex.value : this.calfSex,
      calfCowId: data.calfCowId.present ? data.calfCowId.value : this.calfCowId,
      sold: data.sold.present ? data.sold.value : this.sold,
      saleAmount: data.saleAmount.present
          ? data.saleAmount.value
          : this.saleAmount,
      saleDate: data.saleDate.present ? data.saleDate.value : this.saleDate,
      stage: data.stage.present ? data.stage.value : this.stage,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BreedingCycle(')
          ..write('id: $id, ')
          ..write('cowId: $cowId, ')
          ..write('heatDate: $heatDate, ')
          ..write('serviceDate: $serviceDate, ')
          ..write('check1Date: $check1Date, ')
          ..write('check1Result: $check1Result, ')
          ..write('check2Date: $check2Date, ')
          ..write('check2Result: $check2Result, ')
          ..write('check3Date: $check3Date, ')
          ..write('check3Result: $check3Result, ')
          ..write('gestationDays: $gestationDays, ')
          ..write('expectedCalvingDate: $expectedCalvingDate, ')
          ..write('actualCalvingDate: $actualCalvingDate, ')
          ..write('calfSex: $calfSex, ')
          ..write('calfCowId: $calfCowId, ')
          ..write('sold: $sold, ')
          ..write('saleAmount: $saleAmount, ')
          ..write('saleDate: $saleDate, ')
          ..write('stage: $stage, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    cowId,
    heatDate,
    serviceDate,
    check1Date,
    check1Result,
    check2Date,
    check2Result,
    check3Date,
    check3Result,
    gestationDays,
    expectedCalvingDate,
    actualCalvingDate,
    calfSex,
    calfCowId,
    sold,
    saleAmount,
    saleDate,
    stage,
    isActive,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BreedingCycle &&
          other.id == this.id &&
          other.cowId == this.cowId &&
          other.heatDate == this.heatDate &&
          other.serviceDate == this.serviceDate &&
          other.check1Date == this.check1Date &&
          other.check1Result == this.check1Result &&
          other.check2Date == this.check2Date &&
          other.check2Result == this.check2Result &&
          other.check3Date == this.check3Date &&
          other.check3Result == this.check3Result &&
          other.gestationDays == this.gestationDays &&
          other.expectedCalvingDate == this.expectedCalvingDate &&
          other.actualCalvingDate == this.actualCalvingDate &&
          other.calfSex == this.calfSex &&
          other.calfCowId == this.calfCowId &&
          other.sold == this.sold &&
          other.saleAmount == this.saleAmount &&
          other.saleDate == this.saleDate &&
          other.stage == this.stage &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class BreedingCyclesCompanion extends UpdateCompanion<BreedingCycle> {
  final Value<int> id;
  final Value<int> cowId;
  final Value<DateTime> heatDate;
  final Value<DateTime?> serviceDate;
  final Value<DateTime?> check1Date;
  final Value<bool?> check1Result;
  final Value<DateTime?> check2Date;
  final Value<bool?> check2Result;
  final Value<DateTime?> check3Date;
  final Value<bool?> check3Result;
  final Value<int> gestationDays;
  final Value<DateTime?> expectedCalvingDate;
  final Value<DateTime?> actualCalvingDate;
  final Value<String?> calfSex;
  final Value<int?> calfCowId;
  final Value<bool> sold;
  final Value<double?> saleAmount;
  final Value<DateTime?> saleDate;
  final Value<BreedingStage> stage;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  const BreedingCyclesCompanion({
    this.id = const Value.absent(),
    this.cowId = const Value.absent(),
    this.heatDate = const Value.absent(),
    this.serviceDate = const Value.absent(),
    this.check1Date = const Value.absent(),
    this.check1Result = const Value.absent(),
    this.check2Date = const Value.absent(),
    this.check2Result = const Value.absent(),
    this.check3Date = const Value.absent(),
    this.check3Result = const Value.absent(),
    this.gestationDays = const Value.absent(),
    this.expectedCalvingDate = const Value.absent(),
    this.actualCalvingDate = const Value.absent(),
    this.calfSex = const Value.absent(),
    this.calfCowId = const Value.absent(),
    this.sold = const Value.absent(),
    this.saleAmount = const Value.absent(),
    this.saleDate = const Value.absent(),
    this.stage = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BreedingCyclesCompanion.insert({
    this.id = const Value.absent(),
    required int cowId,
    required DateTime heatDate,
    this.serviceDate = const Value.absent(),
    this.check1Date = const Value.absent(),
    this.check1Result = const Value.absent(),
    this.check2Date = const Value.absent(),
    this.check2Result = const Value.absent(),
    this.check3Date = const Value.absent(),
    this.check3Result = const Value.absent(),
    this.gestationDays = const Value.absent(),
    this.expectedCalvingDate = const Value.absent(),
    this.actualCalvingDate = const Value.absent(),
    this.calfSex = const Value.absent(),
    this.calfCowId = const Value.absent(),
    this.sold = const Value.absent(),
    this.saleAmount = const Value.absent(),
    this.saleDate = const Value.absent(),
    required BreedingStage stage,
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : cowId = Value(cowId),
       heatDate = Value(heatDate),
       stage = Value(stage);
  static Insertable<BreedingCycle> custom({
    Expression<int>? id,
    Expression<int>? cowId,
    Expression<DateTime>? heatDate,
    Expression<DateTime>? serviceDate,
    Expression<DateTime>? check1Date,
    Expression<bool>? check1Result,
    Expression<DateTime>? check2Date,
    Expression<bool>? check2Result,
    Expression<DateTime>? check3Date,
    Expression<bool>? check3Result,
    Expression<int>? gestationDays,
    Expression<DateTime>? expectedCalvingDate,
    Expression<DateTime>? actualCalvingDate,
    Expression<String>? calfSex,
    Expression<int>? calfCowId,
    Expression<bool>? sold,
    Expression<double>? saleAmount,
    Expression<DateTime>? saleDate,
    Expression<int>? stage,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cowId != null) 'cow_id': cowId,
      if (heatDate != null) 'heat_date': heatDate,
      if (serviceDate != null) 'service_date': serviceDate,
      if (check1Date != null) 'check1_date': check1Date,
      if (check1Result != null) 'check1_result': check1Result,
      if (check2Date != null) 'check2_date': check2Date,
      if (check2Result != null) 'check2_result': check2Result,
      if (check3Date != null) 'check3_date': check3Date,
      if (check3Result != null) 'check3_result': check3Result,
      if (gestationDays != null) 'gestation_days': gestationDays,
      if (expectedCalvingDate != null)
        'expected_calving_date': expectedCalvingDate,
      if (actualCalvingDate != null) 'actual_calving_date': actualCalvingDate,
      if (calfSex != null) 'calf_sex': calfSex,
      if (calfCowId != null) 'calf_cow_id': calfCowId,
      if (sold != null) 'sold': sold,
      if (saleAmount != null) 'sale_amount': saleAmount,
      if (saleDate != null) 'sale_date': saleDate,
      if (stage != null) 'stage': stage,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BreedingCyclesCompanion copyWith({
    Value<int>? id,
    Value<int>? cowId,
    Value<DateTime>? heatDate,
    Value<DateTime?>? serviceDate,
    Value<DateTime?>? check1Date,
    Value<bool?>? check1Result,
    Value<DateTime?>? check2Date,
    Value<bool?>? check2Result,
    Value<DateTime?>? check3Date,
    Value<bool?>? check3Result,
    Value<int>? gestationDays,
    Value<DateTime?>? expectedCalvingDate,
    Value<DateTime?>? actualCalvingDate,
    Value<String?>? calfSex,
    Value<int?>? calfCowId,
    Value<bool>? sold,
    Value<double?>? saleAmount,
    Value<DateTime?>? saleDate,
    Value<BreedingStage>? stage,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
  }) {
    return BreedingCyclesCompanion(
      id: id ?? this.id,
      cowId: cowId ?? this.cowId,
      heatDate: heatDate ?? this.heatDate,
      serviceDate: serviceDate ?? this.serviceDate,
      check1Date: check1Date ?? this.check1Date,
      check1Result: check1Result ?? this.check1Result,
      check2Date: check2Date ?? this.check2Date,
      check2Result: check2Result ?? this.check2Result,
      check3Date: check3Date ?? this.check3Date,
      check3Result: check3Result ?? this.check3Result,
      gestationDays: gestationDays ?? this.gestationDays,
      expectedCalvingDate: expectedCalvingDate ?? this.expectedCalvingDate,
      actualCalvingDate: actualCalvingDate ?? this.actualCalvingDate,
      calfSex: calfSex ?? this.calfSex,
      calfCowId: calfCowId ?? this.calfCowId,
      sold: sold ?? this.sold,
      saleAmount: saleAmount ?? this.saleAmount,
      saleDate: saleDate ?? this.saleDate,
      stage: stage ?? this.stage,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cowId.present) {
      map['cow_id'] = Variable<int>(cowId.value);
    }
    if (heatDate.present) {
      map['heat_date'] = Variable<DateTime>(heatDate.value);
    }
    if (serviceDate.present) {
      map['service_date'] = Variable<DateTime>(serviceDate.value);
    }
    if (check1Date.present) {
      map['check1_date'] = Variable<DateTime>(check1Date.value);
    }
    if (check1Result.present) {
      map['check1_result'] = Variable<bool>(check1Result.value);
    }
    if (check2Date.present) {
      map['check2_date'] = Variable<DateTime>(check2Date.value);
    }
    if (check2Result.present) {
      map['check2_result'] = Variable<bool>(check2Result.value);
    }
    if (check3Date.present) {
      map['check3_date'] = Variable<DateTime>(check3Date.value);
    }
    if (check3Result.present) {
      map['check3_result'] = Variable<bool>(check3Result.value);
    }
    if (gestationDays.present) {
      map['gestation_days'] = Variable<int>(gestationDays.value);
    }
    if (expectedCalvingDate.present) {
      map['expected_calving_date'] = Variable<DateTime>(
        expectedCalvingDate.value,
      );
    }
    if (actualCalvingDate.present) {
      map['actual_calving_date'] = Variable<DateTime>(actualCalvingDate.value);
    }
    if (calfSex.present) {
      map['calf_sex'] = Variable<String>(calfSex.value);
    }
    if (calfCowId.present) {
      map['calf_cow_id'] = Variable<int>(calfCowId.value);
    }
    if (sold.present) {
      map['sold'] = Variable<bool>(sold.value);
    }
    if (saleAmount.present) {
      map['sale_amount'] = Variable<double>(saleAmount.value);
    }
    if (saleDate.present) {
      map['sale_date'] = Variable<DateTime>(saleDate.value);
    }
    if (stage.present) {
      map['stage'] = Variable<int>(
        $BreedingCyclesTable.$converterstage.toSql(stage.value),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BreedingCyclesCompanion(')
          ..write('id: $id, ')
          ..write('cowId: $cowId, ')
          ..write('heatDate: $heatDate, ')
          ..write('serviceDate: $serviceDate, ')
          ..write('check1Date: $check1Date, ')
          ..write('check1Result: $check1Result, ')
          ..write('check2Date: $check2Date, ')
          ..write('check2Result: $check2Result, ')
          ..write('check3Date: $check3Date, ')
          ..write('check3Result: $check3Result, ')
          ..write('gestationDays: $gestationDays, ')
          ..write('expectedCalvingDate: $expectedCalvingDate, ')
          ..write('actualCalvingDate: $actualCalvingDate, ')
          ..write('calfSex: $calfSex, ')
          ..write('calfCowId: $calfCowId, ')
          ..write('sold: $sold, ')
          ..write('saleAmount: $saleAmount, ')
          ..write('saleDate: $saleDate, ')
          ..write('stage: $stage, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $LedgerEntriesTable extends LedgerEntries
    with TableInfo<$LedgerEntriesTable, LedgerEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LedgerEntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _cowIdMeta = const VerificationMeta('cowId');
  @override
  late final GeneratedColumn<int> cowId = GeneratedColumn<int>(
    'cow_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cow (id)',
    ),
  );
  static const VerificationMeta _breedingCycleIdMeta = const VerificationMeta(
    'breedingCycleId',
  );
  @override
  late final GeneratedColumn<int> breedingCycleId = GeneratedColumn<int>(
    'breeding_cycle_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES breeding_cycles (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cowId,
    breedingCycleId,
    type,
    category,
    amount,
    note,
    date,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ledger_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<LedgerEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cow_id')) {
      context.handle(
        _cowIdMeta,
        cowId.isAcceptableOrUnknown(data['cow_id']!, _cowIdMeta),
      );
    }
    if (data.containsKey('breeding_cycle_id')) {
      context.handle(
        _breedingCycleIdMeta,
        breedingCycleId.isAcceptableOrUnknown(
          data['breeding_cycle_id']!,
          _breedingCycleIdMeta,
        ),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LedgerEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LedgerEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cowId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cow_id'],
      ),
      breedingCycleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}breeding_cycle_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
    );
  }

  @override
  $LedgerEntriesTable createAlias(String alias) {
    return $LedgerEntriesTable(attachedDatabase, alias);
  }
}

class LedgerEntry extends DataClass implements Insertable<LedgerEntry> {
  final int id;
  final int? cowId;
  final int? breedingCycleId;
  final String type;
  final String category;
  final double amount;
  final String? note;
  final DateTime date;
  const LedgerEntry({
    required this.id,
    this.cowId,
    this.breedingCycleId,
    required this.type,
    required this.category,
    required this.amount,
    this.note,
    required this.date,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || cowId != null) {
      map['cow_id'] = Variable<int>(cowId);
    }
    if (!nullToAbsent || breedingCycleId != null) {
      map['breeding_cycle_id'] = Variable<int>(breedingCycleId);
    }
    map['type'] = Variable<String>(type);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<double>(amount);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['date'] = Variable<DateTime>(date);
    return map;
  }

  LedgerEntriesCompanion toCompanion(bool nullToAbsent) {
    return LedgerEntriesCompanion(
      id: Value(id),
      cowId: cowId == null && nullToAbsent
          ? const Value.absent()
          : Value(cowId),
      breedingCycleId: breedingCycleId == null && nullToAbsent
          ? const Value.absent()
          : Value(breedingCycleId),
      type: Value(type),
      category: Value(category),
      amount: Value(amount),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      date: Value(date),
    );
  }

  factory LedgerEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LedgerEntry(
      id: serializer.fromJson<int>(json['id']),
      cowId: serializer.fromJson<int?>(json['cowId']),
      breedingCycleId: serializer.fromJson<int?>(json['breedingCycleId']),
      type: serializer.fromJson<String>(json['type']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<double>(json['amount']),
      note: serializer.fromJson<String?>(json['note']),
      date: serializer.fromJson<DateTime>(json['date']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cowId': serializer.toJson<int?>(cowId),
      'breedingCycleId': serializer.toJson<int?>(breedingCycleId),
      'type': serializer.toJson<String>(type),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<double>(amount),
      'note': serializer.toJson<String?>(note),
      'date': serializer.toJson<DateTime>(date),
    };
  }

  LedgerEntry copyWith({
    int? id,
    Value<int?> cowId = const Value.absent(),
    Value<int?> breedingCycleId = const Value.absent(),
    String? type,
    String? category,
    double? amount,
    Value<String?> note = const Value.absent(),
    DateTime? date,
  }) => LedgerEntry(
    id: id ?? this.id,
    cowId: cowId.present ? cowId.value : this.cowId,
    breedingCycleId: breedingCycleId.present
        ? breedingCycleId.value
        : this.breedingCycleId,
    type: type ?? this.type,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    note: note.present ? note.value : this.note,
    date: date ?? this.date,
  );
  LedgerEntry copyWithCompanion(LedgerEntriesCompanion data) {
    return LedgerEntry(
      id: data.id.present ? data.id.value : this.id,
      cowId: data.cowId.present ? data.cowId.value : this.cowId,
      breedingCycleId: data.breedingCycleId.present
          ? data.breedingCycleId.value
          : this.breedingCycleId,
      type: data.type.present ? data.type.value : this.type,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      date: data.date.present ? data.date.value : this.date,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntry(')
          ..write('id: $id, ')
          ..write('cowId: $cowId, ')
          ..write('breedingCycleId: $breedingCycleId, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cowId,
    breedingCycleId,
    type,
    category,
    amount,
    note,
    date,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LedgerEntry &&
          other.id == this.id &&
          other.cowId == this.cowId &&
          other.breedingCycleId == this.breedingCycleId &&
          other.type == this.type &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.date == this.date);
}

class LedgerEntriesCompanion extends UpdateCompanion<LedgerEntry> {
  final Value<int> id;
  final Value<int?> cowId;
  final Value<int?> breedingCycleId;
  final Value<String> type;
  final Value<String> category;
  final Value<double> amount;
  final Value<String?> note;
  final Value<DateTime> date;
  const LedgerEntriesCompanion({
    this.id = const Value.absent(),
    this.cowId = const Value.absent(),
    this.breedingCycleId = const Value.absent(),
    this.type = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.date = const Value.absent(),
  });
  LedgerEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.cowId = const Value.absent(),
    this.breedingCycleId = const Value.absent(),
    required String type,
    required String category,
    required double amount,
    this.note = const Value.absent(),
    this.date = const Value.absent(),
  }) : type = Value(type),
       category = Value(category),
       amount = Value(amount);
  static Insertable<LedgerEntry> custom({
    Expression<int>? id,
    Expression<int>? cowId,
    Expression<int>? breedingCycleId,
    Expression<String>? type,
    Expression<String>? category,
    Expression<double>? amount,
    Expression<String>? note,
    Expression<DateTime>? date,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cowId != null) 'cow_id': cowId,
      if (breedingCycleId != null) 'breeding_cycle_id': breedingCycleId,
      if (type != null) 'type': type,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (date != null) 'date': date,
    });
  }

  LedgerEntriesCompanion copyWith({
    Value<int>? id,
    Value<int?>? cowId,
    Value<int?>? breedingCycleId,
    Value<String>? type,
    Value<String>? category,
    Value<double>? amount,
    Value<String?>? note,
    Value<DateTime>? date,
  }) {
    return LedgerEntriesCompanion(
      id: id ?? this.id,
      cowId: cowId ?? this.cowId,
      breedingCycleId: breedingCycleId ?? this.breedingCycleId,
      type: type ?? this.type,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cowId.present) {
      map['cow_id'] = Variable<int>(cowId.value);
    }
    if (breedingCycleId.present) {
      map['breeding_cycle_id'] = Variable<int>(breedingCycleId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LedgerEntriesCompanion(')
          ..write('id: $id, ')
          ..write('cowId: $cowId, ')
          ..write('breedingCycleId: $breedingCycleId, ')
          ..write('type: $type, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('date: $date')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CowTable cow = $CowTable(this);
  late final $MilkTableTable milkTable = $MilkTableTable(this);
  late final $PriceSettingsTable priceSettings = $PriceSettingsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $FeedingLogTable feedingLog = $FeedingLogTable(this);
  late final $HealthRecordTable healthRecord = $HealthRecordTable(this);
  late final $BreedingCyclesTable breedingCycles = $BreedingCyclesTable(this);
  late final $LedgerEntriesTable ledgerEntries = $LedgerEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cow,
    milkTable,
    priceSettings,
    expenses,
    feedingLog,
    healthRecord,
    breedingCycles,
    ledgerEntries,
  ];
}

typedef $$CowTableCreateCompanionBuilder =
    CowCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> tag,
      Value<String?> breed,
      Value<int?> age,
      Value<String?> imagePath,
      Value<int?> parentCowId,
    });
typedef $$CowTableUpdateCompanionBuilder =
    CowCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> tag,
      Value<String?> breed,
      Value<int?> age,
      Value<String?> imagePath,
      Value<int?> parentCowId,
    });

final class $$CowTableReferences
    extends BaseReferences<_$AppDatabase, $CowTable, CowData> {
  $$CowTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CowTable _parentCowIdTable(_$AppDatabase db) =>
      db.cow.createAlias('cow__parent_cow_id__cow__id');

  $$CowTableProcessedTableManager? get parentCowId {
    final $_column = $_itemColumn<int>('parent_cow_id');
    if ($_column == null) return null;
    final manager = $$CowTableTableManager(
      $_db,
      $_db.cow,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentCowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MilkTableTable, List<MilkTableData>>
  _milkTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.milkTable,
    aliasName: 'cow__id__milk_table__cow_id',
  );

  $$MilkTableTableProcessedTableManager get milkTableRefs {
    final manager = $$MilkTableTableTableManager(
      $_db,
      $_db.milkTable,
    ).filter((f) => f.cowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_milkTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FeedingLogTable, List<FeedingLogData>>
  _feedingLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.feedingLog,
    aliasName: 'cow__id__feeding_log__cow_id',
  );

  $$FeedingLogTableProcessedTableManager get feedingLogRefs {
    final manager = $$FeedingLogTableTableManager(
      $_db,
      $_db.feedingLog,
    ).filter((f) => f.cowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_feedingLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$HealthRecordTable, List<HealthRecordData>>
  _healthRecordRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.healthRecord,
    aliasName: 'cow__id__health_record__cow_id',
  );

  $$HealthRecordTableProcessedTableManager get healthRecordRefs {
    final manager = $$HealthRecordTableTableManager(
      $_db,
      $_db.healthRecord,
    ).filter((f) => f.cowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_healthRecordRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LedgerEntriesTable, List<LedgerEntry>>
  _ledgerEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ledgerEntries,
    aliasName: 'cow__id__ledger_entries__cow_id',
  );

  $$LedgerEntriesTableProcessedTableManager get ledgerEntriesRefs {
    final manager = $$LedgerEntriesTableTableManager(
      $_db,
      $_db.ledgerEntries,
    ).filter((f) => f.cowId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CowTableFilterComposer extends Composer<_$AppDatabase, $CowTable> {
  $$CowTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  $$CowTableFilterComposer get parentCowId {
    final $$CowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentCowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableFilterComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> milkTableRefs(
    Expression<bool> Function($$MilkTableTableFilterComposer f) f,
  ) {
    final $$MilkTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milkTable,
      getReferencedColumn: (t) => t.cowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilkTableTableFilterComposer(
            $db: $db,
            $table: $db.milkTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> feedingLogRefs(
    Expression<bool> Function($$FeedingLogTableFilterComposer f) f,
  ) {
    final $$FeedingLogTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedingLog,
      getReferencedColumn: (t) => t.cowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedingLogTableFilterComposer(
            $db: $db,
            $table: $db.feedingLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> healthRecordRefs(
    Expression<bool> Function($$HealthRecordTableFilterComposer f) f,
  ) {
    final $$HealthRecordTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.healthRecord,
      getReferencedColumn: (t) => t.cowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HealthRecordTableFilterComposer(
            $db: $db,
            $table: $db.healthRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ledgerEntriesRefs(
    Expression<bool> Function($$LedgerEntriesTableFilterComposer f) f,
  ) {
    final $$LedgerEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.cowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableFilterComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CowTableOrderingComposer extends Composer<_$AppDatabase, $CowTable> {
  $$CowTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get breed => $composableBuilder(
    column: $table.breed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$CowTableOrderingComposer get parentCowId {
    final $$CowTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentCowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableOrderingComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CowTableAnnotationComposer extends Composer<_$AppDatabase, $CowTable> {
  $$CowTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);

  GeneratedColumn<String> get breed =>
      $composableBuilder(column: $table.breed, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  $$CowTableAnnotationComposer get parentCowId {
    final $$CowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentCowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableAnnotationComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> milkTableRefs<T extends Object>(
    Expression<T> Function($$MilkTableTableAnnotationComposer a) f,
  ) {
    final $$MilkTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.milkTable,
      getReferencedColumn: (t) => t.cowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MilkTableTableAnnotationComposer(
            $db: $db,
            $table: $db.milkTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> feedingLogRefs<T extends Object>(
    Expression<T> Function($$FeedingLogTableAnnotationComposer a) f,
  ) {
    final $$FeedingLogTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.feedingLog,
      getReferencedColumn: (t) => t.cowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FeedingLogTableAnnotationComposer(
            $db: $db,
            $table: $db.feedingLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> healthRecordRefs<T extends Object>(
    Expression<T> Function($$HealthRecordTableAnnotationComposer a) f,
  ) {
    final $$HealthRecordTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.healthRecord,
      getReferencedColumn: (t) => t.cowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HealthRecordTableAnnotationComposer(
            $db: $db,
            $table: $db.healthRecord,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ledgerEntriesRefs<T extends Object>(
    Expression<T> Function($$LedgerEntriesTableAnnotationComposer a) f,
  ) {
    final $$LedgerEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.cowId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CowTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CowTable,
          CowData,
          $$CowTableFilterComposer,
          $$CowTableOrderingComposer,
          $$CowTableAnnotationComposer,
          $$CowTableCreateCompanionBuilder,
          $$CowTableUpdateCompanionBuilder,
          (CowData, $$CowTableReferences),
          CowData,
          PrefetchHooks Function({
            bool parentCowId,
            bool milkTableRefs,
            bool feedingLogRefs,
            bool healthRecordRefs,
            bool ledgerEntriesRefs,
          })
        > {
  $$CowTableTableManager(_$AppDatabase db, $CowTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CowTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CowTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CowTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> tag = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int?> parentCowId = const Value.absent(),
              }) => CowCompanion(
                id: id,
                name: name,
                tag: tag,
                breed: breed,
                age: age,
                imagePath: imagePath,
                parentCowId: parentCowId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> tag = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<int?> parentCowId = const Value.absent(),
              }) => CowCompanion.insert(
                id: id,
                name: name,
                tag: tag,
                breed: breed,
                age: age,
                imagePath: imagePath,
                parentCowId: parentCowId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), $$CowTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentCowId = false,
                milkTableRefs = false,
                feedingLogRefs = false,
                healthRecordRefs = false,
                ledgerEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (milkTableRefs) db.milkTable,
                    if (feedingLogRefs) db.feedingLog,
                    if (healthRecordRefs) db.healthRecord,
                    if (ledgerEntriesRefs) db.ledgerEntries,
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
                        if (parentCowId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentCowId,
                                    referencedTable: $$CowTableReferences
                                        ._parentCowIdTable(db),
                                    referencedColumn: $$CowTableReferences
                                        ._parentCowIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (milkTableRefs)
                        await $_getPrefetchedData<
                          CowData,
                          $CowTable,
                          MilkTableData
                        >(
                          currentTable: table,
                          referencedTable: $$CowTableReferences
                              ._milkTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CowTableReferences(db, table, p0).milkTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cowId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (feedingLogRefs)
                        await $_getPrefetchedData<
                          CowData,
                          $CowTable,
                          FeedingLogData
                        >(
                          currentTable: table,
                          referencedTable: $$CowTableReferences
                              ._feedingLogRefsTable(db),
                          managerFromTypedResult: (p0) => $$CowTableReferences(
                            db,
                            table,
                            p0,
                          ).feedingLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cowId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (healthRecordRefs)
                        await $_getPrefetchedData<
                          CowData,
                          $CowTable,
                          HealthRecordData
                        >(
                          currentTable: table,
                          referencedTable: $$CowTableReferences
                              ._healthRecordRefsTable(db),
                          managerFromTypedResult: (p0) => $$CowTableReferences(
                            db,
                            table,
                            p0,
                          ).healthRecordRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cowId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ledgerEntriesRefs)
                        await $_getPrefetchedData<
                          CowData,
                          $CowTable,
                          LedgerEntry
                        >(
                          currentTable: table,
                          referencedTable: $$CowTableReferences
                              ._ledgerEntriesRefsTable(db),
                          managerFromTypedResult: (p0) => $$CowTableReferences(
                            db,
                            table,
                            p0,
                          ).ledgerEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cowId == item.id,
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

typedef $$CowTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CowTable,
      CowData,
      $$CowTableFilterComposer,
      $$CowTableOrderingComposer,
      $$CowTableAnnotationComposer,
      $$CowTableCreateCompanionBuilder,
      $$CowTableUpdateCompanionBuilder,
      (CowData, $$CowTableReferences),
      CowData,
      PrefetchHooks Function({
        bool parentCowId,
        bool milkTableRefs,
        bool feedingLogRefs,
        bool healthRecordRefs,
        bool ledgerEntriesRefs,
      })
    >;
typedef $$MilkTableTableCreateCompanionBuilder =
    MilkTableCompanion Function({
      required String id,
      required DateTime entryDate,
      required String session,
      required double amount,
      required int cowId,
      Value<int> rowid,
    });
typedef $$MilkTableTableUpdateCompanionBuilder =
    MilkTableCompanion Function({
      Value<String> id,
      Value<DateTime> entryDate,
      Value<String> session,
      Value<double> amount,
      Value<int> cowId,
      Value<int> rowid,
    });

final class $$MilkTableTableReferences
    extends BaseReferences<_$AppDatabase, $MilkTableTable, MilkTableData> {
  $$MilkTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CowTable _cowIdTable(_$AppDatabase db) =>
      db.cow.createAlias('milk_table__cow_id__cow__id');

  $$CowTableProcessedTableManager get cowId {
    final $_column = $_itemColumn<int>('cow_id')!;

    final manager = $$CowTableTableManager(
      $_db,
      $_db.cow,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MilkTableTableFilterComposer
    extends Composer<_$AppDatabase, $MilkTableTable> {
  $$MilkTableTableFilterComposer({
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

  ColumnFilters<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get session => $composableBuilder(
    column: $table.session,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  $$CowTableFilterComposer get cowId {
    final $$CowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableFilterComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilkTableTableOrderingComposer
    extends Composer<_$AppDatabase, $MilkTableTable> {
  $$MilkTableTableOrderingComposer({
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

  ColumnOrderings<DateTime> get entryDate => $composableBuilder(
    column: $table.entryDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get session => $composableBuilder(
    column: $table.session,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  $$CowTableOrderingComposer get cowId {
    final $$CowTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableOrderingComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilkTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilkTableTable> {
  $$MilkTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get entryDate =>
      $composableBuilder(column: $table.entryDate, builder: (column) => column);

  GeneratedColumn<String> get session =>
      $composableBuilder(column: $table.session, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  $$CowTableAnnotationComposer get cowId {
    final $$CowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableAnnotationComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MilkTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilkTableTable,
          MilkTableData,
          $$MilkTableTableFilterComposer,
          $$MilkTableTableOrderingComposer,
          $$MilkTableTableAnnotationComposer,
          $$MilkTableTableCreateCompanionBuilder,
          $$MilkTableTableUpdateCompanionBuilder,
          (MilkTableData, $$MilkTableTableReferences),
          MilkTableData,
          PrefetchHooks Function({bool cowId})
        > {
  $$MilkTableTableTableManager(_$AppDatabase db, $MilkTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilkTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilkTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilkTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> entryDate = const Value.absent(),
                Value<String> session = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int> cowId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilkTableCompanion(
                id: id,
                entryDate: entryDate,
                session: session,
                amount: amount,
                cowId: cowId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime entryDate,
                required String session,
                required double amount,
                required int cowId,
                Value<int> rowid = const Value.absent(),
              }) => MilkTableCompanion.insert(
                id: id,
                entryDate: entryDate,
                session: session,
                amount: amount,
                cowId: cowId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MilkTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cowId = false}) {
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
                    if (cowId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cowId,
                                referencedTable: $$MilkTableTableReferences
                                    ._cowIdTable(db),
                                referencedColumn: $$MilkTableTableReferences
                                    ._cowIdTable(db)
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

typedef $$MilkTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilkTableTable,
      MilkTableData,
      $$MilkTableTableFilterComposer,
      $$MilkTableTableOrderingComposer,
      $$MilkTableTableAnnotationComposer,
      $$MilkTableTableCreateCompanionBuilder,
      $$MilkTableTableUpdateCompanionBuilder,
      (MilkTableData, $$MilkTableTableReferences),
      MilkTableData,
      PrefetchHooks Function({bool cowId})
    >;
typedef $$PriceSettingsTableCreateCompanionBuilder =
    PriceSettingsCompanion Function({
      Value<int> id,
      required DateTime effectiveDate,
      required double pricePerLitre,
    });
typedef $$PriceSettingsTableUpdateCompanionBuilder =
    PriceSettingsCompanion Function({
      Value<int> id,
      Value<DateTime> effectiveDate,
      Value<double> pricePerLitre,
    });

class $$PriceSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $PriceSettingsTable> {
  $$PriceSettingsTableFilterComposer({
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

  ColumnFilters<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerLitre => $composableBuilder(
    column: $table.pricePerLitre,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PriceSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $PriceSettingsTable> {
  $$PriceSettingsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerLitre => $composableBuilder(
    column: $table.pricePerLitre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PriceSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PriceSettingsTable> {
  $$PriceSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get effectiveDate => $composableBuilder(
    column: $table.effectiveDate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pricePerLitre => $composableBuilder(
    column: $table.pricePerLitre,
    builder: (column) => column,
  );
}

class $$PriceSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PriceSettingsTable,
          PriceSetting,
          $$PriceSettingsTableFilterComposer,
          $$PriceSettingsTableOrderingComposer,
          $$PriceSettingsTableAnnotationComposer,
          $$PriceSettingsTableCreateCompanionBuilder,
          $$PriceSettingsTableUpdateCompanionBuilder,
          (
            PriceSetting,
            BaseReferences<_$AppDatabase, $PriceSettingsTable, PriceSetting>,
          ),
          PriceSetting,
          PrefetchHooks Function()
        > {
  $$PriceSettingsTableTableManager(_$AppDatabase db, $PriceSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PriceSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PriceSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PriceSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> effectiveDate = const Value.absent(),
                Value<double> pricePerLitre = const Value.absent(),
              }) => PriceSettingsCompanion(
                id: id,
                effectiveDate: effectiveDate,
                pricePerLitre: pricePerLitre,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime effectiveDate,
                required double pricePerLitre,
              }) => PriceSettingsCompanion.insert(
                id: id,
                effectiveDate: effectiveDate,
                pricePerLitre: pricePerLitre,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PriceSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PriceSettingsTable,
      PriceSetting,
      $$PriceSettingsTableFilterComposer,
      $$PriceSettingsTableOrderingComposer,
      $$PriceSettingsTableAnnotationComposer,
      $$PriceSettingsTableCreateCompanionBuilder,
      $$PriceSettingsTableUpdateCompanionBuilder,
      (
        PriceSetting,
        BaseReferences<_$AppDatabase, $PriceSettingsTable, PriceSetting>,
      ),
      PriceSetting,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required DateTime date,
      required String description,
      required double amount,
      Value<String> category,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> description,
      Value<double> amount,
      Value<String> category,
    });

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
          Expense,
          PrefetchHooks Function()
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                date: date,
                description: description,
                amount: amount,
                category: category,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String description,
                required double amount,
                Value<String> category = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                date: date,
                description: description,
                amount: amount,
                category: category,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, BaseReferences<_$AppDatabase, $ExpensesTable, Expense>),
      Expense,
      PrefetchHooks Function()
    >;
typedef $$FeedingLogTableCreateCompanionBuilder =
    FeedingLogCompanion Function({
      Value<int> id,
      required DateTime date,
      required String feedType,
      required double quantityKg,
      Value<int?> cowId,
      Value<String?> notes,
    });
typedef $$FeedingLogTableUpdateCompanionBuilder =
    FeedingLogCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> feedType,
      Value<double> quantityKg,
      Value<int?> cowId,
      Value<String?> notes,
    });

final class $$FeedingLogTableReferences
    extends BaseReferences<_$AppDatabase, $FeedingLogTable, FeedingLogData> {
  $$FeedingLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CowTable _cowIdTable(_$AppDatabase db) =>
      db.cow.createAlias('feeding_log__cow_id__cow__id');

  $$CowTableProcessedTableManager? get cowId {
    final $_column = $_itemColumn<int>('cow_id');
    if ($_column == null) return null;
    final manager = $$CowTableTableManager(
      $_db,
      $_db.cow,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FeedingLogTableFilterComposer
    extends Composer<_$AppDatabase, $FeedingLogTable> {
  $$FeedingLogTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feedType => $composableBuilder(
    column: $table.feedType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityKg => $composableBuilder(
    column: $table.quantityKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$CowTableFilterComposer get cowId {
    final $$CowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableFilterComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedingLogTableOrderingComposer
    extends Composer<_$AppDatabase, $FeedingLogTable> {
  $$FeedingLogTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feedType => $composableBuilder(
    column: $table.feedType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityKg => $composableBuilder(
    column: $table.quantityKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CowTableOrderingComposer get cowId {
    final $$CowTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableOrderingComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedingLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeedingLogTable> {
  $$FeedingLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get feedType =>
      $composableBuilder(column: $table.feedType, builder: (column) => column);

  GeneratedColumn<double> get quantityKg => $composableBuilder(
    column: $table.quantityKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$CowTableAnnotationComposer get cowId {
    final $$CowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableAnnotationComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FeedingLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeedingLogTable,
          FeedingLogData,
          $$FeedingLogTableFilterComposer,
          $$FeedingLogTableOrderingComposer,
          $$FeedingLogTableAnnotationComposer,
          $$FeedingLogTableCreateCompanionBuilder,
          $$FeedingLogTableUpdateCompanionBuilder,
          (FeedingLogData, $$FeedingLogTableReferences),
          FeedingLogData,
          PrefetchHooks Function({bool cowId})
        > {
  $$FeedingLogTableTableManager(_$AppDatabase db, $FeedingLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeedingLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeedingLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeedingLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> feedType = const Value.absent(),
                Value<double> quantityKg = const Value.absent(),
                Value<int?> cowId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => FeedingLogCompanion(
                id: id,
                date: date,
                feedType: feedType,
                quantityKg: quantityKg,
                cowId: cowId,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String feedType,
                required double quantityKg,
                Value<int?> cowId = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => FeedingLogCompanion.insert(
                id: id,
                date: date,
                feedType: feedType,
                quantityKg: quantityKg,
                cowId: cowId,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FeedingLogTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cowId = false}) {
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
                    if (cowId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cowId,
                                referencedTable: $$FeedingLogTableReferences
                                    ._cowIdTable(db),
                                referencedColumn: $$FeedingLogTableReferences
                                    ._cowIdTable(db)
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

typedef $$FeedingLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeedingLogTable,
      FeedingLogData,
      $$FeedingLogTableFilterComposer,
      $$FeedingLogTableOrderingComposer,
      $$FeedingLogTableAnnotationComposer,
      $$FeedingLogTableCreateCompanionBuilder,
      $$FeedingLogTableUpdateCompanionBuilder,
      (FeedingLogData, $$FeedingLogTableReferences),
      FeedingLogData,
      PrefetchHooks Function({bool cowId})
    >;
typedef $$HealthRecordTableCreateCompanionBuilder =
    HealthRecordCompanion Function({
      Value<int> id,
      required DateTime date,
      required int cowId,
      required String recordType,
      required String description,
      Value<DateTime?> followUpDate,
    });
typedef $$HealthRecordTableUpdateCompanionBuilder =
    HealthRecordCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<int> cowId,
      Value<String> recordType,
      Value<String> description,
      Value<DateTime?> followUpDate,
    });

final class $$HealthRecordTableReferences
    extends
        BaseReferences<_$AppDatabase, $HealthRecordTable, HealthRecordData> {
  $$HealthRecordTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CowTable _cowIdTable(_$AppDatabase db) =>
      db.cow.createAlias('health_record__cow_id__cow__id');

  $$CowTableProcessedTableManager get cowId {
    final $_column = $_itemColumn<int>('cow_id')!;

    final manager = $$CowTableTableManager(
      $_db,
      $_db.cow,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HealthRecordTableFilterComposer
    extends Composer<_$AppDatabase, $HealthRecordTable> {
  $$HealthRecordTableFilterComposer({
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

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => ColumnFilters(column),
  );

  $$CowTableFilterComposer get cowId {
    final $$CowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableFilterComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordTableOrderingComposer
    extends Composer<_$AppDatabase, $HealthRecordTable> {
  $$HealthRecordTableOrderingComposer({
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

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => ColumnOrderings(column),
  );

  $$CowTableOrderingComposer get cowId {
    final $$CowTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableOrderingComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordTableAnnotationComposer
    extends Composer<_$AppDatabase, $HealthRecordTable> {
  $$HealthRecordTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get followUpDate => $composableBuilder(
    column: $table.followUpDate,
    builder: (column) => column,
  );

  $$CowTableAnnotationComposer get cowId {
    final $$CowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableAnnotationComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HealthRecordTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HealthRecordTable,
          HealthRecordData,
          $$HealthRecordTableFilterComposer,
          $$HealthRecordTableOrderingComposer,
          $$HealthRecordTableAnnotationComposer,
          $$HealthRecordTableCreateCompanionBuilder,
          $$HealthRecordTableUpdateCompanionBuilder,
          (HealthRecordData, $$HealthRecordTableReferences),
          HealthRecordData,
          PrefetchHooks Function({bool cowId})
        > {
  $$HealthRecordTableTableManager(_$AppDatabase db, $HealthRecordTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HealthRecordTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HealthRecordTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HealthRecordTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> cowId = const Value.absent(),
                Value<String> recordType = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime?> followUpDate = const Value.absent(),
              }) => HealthRecordCompanion(
                id: id,
                date: date,
                cowId: cowId,
                recordType: recordType,
                description: description,
                followUpDate: followUpDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required int cowId,
                required String recordType,
                required String description,
                Value<DateTime?> followUpDate = const Value.absent(),
              }) => HealthRecordCompanion.insert(
                id: id,
                date: date,
                cowId: cowId,
                recordType: recordType,
                description: description,
                followUpDate: followUpDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HealthRecordTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cowId = false}) {
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
                    if (cowId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cowId,
                                referencedTable: $$HealthRecordTableReferences
                                    ._cowIdTable(db),
                                referencedColumn: $$HealthRecordTableReferences
                                    ._cowIdTable(db)
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

typedef $$HealthRecordTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HealthRecordTable,
      HealthRecordData,
      $$HealthRecordTableFilterComposer,
      $$HealthRecordTableOrderingComposer,
      $$HealthRecordTableAnnotationComposer,
      $$HealthRecordTableCreateCompanionBuilder,
      $$HealthRecordTableUpdateCompanionBuilder,
      (HealthRecordData, $$HealthRecordTableReferences),
      HealthRecordData,
      PrefetchHooks Function({bool cowId})
    >;
typedef $$BreedingCyclesTableCreateCompanionBuilder =
    BreedingCyclesCompanion Function({
      Value<int> id,
      required int cowId,
      required DateTime heatDate,
      Value<DateTime?> serviceDate,
      Value<DateTime?> check1Date,
      Value<bool?> check1Result,
      Value<DateTime?> check2Date,
      Value<bool?> check2Result,
      Value<DateTime?> check3Date,
      Value<bool?> check3Result,
      Value<int> gestationDays,
      Value<DateTime?> expectedCalvingDate,
      Value<DateTime?> actualCalvingDate,
      Value<String?> calfSex,
      Value<int?> calfCowId,
      Value<bool> sold,
      Value<double?> saleAmount,
      Value<DateTime?> saleDate,
      required BreedingStage stage,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });
typedef $$BreedingCyclesTableUpdateCompanionBuilder =
    BreedingCyclesCompanion Function({
      Value<int> id,
      Value<int> cowId,
      Value<DateTime> heatDate,
      Value<DateTime?> serviceDate,
      Value<DateTime?> check1Date,
      Value<bool?> check1Result,
      Value<DateTime?> check2Date,
      Value<bool?> check2Result,
      Value<DateTime?> check3Date,
      Value<bool?> check3Result,
      Value<int> gestationDays,
      Value<DateTime?> expectedCalvingDate,
      Value<DateTime?> actualCalvingDate,
      Value<String?> calfSex,
      Value<int?> calfCowId,
      Value<bool> sold,
      Value<double?> saleAmount,
      Value<DateTime?> saleDate,
      Value<BreedingStage> stage,
      Value<bool> isActive,
      Value<DateTime> createdAt,
    });

final class $$BreedingCyclesTableReferences
    extends BaseReferences<_$AppDatabase, $BreedingCyclesTable, BreedingCycle> {
  $$BreedingCyclesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CowTable _cowIdTable(_$AppDatabase db) =>
      db.cow.createAlias('breeding_cycles__cow_id__cow__id');

  $$CowTableProcessedTableManager get cowId {
    final $_column = $_itemColumn<int>('cow_id')!;

    final manager = $$CowTableTableManager(
      $_db,
      $_db.cow,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CowTable _calfCowIdTable(_$AppDatabase db) =>
      db.cow.createAlias('breeding_cycles__calf_cow_id__cow__id');

  $$CowTableProcessedTableManager? get calfCowId {
    final $_column = $_itemColumn<int>('calf_cow_id');
    if ($_column == null) return null;
    final manager = $$CowTableTableManager(
      $_db,
      $_db.cow,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_calfCowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$LedgerEntriesTable, List<LedgerEntry>>
  _ledgerEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ledgerEntries,
    aliasName: 'breeding_cycles__id__ledger_entries__breeding_cycle_id',
  );

  $$LedgerEntriesTableProcessedTableManager get ledgerEntriesRefs {
    final manager = $$LedgerEntriesTableTableManager(
      $_db,
      $_db.ledgerEntries,
    ).filter((f) => f.breedingCycleId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ledgerEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BreedingCyclesTableFilterComposer
    extends Composer<_$AppDatabase, $BreedingCyclesTable> {
  $$BreedingCyclesTableFilterComposer({
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

  ColumnFilters<DateTime> get heatDate => $composableBuilder(
    column: $table.heatDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serviceDate => $composableBuilder(
    column: $table.serviceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get check1Date => $composableBuilder(
    column: $table.check1Date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get check1Result => $composableBuilder(
    column: $table.check1Result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get check2Date => $composableBuilder(
    column: $table.check2Date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get check2Result => $composableBuilder(
    column: $table.check2Result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get check3Date => $composableBuilder(
    column: $table.check3Date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get check3Result => $composableBuilder(
    column: $table.check3Result,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gestationDays => $composableBuilder(
    column: $table.gestationDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expectedCalvingDate => $composableBuilder(
    column: $table.expectedCalvingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualCalvingDate => $composableBuilder(
    column: $table.actualCalvingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calfSex => $composableBuilder(
    column: $table.calfSex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sold => $composableBuilder(
    column: $table.sold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saleAmount => $composableBuilder(
    column: $table.saleAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<BreedingStage, BreedingStage, int> get stage =>
      $composableBuilder(
        column: $table.stage,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CowTableFilterComposer get cowId {
    final $$CowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableFilterComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CowTableFilterComposer get calfCowId {
    final $$CowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calfCowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableFilterComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> ledgerEntriesRefs(
    Expression<bool> Function($$LedgerEntriesTableFilterComposer f) f,
  ) {
    final $$LedgerEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.breedingCycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableFilterComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BreedingCyclesTableOrderingComposer
    extends Composer<_$AppDatabase, $BreedingCyclesTable> {
  $$BreedingCyclesTableOrderingComposer({
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

  ColumnOrderings<DateTime> get heatDate => $composableBuilder(
    column: $table.heatDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serviceDate => $composableBuilder(
    column: $table.serviceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get check1Date => $composableBuilder(
    column: $table.check1Date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get check1Result => $composableBuilder(
    column: $table.check1Result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get check2Date => $composableBuilder(
    column: $table.check2Date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get check2Result => $composableBuilder(
    column: $table.check2Result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get check3Date => $composableBuilder(
    column: $table.check3Date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get check3Result => $composableBuilder(
    column: $table.check3Result,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gestationDays => $composableBuilder(
    column: $table.gestationDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expectedCalvingDate => $composableBuilder(
    column: $table.expectedCalvingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualCalvingDate => $composableBuilder(
    column: $table.actualCalvingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calfSex => $composableBuilder(
    column: $table.calfSex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sold => $composableBuilder(
    column: $table.sold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saleAmount => $composableBuilder(
    column: $table.saleAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get saleDate => $composableBuilder(
    column: $table.saleDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CowTableOrderingComposer get cowId {
    final $$CowTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableOrderingComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CowTableOrderingComposer get calfCowId {
    final $$CowTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calfCowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableOrderingComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BreedingCyclesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BreedingCyclesTable> {
  $$BreedingCyclesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get heatDate =>
      $composableBuilder(column: $table.heatDate, builder: (column) => column);

  GeneratedColumn<DateTime> get serviceDate => $composableBuilder(
    column: $table.serviceDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get check1Date => $composableBuilder(
    column: $table.check1Date,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get check1Result => $composableBuilder(
    column: $table.check1Result,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get check2Date => $composableBuilder(
    column: $table.check2Date,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get check2Result => $composableBuilder(
    column: $table.check2Result,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get check3Date => $composableBuilder(
    column: $table.check3Date,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get check3Result => $composableBuilder(
    column: $table.check3Result,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gestationDays => $composableBuilder(
    column: $table.gestationDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expectedCalvingDate => $composableBuilder(
    column: $table.expectedCalvingDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get actualCalvingDate => $composableBuilder(
    column: $table.actualCalvingDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get calfSex =>
      $composableBuilder(column: $table.calfSex, builder: (column) => column);

  GeneratedColumn<bool> get sold =>
      $composableBuilder(column: $table.sold, builder: (column) => column);

  GeneratedColumn<double> get saleAmount => $composableBuilder(
    column: $table.saleAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get saleDate =>
      $composableBuilder(column: $table.saleDate, builder: (column) => column);

  GeneratedColumnWithTypeConverter<BreedingStage, int> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CowTableAnnotationComposer get cowId {
    final $$CowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableAnnotationComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CowTableAnnotationComposer get calfCowId {
    final $$CowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.calfCowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableAnnotationComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> ledgerEntriesRefs<T extends Object>(
    Expression<T> Function($$LedgerEntriesTableAnnotationComposer a) f,
  ) {
    final $$LedgerEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ledgerEntries,
      getReferencedColumn: (t) => t.breedingCycleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LedgerEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.ledgerEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BreedingCyclesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BreedingCyclesTable,
          BreedingCycle,
          $$BreedingCyclesTableFilterComposer,
          $$BreedingCyclesTableOrderingComposer,
          $$BreedingCyclesTableAnnotationComposer,
          $$BreedingCyclesTableCreateCompanionBuilder,
          $$BreedingCyclesTableUpdateCompanionBuilder,
          (BreedingCycle, $$BreedingCyclesTableReferences),
          BreedingCycle,
          PrefetchHooks Function({
            bool cowId,
            bool calfCowId,
            bool ledgerEntriesRefs,
          })
        > {
  $$BreedingCyclesTableTableManager(
    _$AppDatabase db,
    $BreedingCyclesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BreedingCyclesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BreedingCyclesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BreedingCyclesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cowId = const Value.absent(),
                Value<DateTime> heatDate = const Value.absent(),
                Value<DateTime?> serviceDate = const Value.absent(),
                Value<DateTime?> check1Date = const Value.absent(),
                Value<bool?> check1Result = const Value.absent(),
                Value<DateTime?> check2Date = const Value.absent(),
                Value<bool?> check2Result = const Value.absent(),
                Value<DateTime?> check3Date = const Value.absent(),
                Value<bool?> check3Result = const Value.absent(),
                Value<int> gestationDays = const Value.absent(),
                Value<DateTime?> expectedCalvingDate = const Value.absent(),
                Value<DateTime?> actualCalvingDate = const Value.absent(),
                Value<String?> calfSex = const Value.absent(),
                Value<int?> calfCowId = const Value.absent(),
                Value<bool> sold = const Value.absent(),
                Value<double?> saleAmount = const Value.absent(),
                Value<DateTime?> saleDate = const Value.absent(),
                Value<BreedingStage> stage = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BreedingCyclesCompanion(
                id: id,
                cowId: cowId,
                heatDate: heatDate,
                serviceDate: serviceDate,
                check1Date: check1Date,
                check1Result: check1Result,
                check2Date: check2Date,
                check2Result: check2Result,
                check3Date: check3Date,
                check3Result: check3Result,
                gestationDays: gestationDays,
                expectedCalvingDate: expectedCalvingDate,
                actualCalvingDate: actualCalvingDate,
                calfSex: calfSex,
                calfCowId: calfCowId,
                sold: sold,
                saleAmount: saleAmount,
                saleDate: saleDate,
                stage: stage,
                isActive: isActive,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cowId,
                required DateTime heatDate,
                Value<DateTime?> serviceDate = const Value.absent(),
                Value<DateTime?> check1Date = const Value.absent(),
                Value<bool?> check1Result = const Value.absent(),
                Value<DateTime?> check2Date = const Value.absent(),
                Value<bool?> check2Result = const Value.absent(),
                Value<DateTime?> check3Date = const Value.absent(),
                Value<bool?> check3Result = const Value.absent(),
                Value<int> gestationDays = const Value.absent(),
                Value<DateTime?> expectedCalvingDate = const Value.absent(),
                Value<DateTime?> actualCalvingDate = const Value.absent(),
                Value<String?> calfSex = const Value.absent(),
                Value<int?> calfCowId = const Value.absent(),
                Value<bool> sold = const Value.absent(),
                Value<double?> saleAmount = const Value.absent(),
                Value<DateTime?> saleDate = const Value.absent(),
                required BreedingStage stage,
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => BreedingCyclesCompanion.insert(
                id: id,
                cowId: cowId,
                heatDate: heatDate,
                serviceDate: serviceDate,
                check1Date: check1Date,
                check1Result: check1Result,
                check2Date: check2Date,
                check2Result: check2Result,
                check3Date: check3Date,
                check3Result: check3Result,
                gestationDays: gestationDays,
                expectedCalvingDate: expectedCalvingDate,
                actualCalvingDate: actualCalvingDate,
                calfSex: calfSex,
                calfCowId: calfCowId,
                sold: sold,
                saleAmount: saleAmount,
                saleDate: saleDate,
                stage: stage,
                isActive: isActive,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BreedingCyclesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({cowId = false, calfCowId = false, ledgerEntriesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ledgerEntriesRefs) db.ledgerEntries,
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
                        if (cowId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cowId,
                                    referencedTable:
                                        $$BreedingCyclesTableReferences
                                            ._cowIdTable(db),
                                    referencedColumn:
                                        $$BreedingCyclesTableReferences
                                            ._cowIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (calfCowId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.calfCowId,
                                    referencedTable:
                                        $$BreedingCyclesTableReferences
                                            ._calfCowIdTable(db),
                                    referencedColumn:
                                        $$BreedingCyclesTableReferences
                                            ._calfCowIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ledgerEntriesRefs)
                        await $_getPrefetchedData<
                          BreedingCycle,
                          $BreedingCyclesTable,
                          LedgerEntry
                        >(
                          currentTable: table,
                          referencedTable: $$BreedingCyclesTableReferences
                              ._ledgerEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BreedingCyclesTableReferences(
                                db,
                                table,
                                p0,
                              ).ledgerEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.breedingCycleId == item.id,
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

typedef $$BreedingCyclesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BreedingCyclesTable,
      BreedingCycle,
      $$BreedingCyclesTableFilterComposer,
      $$BreedingCyclesTableOrderingComposer,
      $$BreedingCyclesTableAnnotationComposer,
      $$BreedingCyclesTableCreateCompanionBuilder,
      $$BreedingCyclesTableUpdateCompanionBuilder,
      (BreedingCycle, $$BreedingCyclesTableReferences),
      BreedingCycle,
      PrefetchHooks Function({
        bool cowId,
        bool calfCowId,
        bool ledgerEntriesRefs,
      })
    >;
typedef $$LedgerEntriesTableCreateCompanionBuilder =
    LedgerEntriesCompanion Function({
      Value<int> id,
      Value<int?> cowId,
      Value<int?> breedingCycleId,
      required String type,
      required String category,
      required double amount,
      Value<String?> note,
      Value<DateTime> date,
    });
typedef $$LedgerEntriesTableUpdateCompanionBuilder =
    LedgerEntriesCompanion Function({
      Value<int> id,
      Value<int?> cowId,
      Value<int?> breedingCycleId,
      Value<String> type,
      Value<String> category,
      Value<double> amount,
      Value<String?> note,
      Value<DateTime> date,
    });

final class $$LedgerEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $LedgerEntriesTable, LedgerEntry> {
  $$LedgerEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CowTable _cowIdTable(_$AppDatabase db) =>
      db.cow.createAlias('ledger_entries__cow_id__cow__id');

  $$CowTableProcessedTableManager? get cowId {
    final $_column = $_itemColumn<int>('cow_id');
    if ($_column == null) return null;
    final manager = $$CowTableTableManager(
      $_db,
      $_db.cow,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cowIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BreedingCyclesTable _breedingCycleIdTable(_$AppDatabase db) => db
      .breedingCycles
      .createAlias('ledger_entries__breeding_cycle_id__breeding_cycles__id');

  $$BreedingCyclesTableProcessedTableManager? get breedingCycleId {
    final $_column = $_itemColumn<int>('breeding_cycle_id');
    if ($_column == null) return null;
    final manager = $$BreedingCyclesTableTableManager(
      $_db,
      $_db.breedingCycles,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_breedingCycleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LedgerEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  $$CowTableFilterComposer get cowId {
    final $$CowTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableFilterComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BreedingCyclesTableFilterComposer get breedingCycleId {
    final $$BreedingCyclesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.breedingCycleId,
      referencedTable: $db.breedingCycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BreedingCyclesTableFilterComposer(
            $db: $db,
            $table: $db.breedingCycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  $$CowTableOrderingComposer get cowId {
    final $$CowTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableOrderingComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BreedingCyclesTableOrderingComposer get breedingCycleId {
    final $$BreedingCyclesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.breedingCycleId,
      referencedTable: $db.breedingCycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BreedingCyclesTableOrderingComposer(
            $db: $db,
            $table: $db.breedingCycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LedgerEntriesTable> {
  $$LedgerEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  $$CowTableAnnotationComposer get cowId {
    final $$CowTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cowId,
      referencedTable: $db.cow,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CowTableAnnotationComposer(
            $db: $db,
            $table: $db.cow,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BreedingCyclesTableAnnotationComposer get breedingCycleId {
    final $$BreedingCyclesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.breedingCycleId,
      referencedTable: $db.breedingCycles,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BreedingCyclesTableAnnotationComposer(
            $db: $db,
            $table: $db.breedingCycles,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LedgerEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LedgerEntriesTable,
          LedgerEntry,
          $$LedgerEntriesTableFilterComposer,
          $$LedgerEntriesTableOrderingComposer,
          $$LedgerEntriesTableAnnotationComposer,
          $$LedgerEntriesTableCreateCompanionBuilder,
          $$LedgerEntriesTableUpdateCompanionBuilder,
          (LedgerEntry, $$LedgerEntriesTableReferences),
          LedgerEntry,
          PrefetchHooks Function({bool cowId, bool breedingCycleId})
        > {
  $$LedgerEntriesTableTableManager(_$AppDatabase db, $LedgerEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LedgerEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LedgerEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LedgerEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> cowId = const Value.absent(),
                Value<int?> breedingCycleId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => LedgerEntriesCompanion(
                id: id,
                cowId: cowId,
                breedingCycleId: breedingCycleId,
                type: type,
                category: category,
                amount: amount,
                note: note,
                date: date,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> cowId = const Value.absent(),
                Value<int?> breedingCycleId = const Value.absent(),
                required String type,
                required String category,
                required double amount,
                Value<String?> note = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
              }) => LedgerEntriesCompanion.insert(
                id: id,
                cowId: cowId,
                breedingCycleId: breedingCycleId,
                type: type,
                category: category,
                amount: amount,
                note: note,
                date: date,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LedgerEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cowId = false, breedingCycleId = false}) {
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
                    if (cowId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cowId,
                                referencedTable: $$LedgerEntriesTableReferences
                                    ._cowIdTable(db),
                                referencedColumn: $$LedgerEntriesTableReferences
                                    ._cowIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (breedingCycleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.breedingCycleId,
                                referencedTable: $$LedgerEntriesTableReferences
                                    ._breedingCycleIdTable(db),
                                referencedColumn: $$LedgerEntriesTableReferences
                                    ._breedingCycleIdTable(db)
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

typedef $$LedgerEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LedgerEntriesTable,
      LedgerEntry,
      $$LedgerEntriesTableFilterComposer,
      $$LedgerEntriesTableOrderingComposer,
      $$LedgerEntriesTableAnnotationComposer,
      $$LedgerEntriesTableCreateCompanionBuilder,
      $$LedgerEntriesTableUpdateCompanionBuilder,
      (LedgerEntry, $$LedgerEntriesTableReferences),
      LedgerEntry,
      PrefetchHooks Function({bool cowId, bool breedingCycleId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CowTableTableManager get cow => $$CowTableTableManager(_db, _db.cow);
  $$MilkTableTableTableManager get milkTable =>
      $$MilkTableTableTableManager(_db, _db.milkTable);
  $$PriceSettingsTableTableManager get priceSettings =>
      $$PriceSettingsTableTableManager(_db, _db.priceSettings);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$FeedingLogTableTableManager get feedingLog =>
      $$FeedingLogTableTableManager(_db, _db.feedingLog);
  $$HealthRecordTableTableManager get healthRecord =>
      $$HealthRecordTableTableManager(_db, _db.healthRecord);
  $$BreedingCyclesTableTableManager get breedingCycles =>
      $$BreedingCyclesTableTableManager(_db, _db.breedingCycles);
  $$LedgerEntriesTableTableManager get ledgerEntries =>
      $$LedgerEntriesTableTableManager(_db, _db.ledgerEntries);
}
