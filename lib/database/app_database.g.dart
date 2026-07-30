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
  @override
  List<GeneratedColumn> get $columns => [id, name, tag, breed, age, imagePath];
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
  const CowData({
    required this.id,
    required this.name,
    this.tag,
    this.breed,
    this.age,
    this.imagePath,
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
    };
  }

  CowData copyWith({
    int? id,
    String? name,
    Value<String?> tag = const Value.absent(),
    Value<String?> breed = const Value.absent(),
    Value<int?> age = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
  }) => CowData(
    id: id ?? this.id,
    name: name ?? this.name,
    tag: tag.present ? tag.value : this.tag,
    breed: breed.present ? breed.value : this.breed,
    age: age.present ? age.value : this.age,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
  );
  CowData copyWithCompanion(CowCompanion data) {
    return CowData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      tag: data.tag.present ? data.tag.value : this.tag,
      breed: data.breed.present ? data.breed.value : this.breed,
      age: data.age.present ? data.age.value : this.age,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
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
          ..write('imagePath: $imagePath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, tag, breed, age, imagePath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CowData &&
          other.id == this.id &&
          other.name == this.name &&
          other.tag == this.tag &&
          other.breed == this.breed &&
          other.age == this.age &&
          other.imagePath == this.imagePath);
}

class CowCompanion extends UpdateCompanion<CowData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> tag;
  final Value<String?> breed;
  final Value<int?> age;
  final Value<String?> imagePath;
  const CowCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.tag = const Value.absent(),
    this.breed = const Value.absent(),
    this.age = const Value.absent(),
    this.imagePath = const Value.absent(),
  });
  CowCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.tag = const Value.absent(),
    this.breed = const Value.absent(),
    this.age = const Value.absent(),
    this.imagePath = const Value.absent(),
  }) : name = Value(name);
  static Insertable<CowData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? tag,
    Expression<String>? breed,
    Expression<int>? age,
    Expression<String>? imagePath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (tag != null) 'tag': tag,
      if (breed != null) 'breed': breed,
      if (age != null) 'age': age,
      if (imagePath != null) 'image_path': imagePath,
    });
  }

  CowCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? tag,
    Value<String?>? breed,
    Value<int?>? age,
    Value<String?>? imagePath,
  }) {
    return CowCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      tag: tag ?? this.tag,
      breed: breed ?? this.breed,
      age: age ?? this.age,
      imagePath: imagePath ?? this.imagePath,
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
          ..write('imagePath: $imagePath')
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

class $MilkRecordsTable extends MilkRecords
    with TableInfo<$MilkRecordsTable, MilkRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilkRecordsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _litresMeta = const VerificationMeta('litres');
  @override
  late final GeneratedColumn<double> litres = GeneratedColumn<double>(
    'litres',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    requiredDuringInsert: false,
    defaultValue: const Constant(50.0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, litres, pricePerLitre];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milk_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilkRecord> instance, {
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
    if (data.containsKey('litres')) {
      context.handle(
        _litresMeta,
        litres.isAcceptableOrUnknown(data['litres']!, _litresMeta),
      );
    } else if (isInserting) {
      context.missing(_litresMeta);
    }
    if (data.containsKey('price_per_litre')) {
      context.handle(
        _pricePerLitreMeta,
        pricePerLitre.isAcceptableOrUnknown(
          data['price_per_litre']!,
          _pricePerLitreMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MilkRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilkRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      litres: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}litres'],
      )!,
      pricePerLitre: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price_per_litre'],
      )!,
    );
  }

  @override
  $MilkRecordsTable createAlias(String alias) {
    return $MilkRecordsTable(attachedDatabase, alias);
  }
}

class MilkRecord extends DataClass implements Insertable<MilkRecord> {
  final int id;
  final DateTime date;
  final double litres;
  final double pricePerLitre;
  const MilkRecord({
    required this.id,
    required this.date,
    required this.litres,
    required this.pricePerLitre,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['litres'] = Variable<double>(litres);
    map['price_per_litre'] = Variable<double>(pricePerLitre);
    return map;
  }

  MilkRecordsCompanion toCompanion(bool nullToAbsent) {
    return MilkRecordsCompanion(
      id: Value(id),
      date: Value(date),
      litres: Value(litres),
      pricePerLitre: Value(pricePerLitre),
    );
  }

  factory MilkRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilkRecord(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      litres: serializer.fromJson<double>(json['litres']),
      pricePerLitre: serializer.fromJson<double>(json['pricePerLitre']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<DateTime>(date),
      'litres': serializer.toJson<double>(litres),
      'pricePerLitre': serializer.toJson<double>(pricePerLitre),
    };
  }

  MilkRecord copyWith({
    int? id,
    DateTime? date,
    double? litres,
    double? pricePerLitre,
  }) => MilkRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    litres: litres ?? this.litres,
    pricePerLitre: pricePerLitre ?? this.pricePerLitre,
  );
  MilkRecord copyWithCompanion(MilkRecordsCompanion data) {
    return MilkRecord(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      litres: data.litres.present ? data.litres.value : this.litres,
      pricePerLitre: data.pricePerLitre.present
          ? data.pricePerLitre.value
          : this.pricePerLitre,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilkRecord(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('litres: $litres, ')
          ..write('pricePerLitre: $pricePerLitre')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, litres, pricePerLitre);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilkRecord &&
          other.id == this.id &&
          other.date == this.date &&
          other.litres == this.litres &&
          other.pricePerLitre == this.pricePerLitre);
}

class MilkRecordsCompanion extends UpdateCompanion<MilkRecord> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<double> litres;
  final Value<double> pricePerLitre;
  const MilkRecordsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.litres = const Value.absent(),
    this.pricePerLitre = const Value.absent(),
  });
  MilkRecordsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required double litres,
    this.pricePerLitre = const Value.absent(),
  }) : date = Value(date),
       litres = Value(litres);
  static Insertable<MilkRecord> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<double>? litres,
    Expression<double>? pricePerLitre,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (litres != null) 'litres': litres,
      if (pricePerLitre != null) 'price_per_litre': pricePerLitre,
    });
  }

  MilkRecordsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<double>? litres,
    Value<double>? pricePerLitre,
  }) {
    return MilkRecordsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      litres: litres ?? this.litres,
      pricePerLitre: pricePerLitre ?? this.pricePerLitre,
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
    if (litres.present) {
      map['litres'] = Variable<double>(litres.value);
    }
    if (pricePerLitre.present) {
      map['price_per_litre'] = Variable<double>(pricePerLitre.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilkRecordsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('litres: $litres, ')
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
  @override
  List<GeneratedColumn> get $columns => [id, date, description, amount];
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
  const Expense({
    required this.id,
    required this.date,
    required this.description,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<DateTime>(date);
    map['description'] = Variable<String>(description);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      description: Value(description),
      amount: Value(amount),
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
    };
  }

  Expense copyWith({
    int? id,
    DateTime? date,
    String? description,
    double? amount,
  }) => Expense(
    id: id ?? this.id,
    date: date ?? this.date,
    description: description ?? this.description,
    amount: amount ?? this.amount,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      description: data.description.present
          ? data.description.value
          : this.description,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, description, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.description == this.description &&
          other.amount == this.amount);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<DateTime> date;
  final Value<String> description;
  final Value<double> amount;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.description = const Value.absent(),
    this.amount = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime date,
    required String description,
    required double amount,
  }) : date = Value(date),
       description = Value(description),
       amount = Value(amount);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<DateTime>? date,
    Expression<String>? description,
    Expression<double>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (description != null) 'description': description,
      if (amount != null) 'amount': amount,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? date,
    Value<String>? description,
    Value<double>? amount,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      description: description ?? this.description,
      amount: amount ?? this.amount,
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
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('description: $description, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CowTable cow = $CowTable(this);
  late final $MilkTableTable milkTable = $MilkTableTable(this);
  late final $MilkRecordsTable milkRecords = $MilkRecordsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    cow,
    milkTable,
    milkRecords,
    expenses,
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
    });
typedef $$CowTableUpdateCompanionBuilder =
    CowCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> tag,
      Value<String?> breed,
      Value<int?> age,
      Value<String?> imagePath,
    });

final class $$CowTableReferences
    extends BaseReferences<_$AppDatabase, $CowTable, CowData> {
  $$CowTableReferences(super.$_db, super.$_table, super.$_typedResult);

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
          PrefetchHooks Function({bool milkTableRefs})
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
              }) => CowCompanion(
                id: id,
                name: name,
                tag: tag,
                breed: breed,
                age: age,
                imagePath: imagePath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> tag = const Value.absent(),
                Value<String?> breed = const Value.absent(),
                Value<int?> age = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
              }) => CowCompanion.insert(
                id: id,
                name: name,
                tag: tag,
                breed: breed,
                age: age,
                imagePath: imagePath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (e.readTable(table), $$CowTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({milkTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (milkTableRefs) db.milkTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (milkTableRefs)
                    await $_getPrefetchedData<
                      CowData,
                      $CowTable,
                      MilkTableData
                    >(
                      currentTable: table,
                      referencedTable: $$CowTableReferences._milkTableRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$CowTableReferences(db, table, p0).milkTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.cowId == item.id),
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
      PrefetchHooks Function({bool milkTableRefs})
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
typedef $$MilkRecordsTableCreateCompanionBuilder =
    MilkRecordsCompanion Function({
      Value<int> id,
      required DateTime date,
      required double litres,
      Value<double> pricePerLitre,
    });
typedef $$MilkRecordsTableUpdateCompanionBuilder =
    MilkRecordsCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<double> litres,
      Value<double> pricePerLitre,
    });

class $$MilkRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $MilkRecordsTable> {
  $$MilkRecordsTableFilterComposer({
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

  ColumnFilters<double> get litres => $composableBuilder(
    column: $table.litres,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pricePerLitre => $composableBuilder(
    column: $table.pricePerLitre,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MilkRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $MilkRecordsTable> {
  $$MilkRecordsTableOrderingComposer({
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

  ColumnOrderings<double> get litres => $composableBuilder(
    column: $table.litres,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pricePerLitre => $composableBuilder(
    column: $table.pricePerLitre,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MilkRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilkRecordsTable> {
  $$MilkRecordsTableAnnotationComposer({
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

  GeneratedColumn<double> get litres =>
      $composableBuilder(column: $table.litres, builder: (column) => column);

  GeneratedColumn<double> get pricePerLitre => $composableBuilder(
    column: $table.pricePerLitre,
    builder: (column) => column,
  );
}

class $$MilkRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilkRecordsTable,
          MilkRecord,
          $$MilkRecordsTableFilterComposer,
          $$MilkRecordsTableOrderingComposer,
          $$MilkRecordsTableAnnotationComposer,
          $$MilkRecordsTableCreateCompanionBuilder,
          $$MilkRecordsTableUpdateCompanionBuilder,
          (
            MilkRecord,
            BaseReferences<_$AppDatabase, $MilkRecordsTable, MilkRecord>,
          ),
          MilkRecord,
          PrefetchHooks Function()
        > {
  $$MilkRecordsTableTableManager(_$AppDatabase db, $MilkRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilkRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilkRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilkRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<double> litres = const Value.absent(),
                Value<double> pricePerLitre = const Value.absent(),
              }) => MilkRecordsCompanion(
                id: id,
                date: date,
                litres: litres,
                pricePerLitre: pricePerLitre,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required double litres,
                Value<double> pricePerLitre = const Value.absent(),
              }) => MilkRecordsCompanion.insert(
                id: id,
                date: date,
                litres: litres,
                pricePerLitre: pricePerLitre,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MilkRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilkRecordsTable,
      MilkRecord,
      $$MilkRecordsTableFilterComposer,
      $$MilkRecordsTableOrderingComposer,
      $$MilkRecordsTableAnnotationComposer,
      $$MilkRecordsTableCreateCompanionBuilder,
      $$MilkRecordsTableUpdateCompanionBuilder,
      (
        MilkRecord,
        BaseReferences<_$AppDatabase, $MilkRecordsTable, MilkRecord>,
      ),
      MilkRecord,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      required DateTime date,
      required String description,
      required double amount,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<int> id,
      Value<DateTime> date,
      Value<String> description,
      Value<double> amount,
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
              }) => ExpensesCompanion(
                id: id,
                date: date,
                description: description,
                amount: amount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime date,
                required String description,
                required double amount,
              }) => ExpensesCompanion.insert(
                id: id,
                date: date,
                description: description,
                amount: amount,
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CowTableTableManager get cow => $$CowTableTableManager(_db, _db.cow);
  $$MilkTableTableTableManager get milkTable =>
      $$MilkTableTableTableManager(_db, _db.milkTable);
  $$MilkRecordsTableTableManager get milkRecords =>
      $$MilkRecordsTableTableManager(_db, _db.milkRecords);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
}
