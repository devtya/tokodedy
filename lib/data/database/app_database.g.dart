// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $TokoTableTable extends TokoTable
    with TableInfo<$TokoTableTable, TokoTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TokoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _alamatMeta = const VerificationMeta('alamat');
  @override
  late final GeneratedColumn<String> alamat = GeneratedColumn<String>(
    'alamat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _teleponMeta = const VerificationMeta(
    'telepon',
  );
  @override
  late final GeneratedColumn<String> telepon = GeneratedColumn<String>(
    'telepon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stokMinimumGlobalMeta = const VerificationMeta(
    'stokMinimumGlobal',
  );
  @override
  late final GeneratedColumn<int> stokMinimumGlobal = GeneratedColumn<int>(
    'stok_minimum_global',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    nama,
    alamat,
    telepon,
    ownerId,
    stokMinimumGlobal,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'toko_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TokoTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('alamat')) {
      context.handle(
        _alamatMeta,
        alamat.isAcceptableOrUnknown(data['alamat']!, _alamatMeta),
      );
    }
    if (data.containsKey('telepon')) {
      context.handle(
        _teleponMeta,
        telepon.isAcceptableOrUnknown(data['telepon']!, _teleponMeta),
      );
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    }
    if (data.containsKey('stok_minimum_global')) {
      context.handle(
        _stokMinimumGlobalMeta,
        stokMinimumGlobal.isAcceptableOrUnknown(
          data['stok_minimum_global']!,
          _stokMinimumGlobalMeta,
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
  TokoTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TokoTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      alamat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alamat'],
      ),
      telepon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telepon'],
      ),
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      ),
      stokMinimumGlobal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stok_minimum_global'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TokoTableTable createAlias(String alias) {
    return $TokoTableTable(attachedDatabase, alias);
  }
}

class TokoTableData extends DataClass implements Insertable<TokoTableData> {
  final String id;
  final String nama;
  final String? alamat;
  final String? telepon;
  final String? ownerId;
  final int stokMinimumGlobal;
  final DateTime createdAt;
  const TokoTableData({
    required this.id,
    required this.nama,
    this.alamat,
    this.telepon,
    this.ownerId,
    required this.stokMinimumGlobal,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    if (!nullToAbsent || telepon != null) {
      map['telepon'] = Variable<String>(telepon);
    }
    if (!nullToAbsent || ownerId != null) {
      map['owner_id'] = Variable<String>(ownerId);
    }
    map['stok_minimum_global'] = Variable<int>(stokMinimumGlobal);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TokoTableCompanion toCompanion(bool nullToAbsent) {
    return TokoTableCompanion(
      id: Value(id),
      nama: Value(nama),
      alamat: alamat == null && nullToAbsent
          ? const Value.absent()
          : Value(alamat),
      telepon: telepon == null && nullToAbsent
          ? const Value.absent()
          : Value(telepon),
      ownerId: ownerId == null && nullToAbsent
          ? const Value.absent()
          : Value(ownerId),
      stokMinimumGlobal: Value(stokMinimumGlobal),
      createdAt: Value(createdAt),
    );
  }

  factory TokoTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TokoTableData(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      telepon: serializer.fromJson<String?>(json['telepon']),
      ownerId: serializer.fromJson<String?>(json['ownerId']),
      stokMinimumGlobal: serializer.fromJson<int>(json['stokMinimumGlobal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'alamat': serializer.toJson<String?>(alamat),
      'telepon': serializer.toJson<String?>(telepon),
      'ownerId': serializer.toJson<String?>(ownerId),
      'stokMinimumGlobal': serializer.toJson<int>(stokMinimumGlobal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TokoTableData copyWith({
    String? id,
    String? nama,
    Value<String?> alamat = const Value.absent(),
    Value<String?> telepon = const Value.absent(),
    Value<String?> ownerId = const Value.absent(),
    int? stokMinimumGlobal,
    DateTime? createdAt,
  }) => TokoTableData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    alamat: alamat.present ? alamat.value : this.alamat,
    telepon: telepon.present ? telepon.value : this.telepon,
    ownerId: ownerId.present ? ownerId.value : this.ownerId,
    stokMinimumGlobal: stokMinimumGlobal ?? this.stokMinimumGlobal,
    createdAt: createdAt ?? this.createdAt,
  );
  TokoTableData copyWithCompanion(TokoTableCompanion data) {
    return TokoTableData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      telepon: data.telepon.present ? data.telepon.value : this.telepon,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      stokMinimumGlobal: data.stokMinimumGlobal.present
          ? data.stokMinimumGlobal.value
          : this.stokMinimumGlobal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TokoTableData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('alamat: $alamat, ')
          ..write('telepon: $telepon, ')
          ..write('ownerId: $ownerId, ')
          ..write('stokMinimumGlobal: $stokMinimumGlobal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nama,
    alamat,
    telepon,
    ownerId,
    stokMinimumGlobal,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TokoTableData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.alamat == this.alamat &&
          other.telepon == this.telepon &&
          other.ownerId == this.ownerId &&
          other.stokMinimumGlobal == this.stokMinimumGlobal &&
          other.createdAt == this.createdAt);
}

class TokoTableCompanion extends UpdateCompanion<TokoTableData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String?> alamat;
  final Value<String?> telepon;
  final Value<String?> ownerId;
  final Value<int> stokMinimumGlobal;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TokoTableCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.alamat = const Value.absent(),
    this.telepon = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.stokMinimumGlobal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TokoTableCompanion.insert({
    required String id,
    required String nama,
    this.alamat = const Value.absent(),
    this.telepon = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.stokMinimumGlobal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama);
  static Insertable<TokoTableData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? alamat,
    Expression<String>? telepon,
    Expression<String>? ownerId,
    Expression<int>? stokMinimumGlobal,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (alamat != null) 'alamat': alamat,
      if (telepon != null) 'telepon': telepon,
      if (ownerId != null) 'owner_id': ownerId,
      if (stokMinimumGlobal != null) 'stok_minimum_global': stokMinimumGlobal,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TokoTableCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String?>? alamat,
    Value<String?>? telepon,
    Value<String?>? ownerId,
    Value<int>? stokMinimumGlobal,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TokoTableCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      alamat: alamat ?? this.alamat,
      telepon: telepon ?? this.telepon,
      ownerId: ownerId ?? this.ownerId,
      stokMinimumGlobal: stokMinimumGlobal ?? this.stokMinimumGlobal,
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
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (telepon.present) {
      map['telepon'] = Variable<String>(telepon.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (stokMinimumGlobal.present) {
      map['stok_minimum_global'] = Variable<int>(stokMinimumGlobal.value);
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
    return (StringBuffer('TokoTableCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('alamat: $alamat, ')
          ..write('telepon: $telepon, ')
          ..write('ownerId: $ownerId, ')
          ..write('stokMinimumGlobal: $stokMinimumGlobal, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserTableTable extends UserTable
    with TableInfo<$UserTableTable, UserTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('kasir'),
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
  List<GeneratedColumn> get $columns => [id, tokoId, nama, role, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
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
  UserTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserTableTable createAlias(String alias) {
    return $UserTableTable(attachedDatabase, alias);
  }
}

class UserTableData extends DataClass implements Insertable<UserTableData> {
  final String id;
  final String tokoId;
  final String? nama;
  final String role;
  final DateTime createdAt;
  const UserTableData({
    required this.id,
    required this.tokoId,
    this.nama,
    required this.role,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    if (!nullToAbsent || nama != null) {
      map['nama'] = Variable<String>(nama);
    }
    map['role'] = Variable<String>(role);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserTableCompanion toCompanion(bool nullToAbsent) {
    return UserTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      nama: nama == null && nullToAbsent ? const Value.absent() : Value(nama),
      role: Value(role),
      createdAt: Value(createdAt),
    );
  }

  factory UserTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      nama: serializer.fromJson<String?>(json['nama']),
      role: serializer.fromJson<String>(json['role']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'nama': serializer.toJson<String?>(nama),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserTableData copyWith({
    String? id,
    String? tokoId,
    Value<String?> nama = const Value.absent(),
    String? role,
    DateTime? createdAt,
  }) => UserTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    nama: nama.present ? nama.value : this.nama,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
  );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      nama: data.nama.present ? data.nama.value : this.nama,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('nama: $nama, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, tokoId, nama, role, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.nama == this.nama &&
          other.role == this.role &&
          other.createdAt == this.createdAt);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String?> nama;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.nama = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String id,
    required String tokoId,
    this.nama = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId);
  static Insertable<UserTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? nama,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (nama != null) 'nama': nama,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String?>? nama,
    Value<String>? role,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      nama: nama ?? this.nama,
      role: role ?? this.role,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
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
    return (StringBuffer('UserTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('nama: $nama, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProdukTableTable extends ProdukTable
    with TableInfo<$ProdukTableTable, ProdukTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProdukTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hargaBeliMeta = const VerificationMeta(
    'hargaBeli',
  );
  @override
  late final GeneratedColumn<double> hargaBeli = GeneratedColumn<double>(
    'harga_beli',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hargaJualMeta = const VerificationMeta(
    'hargaJual',
  );
  @override
  late final GeneratedColumn<double> hargaJual = GeneratedColumn<double>(
    'harga_jual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _stokMeta = const VerificationMeta('stok');
  @override
  late final GeneratedColumn<int> stok = GeneratedColumn<int>(
    'stok',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kategoriMeta = const VerificationMeta(
    'kategori',
  );
  @override
  late final GeneratedColumn<String> kategori = GeneratedColumn<String>(
    'kategori',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _satuanMeta = const VerificationMeta('satuan');
  @override
  late final GeneratedColumn<String> satuan = GeneratedColumn<String>(
    'satuan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pcs'),
  );
  static const VerificationMeta _stokMinimumMeta = const VerificationMeta(
    'stokMinimum',
  );
  @override
  late final GeneratedColumn<int> stokMinimum = GeneratedColumn<int>(
    'stok_minimum',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
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
    defaultValue: currentDateAndTime,
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
    tokoId,
    nama,
    barcode,
    hargaBeli,
    hargaJual,
    stok,
    kategori,
    satuan,
    stokMinimum,
    updatedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'produk_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProdukTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('harga_beli')) {
      context.handle(
        _hargaBeliMeta,
        hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta),
      );
    }
    if (data.containsKey('harga_jual')) {
      context.handle(
        _hargaJualMeta,
        hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta),
      );
    }
    if (data.containsKey('stok')) {
      context.handle(
        _stokMeta,
        stok.isAcceptableOrUnknown(data['stok']!, _stokMeta),
      );
    }
    if (data.containsKey('kategori')) {
      context.handle(
        _kategoriMeta,
        kategori.isAcceptableOrUnknown(data['kategori']!, _kategoriMeta),
      );
    }
    if (data.containsKey('satuan')) {
      context.handle(
        _satuanMeta,
        satuan.isAcceptableOrUnknown(data['satuan']!, _satuanMeta),
      );
    }
    if (data.containsKey('stok_minimum')) {
      context.handle(
        _stokMinimumMeta,
        stokMinimum.isAcceptableOrUnknown(
          data['stok_minimum']!,
          _stokMinimumMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
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
  ProdukTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProdukTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      hargaBeli: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_beli'],
      )!,
      hargaJual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_jual'],
      )!,
      stok: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stok'],
      )!,
      kategori: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori'],
      ),
      satuan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}satuan'],
      )!,
      stokMinimum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stok_minimum'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProdukTableTable createAlias(String alias) {
    return $ProdukTableTable(attachedDatabase, alias);
  }
}

class ProdukTableData extends DataClass implements Insertable<ProdukTableData> {
  final String id;
  final String tokoId;
  final String nama;
  final String? barcode;
  final double hargaBeli;
  final double hargaJual;
  final int stok;
  final String? kategori;
  final String satuan;
  final int? stokMinimum;
  final DateTime updatedAt;
  final DateTime createdAt;
  const ProdukTableData({
    required this.id,
    required this.tokoId,
    required this.nama,
    this.barcode,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
    this.kategori,
    required this.satuan,
    this.stokMinimum,
    required this.updatedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['harga_beli'] = Variable<double>(hargaBeli);
    map['harga_jual'] = Variable<double>(hargaJual);
    map['stok'] = Variable<int>(stok);
    if (!nullToAbsent || kategori != null) {
      map['kategori'] = Variable<String>(kategori);
    }
    map['satuan'] = Variable<String>(satuan);
    if (!nullToAbsent || stokMinimum != null) {
      map['stok_minimum'] = Variable<int>(stokMinimum);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProdukTableCompanion toCompanion(bool nullToAbsent) {
    return ProdukTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      nama: Value(nama),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      stok: Value(stok),
      kategori: kategori == null && nullToAbsent
          ? const Value.absent()
          : Value(kategori),
      satuan: Value(satuan),
      stokMinimum: stokMinimum == null && nullToAbsent
          ? const Value.absent()
          : Value(stokMinimum),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory ProdukTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProdukTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      nama: serializer.fromJson<String>(json['nama']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      hargaBeli: serializer.fromJson<double>(json['hargaBeli']),
      hargaJual: serializer.fromJson<double>(json['hargaJual']),
      stok: serializer.fromJson<int>(json['stok']),
      kategori: serializer.fromJson<String?>(json['kategori']),
      satuan: serializer.fromJson<String>(json['satuan']),
      stokMinimum: serializer.fromJson<int?>(json['stokMinimum']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'nama': serializer.toJson<String>(nama),
      'barcode': serializer.toJson<String?>(barcode),
      'hargaBeli': serializer.toJson<double>(hargaBeli),
      'hargaJual': serializer.toJson<double>(hargaJual),
      'stok': serializer.toJson<int>(stok),
      'kategori': serializer.toJson<String?>(kategori),
      'satuan': serializer.toJson<String>(satuan),
      'stokMinimum': serializer.toJson<int?>(stokMinimum),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProdukTableData copyWith({
    String? id,
    String? tokoId,
    String? nama,
    Value<String?> barcode = const Value.absent(),
    double? hargaBeli,
    double? hargaJual,
    int? stok,
    Value<String?> kategori = const Value.absent(),
    String? satuan,
    Value<int?> stokMinimum = const Value.absent(),
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => ProdukTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    nama: nama ?? this.nama,
    barcode: barcode.present ? barcode.value : this.barcode,
    hargaBeli: hargaBeli ?? this.hargaBeli,
    hargaJual: hargaJual ?? this.hargaJual,
    stok: stok ?? this.stok,
    kategori: kategori.present ? kategori.value : this.kategori,
    satuan: satuan ?? this.satuan,
    stokMinimum: stokMinimum.present ? stokMinimum.value : this.stokMinimum,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ProdukTableData copyWithCompanion(ProdukTableCompanion data) {
    return ProdukTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      nama: data.nama.present ? data.nama.value : this.nama,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      stok: data.stok.present ? data.stok.value : this.stok,
      kategori: data.kategori.present ? data.kategori.value : this.kategori,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      stokMinimum: data.stokMinimum.present
          ? data.stokMinimum.value
          : this.stokMinimum,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProdukTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('nama: $nama, ')
          ..write('barcode: $barcode, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('stok: $stok, ')
          ..write('kategori: $kategori, ')
          ..write('satuan: $satuan, ')
          ..write('stokMinimum: $stokMinimum, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    nama,
    barcode,
    hargaBeli,
    hargaJual,
    stok,
    kategori,
    satuan,
    stokMinimum,
    updatedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProdukTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.nama == this.nama &&
          other.barcode == this.barcode &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.stok == this.stok &&
          other.kategori == this.kategori &&
          other.satuan == this.satuan &&
          other.stokMinimum == this.stokMinimum &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class ProdukTableCompanion extends UpdateCompanion<ProdukTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> nama;
  final Value<String?> barcode;
  final Value<double> hargaBeli;
  final Value<double> hargaJual;
  final Value<int> stok;
  final Value<String?> kategori;
  final Value<String> satuan;
  final Value<int?> stokMinimum;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProdukTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.nama = const Value.absent(),
    this.barcode = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.stok = const Value.absent(),
    this.kategori = const Value.absent(),
    this.satuan = const Value.absent(),
    this.stokMinimum = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProdukTableCompanion.insert({
    required String id,
    required String tokoId,
    required String nama,
    this.barcode = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.stok = const Value.absent(),
    this.kategori = const Value.absent(),
    this.satuan = const Value.absent(),
    this.stokMinimum = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       nama = Value(nama);
  static Insertable<ProdukTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? nama,
    Expression<String>? barcode,
    Expression<double>? hargaBeli,
    Expression<double>? hargaJual,
    Expression<int>? stok,
    Expression<String>? kategori,
    Expression<String>? satuan,
    Expression<int>? stokMinimum,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (nama != null) 'nama': nama,
      if (barcode != null) 'barcode': barcode,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (stok != null) 'stok': stok,
      if (kategori != null) 'kategori': kategori,
      if (satuan != null) 'satuan': satuan,
      if (stokMinimum != null) 'stok_minimum': stokMinimum,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProdukTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? nama,
    Value<String?>? barcode,
    Value<double>? hargaBeli,
    Value<double>? hargaJual,
    Value<int>? stok,
    Value<String?>? kategori,
    Value<String>? satuan,
    Value<int?>? stokMinimum,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProdukTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      nama: nama ?? this.nama,
      barcode: barcode ?? this.barcode,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      stok: stok ?? this.stok,
      kategori: kategori ?? this.kategori,
      satuan: satuan ?? this.satuan,
      stokMinimum: stokMinimum ?? this.stokMinimum,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<double>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<double>(hargaJual.value);
    }
    if (stok.present) {
      map['stok'] = Variable<int>(stok.value);
    }
    if (kategori.present) {
      map['kategori'] = Variable<String>(kategori.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (stokMinimum.present) {
      map['stok_minimum'] = Variable<int>(stokMinimum.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    return (StringBuffer('ProdukTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('nama: $nama, ')
          ..write('barcode: $barcode, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('stok: $stok, ')
          ..write('kategori: $kategori, ')
          ..write('satuan: $satuan, ')
          ..write('stokMinimum: $stokMinimum, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SatuanProdukTableTable extends SatuanProdukTable
    with TableInfo<$SatuanProdukTableTable, SatuanProdukTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SatuanProdukTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<String> produkId = GeneratedColumn<String>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _konversiMeta = const VerificationMeta(
    'konversi',
  );
  @override
  late final GeneratedColumn<double> konversi = GeneratedColumn<double>(
    'konversi',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _hargaBeliMeta = const VerificationMeta(
    'hargaBeli',
  );
  @override
  late final GeneratedColumn<double> hargaBeli = GeneratedColumn<double>(
    'harga_beli',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hargaJualMeta = const VerificationMeta(
    'hargaJual',
  );
  @override
  late final GeneratedColumn<double> hargaJual = GeneratedColumn<double>(
    'harga_jual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    produkId,
    nama,
    konversi,
    hargaBeli,
    hargaJual,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'satuan_produk_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SatuanProdukTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('konversi')) {
      context.handle(
        _konversiMeta,
        konversi.isAcceptableOrUnknown(data['konversi']!, _konversiMeta),
      );
    }
    if (data.containsKey('harga_beli')) {
      context.handle(
        _hargaBeliMeta,
        hargaBeli.isAcceptableOrUnknown(data['harga_beli']!, _hargaBeliMeta),
      );
    }
    if (data.containsKey('harga_jual')) {
      context.handle(
        _hargaJualMeta,
        hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta),
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
  SatuanProdukTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SatuanProdukTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      konversi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}konversi'],
      )!,
      hargaBeli: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_beli'],
      )!,
      hargaJual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_jual'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SatuanProdukTableTable createAlias(String alias) {
    return $SatuanProdukTableTable(attachedDatabase, alias);
  }
}

class SatuanProdukTableData extends DataClass
    implements Insertable<SatuanProdukTableData> {
  final String id;
  final String tokoId;
  final String produkId;
  final String nama;
  final double konversi;
  final double hargaBeli;
  final double hargaJual;
  final DateTime updatedAt;
  const SatuanProdukTableData({
    required this.id,
    required this.tokoId,
    required this.produkId,
    required this.nama,
    required this.konversi,
    required this.hargaBeli,
    required this.hargaJual,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['produk_id'] = Variable<String>(produkId);
    map['nama'] = Variable<String>(nama);
    map['konversi'] = Variable<double>(konversi);
    map['harga_beli'] = Variable<double>(hargaBeli);
    map['harga_jual'] = Variable<double>(hargaJual);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SatuanProdukTableCompanion toCompanion(bool nullToAbsent) {
    return SatuanProdukTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      produkId: Value(produkId),
      nama: Value(nama),
      konversi: Value(konversi),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      updatedAt: Value(updatedAt),
    );
  }

  factory SatuanProdukTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SatuanProdukTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      nama: serializer.fromJson<String>(json['nama']),
      konversi: serializer.fromJson<double>(json['konversi']),
      hargaBeli: serializer.fromJson<double>(json['hargaBeli']),
      hargaJual: serializer.fromJson<double>(json['hargaJual']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'produkId': serializer.toJson<String>(produkId),
      'nama': serializer.toJson<String>(nama),
      'konversi': serializer.toJson<double>(konversi),
      'hargaBeli': serializer.toJson<double>(hargaBeli),
      'hargaJual': serializer.toJson<double>(hargaJual),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SatuanProdukTableData copyWith({
    String? id,
    String? tokoId,
    String? produkId,
    String? nama,
    double? konversi,
    double? hargaBeli,
    double? hargaJual,
    DateTime? updatedAt,
  }) => SatuanProdukTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    produkId: produkId ?? this.produkId,
    nama: nama ?? this.nama,
    konversi: konversi ?? this.konversi,
    hargaBeli: hargaBeli ?? this.hargaBeli,
    hargaJual: hargaJual ?? this.hargaJual,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SatuanProdukTableData copyWithCompanion(SatuanProdukTableCompanion data) {
    return SatuanProdukTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      nama: data.nama.present ? data.nama.value : this.nama,
      konversi: data.konversi.present ? data.konversi.value : this.konversi,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SatuanProdukTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('produkId: $produkId, ')
          ..write('nama: $nama, ')
          ..write('konversi: $konversi, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    produkId,
    nama,
    konversi,
    hargaBeli,
    hargaJual,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SatuanProdukTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.produkId == this.produkId &&
          other.nama == this.nama &&
          other.konversi == this.konversi &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.updatedAt == this.updatedAt);
}

class SatuanProdukTableCompanion
    extends UpdateCompanion<SatuanProdukTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> produkId;
  final Value<String> nama;
  final Value<double> konversi;
  final Value<double> hargaBeli;
  final Value<double> hargaJual;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SatuanProdukTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.nama = const Value.absent(),
    this.konversi = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SatuanProdukTableCompanion.insert({
    required String id,
    required String tokoId,
    required String produkId,
    required String nama,
    this.konversi = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       produkId = Value(produkId),
       nama = Value(nama);
  static Insertable<SatuanProdukTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? produkId,
    Expression<String>? nama,
    Expression<double>? konversi,
    Expression<double>? hargaBeli,
    Expression<double>? hargaJual,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (produkId != null) 'produk_id': produkId,
      if (nama != null) 'nama': nama,
      if (konversi != null) 'konversi': konversi,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SatuanProdukTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? produkId,
    Value<String>? nama,
    Value<double>? konversi,
    Value<double>? hargaBeli,
    Value<double>? hargaJual,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SatuanProdukTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      produkId: produkId ?? this.produkId,
      nama: nama ?? this.nama,
      konversi: konversi ?? this.konversi,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (konversi.present) {
      map['konversi'] = Variable<double>(konversi.value);
    }
    if (hargaBeli.present) {
      map['harga_beli'] = Variable<double>(hargaBeli.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<double>(hargaJual.value);
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
    return (StringBuffer('SatuanProdukTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('produkId: $produkId, ')
          ..write('nama: $nama, ')
          ..write('konversi: $konversi, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplierTableTable extends SupplierTable
    with TableInfo<$SupplierTableTable, SupplierTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaMeta = const VerificationMeta('nama');
  @override
  late final GeneratedColumn<String> nama = GeneratedColumn<String>(
    'nama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teleponMeta = const VerificationMeta(
    'telepon',
  );
  @override
  late final GeneratedColumn<String> telepon = GeneratedColumn<String>(
    'telepon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _alamatMeta = const VerificationMeta('alamat');
  @override
  late final GeneratedColumn<String> alamat = GeneratedColumn<String>(
    'alamat',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
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
    defaultValue: currentDateAndTime,
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
    tokoId,
    nama,
    telepon,
    alamat,
    updatedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplierTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('nama')) {
      context.handle(
        _namaMeta,
        nama.isAcceptableOrUnknown(data['nama']!, _namaMeta),
      );
    } else if (isInserting) {
      context.missing(_namaMeta);
    }
    if (data.containsKey('telepon')) {
      context.handle(
        _teleponMeta,
        telepon.isAcceptableOrUnknown(data['telepon']!, _teleponMeta),
      );
    }
    if (data.containsKey('alamat')) {
      context.handle(
        _alamatMeta,
        alamat.isAcceptableOrUnknown(data['alamat']!, _alamatMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
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
  SupplierTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      nama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama'],
      )!,
      telepon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telepon'],
      ),
      alamat: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alamat'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SupplierTableTable createAlias(String alias) {
    return $SupplierTableTable(attachedDatabase, alias);
  }
}

class SupplierTableData extends DataClass
    implements Insertable<SupplierTableData> {
  final String id;
  final String tokoId;
  final String nama;
  final String? telepon;
  final String? alamat;
  final DateTime updatedAt;
  final DateTime createdAt;
  const SupplierTableData({
    required this.id,
    required this.tokoId,
    required this.nama,
    this.telepon,
    this.alamat,
    required this.updatedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || telepon != null) {
      map['telepon'] = Variable<String>(telepon);
    }
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SupplierTableCompanion toCompanion(bool nullToAbsent) {
    return SupplierTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      nama: Value(nama),
      telepon: telepon == null && nullToAbsent
          ? const Value.absent()
          : Value(telepon),
      alamat: alamat == null && nullToAbsent
          ? const Value.absent()
          : Value(alamat),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory SupplierTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      nama: serializer.fromJson<String>(json['nama']),
      telepon: serializer.fromJson<String?>(json['telepon']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'nama': serializer.toJson<String>(nama),
      'telepon': serializer.toJson<String?>(telepon),
      'alamat': serializer.toJson<String?>(alamat),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupplierTableData copyWith({
    String? id,
    String? tokoId,
    String? nama,
    Value<String?> telepon = const Value.absent(),
    Value<String?> alamat = const Value.absent(),
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => SupplierTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    nama: nama ?? this.nama,
    telepon: telepon.present ? telepon.value : this.telepon,
    alamat: alamat.present ? alamat.value : this.alamat,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  SupplierTableData copyWithCompanion(SupplierTableCompanion data) {
    return SupplierTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      nama: data.nama.present ? data.nama.value : this.nama,
      telepon: data.telepon.present ? data.telepon.value : this.telepon,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('nama: $nama, ')
          ..write('telepon: $telepon, ')
          ..write('alamat: $alamat, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tokoId, nama, telepon, alamat, updatedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.nama == this.nama &&
          other.telepon == this.telepon &&
          other.alamat == this.alamat &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class SupplierTableCompanion extends UpdateCompanion<SupplierTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> nama;
  final Value<String?> telepon;
  final Value<String?> alamat;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SupplierTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.nama = const Value.absent(),
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplierTableCompanion.insert({
    required String id,
    required String tokoId,
    required String nama,
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       nama = Value(nama);
  static Insertable<SupplierTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? nama,
    Expression<String>? telepon,
    Expression<String>? alamat,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (nama != null) 'nama': nama,
      if (telepon != null) 'telepon': telepon,
      if (alamat != null) 'alamat': alamat,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplierTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? nama,
    Value<String?>? telepon,
    Value<String?>? alamat,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SupplierTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      nama: nama ?? this.nama,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (telepon.present) {
      map['telepon'] = Variable<String>(telepon.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    return (StringBuffer('SupplierTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('nama: $nama, ')
          ..write('telepon: $telepon, ')
          ..write('alamat: $alamat, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SupplierProductsTableTable extends SupplierProductsTable
    with TableInfo<$SupplierProductsTableTable, SupplierProductsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupplierProductsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<String> produkId = GeneratedColumn<String>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaMeta = const VerificationMeta('harga');
  @override
  late final GeneratedColumn<double> harga = GeneratedColumn<double>(
    'harga',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    supplierId,
    produkId,
    harga,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'supplier_products_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupplierProductsTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    } else if (isInserting) {
      context.missing(_supplierIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('harga')) {
      context.handle(
        _hargaMeta,
        harga.isAcceptableOrUnknown(data['harga']!, _hargaMeta),
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
  SupplierProductsTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupplierProductsTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      harga: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SupplierProductsTableTable createAlias(String alias) {
    return $SupplierProductsTableTable(attachedDatabase, alias);
  }
}

class SupplierProductsTableData extends DataClass
    implements Insertable<SupplierProductsTableData> {
  final String id;
  final String tokoId;
  final String supplierId;
  final String produkId;
  final double harga;
  final DateTime updatedAt;
  const SupplierProductsTableData({
    required this.id,
    required this.tokoId,
    required this.supplierId,
    required this.produkId,
    required this.harga,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['supplier_id'] = Variable<String>(supplierId);
    map['produk_id'] = Variable<String>(produkId);
    map['harga'] = Variable<double>(harga);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SupplierProductsTableCompanion toCompanion(bool nullToAbsent) {
    return SupplierProductsTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      supplierId: Value(supplierId),
      produkId: Value(produkId),
      harga: Value(harga),
      updatedAt: Value(updatedAt),
    );
  }

  factory SupplierProductsTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupplierProductsTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      supplierId: serializer.fromJson<String>(json['supplierId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      harga: serializer.fromJson<double>(json['harga']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'supplierId': serializer.toJson<String>(supplierId),
      'produkId': serializer.toJson<String>(produkId),
      'harga': serializer.toJson<double>(harga),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SupplierProductsTableData copyWith({
    String? id,
    String? tokoId,
    String? supplierId,
    String? produkId,
    double? harga,
    DateTime? updatedAt,
  }) => SupplierProductsTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    supplierId: supplierId ?? this.supplierId,
    produkId: produkId ?? this.produkId,
    harga: harga ?? this.harga,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SupplierProductsTableData copyWithCompanion(
    SupplierProductsTableCompanion data,
  ) {
    return SupplierProductsTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      harga: data.harga.present ? data.harga.value : this.harga,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupplierProductsTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('supplierId: $supplierId, ')
          ..write('produkId: $produkId, ')
          ..write('harga: $harga, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tokoId, supplierId, produkId, harga, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierProductsTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.supplierId == this.supplierId &&
          other.produkId == this.produkId &&
          other.harga == this.harga &&
          other.updatedAt == this.updatedAt);
}

class SupplierProductsTableCompanion
    extends UpdateCompanion<SupplierProductsTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> supplierId;
  final Value<String> produkId;
  final Value<double> harga;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SupplierProductsTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.harga = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplierProductsTableCompanion.insert({
    required String id,
    required String tokoId,
    required String supplierId,
    required String produkId,
    this.harga = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       supplierId = Value(supplierId),
       produkId = Value(produkId);
  static Insertable<SupplierProductsTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? supplierId,
    Expression<String>? produkId,
    Expression<double>? harga,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (produkId != null) 'produk_id': produkId,
      if (harga != null) 'harga': harga,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplierProductsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? supplierId,
    Value<String>? produkId,
    Value<double>? harga,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SupplierProductsTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      supplierId: supplierId ?? this.supplierId,
      produkId: produkId ?? this.produkId,
      harga: harga ?? this.harga,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (harga.present) {
      map['harga'] = Variable<double>(harga.value);
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
    return (StringBuffer('SupplierProductsTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('supplierId: $supplierId, ')
          ..write('produkId: $produkId, ')
          ..write('harga: $harga, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransaksiTableTable extends TransaksiTable
    with TableInfo<$TransaksiTableTable, TransaksiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransaksiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kasirIdMeta = const VerificationMeta(
    'kasirId',
  );
  @override
  late final GeneratedColumn<String> kasirId = GeneratedColumn<String>(
    'kasir_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalHargaMeta = const VerificationMeta(
    'totalHarga',
  );
  @override
  late final GeneratedColumn<double> totalHarga = GeneratedColumn<double>(
    'total_harga',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _jumlahBayarMeta = const VerificationMeta(
    'jumlahBayar',
  );
  @override
  late final GeneratedColumn<double> jumlahBayar = GeneratedColumn<double>(
    'jumlah_bayar',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _kembalianMeta = const VerificationMeta(
    'kembalian',
  );
  @override
  late final GeneratedColumn<double> kembalian = GeneratedColumn<double>(
    'kembalian',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('lunas'),
  );
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
    defaultValue: currentDateAndTime,
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
    tokoId,
    kasirId,
    totalHarga,
    jumlahBayar,
    kembalian,
    status,
    updatedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaksi_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransaksiTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('kasir_id')) {
      context.handle(
        _kasirIdMeta,
        kasirId.isAcceptableOrUnknown(data['kasir_id']!, _kasirIdMeta),
      );
    }
    if (data.containsKey('total_harga')) {
      context.handle(
        _totalHargaMeta,
        totalHarga.isAcceptableOrUnknown(data['total_harga']!, _totalHargaMeta),
      );
    }
    if (data.containsKey('jumlah_bayar')) {
      context.handle(
        _jumlahBayarMeta,
        jumlahBayar.isAcceptableOrUnknown(
          data['jumlah_bayar']!,
          _jumlahBayarMeta,
        ),
      );
    }
    if (data.containsKey('kembalian')) {
      context.handle(
        _kembalianMeta,
        kembalian.isAcceptableOrUnknown(data['kembalian']!, _kembalianMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
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
  TransaksiTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransaksiTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      kasirId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kasir_id'],
      ),
      totalHarga: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_harga'],
      )!,
      jumlahBayar: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jumlah_bayar'],
      )!,
      kembalian: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}kembalian'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransaksiTableTable createAlias(String alias) {
    return $TransaksiTableTable(attachedDatabase, alias);
  }
}

class TransaksiTableData extends DataClass
    implements Insertable<TransaksiTableData> {
  final String id;
  final String tokoId;
  final String? kasirId;
  final double totalHarga;
  final double jumlahBayar;
  final double kembalian;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;
  const TransaksiTableData({
    required this.id,
    required this.tokoId,
    this.kasirId,
    required this.totalHarga,
    required this.jumlahBayar,
    required this.kembalian,
    required this.status,
    required this.updatedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    if (!nullToAbsent || kasirId != null) {
      map['kasir_id'] = Variable<String>(kasirId);
    }
    map['total_harga'] = Variable<double>(totalHarga);
    map['jumlah_bayar'] = Variable<double>(jumlahBayar);
    map['kembalian'] = Variable<double>(kembalian);
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransaksiTableCompanion toCompanion(bool nullToAbsent) {
    return TransaksiTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      kasirId: kasirId == null && nullToAbsent
          ? const Value.absent()
          : Value(kasirId),
      totalHarga: Value(totalHarga),
      jumlahBayar: Value(jumlahBayar),
      kembalian: Value(kembalian),
      status: Value(status),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory TransaksiTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransaksiTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      kasirId: serializer.fromJson<String?>(json['kasirId']),
      totalHarga: serializer.fromJson<double>(json['totalHarga']),
      jumlahBayar: serializer.fromJson<double>(json['jumlahBayar']),
      kembalian: serializer.fromJson<double>(json['kembalian']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'kasirId': serializer.toJson<String?>(kasirId),
      'totalHarga': serializer.toJson<double>(totalHarga),
      'jumlahBayar': serializer.toJson<double>(jumlahBayar),
      'kembalian': serializer.toJson<double>(kembalian),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransaksiTableData copyWith({
    String? id,
    String? tokoId,
    Value<String?> kasirId = const Value.absent(),
    double? totalHarga,
    double? jumlahBayar,
    double? kembalian,
    String? status,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => TransaksiTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    kasirId: kasirId.present ? kasirId.value : this.kasirId,
    totalHarga: totalHarga ?? this.totalHarga,
    jumlahBayar: jumlahBayar ?? this.jumlahBayar,
    kembalian: kembalian ?? this.kembalian,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  TransaksiTableData copyWithCompanion(TransaksiTableCompanion data) {
    return TransaksiTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      kasirId: data.kasirId.present ? data.kasirId.value : this.kasirId,
      totalHarga: data.totalHarga.present
          ? data.totalHarga.value
          : this.totalHarga,
      jumlahBayar: data.jumlahBayar.present
          ? data.jumlahBayar.value
          : this.jumlahBayar,
      kembalian: data.kembalian.present ? data.kembalian.value : this.kembalian,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransaksiTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('kasirId: $kasirId, ')
          ..write('totalHarga: $totalHarga, ')
          ..write('jumlahBayar: $jumlahBayar, ')
          ..write('kembalian: $kembalian, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    kasirId,
    totalHarga,
    jumlahBayar,
    kembalian,
    status,
    updatedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransaksiTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.kasirId == this.kasirId &&
          other.totalHarga == this.totalHarga &&
          other.jumlahBayar == this.jumlahBayar &&
          other.kembalian == this.kembalian &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class TransaksiTableCompanion extends UpdateCompanion<TransaksiTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String?> kasirId;
  final Value<double> totalHarga;
  final Value<double> jumlahBayar;
  final Value<double> kembalian;
  final Value<String> status;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransaksiTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.kasirId = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.jumlahBayar = const Value.absent(),
    this.kembalian = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransaksiTableCompanion.insert({
    required String id,
    required String tokoId,
    this.kasirId = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.jumlahBayar = const Value.absent(),
    this.kembalian = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId);
  static Insertable<TransaksiTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? kasirId,
    Expression<double>? totalHarga,
    Expression<double>? jumlahBayar,
    Expression<double>? kembalian,
    Expression<String>? status,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (kasirId != null) 'kasir_id': kasirId,
      if (totalHarga != null) 'total_harga': totalHarga,
      if (jumlahBayar != null) 'jumlah_bayar': jumlahBayar,
      if (kembalian != null) 'kembalian': kembalian,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransaksiTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String?>? kasirId,
    Value<double>? totalHarga,
    Value<double>? jumlahBayar,
    Value<double>? kembalian,
    Value<String>? status,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TransaksiTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      kasirId: kasirId ?? this.kasirId,
      totalHarga: totalHarga ?? this.totalHarga,
      jumlahBayar: jumlahBayar ?? this.jumlahBayar,
      kembalian: kembalian ?? this.kembalian,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (kasirId.present) {
      map['kasir_id'] = Variable<String>(kasirId.value);
    }
    if (totalHarga.present) {
      map['total_harga'] = Variable<double>(totalHarga.value);
    }
    if (jumlahBayar.present) {
      map['jumlah_bayar'] = Variable<double>(jumlahBayar.value);
    }
    if (kembalian.present) {
      map['kembalian'] = Variable<double>(kembalian.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    return (StringBuffer('TransaksiTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('kasirId: $kasirId, ')
          ..write('totalHarga: $totalHarga, ')
          ..write('jumlahBayar: $jumlahBayar, ')
          ..write('kembalian: $kembalian, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemTransaksiTableTable extends ItemTransaksiTable
    with TableInfo<$ItemTransaksiTableTable, ItemTransaksiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemTransaksiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transaksiIdMeta = const VerificationMeta(
    'transaksiId',
  );
  @override
  late final GeneratedColumn<String> transaksiId = GeneratedColumn<String>(
    'transaksi_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<String> produkId = GeneratedColumn<String>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<int> jumlah = GeneratedColumn<int>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _hargaSatuanMeta = const VerificationMeta(
    'hargaSatuan',
  );
  @override
  late final GeneratedColumn<double> hargaSatuan = GeneratedColumn<double>(
    'harga_satuan',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    transaksiId,
    produkId,
    jumlah,
    hargaSatuan,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_transaksi_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemTransaksiTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('transaksi_id')) {
      context.handle(
        _transaksiIdMeta,
        transaksiId.isAcceptableOrUnknown(
          data['transaksi_id']!,
          _transaksiIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transaksiIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    }
    if (data.containsKey('harga_satuan')) {
      context.handle(
        _hargaSatuanMeta,
        hargaSatuan.isAcceptableOrUnknown(
          data['harga_satuan']!,
          _hargaSatuanMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemTransaksiTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemTransaksiTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      transaksiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaksi_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah'],
      )!,
      hargaSatuan: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_satuan'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $ItemTransaksiTableTable createAlias(String alias) {
    return $ItemTransaksiTableTable(attachedDatabase, alias);
  }
}

class ItemTransaksiTableData extends DataClass
    implements Insertable<ItemTransaksiTableData> {
  final String id;
  final String tokoId;
  final String transaksiId;
  final String produkId;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;
  const ItemTransaksiTableData({
    required this.id,
    required this.tokoId,
    required this.transaksiId,
    required this.produkId,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['transaksi_id'] = Variable<String>(transaksiId);
    map['produk_id'] = Variable<String>(produkId);
    map['jumlah'] = Variable<int>(jumlah);
    map['harga_satuan'] = Variable<double>(hargaSatuan);
    map['subtotal'] = Variable<double>(subtotal);
    return map;
  }

  ItemTransaksiTableCompanion toCompanion(bool nullToAbsent) {
    return ItemTransaksiTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      transaksiId: Value(transaksiId),
      produkId: Value(produkId),
      jumlah: Value(jumlah),
      hargaSatuan: Value(hargaSatuan),
      subtotal: Value(subtotal),
    );
  }

  factory ItemTransaksiTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemTransaksiTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      transaksiId: serializer.fromJson<String>(json['transaksiId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      jumlah: serializer.fromJson<int>(json['jumlah']),
      hargaSatuan: serializer.fromJson<double>(json['hargaSatuan']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'transaksiId': serializer.toJson<String>(transaksiId),
      'produkId': serializer.toJson<String>(produkId),
      'jumlah': serializer.toJson<int>(jumlah),
      'hargaSatuan': serializer.toJson<double>(hargaSatuan),
      'subtotal': serializer.toJson<double>(subtotal),
    };
  }

  ItemTransaksiTableData copyWith({
    String? id,
    String? tokoId,
    String? transaksiId,
    String? produkId,
    int? jumlah,
    double? hargaSatuan,
    double? subtotal,
  }) => ItemTransaksiTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    transaksiId: transaksiId ?? this.transaksiId,
    produkId: produkId ?? this.produkId,
    jumlah: jumlah ?? this.jumlah,
    hargaSatuan: hargaSatuan ?? this.hargaSatuan,
    subtotal: subtotal ?? this.subtotal,
  );
  ItemTransaksiTableData copyWithCompanion(ItemTransaksiTableCompanion data) {
    return ItemTransaksiTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      transaksiId: data.transaksiId.present
          ? data.transaksiId.value
          : this.transaksiId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      hargaSatuan: data.hargaSatuan.present
          ? data.hargaSatuan.value
          : this.hargaSatuan,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemTransaksiTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('transaksiId: $transaksiId, ')
          ..write('produkId: $produkId, ')
          ..write('jumlah: $jumlah, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    transaksiId,
    produkId,
    jumlah,
    hargaSatuan,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemTransaksiTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.transaksiId == this.transaksiId &&
          other.produkId == this.produkId &&
          other.jumlah == this.jumlah &&
          other.hargaSatuan == this.hargaSatuan &&
          other.subtotal == this.subtotal);
}

class ItemTransaksiTableCompanion
    extends UpdateCompanion<ItemTransaksiTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> transaksiId;
  final Value<String> produkId;
  final Value<int> jumlah;
  final Value<double> hargaSatuan;
  final Value<double> subtotal;
  final Value<int> rowid;
  const ItemTransaksiTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.transaksiId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemTransaksiTableCompanion.insert({
    required String id,
    required String tokoId,
    required String transaksiId,
    required String produkId,
    this.jumlah = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       transaksiId = Value(transaksiId),
       produkId = Value(produkId);
  static Insertable<ItemTransaksiTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? transaksiId,
    Expression<String>? produkId,
    Expression<int>? jumlah,
    Expression<double>? hargaSatuan,
    Expression<double>? subtotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (transaksiId != null) 'transaksi_id': transaksiId,
      if (produkId != null) 'produk_id': produkId,
      if (jumlah != null) 'jumlah': jumlah,
      if (hargaSatuan != null) 'harga_satuan': hargaSatuan,
      if (subtotal != null) 'subtotal': subtotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemTransaksiTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? transaksiId,
    Value<String>? produkId,
    Value<int>? jumlah,
    Value<double>? hargaSatuan,
    Value<double>? subtotal,
    Value<int>? rowid,
  }) {
    return ItemTransaksiTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      transaksiId: transaksiId ?? this.transaksiId,
      produkId: produkId ?? this.produkId,
      jumlah: jumlah ?? this.jumlah,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      subtotal: subtotal ?? this.subtotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (transaksiId.present) {
      map['transaksi_id'] = Variable<String>(transaksiId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<int>(jumlah.value);
    }
    if (hargaSatuan.present) {
      map['harga_satuan'] = Variable<double>(hargaSatuan.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemTransaksiTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('transaksiId: $transaksiId, ')
          ..write('produkId: $produkId, ')
          ..write('jumlah: $jumlah, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('subtotal: $subtotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $HutangPiutangTableTable extends HutangPiutangTable
    with TableInfo<$HutangPiutangTableTable, HutangPiutangTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HutangPiutangTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transaksiIdMeta = const VerificationMeta(
    'transaksiId',
  );
  @override
  late final GeneratedColumn<String> transaksiId = GeneratedColumn<String>(
    'transaksi_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _namaPelangganMeta = const VerificationMeta(
    'namaPelanggan',
  );
  @override
  late final GeneratedColumn<String> namaPelanggan = GeneratedColumn<String>(
    'nama_pelanggan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<double> jumlah = GeneratedColumn<double>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('belum_lunas'),
  );
  static const VerificationMeta _tanggalJatuhTempoMeta = const VerificationMeta(
    'tanggalJatuhTempo',
  );
  @override
  late final GeneratedColumn<DateTime> tanggalJatuhTempo =
      GeneratedColumn<DateTime>(
        'tanggal_jatuh_tempo',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
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
    defaultValue: currentDateAndTime,
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
    tokoId,
    transaksiId,
    namaPelanggan,
    jumlah,
    status,
    tanggalJatuhTempo,
    updatedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hutang_piutang_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<HutangPiutangTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('transaksi_id')) {
      context.handle(
        _transaksiIdMeta,
        transaksiId.isAcceptableOrUnknown(
          data['transaksi_id']!,
          _transaksiIdMeta,
        ),
      );
    }
    if (data.containsKey('nama_pelanggan')) {
      context.handle(
        _namaPelangganMeta,
        namaPelanggan.isAcceptableOrUnknown(
          data['nama_pelanggan']!,
          _namaPelangganMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_namaPelangganMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('tanggal_jatuh_tempo')) {
      context.handle(
        _tanggalJatuhTempoMeta,
        tanggalJatuhTempo.isAcceptableOrUnknown(
          data['tanggal_jatuh_tempo']!,
          _tanggalJatuhTempoMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
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
  HutangPiutangTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HutangPiutangTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      transaksiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaksi_id'],
      ),
      namaPelanggan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_pelanggan'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jumlah'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      tanggalJatuhTempo: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal_jatuh_tempo'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $HutangPiutangTableTable createAlias(String alias) {
    return $HutangPiutangTableTable(attachedDatabase, alias);
  }
}

class HutangPiutangTableData extends DataClass
    implements Insertable<HutangPiutangTableData> {
  final String id;
  final String tokoId;
  final String? transaksiId;
  final String namaPelanggan;
  final double jumlah;
  final String status;
  final DateTime? tanggalJatuhTempo;
  final DateTime updatedAt;
  final DateTime createdAt;
  const HutangPiutangTableData({
    required this.id,
    required this.tokoId,
    this.transaksiId,
    required this.namaPelanggan,
    required this.jumlah,
    required this.status,
    this.tanggalJatuhTempo,
    required this.updatedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    if (!nullToAbsent || transaksiId != null) {
      map['transaksi_id'] = Variable<String>(transaksiId);
    }
    map['nama_pelanggan'] = Variable<String>(namaPelanggan);
    map['jumlah'] = Variable<double>(jumlah);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || tanggalJatuhTempo != null) {
      map['tanggal_jatuh_tempo'] = Variable<DateTime>(tanggalJatuhTempo);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  HutangPiutangTableCompanion toCompanion(bool nullToAbsent) {
    return HutangPiutangTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      transaksiId: transaksiId == null && nullToAbsent
          ? const Value.absent()
          : Value(transaksiId),
      namaPelanggan: Value(namaPelanggan),
      jumlah: Value(jumlah),
      status: Value(status),
      tanggalJatuhTempo: tanggalJatuhTempo == null && nullToAbsent
          ? const Value.absent()
          : Value(tanggalJatuhTempo),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory HutangPiutangTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HutangPiutangTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      transaksiId: serializer.fromJson<String?>(json['transaksiId']),
      namaPelanggan: serializer.fromJson<String>(json['namaPelanggan']),
      jumlah: serializer.fromJson<double>(json['jumlah']),
      status: serializer.fromJson<String>(json['status']),
      tanggalJatuhTempo: serializer.fromJson<DateTime?>(
        json['tanggalJatuhTempo'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'transaksiId': serializer.toJson<String?>(transaksiId),
      'namaPelanggan': serializer.toJson<String>(namaPelanggan),
      'jumlah': serializer.toJson<double>(jumlah),
      'status': serializer.toJson<String>(status),
      'tanggalJatuhTempo': serializer.toJson<DateTime?>(tanggalJatuhTempo),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  HutangPiutangTableData copyWith({
    String? id,
    String? tokoId,
    Value<String?> transaksiId = const Value.absent(),
    String? namaPelanggan,
    double? jumlah,
    String? status,
    Value<DateTime?> tanggalJatuhTempo = const Value.absent(),
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => HutangPiutangTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    transaksiId: transaksiId.present ? transaksiId.value : this.transaksiId,
    namaPelanggan: namaPelanggan ?? this.namaPelanggan,
    jumlah: jumlah ?? this.jumlah,
    status: status ?? this.status,
    tanggalJatuhTempo: tanggalJatuhTempo.present
        ? tanggalJatuhTempo.value
        : this.tanggalJatuhTempo,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  HutangPiutangTableData copyWithCompanion(HutangPiutangTableCompanion data) {
    return HutangPiutangTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      transaksiId: data.transaksiId.present
          ? data.transaksiId.value
          : this.transaksiId,
      namaPelanggan: data.namaPelanggan.present
          ? data.namaPelanggan.value
          : this.namaPelanggan,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      status: data.status.present ? data.status.value : this.status,
      tanggalJatuhTempo: data.tanggalJatuhTempo.present
          ? data.tanggalJatuhTempo.value
          : this.tanggalJatuhTempo,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HutangPiutangTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('transaksiId: $transaksiId, ')
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('jumlah: $jumlah, ')
          ..write('status: $status, ')
          ..write('tanggalJatuhTempo: $tanggalJatuhTempo, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    transaksiId,
    namaPelanggan,
    jumlah,
    status,
    tanggalJatuhTempo,
    updatedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HutangPiutangTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.transaksiId == this.transaksiId &&
          other.namaPelanggan == this.namaPelanggan &&
          other.jumlah == this.jumlah &&
          other.status == this.status &&
          other.tanggalJatuhTempo == this.tanggalJatuhTempo &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class HutangPiutangTableCompanion
    extends UpdateCompanion<HutangPiutangTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String?> transaksiId;
  final Value<String> namaPelanggan;
  final Value<double> jumlah;
  final Value<String> status;
  final Value<DateTime?> tanggalJatuhTempo;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const HutangPiutangTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.transaksiId = const Value.absent(),
    this.namaPelanggan = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.status = const Value.absent(),
    this.tanggalJatuhTempo = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HutangPiutangTableCompanion.insert({
    required String id,
    required String tokoId,
    this.transaksiId = const Value.absent(),
    required String namaPelanggan,
    this.jumlah = const Value.absent(),
    this.status = const Value.absent(),
    this.tanggalJatuhTempo = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       namaPelanggan = Value(namaPelanggan);
  static Insertable<HutangPiutangTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? transaksiId,
    Expression<String>? namaPelanggan,
    Expression<double>? jumlah,
    Expression<String>? status,
    Expression<DateTime>? tanggalJatuhTempo,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (transaksiId != null) 'transaksi_id': transaksiId,
      if (namaPelanggan != null) 'nama_pelanggan': namaPelanggan,
      if (jumlah != null) 'jumlah': jumlah,
      if (status != null) 'status': status,
      if (tanggalJatuhTempo != null) 'tanggal_jatuh_tempo': tanggalJatuhTempo,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HutangPiutangTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String?>? transaksiId,
    Value<String>? namaPelanggan,
    Value<double>? jumlah,
    Value<String>? status,
    Value<DateTime?>? tanggalJatuhTempo,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return HutangPiutangTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      transaksiId: transaksiId ?? this.transaksiId,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      jumlah: jumlah ?? this.jumlah,
      status: status ?? this.status,
      tanggalJatuhTempo: tanggalJatuhTempo ?? this.tanggalJatuhTempo,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (transaksiId.present) {
      map['transaksi_id'] = Variable<String>(transaksiId.value);
    }
    if (namaPelanggan.present) {
      map['nama_pelanggan'] = Variable<String>(namaPelanggan.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<double>(jumlah.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (tanggalJatuhTempo.present) {
      map['tanggal_jatuh_tempo'] = Variable<DateTime>(tanggalJatuhTempo.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    return (StringBuffer('HutangPiutangTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('transaksiId: $transaksiId, ')
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('jumlah: $jumlah, ')
          ..write('status: $status, ')
          ..write('tanggalJatuhTempo: $tanggalJatuhTempo, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RiwayatStokTableTable extends RiwayatStokTable
    with TableInfo<$RiwayatStokTableTable, RiwayatStokTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RiwayatStokTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<String> produkId = GeneratedColumn<String>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipeMeta = const VerificationMeta('tipe');
  @override
  late final GeneratedColumn<String> tipe = GeneratedColumn<String>(
    'tipe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<int> jumlah = GeneratedColumn<int>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _keteranganMeta = const VerificationMeta(
    'keterangan',
  );
  @override
  late final GeneratedColumn<String> keterangan = GeneratedColumn<String>(
    'keterangan',
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    produkId,
    tipe,
    jumlah,
    keterangan,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'riwayat_stok_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RiwayatStokTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('tipe')) {
      context.handle(
        _tipeMeta,
        tipe.isAcceptableOrUnknown(data['tipe']!, _tipeMeta),
      );
    } else if (isInserting) {
      context.missing(_tipeMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    }
    if (data.containsKey('keterangan')) {
      context.handle(
        _keteranganMeta,
        keterangan.isAcceptableOrUnknown(data['keterangan']!, _keteranganMeta),
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
  RiwayatStokTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RiwayatStokTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      tipe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipe'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah'],
      )!,
      keterangan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keterangan'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RiwayatStokTableTable createAlias(String alias) {
    return $RiwayatStokTableTable(attachedDatabase, alias);
  }
}

class RiwayatStokTableData extends DataClass
    implements Insertable<RiwayatStokTableData> {
  final String id;
  final String tokoId;
  final String produkId;
  final String tipe;
  final int jumlah;
  final String? keterangan;
  final DateTime createdAt;
  const RiwayatStokTableData({
    required this.id,
    required this.tokoId,
    required this.produkId,
    required this.tipe,
    required this.jumlah,
    this.keterangan,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['produk_id'] = Variable<String>(produkId);
    map['tipe'] = Variable<String>(tipe);
    map['jumlah'] = Variable<int>(jumlah);
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RiwayatStokTableCompanion toCompanion(bool nullToAbsent) {
    return RiwayatStokTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      produkId: Value(produkId),
      tipe: Value(tipe),
      jumlah: Value(jumlah),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
      createdAt: Value(createdAt),
    );
  }

  factory RiwayatStokTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RiwayatStokTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      tipe: serializer.fromJson<String>(json['tipe']),
      jumlah: serializer.fromJson<int>(json['jumlah']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'produkId': serializer.toJson<String>(produkId),
      'tipe': serializer.toJson<String>(tipe),
      'jumlah': serializer.toJson<int>(jumlah),
      'keterangan': serializer.toJson<String?>(keterangan),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RiwayatStokTableData copyWith({
    String? id,
    String? tokoId,
    String? produkId,
    String? tipe,
    int? jumlah,
    Value<String?> keterangan = const Value.absent(),
    DateTime? createdAt,
  }) => RiwayatStokTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    produkId: produkId ?? this.produkId,
    tipe: tipe ?? this.tipe,
    jumlah: jumlah ?? this.jumlah,
    keterangan: keterangan.present ? keterangan.value : this.keterangan,
    createdAt: createdAt ?? this.createdAt,
  );
  RiwayatStokTableData copyWithCompanion(RiwayatStokTableCompanion data) {
    return RiwayatStokTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      tipe: data.tipe.present ? data.tipe.value : this.tipe,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      keterangan: data.keterangan.present
          ? data.keterangan.value
          : this.keterangan,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RiwayatStokTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('produkId: $produkId, ')
          ..write('tipe: $tipe, ')
          ..write('jumlah: $jumlah, ')
          ..write('keterangan: $keterangan, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tokoId, produkId, tipe, jumlah, keterangan, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiwayatStokTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.produkId == this.produkId &&
          other.tipe == this.tipe &&
          other.jumlah == this.jumlah &&
          other.keterangan == this.keterangan &&
          other.createdAt == this.createdAt);
}

class RiwayatStokTableCompanion extends UpdateCompanion<RiwayatStokTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> produkId;
  final Value<String> tipe;
  final Value<int> jumlah;
  final Value<String?> keterangan;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RiwayatStokTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.tipe = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RiwayatStokTableCompanion.insert({
    required String id,
    required String tokoId,
    required String produkId,
    required String tipe,
    this.jumlah = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       produkId = Value(produkId),
       tipe = Value(tipe);
  static Insertable<RiwayatStokTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? produkId,
    Expression<String>? tipe,
    Expression<int>? jumlah,
    Expression<String>? keterangan,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (produkId != null) 'produk_id': produkId,
      if (tipe != null) 'tipe': tipe,
      if (jumlah != null) 'jumlah': jumlah,
      if (keterangan != null) 'keterangan': keterangan,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RiwayatStokTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? produkId,
    Value<String>? tipe,
    Value<int>? jumlah,
    Value<String?>? keterangan,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RiwayatStokTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      produkId: produkId ?? this.produkId,
      tipe: tipe ?? this.tipe,
      jumlah: jumlah ?? this.jumlah,
      keterangan: keterangan ?? this.keterangan,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (tipe.present) {
      map['tipe'] = Variable<String>(tipe.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<int>(jumlah.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
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
    return (StringBuffer('RiwayatStokTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('produkId: $produkId, ')
          ..write('tipe: $tipe, ')
          ..write('jumlah: $jumlah, ')
          ..write('keterangan: $keterangan, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PembelianTableTable extends PembelianTable
    with TableInfo<$PembelianTableTable, PembelianTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PembelianTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _namaSupplierMeta = const VerificationMeta(
    'namaSupplier',
  );
  @override
  late final GeneratedColumn<String> namaSupplier = GeneratedColumn<String>(
    'nama_supplier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalHargaMeta = const VerificationMeta(
    'totalHarga',
  );
  @override
  late final GeneratedColumn<double> totalHarga = GeneratedColumn<double>(
    'total_harga',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
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
    defaultValue: currentDateAndTime,
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
    tokoId,
    supplierId,
    namaSupplier,
    totalHarga,
    updatedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pembelian_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PembelianTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('nama_supplier')) {
      context.handle(
        _namaSupplierMeta,
        namaSupplier.isAcceptableOrUnknown(
          data['nama_supplier']!,
          _namaSupplierMeta,
        ),
      );
    }
    if (data.containsKey('total_harga')) {
      context.handle(
        _totalHargaMeta,
        totalHarga.isAcceptableOrUnknown(data['total_harga']!, _totalHargaMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
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
  PembelianTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PembelianTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      namaSupplier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_supplier'],
      ),
      totalHarga: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_harga'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PembelianTableTable createAlias(String alias) {
    return $PembelianTableTable(attachedDatabase, alias);
  }
}

class PembelianTableData extends DataClass
    implements Insertable<PembelianTableData> {
  final String id;
  final String tokoId;
  final String? supplierId;
  final String? namaSupplier;
  final double totalHarga;
  final DateTime updatedAt;
  final DateTime createdAt;
  const PembelianTableData({
    required this.id,
    required this.tokoId,
    this.supplierId,
    this.namaSupplier,
    required this.totalHarga,
    required this.updatedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || namaSupplier != null) {
      map['nama_supplier'] = Variable<String>(namaSupplier);
    }
    map['total_harga'] = Variable<double>(totalHarga);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PembelianTableCompanion toCompanion(bool nullToAbsent) {
    return PembelianTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      namaSupplier: namaSupplier == null && nullToAbsent
          ? const Value.absent()
          : Value(namaSupplier),
      totalHarga: Value(totalHarga),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory PembelianTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PembelianTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      namaSupplier: serializer.fromJson<String?>(json['namaSupplier']),
      totalHarga: serializer.fromJson<double>(json['totalHarga']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'supplierId': serializer.toJson<String?>(supplierId),
      'namaSupplier': serializer.toJson<String?>(namaSupplier),
      'totalHarga': serializer.toJson<double>(totalHarga),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PembelianTableData copyWith({
    String? id,
    String? tokoId,
    Value<String?> supplierId = const Value.absent(),
    Value<String?> namaSupplier = const Value.absent(),
    double? totalHarga,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => PembelianTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    namaSupplier: namaSupplier.present ? namaSupplier.value : this.namaSupplier,
    totalHarga: totalHarga ?? this.totalHarga,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  PembelianTableData copyWithCompanion(PembelianTableCompanion data) {
    return PembelianTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      namaSupplier: data.namaSupplier.present
          ? data.namaSupplier.value
          : this.namaSupplier,
      totalHarga: data.totalHarga.present
          ? data.totalHarga.value
          : this.totalHarga,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PembelianTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('supplierId: $supplierId, ')
          ..write('namaSupplier: $namaSupplier, ')
          ..write('totalHarga: $totalHarga, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    supplierId,
    namaSupplier,
    totalHarga,
    updatedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PembelianTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.supplierId == this.supplierId &&
          other.namaSupplier == this.namaSupplier &&
          other.totalHarga == this.totalHarga &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class PembelianTableCompanion extends UpdateCompanion<PembelianTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String?> supplierId;
  final Value<String?> namaSupplier;
  final Value<double> totalHarga;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PembelianTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PembelianTableCompanion.insert({
    required String id,
    required String tokoId,
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId);
  static Insertable<PembelianTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? supplierId,
    Expression<String>? namaSupplier,
    Expression<double>? totalHarga,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (namaSupplier != null) 'nama_supplier': namaSupplier,
      if (totalHarga != null) 'total_harga': totalHarga,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PembelianTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String?>? supplierId,
    Value<String?>? namaSupplier,
    Value<double>? totalHarga,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PembelianTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      supplierId: supplierId ?? this.supplierId,
      namaSupplier: namaSupplier ?? this.namaSupplier,
      totalHarga: totalHarga ?? this.totalHarga,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (namaSupplier.present) {
      map['nama_supplier'] = Variable<String>(namaSupplier.value);
    }
    if (totalHarga.present) {
      map['total_harga'] = Variable<double>(totalHarga.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
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
    return (StringBuffer('PembelianTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('supplierId: $supplierId, ')
          ..write('namaSupplier: $namaSupplier, ')
          ..write('totalHarga: $totalHarga, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ItemPembelianTableTable extends ItemPembelianTable
    with TableInfo<$ItemPembelianTableTable, ItemPembelianTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ItemPembelianTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pembelianIdMeta = const VerificationMeta(
    'pembelianId',
  );
  @override
  late final GeneratedColumn<String> pembelianId = GeneratedColumn<String>(
    'pembelian_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<String> produkId = GeneratedColumn<String>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<int> jumlah = GeneratedColumn<int>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _hargaBeliSatuanMeta = const VerificationMeta(
    'hargaBeliSatuan',
  );
  @override
  late final GeneratedColumn<double> hargaBeliSatuan = GeneratedColumn<double>(
    'harga_beli_satuan',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _satuanIdMeta = const VerificationMeta(
    'satuanId',
  );
  @override
  late final GeneratedColumn<String> satuanId = GeneratedColumn<String>(
    'satuan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _konversiMeta = const VerificationMeta(
    'konversi',
  );
  @override
  late final GeneratedColumn<double> konversi = GeneratedColumn<double>(
    'konversi',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    pembelianId,
    produkId,
    jumlah,
    hargaBeliSatuan,
    subtotal,
    satuanId,
    konversi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'item_pembelian_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ItemPembelianTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('pembelian_id')) {
      context.handle(
        _pembelianIdMeta,
        pembelianId.isAcceptableOrUnknown(
          data['pembelian_id']!,
          _pembelianIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pembelianIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    }
    if (data.containsKey('harga_beli_satuan')) {
      context.handle(
        _hargaBeliSatuanMeta,
        hargaBeliSatuan.isAcceptableOrUnknown(
          data['harga_beli_satuan']!,
          _hargaBeliSatuanMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    if (data.containsKey('satuan_id')) {
      context.handle(
        _satuanIdMeta,
        satuanId.isAcceptableOrUnknown(data['satuan_id']!, _satuanIdMeta),
      );
    }
    if (data.containsKey('konversi')) {
      context.handle(
        _konversiMeta,
        konversi.isAcceptableOrUnknown(data['konversi']!, _konversiMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ItemPembelianTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ItemPembelianTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      pembelianId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pembelian_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah'],
      )!,
      hargaBeliSatuan: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_beli_satuan'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
      satuanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}satuan_id'],
      ),
      konversi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}konversi'],
      )!,
    );
  }

  @override
  $ItemPembelianTableTable createAlias(String alias) {
    return $ItemPembelianTableTable(attachedDatabase, alias);
  }
}

class ItemPembelianTableData extends DataClass
    implements Insertable<ItemPembelianTableData> {
  final String id;
  final String tokoId;
  final String pembelianId;
  final String produkId;
  final int jumlah;
  final double hargaBeliSatuan;
  final double subtotal;
  final String? satuanId;
  final double konversi;
  const ItemPembelianTableData({
    required this.id,
    required this.tokoId,
    required this.pembelianId,
    required this.produkId,
    required this.jumlah,
    required this.hargaBeliSatuan,
    required this.subtotal,
    this.satuanId,
    required this.konversi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['pembelian_id'] = Variable<String>(pembelianId);
    map['produk_id'] = Variable<String>(produkId);
    map['jumlah'] = Variable<int>(jumlah);
    map['harga_beli_satuan'] = Variable<double>(hargaBeliSatuan);
    map['subtotal'] = Variable<double>(subtotal);
    if (!nullToAbsent || satuanId != null) {
      map['satuan_id'] = Variable<String>(satuanId);
    }
    map['konversi'] = Variable<double>(konversi);
    return map;
  }

  ItemPembelianTableCompanion toCompanion(bool nullToAbsent) {
    return ItemPembelianTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      pembelianId: Value(pembelianId),
      produkId: Value(produkId),
      jumlah: Value(jumlah),
      hargaBeliSatuan: Value(hargaBeliSatuan),
      subtotal: Value(subtotal),
      satuanId: satuanId == null && nullToAbsent
          ? const Value.absent()
          : Value(satuanId),
      konversi: Value(konversi),
    );
  }

  factory ItemPembelianTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ItemPembelianTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      pembelianId: serializer.fromJson<String>(json['pembelianId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      jumlah: serializer.fromJson<int>(json['jumlah']),
      hargaBeliSatuan: serializer.fromJson<double>(json['hargaBeliSatuan']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      satuanId: serializer.fromJson<String?>(json['satuanId']),
      konversi: serializer.fromJson<double>(json['konversi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'pembelianId': serializer.toJson<String>(pembelianId),
      'produkId': serializer.toJson<String>(produkId),
      'jumlah': serializer.toJson<int>(jumlah),
      'hargaBeliSatuan': serializer.toJson<double>(hargaBeliSatuan),
      'subtotal': serializer.toJson<double>(subtotal),
      'satuanId': serializer.toJson<String?>(satuanId),
      'konversi': serializer.toJson<double>(konversi),
    };
  }

  ItemPembelianTableData copyWith({
    String? id,
    String? tokoId,
    String? pembelianId,
    String? produkId,
    int? jumlah,
    double? hargaBeliSatuan,
    double? subtotal,
    Value<String?> satuanId = const Value.absent(),
    double? konversi,
  }) => ItemPembelianTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    pembelianId: pembelianId ?? this.pembelianId,
    produkId: produkId ?? this.produkId,
    jumlah: jumlah ?? this.jumlah,
    hargaBeliSatuan: hargaBeliSatuan ?? this.hargaBeliSatuan,
    subtotal: subtotal ?? this.subtotal,
    satuanId: satuanId.present ? satuanId.value : this.satuanId,
    konversi: konversi ?? this.konversi,
  );
  ItemPembelianTableData copyWithCompanion(ItemPembelianTableCompanion data) {
    return ItemPembelianTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      pembelianId: data.pembelianId.present
          ? data.pembelianId.value
          : this.pembelianId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      hargaBeliSatuan: data.hargaBeliSatuan.present
          ? data.hargaBeliSatuan.value
          : this.hargaBeliSatuan,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      satuanId: data.satuanId.present ? data.satuanId.value : this.satuanId,
      konversi: data.konversi.present ? data.konversi.value : this.konversi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ItemPembelianTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('pembelianId: $pembelianId, ')
          ..write('produkId: $produkId, ')
          ..write('jumlah: $jumlah, ')
          ..write('hargaBeliSatuan: $hargaBeliSatuan, ')
          ..write('subtotal: $subtotal, ')
          ..write('satuanId: $satuanId, ')
          ..write('konversi: $konversi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    pembelianId,
    produkId,
    jumlah,
    hargaBeliSatuan,
    subtotal,
    satuanId,
    konversi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemPembelianTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.pembelianId == this.pembelianId &&
          other.produkId == this.produkId &&
          other.jumlah == this.jumlah &&
          other.hargaBeliSatuan == this.hargaBeliSatuan &&
          other.subtotal == this.subtotal &&
          other.satuanId == this.satuanId &&
          other.konversi == this.konversi);
}

class ItemPembelianTableCompanion
    extends UpdateCompanion<ItemPembelianTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> pembelianId;
  final Value<String> produkId;
  final Value<int> jumlah;
  final Value<double> hargaBeliSatuan;
  final Value<double> subtotal;
  final Value<String?> satuanId;
  final Value<double> konversi;
  final Value<int> rowid;
  const ItemPembelianTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.pembelianId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.hargaBeliSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemPembelianTableCompanion.insert({
    required String id,
    required String tokoId,
    required String pembelianId,
    required String produkId,
    this.jumlah = const Value.absent(),
    this.hargaBeliSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       pembelianId = Value(pembelianId),
       produkId = Value(produkId);
  static Insertable<ItemPembelianTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? pembelianId,
    Expression<String>? produkId,
    Expression<int>? jumlah,
    Expression<double>? hargaBeliSatuan,
    Expression<double>? subtotal,
    Expression<String>? satuanId,
    Expression<double>? konversi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (pembelianId != null) 'pembelian_id': pembelianId,
      if (produkId != null) 'produk_id': produkId,
      if (jumlah != null) 'jumlah': jumlah,
      if (hargaBeliSatuan != null) 'harga_beli_satuan': hargaBeliSatuan,
      if (subtotal != null) 'subtotal': subtotal,
      if (satuanId != null) 'satuan_id': satuanId,
      if (konversi != null) 'konversi': konversi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemPembelianTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? pembelianId,
    Value<String>? produkId,
    Value<int>? jumlah,
    Value<double>? hargaBeliSatuan,
    Value<double>? subtotal,
    Value<String?>? satuanId,
    Value<double>? konversi,
    Value<int>? rowid,
  }) {
    return ItemPembelianTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      pembelianId: pembelianId ?? this.pembelianId,
      produkId: produkId ?? this.produkId,
      jumlah: jumlah ?? this.jumlah,
      hargaBeliSatuan: hargaBeliSatuan ?? this.hargaBeliSatuan,
      subtotal: subtotal ?? this.subtotal,
      satuanId: satuanId ?? this.satuanId,
      konversi: konversi ?? this.konversi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (pembelianId.present) {
      map['pembelian_id'] = Variable<String>(pembelianId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<int>(jumlah.value);
    }
    if (hargaBeliSatuan.present) {
      map['harga_beli_satuan'] = Variable<double>(hargaBeliSatuan.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (satuanId.present) {
      map['satuan_id'] = Variable<String>(satuanId.value);
    }
    if (konversi.present) {
      map['konversi'] = Variable<double>(konversi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ItemPembelianTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('pembelianId: $pembelianId, ')
          ..write('produkId: $produkId, ')
          ..write('jumlah: $jumlah, ')
          ..write('hargaBeliSatuan: $hargaBeliSatuan, ')
          ..write('subtotal: $subtotal, ')
          ..write('satuanId: $satuanId, ')
          ..write('konversi: $konversi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingOrderTableTable extends PendingOrderTable
    with TableInfo<$PendingOrderTableTable, PendingOrderTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOrderTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaPelangganMeta = const VerificationMeta(
    'namaPelanggan',
  );
  @override
  late final GeneratedColumn<String> namaPelanggan = GeneratedColumn<String>(
    'nama_pelanggan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catatanMeta = const VerificationMeta(
    'catatan',
  );
  @override
  late final GeneratedColumn<String> catatan = GeneratedColumn<String>(
    'catatan',
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
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    namaPelanggan,
    catatan,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_order_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingOrderTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('nama_pelanggan')) {
      context.handle(
        _namaPelangganMeta,
        namaPelanggan.isAcceptableOrUnknown(
          data['nama_pelanggan']!,
          _namaPelangganMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_namaPelangganMeta);
    }
    if (data.containsKey('catatan')) {
      context.handle(
        _catatanMeta,
        catatan.isAcceptableOrUnknown(data['catatan']!, _catatanMeta),
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
  PendingOrderTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOrderTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      namaPelanggan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_pelanggan'],
      )!,
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingOrderTableTable createAlias(String alias) {
    return $PendingOrderTableTable(attachedDatabase, alias);
  }
}

class PendingOrderTableData extends DataClass
    implements Insertable<PendingOrderTableData> {
  final String id;
  final String tokoId;
  final String namaPelanggan;
  final String? catatan;
  final DateTime createdAt;
  const PendingOrderTableData({
    required this.id,
    required this.tokoId,
    required this.namaPelanggan,
    this.catatan,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['nama_pelanggan'] = Variable<String>(namaPelanggan);
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingOrderTableCompanion toCompanion(bool nullToAbsent) {
    return PendingOrderTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      namaPelanggan: Value(namaPelanggan),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      createdAt: Value(createdAt),
    );
  }

  factory PendingOrderTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOrderTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      namaPelanggan: serializer.fromJson<String>(json['namaPelanggan']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'namaPelanggan': serializer.toJson<String>(namaPelanggan),
      'catatan': serializer.toJson<String?>(catatan),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingOrderTableData copyWith({
    String? id,
    String? tokoId,
    String? namaPelanggan,
    Value<String?> catatan = const Value.absent(),
    DateTime? createdAt,
  }) => PendingOrderTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    namaPelanggan: namaPelanggan ?? this.namaPelanggan,
    catatan: catatan.present ? catatan.value : this.catatan,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingOrderTableData copyWithCompanion(PendingOrderTableCompanion data) {
    return PendingOrderTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      namaPelanggan: data.namaPelanggan.present
          ? data.namaPelanggan.value
          : this.namaPelanggan,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOrderTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tokoId, namaPelanggan, catatan, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOrderTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.namaPelanggan == this.namaPelanggan &&
          other.catatan == this.catatan &&
          other.createdAt == this.createdAt);
}

class PendingOrderTableCompanion
    extends UpdateCompanion<PendingOrderTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> namaPelanggan;
  final Value<String?> catatan;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingOrderTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.namaPelanggan = const Value.absent(),
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingOrderTableCompanion.insert({
    required String id,
    required String tokoId,
    required String namaPelanggan,
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       namaPelanggan = Value(namaPelanggan);
  static Insertable<PendingOrderTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? namaPelanggan,
    Expression<String>? catatan,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (namaPelanggan != null) 'nama_pelanggan': namaPelanggan,
      if (catatan != null) 'catatan': catatan,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingOrderTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? namaPelanggan,
    Value<String?>? catatan,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingOrderTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      namaPelanggan: namaPelanggan ?? this.namaPelanggan,
      catatan: catatan ?? this.catatan,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (namaPelanggan.present) {
      map['nama_pelanggan'] = Variable<String>(namaPelanggan.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
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
    return (StringBuffer('PendingOrderTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingOrderItemTableTable extends PendingOrderItemTable
    with TableInfo<$PendingOrderItemTableTable, PendingOrderItemTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingOrderItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendingOrderIdMeta = const VerificationMeta(
    'pendingOrderId',
  );
  @override
  late final GeneratedColumn<String> pendingOrderId = GeneratedColumn<String>(
    'pending_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<String> produkId = GeneratedColumn<String>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaProdukMeta = const VerificationMeta(
    'namaProduk',
  );
  @override
  late final GeneratedColumn<String> namaProduk = GeneratedColumn<String>(
    'nama_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaJualMeta = const VerificationMeta(
    'hargaJual',
  );
  @override
  late final GeneratedColumn<double> hargaJual = GeneratedColumn<double>(
    'harga_jual',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<int> jumlah = GeneratedColumn<int>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _diskonTipeMeta = const VerificationMeta(
    'diskonTipe',
  );
  @override
  late final GeneratedColumn<int> diskonTipe = GeneratedColumn<int>(
    'diskon_tipe',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _diskonValueMeta = const VerificationMeta(
    'diskonValue',
  );
  @override
  late final GeneratedColumn<double> diskonValue = GeneratedColumn<double>(
    'diskon_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    pendingOrderId,
    produkId,
    namaProduk,
    hargaJual,
    jumlah,
    diskonTipe,
    diskonValue,
    subtotal,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_order_item_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingOrderItemTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('pending_order_id')) {
      context.handle(
        _pendingOrderIdMeta,
        pendingOrderId.isAcceptableOrUnknown(
          data['pending_order_id']!,
          _pendingOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pendingOrderIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('nama_produk')) {
      context.handle(
        _namaProdukMeta,
        namaProduk.isAcceptableOrUnknown(data['nama_produk']!, _namaProdukMeta),
      );
    } else if (isInserting) {
      context.missing(_namaProdukMeta);
    }
    if (data.containsKey('harga_jual')) {
      context.handle(
        _hargaJualMeta,
        hargaJual.isAcceptableOrUnknown(data['harga_jual']!, _hargaJualMeta),
      );
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    }
    if (data.containsKey('diskon_tipe')) {
      context.handle(
        _diskonTipeMeta,
        diskonTipe.isAcceptableOrUnknown(data['diskon_tipe']!, _diskonTipeMeta),
      );
    }
    if (data.containsKey('diskon_value')) {
      context.handle(
        _diskonValueMeta,
        diskonValue.isAcceptableOrUnknown(
          data['diskon_value']!,
          _diskonValueMeta,
        ),
      );
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingOrderItemTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingOrderItemTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      pendingOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_order_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      )!,
      hargaJual: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_jual'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah'],
      )!,
      diskonTipe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diskon_tipe'],
      )!,
      diskonValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}diskon_value'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}subtotal'],
      )!,
    );
  }

  @override
  $PendingOrderItemTableTable createAlias(String alias) {
    return $PendingOrderItemTableTable(attachedDatabase, alias);
  }
}

class PendingOrderItemTableData extends DataClass
    implements Insertable<PendingOrderItemTableData> {
  final String id;
  final String tokoId;
  final String pendingOrderId;
  final String produkId;
  final String namaProduk;
  final double hargaJual;
  final int jumlah;
  final int diskonTipe;
  final double diskonValue;
  final double subtotal;
  const PendingOrderItemTableData({
    required this.id,
    required this.tokoId,
    required this.pendingOrderId,
    required this.produkId,
    required this.namaProduk,
    required this.hargaJual,
    required this.jumlah,
    required this.diskonTipe,
    required this.diskonValue,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['pending_order_id'] = Variable<String>(pendingOrderId);
    map['produk_id'] = Variable<String>(produkId);
    map['nama_produk'] = Variable<String>(namaProduk);
    map['harga_jual'] = Variable<double>(hargaJual);
    map['jumlah'] = Variable<int>(jumlah);
    map['diskon_tipe'] = Variable<int>(diskonTipe);
    map['diskon_value'] = Variable<double>(diskonValue);
    map['subtotal'] = Variable<double>(subtotal);
    return map;
  }

  PendingOrderItemTableCompanion toCompanion(bool nullToAbsent) {
    return PendingOrderItemTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      pendingOrderId: Value(pendingOrderId),
      produkId: Value(produkId),
      namaProduk: Value(namaProduk),
      hargaJual: Value(hargaJual),
      jumlah: Value(jumlah),
      diskonTipe: Value(diskonTipe),
      diskonValue: Value(diskonValue),
      subtotal: Value(subtotal),
    );
  }

  factory PendingOrderItemTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingOrderItemTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      pendingOrderId: serializer.fromJson<String>(json['pendingOrderId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      namaProduk: serializer.fromJson<String>(json['namaProduk']),
      hargaJual: serializer.fromJson<double>(json['hargaJual']),
      jumlah: serializer.fromJson<int>(json['jumlah']),
      diskonTipe: serializer.fromJson<int>(json['diskonTipe']),
      diskonValue: serializer.fromJson<double>(json['diskonValue']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'pendingOrderId': serializer.toJson<String>(pendingOrderId),
      'produkId': serializer.toJson<String>(produkId),
      'namaProduk': serializer.toJson<String>(namaProduk),
      'hargaJual': serializer.toJson<double>(hargaJual),
      'jumlah': serializer.toJson<int>(jumlah),
      'diskonTipe': serializer.toJson<int>(diskonTipe),
      'diskonValue': serializer.toJson<double>(diskonValue),
      'subtotal': serializer.toJson<double>(subtotal),
    };
  }

  PendingOrderItemTableData copyWith({
    String? id,
    String? tokoId,
    String? pendingOrderId,
    String? produkId,
    String? namaProduk,
    double? hargaJual,
    int? jumlah,
    int? diskonTipe,
    double? diskonValue,
    double? subtotal,
  }) => PendingOrderItemTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    pendingOrderId: pendingOrderId ?? this.pendingOrderId,
    produkId: produkId ?? this.produkId,
    namaProduk: namaProduk ?? this.namaProduk,
    hargaJual: hargaJual ?? this.hargaJual,
    jumlah: jumlah ?? this.jumlah,
    diskonTipe: diskonTipe ?? this.diskonTipe,
    diskonValue: diskonValue ?? this.diskonValue,
    subtotal: subtotal ?? this.subtotal,
  );
  PendingOrderItemTableData copyWithCompanion(
    PendingOrderItemTableCompanion data,
  ) {
    return PendingOrderItemTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      pendingOrderId: data.pendingOrderId.present
          ? data.pendingOrderId.value
          : this.pendingOrderId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      diskonTipe: data.diskonTipe.present
          ? data.diskonTipe.value
          : this.diskonTipe,
      diskonValue: data.diskonValue.present
          ? data.diskonValue.value
          : this.diskonValue,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingOrderItemTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('pendingOrderId: $pendingOrderId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jumlah: $jumlah, ')
          ..write('diskonTipe: $diskonTipe, ')
          ..write('diskonValue: $diskonValue, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    pendingOrderId,
    produkId,
    namaProduk,
    hargaJual,
    jumlah,
    diskonTipe,
    diskonValue,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOrderItemTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.pendingOrderId == this.pendingOrderId &&
          other.produkId == this.produkId &&
          other.namaProduk == this.namaProduk &&
          other.hargaJual == this.hargaJual &&
          other.jumlah == this.jumlah &&
          other.diskonTipe == this.diskonTipe &&
          other.diskonValue == this.diskonValue &&
          other.subtotal == this.subtotal);
}

class PendingOrderItemTableCompanion
    extends UpdateCompanion<PendingOrderItemTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> pendingOrderId;
  final Value<String> produkId;
  final Value<String> namaProduk;
  final Value<double> hargaJual;
  final Value<int> jumlah;
  final Value<int> diskonTipe;
  final Value<double> diskonValue;
  final Value<double> subtotal;
  final Value<int> rowid;
  const PendingOrderItemTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.pendingOrderId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.namaProduk = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.diskonTipe = const Value.absent(),
    this.diskonValue = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingOrderItemTableCompanion.insert({
    required String id,
    required String tokoId,
    required String pendingOrderId,
    required String produkId,
    required String namaProduk,
    this.hargaJual = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.diskonTipe = const Value.absent(),
    this.diskonValue = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       pendingOrderId = Value(pendingOrderId),
       produkId = Value(produkId),
       namaProduk = Value(namaProduk);
  static Insertable<PendingOrderItemTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? pendingOrderId,
    Expression<String>? produkId,
    Expression<String>? namaProduk,
    Expression<double>? hargaJual,
    Expression<int>? jumlah,
    Expression<int>? diskonTipe,
    Expression<double>? diskonValue,
    Expression<double>? subtotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (pendingOrderId != null) 'pending_order_id': pendingOrderId,
      if (produkId != null) 'produk_id': produkId,
      if (namaProduk != null) 'nama_produk': namaProduk,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (jumlah != null) 'jumlah': jumlah,
      if (diskonTipe != null) 'diskon_tipe': diskonTipe,
      if (diskonValue != null) 'diskon_value': diskonValue,
      if (subtotal != null) 'subtotal': subtotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingOrderItemTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? pendingOrderId,
    Value<String>? produkId,
    Value<String>? namaProduk,
    Value<double>? hargaJual,
    Value<int>? jumlah,
    Value<int>? diskonTipe,
    Value<double>? diskonValue,
    Value<double>? subtotal,
    Value<int>? rowid,
  }) {
    return PendingOrderItemTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      pendingOrderId: pendingOrderId ?? this.pendingOrderId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      hargaJual: hargaJual ?? this.hargaJual,
      jumlah: jumlah ?? this.jumlah,
      diskonTipe: diskonTipe ?? this.diskonTipe,
      diskonValue: diskonValue ?? this.diskonValue,
      subtotal: subtotal ?? this.subtotal,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (pendingOrderId.present) {
      map['pending_order_id'] = Variable<String>(pendingOrderId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (namaProduk.present) {
      map['nama_produk'] = Variable<String>(namaProduk.value);
    }
    if (hargaJual.present) {
      map['harga_jual'] = Variable<double>(hargaJual.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<int>(jumlah.value);
    }
    if (diskonTipe.present) {
      map['diskon_tipe'] = Variable<int>(diskonTipe.value);
    }
    if (diskonValue.present) {
      map['diskon_value'] = Variable<double>(diskonValue.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingOrderItemTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('pendingOrderId: $pendingOrderId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('jumlah: $jumlah, ')
          ..write('diskonTipe: $diskonTipe, ')
          ..write('diskonValue: $diskonValue, ')
          ..write('subtotal: $subtotal, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingPembelianTableTable extends PendingPembelianTable
    with TableInfo<$PendingPembelianTableTable, PendingPembelianTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingPembelianTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierIdMeta = const VerificationMeta(
    'supplierId',
  );
  @override
  late final GeneratedColumn<String> supplierId = GeneratedColumn<String>(
    'supplier_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _namaSupplierMeta = const VerificationMeta(
    'namaSupplier',
  );
  @override
  late final GeneratedColumn<String> namaSupplier = GeneratedColumn<String>(
    'nama_supplier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPpnEnabledMeta = const VerificationMeta(
    'isPpnEnabled',
  );
  @override
  late final GeneratedColumn<bool> isPpnEnabled = GeneratedColumn<bool>(
    'is_ppn_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ppn_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _ppnPercentMeta = const VerificationMeta(
    'ppnPercent',
  );
  @override
  late final GeneratedColumn<double> ppnPercent = GeneratedColumn<double>(
    'ppn_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(11.0),
  );
  static const VerificationMeta _diskonTipeMeta = const VerificationMeta(
    'diskonTipe',
  );
  @override
  late final GeneratedColumn<int> diskonTipe = GeneratedColumn<int>(
    'diskon_tipe',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _diskonPersenMeta = const VerificationMeta(
    'diskonPersen',
  );
  @override
  late final GeneratedColumn<double> diskonPersen = GeneratedColumn<double>(
    'diskon_persen',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _diskonNominalMeta = const VerificationMeta(
    'diskonNominal',
  );
  @override
  late final GeneratedColumn<double> diskonNominal = GeneratedColumn<double>(
    'diskon_nominal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    tokoId,
    supplierId,
    namaSupplier,
    isPpnEnabled,
    ppnPercent,
    diskonTipe,
    diskonPersen,
    diskonNominal,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_pembelian_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingPembelianTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('supplier_id')) {
      context.handle(
        _supplierIdMeta,
        supplierId.isAcceptableOrUnknown(data['supplier_id']!, _supplierIdMeta),
      );
    }
    if (data.containsKey('nama_supplier')) {
      context.handle(
        _namaSupplierMeta,
        namaSupplier.isAcceptableOrUnknown(
          data['nama_supplier']!,
          _namaSupplierMeta,
        ),
      );
    }
    if (data.containsKey('is_ppn_enabled')) {
      context.handle(
        _isPpnEnabledMeta,
        isPpnEnabled.isAcceptableOrUnknown(
          data['is_ppn_enabled']!,
          _isPpnEnabledMeta,
        ),
      );
    }
    if (data.containsKey('ppn_percent')) {
      context.handle(
        _ppnPercentMeta,
        ppnPercent.isAcceptableOrUnknown(data['ppn_percent']!, _ppnPercentMeta),
      );
    }
    if (data.containsKey('diskon_tipe')) {
      context.handle(
        _diskonTipeMeta,
        diskonTipe.isAcceptableOrUnknown(data['diskon_tipe']!, _diskonTipeMeta),
      );
    }
    if (data.containsKey('diskon_persen')) {
      context.handle(
        _diskonPersenMeta,
        diskonPersen.isAcceptableOrUnknown(
          data['diskon_persen']!,
          _diskonPersenMeta,
        ),
      );
    }
    if (data.containsKey('diskon_nominal')) {
      context.handle(
        _diskonNominalMeta,
        diskonNominal.isAcceptableOrUnknown(
          data['diskon_nominal']!,
          _diskonNominalMeta,
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
  PendingPembelianTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingPembelianTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      namaSupplier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_supplier'],
      ),
      isPpnEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_ppn_enabled'],
      )!,
      ppnPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ppn_percent'],
      )!,
      diskonTipe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diskon_tipe'],
      )!,
      diskonPersen: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}diskon_persen'],
      )!,
      diskonNominal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}diskon_nominal'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingPembelianTableTable createAlias(String alias) {
    return $PendingPembelianTableTable(attachedDatabase, alias);
  }
}

class PendingPembelianTableData extends DataClass
    implements Insertable<PendingPembelianTableData> {
  final String id;
  final String tokoId;
  final String? supplierId;
  final String? namaSupplier;
  final bool isPpnEnabled;
  final double ppnPercent;
  final int diskonTipe;
  final double diskonPersen;
  final double diskonNominal;
  final DateTime createdAt;
  const PendingPembelianTableData({
    required this.id,
    required this.tokoId,
    this.supplierId,
    this.namaSupplier,
    required this.isPpnEnabled,
    required this.ppnPercent,
    required this.diskonTipe,
    required this.diskonPersen,
    required this.diskonNominal,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || namaSupplier != null) {
      map['nama_supplier'] = Variable<String>(namaSupplier);
    }
    map['is_ppn_enabled'] = Variable<bool>(isPpnEnabled);
    map['ppn_percent'] = Variable<double>(ppnPercent);
    map['diskon_tipe'] = Variable<int>(diskonTipe);
    map['diskon_persen'] = Variable<double>(diskonPersen);
    map['diskon_nominal'] = Variable<double>(diskonNominal);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingPembelianTableCompanion toCompanion(bool nullToAbsent) {
    return PendingPembelianTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      namaSupplier: namaSupplier == null && nullToAbsent
          ? const Value.absent()
          : Value(namaSupplier),
      isPpnEnabled: Value(isPpnEnabled),
      ppnPercent: Value(ppnPercent),
      diskonTipe: Value(diskonTipe),
      diskonPersen: Value(diskonPersen),
      diskonNominal: Value(diskonNominal),
      createdAt: Value(createdAt),
    );
  }

  factory PendingPembelianTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingPembelianTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      namaSupplier: serializer.fromJson<String?>(json['namaSupplier']),
      isPpnEnabled: serializer.fromJson<bool>(json['isPpnEnabled']),
      ppnPercent: serializer.fromJson<double>(json['ppnPercent']),
      diskonTipe: serializer.fromJson<int>(json['diskonTipe']),
      diskonPersen: serializer.fromJson<double>(json['diskonPersen']),
      diskonNominal: serializer.fromJson<double>(json['diskonNominal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'supplierId': serializer.toJson<String?>(supplierId),
      'namaSupplier': serializer.toJson<String?>(namaSupplier),
      'isPpnEnabled': serializer.toJson<bool>(isPpnEnabled),
      'ppnPercent': serializer.toJson<double>(ppnPercent),
      'diskonTipe': serializer.toJson<int>(diskonTipe),
      'diskonPersen': serializer.toJson<double>(diskonPersen),
      'diskonNominal': serializer.toJson<double>(diskonNominal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingPembelianTableData copyWith({
    String? id,
    String? tokoId,
    Value<String?> supplierId = const Value.absent(),
    Value<String?> namaSupplier = const Value.absent(),
    bool? isPpnEnabled,
    double? ppnPercent,
    int? diskonTipe,
    double? diskonPersen,
    double? diskonNominal,
    DateTime? createdAt,
  }) => PendingPembelianTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    namaSupplier: namaSupplier.present ? namaSupplier.value : this.namaSupplier,
    isPpnEnabled: isPpnEnabled ?? this.isPpnEnabled,
    ppnPercent: ppnPercent ?? this.ppnPercent,
    diskonTipe: diskonTipe ?? this.diskonTipe,
    diskonPersen: diskonPersen ?? this.diskonPersen,
    diskonNominal: diskonNominal ?? this.diskonNominal,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingPembelianTableData copyWithCompanion(
    PendingPembelianTableCompanion data,
  ) {
    return PendingPembelianTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      namaSupplier: data.namaSupplier.present
          ? data.namaSupplier.value
          : this.namaSupplier,
      isPpnEnabled: data.isPpnEnabled.present
          ? data.isPpnEnabled.value
          : this.isPpnEnabled,
      ppnPercent: data.ppnPercent.present
          ? data.ppnPercent.value
          : this.ppnPercent,
      diskonTipe: data.diskonTipe.present
          ? data.diskonTipe.value
          : this.diskonTipe,
      diskonPersen: data.diskonPersen.present
          ? data.diskonPersen.value
          : this.diskonPersen,
      diskonNominal: data.diskonNominal.present
          ? data.diskonNominal.value
          : this.diskonNominal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingPembelianTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('supplierId: $supplierId, ')
          ..write('namaSupplier: $namaSupplier, ')
          ..write('isPpnEnabled: $isPpnEnabled, ')
          ..write('ppnPercent: $ppnPercent, ')
          ..write('diskonTipe: $diskonTipe, ')
          ..write('diskonPersen: $diskonPersen, ')
          ..write('diskonNominal: $diskonNominal, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    supplierId,
    namaSupplier,
    isPpnEnabled,
    ppnPercent,
    diskonTipe,
    diskonPersen,
    diskonNominal,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingPembelianTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.supplierId == this.supplierId &&
          other.namaSupplier == this.namaSupplier &&
          other.isPpnEnabled == this.isPpnEnabled &&
          other.ppnPercent == this.ppnPercent &&
          other.diskonTipe == this.diskonTipe &&
          other.diskonPersen == this.diskonPersen &&
          other.diskonNominal == this.diskonNominal &&
          other.createdAt == this.createdAt);
}

class PendingPembelianTableCompanion
    extends UpdateCompanion<PendingPembelianTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String?> supplierId;
  final Value<String?> namaSupplier;
  final Value<bool> isPpnEnabled;
  final Value<double> ppnPercent;
  final Value<int> diskonTipe;
  final Value<double> diskonPersen;
  final Value<double> diskonNominal;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingPembelianTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.isPpnEnabled = const Value.absent(),
    this.ppnPercent = const Value.absent(),
    this.diskonTipe = const Value.absent(),
    this.diskonPersen = const Value.absent(),
    this.diskonNominal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingPembelianTableCompanion.insert({
    required String id,
    required String tokoId,
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.isPpnEnabled = const Value.absent(),
    this.ppnPercent = const Value.absent(),
    this.diskonTipe = const Value.absent(),
    this.diskonPersen = const Value.absent(),
    this.diskonNominal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId);
  static Insertable<PendingPembelianTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? supplierId,
    Expression<String>? namaSupplier,
    Expression<bool>? isPpnEnabled,
    Expression<double>? ppnPercent,
    Expression<int>? diskonTipe,
    Expression<double>? diskonPersen,
    Expression<double>? diskonNominal,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (supplierId != null) 'supplier_id': supplierId,
      if (namaSupplier != null) 'nama_supplier': namaSupplier,
      if (isPpnEnabled != null) 'is_ppn_enabled': isPpnEnabled,
      if (ppnPercent != null) 'ppn_percent': ppnPercent,
      if (diskonTipe != null) 'diskon_tipe': diskonTipe,
      if (diskonPersen != null) 'diskon_persen': diskonPersen,
      if (diskonNominal != null) 'diskon_nominal': diskonNominal,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingPembelianTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String?>? supplierId,
    Value<String?>? namaSupplier,
    Value<bool>? isPpnEnabled,
    Value<double>? ppnPercent,
    Value<int>? diskonTipe,
    Value<double>? diskonPersen,
    Value<double>? diskonNominal,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingPembelianTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      supplierId: supplierId ?? this.supplierId,
      namaSupplier: namaSupplier ?? this.namaSupplier,
      isPpnEnabled: isPpnEnabled ?? this.isPpnEnabled,
      ppnPercent: ppnPercent ?? this.ppnPercent,
      diskonTipe: diskonTipe ?? this.diskonTipe,
      diskonPersen: diskonPersen ?? this.diskonPersen,
      diskonNominal: diskonNominal ?? this.diskonNominal,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (namaSupplier.present) {
      map['nama_supplier'] = Variable<String>(namaSupplier.value);
    }
    if (isPpnEnabled.present) {
      map['is_ppn_enabled'] = Variable<bool>(isPpnEnabled.value);
    }
    if (ppnPercent.present) {
      map['ppn_percent'] = Variable<double>(ppnPercent.value);
    }
    if (diskonTipe.present) {
      map['diskon_tipe'] = Variable<int>(diskonTipe.value);
    }
    if (diskonPersen.present) {
      map['diskon_persen'] = Variable<double>(diskonPersen.value);
    }
    if (diskonNominal.present) {
      map['diskon_nominal'] = Variable<double>(diskonNominal.value);
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
    return (StringBuffer('PendingPembelianTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('supplierId: $supplierId, ')
          ..write('namaSupplier: $namaSupplier, ')
          ..write('isPpnEnabled: $isPpnEnabled, ')
          ..write('ppnPercent: $ppnPercent, ')
          ..write('diskonTipe: $diskonTipe, ')
          ..write('diskonPersen: $diskonPersen, ')
          ..write('diskonNominal: $diskonNominal, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingPembelianItemTableTable extends PendingPembelianItemTable
    with
        TableInfo<
          $PendingPembelianItemTableTable,
          PendingPembelianItemTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingPembelianItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pendingPembelianIdMeta =
      const VerificationMeta('pendingPembelianId');
  @override
  late final GeneratedColumn<String> pendingPembelianId =
      GeneratedColumn<String>(
        'pending_pembelian_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<String> produkId = GeneratedColumn<String>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _namaProdukMeta = const VerificationMeta(
    'namaProduk',
  );
  @override
  late final GeneratedColumn<String> namaProduk = GeneratedColumn<String>(
    'nama_produk',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jumlahMeta = const VerificationMeta('jumlah');
  @override
  late final GeneratedColumn<int> jumlah = GeneratedColumn<int>(
    'jumlah',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _hargaBeliSatuanMeta = const VerificationMeta(
    'hargaBeliSatuan',
  );
  @override
  late final GeneratedColumn<double> hargaBeliSatuan = GeneratedColumn<double>(
    'harga_beli_satuan',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _hargaBeliLamaMeta = const VerificationMeta(
    'hargaBeliLama',
  );
  @override
  late final GeneratedColumn<double> hargaBeliLama = GeneratedColumn<double>(
    'harga_beli_lama',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _diskonTipeMeta = const VerificationMeta(
    'diskonTipe',
  );
  @override
  late final GeneratedColumn<int> diskonTipe = GeneratedColumn<int>(
    'diskon_tipe',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _diskonValueMeta = const VerificationMeta(
    'diskonValue',
  );
  @override
  late final GeneratedColumn<double> diskonValue = GeneratedColumn<double>(
    'diskon_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _satuanIdMeta = const VerificationMeta(
    'satuanId',
  );
  @override
  late final GeneratedColumn<String> satuanId = GeneratedColumn<String>(
    'satuan_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _konversiMeta = const VerificationMeta(
    'konversi',
  );
  @override
  late final GeneratedColumn<double> konversi = GeneratedColumn<double>(
    'konversi',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    pendingPembelianId,
    produkId,
    namaProduk,
    jumlah,
    hargaBeliSatuan,
    hargaBeliLama,
    diskonTipe,
    diskonValue,
    satuanId,
    konversi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_pembelian_item_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingPembelianItemTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('pending_pembelian_id')) {
      context.handle(
        _pendingPembelianIdMeta,
        pendingPembelianId.isAcceptableOrUnknown(
          data['pending_pembelian_id']!,
          _pendingPembelianIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pendingPembelianIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('nama_produk')) {
      context.handle(
        _namaProdukMeta,
        namaProduk.isAcceptableOrUnknown(data['nama_produk']!, _namaProdukMeta),
      );
    } else if (isInserting) {
      context.missing(_namaProdukMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    }
    if (data.containsKey('harga_beli_satuan')) {
      context.handle(
        _hargaBeliSatuanMeta,
        hargaBeliSatuan.isAcceptableOrUnknown(
          data['harga_beli_satuan']!,
          _hargaBeliSatuanMeta,
        ),
      );
    }
    if (data.containsKey('harga_beli_lama')) {
      context.handle(
        _hargaBeliLamaMeta,
        hargaBeliLama.isAcceptableOrUnknown(
          data['harga_beli_lama']!,
          _hargaBeliLamaMeta,
        ),
      );
    }
    if (data.containsKey('diskon_tipe')) {
      context.handle(
        _diskonTipeMeta,
        diskonTipe.isAcceptableOrUnknown(data['diskon_tipe']!, _diskonTipeMeta),
      );
    }
    if (data.containsKey('diskon_value')) {
      context.handle(
        _diskonValueMeta,
        diskonValue.isAcceptableOrUnknown(
          data['diskon_value']!,
          _diskonValueMeta,
        ),
      );
    }
    if (data.containsKey('satuan_id')) {
      context.handle(
        _satuanIdMeta,
        satuanId.isAcceptableOrUnknown(data['satuan_id']!, _satuanIdMeta),
      );
    }
    if (data.containsKey('konversi')) {
      context.handle(
        _konversiMeta,
        konversi.isAcceptableOrUnknown(data['konversi']!, _konversiMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PendingPembelianItemTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingPembelianItemTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      pendingPembelianId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pending_pembelian_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah'],
      )!,
      hargaBeliSatuan: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_beli_satuan'],
      )!,
      hargaBeliLama: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_beli_lama'],
      )!,
      diskonTipe: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diskon_tipe'],
      )!,
      diskonValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}diskon_value'],
      )!,
      satuanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}satuan_id'],
      ),
      konversi: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}konversi'],
      )!,
    );
  }

  @override
  $PendingPembelianItemTableTable createAlias(String alias) {
    return $PendingPembelianItemTableTable(attachedDatabase, alias);
  }
}

class PendingPembelianItemTableData extends DataClass
    implements Insertable<PendingPembelianItemTableData> {
  final String id;
  final String tokoId;
  final String pendingPembelianId;
  final String produkId;
  final String namaProduk;
  final int jumlah;
  final double hargaBeliSatuan;
  final double hargaBeliLama;
  final int diskonTipe;
  final double diskonValue;
  final String? satuanId;
  final double konversi;
  const PendingPembelianItemTableData({
    required this.id,
    required this.tokoId,
    required this.pendingPembelianId,
    required this.produkId,
    required this.namaProduk,
    required this.jumlah,
    required this.hargaBeliSatuan,
    required this.hargaBeliLama,
    required this.diskonTipe,
    required this.diskonValue,
    this.satuanId,
    required this.konversi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['pending_pembelian_id'] = Variable<String>(pendingPembelianId);
    map['produk_id'] = Variable<String>(produkId);
    map['nama_produk'] = Variable<String>(namaProduk);
    map['jumlah'] = Variable<int>(jumlah);
    map['harga_beli_satuan'] = Variable<double>(hargaBeliSatuan);
    map['harga_beli_lama'] = Variable<double>(hargaBeliLama);
    map['diskon_tipe'] = Variable<int>(diskonTipe);
    map['diskon_value'] = Variable<double>(diskonValue);
    if (!nullToAbsent || satuanId != null) {
      map['satuan_id'] = Variable<String>(satuanId);
    }
    map['konversi'] = Variable<double>(konversi);
    return map;
  }

  PendingPembelianItemTableCompanion toCompanion(bool nullToAbsent) {
    return PendingPembelianItemTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      pendingPembelianId: Value(pendingPembelianId),
      produkId: Value(produkId),
      namaProduk: Value(namaProduk),
      jumlah: Value(jumlah),
      hargaBeliSatuan: Value(hargaBeliSatuan),
      hargaBeliLama: Value(hargaBeliLama),
      diskonTipe: Value(diskonTipe),
      diskonValue: Value(diskonValue),
      satuanId: satuanId == null && nullToAbsent
          ? const Value.absent()
          : Value(satuanId),
      konversi: Value(konversi),
    );
  }

  factory PendingPembelianItemTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingPembelianItemTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      pendingPembelianId: serializer.fromJson<String>(
        json['pendingPembelianId'],
      ),
      produkId: serializer.fromJson<String>(json['produkId']),
      namaProduk: serializer.fromJson<String>(json['namaProduk']),
      jumlah: serializer.fromJson<int>(json['jumlah']),
      hargaBeliSatuan: serializer.fromJson<double>(json['hargaBeliSatuan']),
      hargaBeliLama: serializer.fromJson<double>(json['hargaBeliLama']),
      diskonTipe: serializer.fromJson<int>(json['diskonTipe']),
      diskonValue: serializer.fromJson<double>(json['diskonValue']),
      satuanId: serializer.fromJson<String?>(json['satuanId']),
      konversi: serializer.fromJson<double>(json['konversi']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'pendingPembelianId': serializer.toJson<String>(pendingPembelianId),
      'produkId': serializer.toJson<String>(produkId),
      'namaProduk': serializer.toJson<String>(namaProduk),
      'jumlah': serializer.toJson<int>(jumlah),
      'hargaBeliSatuan': serializer.toJson<double>(hargaBeliSatuan),
      'hargaBeliLama': serializer.toJson<double>(hargaBeliLama),
      'diskonTipe': serializer.toJson<int>(diskonTipe),
      'diskonValue': serializer.toJson<double>(diskonValue),
      'satuanId': serializer.toJson<String?>(satuanId),
      'konversi': serializer.toJson<double>(konversi),
    };
  }

  PendingPembelianItemTableData copyWith({
    String? id,
    String? tokoId,
    String? pendingPembelianId,
    String? produkId,
    String? namaProduk,
    int? jumlah,
    double? hargaBeliSatuan,
    double? hargaBeliLama,
    int? diskonTipe,
    double? diskonValue,
    Value<String?> satuanId = const Value.absent(),
    double? konversi,
  }) => PendingPembelianItemTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    pendingPembelianId: pendingPembelianId ?? this.pendingPembelianId,
    produkId: produkId ?? this.produkId,
    namaProduk: namaProduk ?? this.namaProduk,
    jumlah: jumlah ?? this.jumlah,
    hargaBeliSatuan: hargaBeliSatuan ?? this.hargaBeliSatuan,
    hargaBeliLama: hargaBeliLama ?? this.hargaBeliLama,
    diskonTipe: diskonTipe ?? this.diskonTipe,
    diskonValue: diskonValue ?? this.diskonValue,
    satuanId: satuanId.present ? satuanId.value : this.satuanId,
    konversi: konversi ?? this.konversi,
  );
  PendingPembelianItemTableData copyWithCompanion(
    PendingPembelianItemTableCompanion data,
  ) {
    return PendingPembelianItemTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      pendingPembelianId: data.pendingPembelianId.present
          ? data.pendingPembelianId.value
          : this.pendingPembelianId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      hargaBeliSatuan: data.hargaBeliSatuan.present
          ? data.hargaBeliSatuan.value
          : this.hargaBeliSatuan,
      hargaBeliLama: data.hargaBeliLama.present
          ? data.hargaBeliLama.value
          : this.hargaBeliLama,
      diskonTipe: data.diskonTipe.present
          ? data.diskonTipe.value
          : this.diskonTipe,
      diskonValue: data.diskonValue.present
          ? data.diskonValue.value
          : this.diskonValue,
      satuanId: data.satuanId.present ? data.satuanId.value : this.satuanId,
      konversi: data.konversi.present ? data.konversi.value : this.konversi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingPembelianItemTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('pendingPembelianId: $pendingPembelianId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('jumlah: $jumlah, ')
          ..write('hargaBeliSatuan: $hargaBeliSatuan, ')
          ..write('hargaBeliLama: $hargaBeliLama, ')
          ..write('diskonTipe: $diskonTipe, ')
          ..write('diskonValue: $diskonValue, ')
          ..write('satuanId: $satuanId, ')
          ..write('konversi: $konversi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    pendingPembelianId,
    produkId,
    namaProduk,
    jumlah,
    hargaBeliSatuan,
    hargaBeliLama,
    diskonTipe,
    diskonValue,
    satuanId,
    konversi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingPembelianItemTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.pendingPembelianId == this.pendingPembelianId &&
          other.produkId == this.produkId &&
          other.namaProduk == this.namaProduk &&
          other.jumlah == this.jumlah &&
          other.hargaBeliSatuan == this.hargaBeliSatuan &&
          other.hargaBeliLama == this.hargaBeliLama &&
          other.diskonTipe == this.diskonTipe &&
          other.diskonValue == this.diskonValue &&
          other.satuanId == this.satuanId &&
          other.konversi == this.konversi);
}

class PendingPembelianItemTableCompanion
    extends UpdateCompanion<PendingPembelianItemTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> pendingPembelianId;
  final Value<String> produkId;
  final Value<String> namaProduk;
  final Value<int> jumlah;
  final Value<double> hargaBeliSatuan;
  final Value<double> hargaBeliLama;
  final Value<int> diskonTipe;
  final Value<double> diskonValue;
  final Value<String?> satuanId;
  final Value<double> konversi;
  final Value<int> rowid;
  const PendingPembelianItemTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.pendingPembelianId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.namaProduk = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.hargaBeliSatuan = const Value.absent(),
    this.hargaBeliLama = const Value.absent(),
    this.diskonTipe = const Value.absent(),
    this.diskonValue = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingPembelianItemTableCompanion.insert({
    required String id,
    required String tokoId,
    required String pendingPembelianId,
    required String produkId,
    required String namaProduk,
    this.jumlah = const Value.absent(),
    this.hargaBeliSatuan = const Value.absent(),
    this.hargaBeliLama = const Value.absent(),
    this.diskonTipe = const Value.absent(),
    this.diskonValue = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       pendingPembelianId = Value(pendingPembelianId),
       produkId = Value(produkId),
       namaProduk = Value(namaProduk);
  static Insertable<PendingPembelianItemTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? pendingPembelianId,
    Expression<String>? produkId,
    Expression<String>? namaProduk,
    Expression<int>? jumlah,
    Expression<double>? hargaBeliSatuan,
    Expression<double>? hargaBeliLama,
    Expression<int>? diskonTipe,
    Expression<double>? diskonValue,
    Expression<String>? satuanId,
    Expression<double>? konversi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (pendingPembelianId != null)
        'pending_pembelian_id': pendingPembelianId,
      if (produkId != null) 'produk_id': produkId,
      if (namaProduk != null) 'nama_produk': namaProduk,
      if (jumlah != null) 'jumlah': jumlah,
      if (hargaBeliSatuan != null) 'harga_beli_satuan': hargaBeliSatuan,
      if (hargaBeliLama != null) 'harga_beli_lama': hargaBeliLama,
      if (diskonTipe != null) 'diskon_tipe': diskonTipe,
      if (diskonValue != null) 'diskon_value': diskonValue,
      if (satuanId != null) 'satuan_id': satuanId,
      if (konversi != null) 'konversi': konversi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingPembelianItemTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? pendingPembelianId,
    Value<String>? produkId,
    Value<String>? namaProduk,
    Value<int>? jumlah,
    Value<double>? hargaBeliSatuan,
    Value<double>? hargaBeliLama,
    Value<int>? diskonTipe,
    Value<double>? diskonValue,
    Value<String?>? satuanId,
    Value<double>? konversi,
    Value<int>? rowid,
  }) {
    return PendingPembelianItemTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      pendingPembelianId: pendingPembelianId ?? this.pendingPembelianId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      jumlah: jumlah ?? this.jumlah,
      hargaBeliSatuan: hargaBeliSatuan ?? this.hargaBeliSatuan,
      hargaBeliLama: hargaBeliLama ?? this.hargaBeliLama,
      diskonTipe: diskonTipe ?? this.diskonTipe,
      diskonValue: diskonValue ?? this.diskonValue,
      satuanId: satuanId ?? this.satuanId,
      konversi: konversi ?? this.konversi,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (pendingPembelianId.present) {
      map['pending_pembelian_id'] = Variable<String>(pendingPembelianId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (namaProduk.present) {
      map['nama_produk'] = Variable<String>(namaProduk.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<int>(jumlah.value);
    }
    if (hargaBeliSatuan.present) {
      map['harga_beli_satuan'] = Variable<double>(hargaBeliSatuan.value);
    }
    if (hargaBeliLama.present) {
      map['harga_beli_lama'] = Variable<double>(hargaBeliLama.value);
    }
    if (diskonTipe.present) {
      map['diskon_tipe'] = Variable<int>(diskonTipe.value);
    }
    if (diskonValue.present) {
      map['diskon_value'] = Variable<double>(diskonValue.value);
    }
    if (satuanId.present) {
      map['satuan_id'] = Variable<String>(satuanId.value);
    }
    if (konversi.present) {
      map['konversi'] = Variable<double>(konversi.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingPembelianItemTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('pendingPembelianId: $pendingPembelianId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('jumlah: $jumlah, ')
          ..write('hargaBeliSatuan: $hargaBeliSatuan, ')
          ..write('hargaBeliLama: $hargaBeliLama, ')
          ..write('diskonTipe: $diskonTipe, ')
          ..write('diskonValue: $diskonValue, ')
          ..write('satuanId: $satuanId, ')
          ..write('konversi: $konversi, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotifikasiTableTable extends NotifikasiTable
    with TableInfo<$NotifikasiTableTable, NotifikasiTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotifikasiTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _judulMeta = const VerificationMeta('judul');
  @override
  late final GeneratedColumn<String> judul = GeneratedColumn<String>(
    'judul',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pesanMeta = const VerificationMeta('pesan');
  @override
  late final GeneratedColumn<String> pesan = GeneratedColumn<String>(
    'pesan',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tipeMeta = const VerificationMeta('tipe');
  @override
  late final GeneratedColumn<String> tipe = GeneratedColumn<String>(
    'tipe',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INFO'),
  );
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
    'is_read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    tokoId,
    judul,
    pesan,
    tipe,
    isRead,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notifikasi_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotifikasiTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('judul')) {
      context.handle(
        _judulMeta,
        judul.isAcceptableOrUnknown(data['judul']!, _judulMeta),
      );
    } else if (isInserting) {
      context.missing(_judulMeta);
    }
    if (data.containsKey('pesan')) {
      context.handle(
        _pesanMeta,
        pesan.isAcceptableOrUnknown(data['pesan']!, _pesanMeta),
      );
    } else if (isInserting) {
      context.missing(_pesanMeta);
    }
    if (data.containsKey('tipe')) {
      context.handle(
        _tipeMeta,
        tipe.isAcceptableOrUnknown(data['tipe']!, _tipeMeta),
      );
    }
    if (data.containsKey('is_read')) {
      context.handle(
        _isReadMeta,
        isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta),
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
  NotifikasiTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotifikasiTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      judul: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}judul'],
      )!,
      pesan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pesan'],
      )!,
      tipe: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tipe'],
      )!,
      isRead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NotifikasiTableTable createAlias(String alias) {
    return $NotifikasiTableTable(attachedDatabase, alias);
  }
}

class NotifikasiTableData extends DataClass
    implements Insertable<NotifikasiTableData> {
  final String id;
  final String tokoId;
  final String judul;
  final String pesan;
  final String tipe;
  final bool isRead;
  final DateTime createdAt;
  const NotifikasiTableData({
    required this.id,
    required this.tokoId,
    required this.judul,
    required this.pesan,
    required this.tipe,
    required this.isRead,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['judul'] = Variable<String>(judul);
    map['pesan'] = Variable<String>(pesan);
    map['tipe'] = Variable<String>(tipe);
    map['is_read'] = Variable<bool>(isRead);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NotifikasiTableCompanion toCompanion(bool nullToAbsent) {
    return NotifikasiTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      judul: Value(judul),
      pesan: Value(pesan),
      tipe: Value(tipe),
      isRead: Value(isRead),
      createdAt: Value(createdAt),
    );
  }

  factory NotifikasiTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotifikasiTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      judul: serializer.fromJson<String>(json['judul']),
      pesan: serializer.fromJson<String>(json['pesan']),
      tipe: serializer.fromJson<String>(json['tipe']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'judul': serializer.toJson<String>(judul),
      'pesan': serializer.toJson<String>(pesan),
      'tipe': serializer.toJson<String>(tipe),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NotifikasiTableData copyWith({
    String? id,
    String? tokoId,
    String? judul,
    String? pesan,
    String? tipe,
    bool? isRead,
    DateTime? createdAt,
  }) => NotifikasiTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    judul: judul ?? this.judul,
    pesan: pesan ?? this.pesan,
    tipe: tipe ?? this.tipe,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  NotifikasiTableData copyWithCompanion(NotifikasiTableCompanion data) {
    return NotifikasiTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      judul: data.judul.present ? data.judul.value : this.judul,
      pesan: data.pesan.present ? data.pesan.value : this.pesan,
      tipe: data.tipe.present ? data.tipe.value : this.tipe,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotifikasiTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('judul: $judul, ')
          ..write('pesan: $pesan, ')
          ..write('tipe: $tipe, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tokoId, judul, pesan, tipe, isRead, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotifikasiTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.judul == this.judul &&
          other.pesan == this.pesan &&
          other.tipe == this.tipe &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class NotifikasiTableCompanion extends UpdateCompanion<NotifikasiTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> judul;
  final Value<String> pesan;
  final Value<String> tipe;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NotifikasiTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.judul = const Value.absent(),
    this.pesan = const Value.absent(),
    this.tipe = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotifikasiTableCompanion.insert({
    required String id,
    required String tokoId,
    required String judul,
    required String pesan,
    this.tipe = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       judul = Value(judul),
       pesan = Value(pesan);
  static Insertable<NotifikasiTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? judul,
    Expression<String>? pesan,
    Expression<String>? tipe,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (judul != null) 'judul': judul,
      if (pesan != null) 'pesan': pesan,
      if (tipe != null) 'tipe': tipe,
      if (isRead != null) 'is_read': isRead,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotifikasiTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? judul,
    Value<String>? pesan,
    Value<String>? tipe,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return NotifikasiTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      judul: judul ?? this.judul,
      pesan: pesan ?? this.pesan,
      tipe: tipe ?? this.tipe,
      isRead: isRead ?? this.isRead,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (judul.present) {
      map['judul'] = Variable<String>(judul.value);
    }
    if (pesan.present) {
      map['pesan'] = Variable<String>(pesan.value);
    }
    if (tipe.present) {
      map['tipe'] = Variable<String>(tipe.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
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
    return (StringBuffer('NotifikasiTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('judul: $judul, ')
          ..write('pesan: $pesan, ')
          ..write('tipe: $tipe, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingSyncQueueTableTable extends PendingSyncQueueTable
    with TableInfo<$PendingSyncQueueTableTable, PendingSyncQueueTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingSyncQueueTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    operation,
    recordId,
    payload,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_sync_queue_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingSyncQueueTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
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
  PendingSyncQueueTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingSyncQueueTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PendingSyncQueueTableTable createAlias(String alias) {
    return $PendingSyncQueueTableTable(attachedDatabase, alias);
  }
}

class PendingSyncQueueTableData extends DataClass
    implements Insertable<PendingSyncQueueTableData> {
  final int id;
  final String targetTable;
  final String operation;
  final String recordId;
  final String payload;
  final DateTime createdAt;
  const PendingSyncQueueTableData({
    required this.id,
    required this.targetTable,
    required this.operation,
    required this.recordId,
    required this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['target_table'] = Variable<String>(targetTable);
    map['operation'] = Variable<String>(operation);
    map['record_id'] = Variable<String>(recordId);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PendingSyncQueueTableCompanion toCompanion(bool nullToAbsent) {
    return PendingSyncQueueTableCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      operation: Value(operation),
      recordId: Value(recordId),
      payload: Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory PendingSyncQueueTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingSyncQueueTableData(
      id: serializer.fromJson<int>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      operation: serializer.fromJson<String>(json['operation']),
      recordId: serializer.fromJson<String>(json['recordId']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'operation': serializer.toJson<String>(operation),
      'recordId': serializer.toJson<String>(recordId),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingSyncQueueTableData copyWith({
    int? id,
    String? targetTable,
    String? operation,
    String? recordId,
    String? payload,
    DateTime? createdAt,
  }) => PendingSyncQueueTableData(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    operation: operation ?? this.operation,
    recordId: recordId ?? this.recordId,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingSyncQueueTableData copyWithCompanion(
    PendingSyncQueueTableCompanion data,
  ) {
    return PendingSyncQueueTableData(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      operation: data.operation.present ? data.operation.value : this.operation,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncQueueTableData(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('operation: $operation, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, targetTable, operation, recordId, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingSyncQueueTableData &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.operation == this.operation &&
          other.recordId == this.recordId &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class PendingSyncQueueTableCompanion
    extends UpdateCompanion<PendingSyncQueueTableData> {
  final Value<int> id;
  final Value<String> targetTable;
  final Value<String> operation;
  final Value<String> recordId;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  const PendingSyncQueueTableCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.operation = const Value.absent(),
    this.recordId = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PendingSyncQueueTableCompanion.insert({
    this.id = const Value.absent(),
    required String targetTable,
    required String operation,
    required String recordId,
    required String payload,
    this.createdAt = const Value.absent(),
  }) : targetTable = Value(targetTable),
       operation = Value(operation),
       recordId = Value(recordId),
       payload = Value(payload);
  static Insertable<PendingSyncQueueTableData> custom({
    Expression<int>? id,
    Expression<String>? targetTable,
    Expression<String>? operation,
    Expression<String>? recordId,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'target_table': targetTable,
      if (operation != null) 'operation': operation,
      if (recordId != null) 'record_id': recordId,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PendingSyncQueueTableCompanion copyWith({
    Value<int>? id,
    Value<String>? targetTable,
    Value<String>? operation,
    Value<String>? recordId,
    Value<String>? payload,
    Value<DateTime>? createdAt,
  }) {
    return PendingSyncQueueTableCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      operation: operation ?? this.operation,
      recordId: recordId ?? this.recordId,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingSyncQueueTableCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('operation: $operation, ')
          ..write('recordId: $recordId, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RiwayatHargaTableTable extends RiwayatHargaTable
    with TableInfo<$RiwayatHargaTableTable, RiwayatHargaTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RiwayatHargaTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokoIdMeta = const VerificationMeta('tokoId');
  @override
  late final GeneratedColumn<String> tokoId = GeneratedColumn<String>(
    'toko_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _produkIdMeta = const VerificationMeta(
    'produkId',
  );
  @override
  late final GeneratedColumn<String> produkId = GeneratedColumn<String>(
    'produk_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaBeliLamaMeta = const VerificationMeta(
    'hargaBeliLama',
  );
  @override
  late final GeneratedColumn<double> hargaBeliLama = GeneratedColumn<double>(
    'harga_beli_lama',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaBeliBaruMeta = const VerificationMeta(
    'hargaBeliBaru',
  );
  @override
  late final GeneratedColumn<double> hargaBeliBaru = GeneratedColumn<double>(
    'harga_beli_baru',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaJualLamaMeta = const VerificationMeta(
    'hargaJualLama',
  );
  @override
  late final GeneratedColumn<double> hargaJualLama = GeneratedColumn<double>(
    'harga_jual_lama',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hargaJualBaruMeta = const VerificationMeta(
    'hargaJualBaru',
  );
  @override
  late final GeneratedColumn<double> hargaJualBaru = GeneratedColumn<double>(
    'harga_jual_baru',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tokoId,
    produkId,
    hargaBeliLama,
    hargaBeliBaru,
    hargaJualLama,
    hargaJualBaru,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'riwayat_harga_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RiwayatHargaTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('toko_id')) {
      context.handle(
        _tokoIdMeta,
        tokoId.isAcceptableOrUnknown(data['toko_id']!, _tokoIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tokoIdMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('harga_beli_lama')) {
      context.handle(
        _hargaBeliLamaMeta,
        hargaBeliLama.isAcceptableOrUnknown(
          data['harga_beli_lama']!,
          _hargaBeliLamaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaBeliLamaMeta);
    }
    if (data.containsKey('harga_beli_baru')) {
      context.handle(
        _hargaBeliBaruMeta,
        hargaBeliBaru.isAcceptableOrUnknown(
          data['harga_beli_baru']!,
          _hargaBeliBaruMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaBeliBaruMeta);
    }
    if (data.containsKey('harga_jual_lama')) {
      context.handle(
        _hargaJualLamaMeta,
        hargaJualLama.isAcceptableOrUnknown(
          data['harga_jual_lama']!,
          _hargaJualLamaMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaJualLamaMeta);
    }
    if (data.containsKey('harga_jual_baru')) {
      context.handle(
        _hargaJualBaruMeta,
        hargaJualBaru.isAcceptableOrUnknown(
          data['harga_jual_baru']!,
          _hargaJualBaruMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hargaJualBaruMeta);
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
  RiwayatHargaTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RiwayatHargaTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tokoId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}toko_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      hargaBeliLama: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_beli_lama'],
      )!,
      hargaBeliBaru: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_beli_baru'],
      )!,
      hargaJualLama: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_jual_lama'],
      )!,
      hargaJualBaru: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_jual_baru'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RiwayatHargaTableTable createAlias(String alias) {
    return $RiwayatHargaTableTable(attachedDatabase, alias);
  }
}

class RiwayatHargaTableData extends DataClass
    implements Insertable<RiwayatHargaTableData> {
  final String id;
  final String tokoId;
  final String produkId;
  final double hargaBeliLama;
  final double hargaBeliBaru;
  final double hargaJualLama;
  final double hargaJualBaru;
  final DateTime createdAt;
  const RiwayatHargaTableData({
    required this.id,
    required this.tokoId,
    required this.produkId,
    required this.hargaBeliLama,
    required this.hargaBeliBaru,
    required this.hargaJualLama,
    required this.hargaJualBaru,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['toko_id'] = Variable<String>(tokoId);
    map['produk_id'] = Variable<String>(produkId);
    map['harga_beli_lama'] = Variable<double>(hargaBeliLama);
    map['harga_beli_baru'] = Variable<double>(hargaBeliBaru);
    map['harga_jual_lama'] = Variable<double>(hargaJualLama);
    map['harga_jual_baru'] = Variable<double>(hargaJualBaru);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RiwayatHargaTableCompanion toCompanion(bool nullToAbsent) {
    return RiwayatHargaTableCompanion(
      id: Value(id),
      tokoId: Value(tokoId),
      produkId: Value(produkId),
      hargaBeliLama: Value(hargaBeliLama),
      hargaBeliBaru: Value(hargaBeliBaru),
      hargaJualLama: Value(hargaJualLama),
      hargaJualBaru: Value(hargaJualBaru),
      createdAt: Value(createdAt),
    );
  }

  factory RiwayatHargaTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RiwayatHargaTableData(
      id: serializer.fromJson<String>(json['id']),
      tokoId: serializer.fromJson<String>(json['tokoId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      hargaBeliLama: serializer.fromJson<double>(json['hargaBeliLama']),
      hargaBeliBaru: serializer.fromJson<double>(json['hargaBeliBaru']),
      hargaJualLama: serializer.fromJson<double>(json['hargaJualLama']),
      hargaJualBaru: serializer.fromJson<double>(json['hargaJualBaru']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tokoId': serializer.toJson<String>(tokoId),
      'produkId': serializer.toJson<String>(produkId),
      'hargaBeliLama': serializer.toJson<double>(hargaBeliLama),
      'hargaBeliBaru': serializer.toJson<double>(hargaBeliBaru),
      'hargaJualLama': serializer.toJson<double>(hargaJualLama),
      'hargaJualBaru': serializer.toJson<double>(hargaJualBaru),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RiwayatHargaTableData copyWith({
    String? id,
    String? tokoId,
    String? produkId,
    double? hargaBeliLama,
    double? hargaBeliBaru,
    double? hargaJualLama,
    double? hargaJualBaru,
    DateTime? createdAt,
  }) => RiwayatHargaTableData(
    id: id ?? this.id,
    tokoId: tokoId ?? this.tokoId,
    produkId: produkId ?? this.produkId,
    hargaBeliLama: hargaBeliLama ?? this.hargaBeliLama,
    hargaBeliBaru: hargaBeliBaru ?? this.hargaBeliBaru,
    hargaJualLama: hargaJualLama ?? this.hargaJualLama,
    hargaJualBaru: hargaJualBaru ?? this.hargaJualBaru,
    createdAt: createdAt ?? this.createdAt,
  );
  RiwayatHargaTableData copyWithCompanion(RiwayatHargaTableCompanion data) {
    return RiwayatHargaTableData(
      id: data.id.present ? data.id.value : this.id,
      tokoId: data.tokoId.present ? data.tokoId.value : this.tokoId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      hargaBeliLama: data.hargaBeliLama.present
          ? data.hargaBeliLama.value
          : this.hargaBeliLama,
      hargaBeliBaru: data.hargaBeliBaru.present
          ? data.hargaBeliBaru.value
          : this.hargaBeliBaru,
      hargaJualLama: data.hargaJualLama.present
          ? data.hargaJualLama.value
          : this.hargaJualLama,
      hargaJualBaru: data.hargaJualBaru.present
          ? data.hargaJualBaru.value
          : this.hargaJualBaru,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RiwayatHargaTableData(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('produkId: $produkId, ')
          ..write('hargaBeliLama: $hargaBeliLama, ')
          ..write('hargaBeliBaru: $hargaBeliBaru, ')
          ..write('hargaJualLama: $hargaJualLama, ')
          ..write('hargaJualBaru: $hargaJualBaru, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    tokoId,
    produkId,
    hargaBeliLama,
    hargaBeliBaru,
    hargaJualLama,
    hargaJualBaru,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiwayatHargaTableData &&
          other.id == this.id &&
          other.tokoId == this.tokoId &&
          other.produkId == this.produkId &&
          other.hargaBeliLama == this.hargaBeliLama &&
          other.hargaBeliBaru == this.hargaBeliBaru &&
          other.hargaJualLama == this.hargaJualLama &&
          other.hargaJualBaru == this.hargaJualBaru &&
          other.createdAt == this.createdAt);
}

class RiwayatHargaTableCompanion
    extends UpdateCompanion<RiwayatHargaTableData> {
  final Value<String> id;
  final Value<String> tokoId;
  final Value<String> produkId;
  final Value<double> hargaBeliLama;
  final Value<double> hargaBeliBaru;
  final Value<double> hargaJualLama;
  final Value<double> hargaJualBaru;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RiwayatHargaTableCompanion({
    this.id = const Value.absent(),
    this.tokoId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.hargaBeliLama = const Value.absent(),
    this.hargaBeliBaru = const Value.absent(),
    this.hargaJualLama = const Value.absent(),
    this.hargaJualBaru = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RiwayatHargaTableCompanion.insert({
    required String id,
    required String tokoId,
    required String produkId,
    required double hargaBeliLama,
    required double hargaBeliBaru,
    required double hargaJualLama,
    required double hargaJualBaru,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tokoId = Value(tokoId),
       produkId = Value(produkId),
       hargaBeliLama = Value(hargaBeliLama),
       hargaBeliBaru = Value(hargaBeliBaru),
       hargaJualLama = Value(hargaJualLama),
       hargaJualBaru = Value(hargaJualBaru);
  static Insertable<RiwayatHargaTableData> custom({
    Expression<String>? id,
    Expression<String>? tokoId,
    Expression<String>? produkId,
    Expression<double>? hargaBeliLama,
    Expression<double>? hargaBeliBaru,
    Expression<double>? hargaJualLama,
    Expression<double>? hargaJualBaru,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tokoId != null) 'toko_id': tokoId,
      if (produkId != null) 'produk_id': produkId,
      if (hargaBeliLama != null) 'harga_beli_lama': hargaBeliLama,
      if (hargaBeliBaru != null) 'harga_beli_baru': hargaBeliBaru,
      if (hargaJualLama != null) 'harga_jual_lama': hargaJualLama,
      if (hargaJualBaru != null) 'harga_jual_baru': hargaJualBaru,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RiwayatHargaTableCompanion copyWith({
    Value<String>? id,
    Value<String>? tokoId,
    Value<String>? produkId,
    Value<double>? hargaBeliLama,
    Value<double>? hargaBeliBaru,
    Value<double>? hargaJualLama,
    Value<double>? hargaJualBaru,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RiwayatHargaTableCompanion(
      id: id ?? this.id,
      tokoId: tokoId ?? this.tokoId,
      produkId: produkId ?? this.produkId,
      hargaBeliLama: hargaBeliLama ?? this.hargaBeliLama,
      hargaBeliBaru: hargaBeliBaru ?? this.hargaBeliBaru,
      hargaJualLama: hargaJualLama ?? this.hargaJualLama,
      hargaJualBaru: hargaJualBaru ?? this.hargaJualBaru,
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
    if (tokoId.present) {
      map['toko_id'] = Variable<String>(tokoId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (hargaBeliLama.present) {
      map['harga_beli_lama'] = Variable<double>(hargaBeliLama.value);
    }
    if (hargaBeliBaru.present) {
      map['harga_beli_baru'] = Variable<double>(hargaBeliBaru.value);
    }
    if (hargaJualLama.present) {
      map['harga_jual_lama'] = Variable<double>(hargaJualLama.value);
    }
    if (hargaJualBaru.present) {
      map['harga_jual_baru'] = Variable<double>(hargaJualBaru.value);
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
    return (StringBuffer('RiwayatHargaTableCompanion(')
          ..write('id: $id, ')
          ..write('tokoId: $tokoId, ')
          ..write('produkId: $produkId, ')
          ..write('hargaBeliLama: $hargaBeliLama, ')
          ..write('hargaBeliBaru: $hargaBeliBaru, ')
          ..write('hargaJualLama: $hargaJualLama, ')
          ..write('hargaJualBaru: $hargaJualBaru, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TokoTableTable tokoTable = $TokoTableTable(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $ProdukTableTable produkTable = $ProdukTableTable(this);
  late final $SatuanProdukTableTable satuanProdukTable =
      $SatuanProdukTableTable(this);
  late final $SupplierTableTable supplierTable = $SupplierTableTable(this);
  late final $SupplierProductsTableTable supplierProductsTable =
      $SupplierProductsTableTable(this);
  late final $TransaksiTableTable transaksiTable = $TransaksiTableTable(this);
  late final $ItemTransaksiTableTable itemTransaksiTable =
      $ItemTransaksiTableTable(this);
  late final $HutangPiutangTableTable hutangPiutangTable =
      $HutangPiutangTableTable(this);
  late final $RiwayatStokTableTable riwayatStokTable = $RiwayatStokTableTable(
    this,
  );
  late final $PembelianTableTable pembelianTable = $PembelianTableTable(this);
  late final $ItemPembelianTableTable itemPembelianTable =
      $ItemPembelianTableTable(this);
  late final $PendingOrderTableTable pendingOrderTable =
      $PendingOrderTableTable(this);
  late final $PendingOrderItemTableTable pendingOrderItemTable =
      $PendingOrderItemTableTable(this);
  late final $PendingPembelianTableTable pendingPembelianTable =
      $PendingPembelianTableTable(this);
  late final $PendingPembelianItemTableTable pendingPembelianItemTable =
      $PendingPembelianItemTableTable(this);
  late final $NotifikasiTableTable notifikasiTable = $NotifikasiTableTable(
    this,
  );
  late final $PendingSyncQueueTableTable pendingSyncQueueTable =
      $PendingSyncQueueTableTable(this);
  late final $RiwayatHargaTableTable riwayatHargaTable =
      $RiwayatHargaTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    tokoTable,
    userTable,
    produkTable,
    satuanProdukTable,
    supplierTable,
    supplierProductsTable,
    transaksiTable,
    itemTransaksiTable,
    hutangPiutangTable,
    riwayatStokTable,
    pembelianTable,
    itemPembelianTable,
    pendingOrderTable,
    pendingOrderItemTable,
    pendingPembelianTable,
    pendingPembelianItemTable,
    notifikasiTable,
    pendingSyncQueueTable,
    riwayatHargaTable,
  ];
}

typedef $$TokoTableTableCreateCompanionBuilder =
    TokoTableCompanion Function({
      required String id,
      required String nama,
      Value<String?> alamat,
      Value<String?> telepon,
      Value<String?> ownerId,
      Value<int> stokMinimumGlobal,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TokoTableTableUpdateCompanionBuilder =
    TokoTableCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<String?> alamat,
      Value<String?> telepon,
      Value<String?> ownerId,
      Value<int> stokMinimumGlobal,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TokoTableTableFilterComposer
    extends Composer<_$AppDatabase, $TokoTableTable> {
  $$TokoTableTableFilterComposer({
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

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telepon => $composableBuilder(
    column: $table.telepon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stokMinimumGlobal => $composableBuilder(
    column: $table.stokMinimumGlobal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TokoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TokoTableTable> {
  $$TokoTableTableOrderingComposer({
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

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telepon => $composableBuilder(
    column: $table.telepon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stokMinimumGlobal => $composableBuilder(
    column: $table.stokMinimumGlobal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TokoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TokoTableTable> {
  $$TokoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<String> get telepon =>
      $composableBuilder(column: $table.telepon, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<int> get stokMinimumGlobal => $composableBuilder(
    column: $table.stokMinimumGlobal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TokoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TokoTableTable,
          TokoTableData,
          $$TokoTableTableFilterComposer,
          $$TokoTableTableOrderingComposer,
          $$TokoTableTableAnnotationComposer,
          $$TokoTableTableCreateCompanionBuilder,
          $$TokoTableTableUpdateCompanionBuilder,
          (
            TokoTableData,
            BaseReferences<_$AppDatabase, $TokoTableTable, TokoTableData>,
          ),
          TokoTableData,
          PrefetchHooks Function()
        > {
  $$TokoTableTableTableManager(_$AppDatabase db, $TokoTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TokoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TokoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TokoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<String?> telepon = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<int> stokMinimumGlobal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TokoTableCompanion(
                id: id,
                nama: nama,
                alamat: alamat,
                telepon: telepon,
                ownerId: ownerId,
                stokMinimumGlobal: stokMinimumGlobal,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                Value<String?> alamat = const Value.absent(),
                Value<String?> telepon = const Value.absent(),
                Value<String?> ownerId = const Value.absent(),
                Value<int> stokMinimumGlobal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TokoTableCompanion.insert(
                id: id,
                nama: nama,
                alamat: alamat,
                telepon: telepon,
                ownerId: ownerId,
                stokMinimumGlobal: stokMinimumGlobal,
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

typedef $$TokoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TokoTableTable,
      TokoTableData,
      $$TokoTableTableFilterComposer,
      $$TokoTableTableOrderingComposer,
      $$TokoTableTableAnnotationComposer,
      $$TokoTableTableCreateCompanionBuilder,
      $$TokoTableTableUpdateCompanionBuilder,
      (
        TokoTableData,
        BaseReferences<_$AppDatabase, $TokoTableTable, TokoTableData>,
      ),
      TokoTableData,
      PrefetchHooks Function()
    >;
typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      required String id,
      required String tokoId,
      Value<String?> nama,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String?> nama,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$UserTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserTableTable> {
  $$UserTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserTableTable,
          UserTableData,
          $$UserTableTableFilterComposer,
          $$UserTableTableOrderingComposer,
          $$UserTableTableAnnotationComposer,
          $$UserTableTableCreateCompanionBuilder,
          $$UserTableTableUpdateCompanionBuilder,
          (
            UserTableData,
            BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>,
          ),
          UserTableData,
          PrefetchHooks Function()
        > {
  $$UserTableTableTableManager(_$AppDatabase db, $UserTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String?> nama = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                tokoId: tokoId,
                nama: nama,
                role: role,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                Value<String?> nama = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                nama: nama,
                role: role,
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

typedef $$UserTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserTableTable,
      UserTableData,
      $$UserTableTableFilterComposer,
      $$UserTableTableOrderingComposer,
      $$UserTableTableAnnotationComposer,
      $$UserTableTableCreateCompanionBuilder,
      $$UserTableTableUpdateCompanionBuilder,
      (
        UserTableData,
        BaseReferences<_$AppDatabase, $UserTableTable, UserTableData>,
      ),
      UserTableData,
      PrefetchHooks Function()
    >;
typedef $$ProdukTableTableCreateCompanionBuilder =
    ProdukTableCompanion Function({
      required String id,
      required String tokoId,
      required String nama,
      Value<String?> barcode,
      Value<double> hargaBeli,
      Value<double> hargaJual,
      Value<int> stok,
      Value<String?> kategori,
      Value<String> satuan,
      Value<int?> stokMinimum,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ProdukTableTableUpdateCompanionBuilder =
    ProdukTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> nama,
      Value<String?> barcode,
      Value<double> hargaBeli,
      Value<double> hargaJual,
      Value<int> stok,
      Value<String?> kategori,
      Value<String> satuan,
      Value<int?> stokMinimum,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ProdukTableTableFilterComposer
    extends Composer<_$AppDatabase, $ProdukTableTable> {
  $$ProdukTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaBeli => $composableBuilder(
    column: $table.hargaBeli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stok => $composableBuilder(
    column: $table.stok,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get satuan => $composableBuilder(
    column: $table.satuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stokMinimum => $composableBuilder(
    column: $table.stokMinimum,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProdukTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ProdukTableTable> {
  $$ProdukTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaBeli => $composableBuilder(
    column: $table.hargaBeli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stok => $composableBuilder(
    column: $table.stok,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get satuan => $composableBuilder(
    column: $table.satuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stokMinimum => $composableBuilder(
    column: $table.stokMinimum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProdukTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProdukTableTable> {
  $$ProdukTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<double> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<double> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get stok =>
      $composableBuilder(column: $table.stok, builder: (column) => column);

  GeneratedColumn<String> get kategori =>
      $composableBuilder(column: $table.kategori, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<int> get stokMinimum => $composableBuilder(
    column: $table.stokMinimum,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProdukTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProdukTableTable,
          ProdukTableData,
          $$ProdukTableTableFilterComposer,
          $$ProdukTableTableOrderingComposer,
          $$ProdukTableTableAnnotationComposer,
          $$ProdukTableTableCreateCompanionBuilder,
          $$ProdukTableTableUpdateCompanionBuilder,
          (
            ProdukTableData,
            BaseReferences<_$AppDatabase, $ProdukTableTable, ProdukTableData>,
          ),
          ProdukTableData,
          PrefetchHooks Function()
        > {
  $$ProdukTableTableTableManager(_$AppDatabase db, $ProdukTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProdukTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProdukTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProdukTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<double> hargaBeli = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<int> stok = const Value.absent(),
                Value<String?> kategori = const Value.absent(),
                Value<String> satuan = const Value.absent(),
                Value<int?> stokMinimum = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdukTableCompanion(
                id: id,
                tokoId: tokoId,
                nama: nama,
                barcode: barcode,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                stok: stok,
                kategori: kategori,
                satuan: satuan,
                stokMinimum: stokMinimum,
                updatedAt: updatedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String nama,
                Value<String?> barcode = const Value.absent(),
                Value<double> hargaBeli = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<int> stok = const Value.absent(),
                Value<String?> kategori = const Value.absent(),
                Value<String> satuan = const Value.absent(),
                Value<int?> stokMinimum = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdukTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                nama: nama,
                barcode: barcode,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                stok: stok,
                kategori: kategori,
                satuan: satuan,
                stokMinimum: stokMinimum,
                updatedAt: updatedAt,
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

typedef $$ProdukTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProdukTableTable,
      ProdukTableData,
      $$ProdukTableTableFilterComposer,
      $$ProdukTableTableOrderingComposer,
      $$ProdukTableTableAnnotationComposer,
      $$ProdukTableTableCreateCompanionBuilder,
      $$ProdukTableTableUpdateCompanionBuilder,
      (
        ProdukTableData,
        BaseReferences<_$AppDatabase, $ProdukTableTable, ProdukTableData>,
      ),
      ProdukTableData,
      PrefetchHooks Function()
    >;
typedef $$SatuanProdukTableTableCreateCompanionBuilder =
    SatuanProdukTableCompanion Function({
      required String id,
      required String tokoId,
      required String produkId,
      required String nama,
      Value<double> konversi,
      Value<double> hargaBeli,
      Value<double> hargaJual,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SatuanProdukTableTableUpdateCompanionBuilder =
    SatuanProdukTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> produkId,
      Value<String> nama,
      Value<double> konversi,
      Value<double> hargaBeli,
      Value<double> hargaJual,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SatuanProdukTableTableFilterComposer
    extends Composer<_$AppDatabase, $SatuanProdukTableTable> {
  $$SatuanProdukTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaBeli => $composableBuilder(
    column: $table.hargaBeli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SatuanProdukTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SatuanProdukTableTable> {
  $$SatuanProdukTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaBeli => $composableBuilder(
    column: $table.hargaBeli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SatuanProdukTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SatuanProdukTableTable> {
  $$SatuanProdukTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<double> get konversi =>
      $composableBuilder(column: $table.konversi, builder: (column) => column);

  GeneratedColumn<double> get hargaBeli =>
      $composableBuilder(column: $table.hargaBeli, builder: (column) => column);

  GeneratedColumn<double> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SatuanProdukTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SatuanProdukTableTable,
          SatuanProdukTableData,
          $$SatuanProdukTableTableFilterComposer,
          $$SatuanProdukTableTableOrderingComposer,
          $$SatuanProdukTableTableAnnotationComposer,
          $$SatuanProdukTableTableCreateCompanionBuilder,
          $$SatuanProdukTableTableUpdateCompanionBuilder,
          (
            SatuanProdukTableData,
            BaseReferences<
              _$AppDatabase,
              $SatuanProdukTableTable,
              SatuanProdukTableData
            >,
          ),
          SatuanProdukTableData,
          PrefetchHooks Function()
        > {
  $$SatuanProdukTableTableTableManager(
    _$AppDatabase db,
    $SatuanProdukTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SatuanProdukTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SatuanProdukTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SatuanProdukTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<double> hargaBeli = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SatuanProdukTableCompanion(
                id: id,
                tokoId: tokoId,
                produkId: produkId,
                nama: nama,
                konversi: konversi,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String produkId,
                required String nama,
                Value<double> konversi = const Value.absent(),
                Value<double> hargaBeli = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SatuanProdukTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                produkId: produkId,
                nama: nama,
                konversi: konversi,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SatuanProdukTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SatuanProdukTableTable,
      SatuanProdukTableData,
      $$SatuanProdukTableTableFilterComposer,
      $$SatuanProdukTableTableOrderingComposer,
      $$SatuanProdukTableTableAnnotationComposer,
      $$SatuanProdukTableTableCreateCompanionBuilder,
      $$SatuanProdukTableTableUpdateCompanionBuilder,
      (
        SatuanProdukTableData,
        BaseReferences<
          _$AppDatabase,
          $SatuanProdukTableTable,
          SatuanProdukTableData
        >,
      ),
      SatuanProdukTableData,
      PrefetchHooks Function()
    >;
typedef $$SupplierTableTableCreateCompanionBuilder =
    SupplierTableCompanion Function({
      required String id,
      required String tokoId,
      required String nama,
      Value<String?> telepon,
      Value<String?> alamat,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$SupplierTableTableUpdateCompanionBuilder =
    SupplierTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> nama,
      Value<String?> telepon,
      Value<String?> alamat,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SupplierTableTableFilterComposer
    extends Composer<_$AppDatabase, $SupplierTableTable> {
  $$SupplierTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telepon => $composableBuilder(
    column: $table.telepon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplierTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplierTableTable> {
  $$SupplierTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nama => $composableBuilder(
    column: $table.nama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telepon => $composableBuilder(
    column: $table.telepon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplierTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplierTableTable> {
  $$SupplierTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get nama =>
      $composableBuilder(column: $table.nama, builder: (column) => column);

  GeneratedColumn<String> get telepon =>
      $composableBuilder(column: $table.telepon, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SupplierTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplierTableTable,
          SupplierTableData,
          $$SupplierTableTableFilterComposer,
          $$SupplierTableTableOrderingComposer,
          $$SupplierTableTableAnnotationComposer,
          $$SupplierTableTableCreateCompanionBuilder,
          $$SupplierTableTableUpdateCompanionBuilder,
          (
            SupplierTableData,
            BaseReferences<
              _$AppDatabase,
              $SupplierTableTable,
              SupplierTableData
            >,
          ),
          SupplierTableData,
          PrefetchHooks Function()
        > {
  $$SupplierTableTableTableManager(_$AppDatabase db, $SupplierTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupplierTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupplierTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String?> telepon = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplierTableCompanion(
                id: id,
                tokoId: tokoId,
                nama: nama,
                telepon: telepon,
                alamat: alamat,
                updatedAt: updatedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String nama,
                Value<String?> telepon = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplierTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                nama: nama,
                telepon: telepon,
                alamat: alamat,
                updatedAt: updatedAt,
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

typedef $$SupplierTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplierTableTable,
      SupplierTableData,
      $$SupplierTableTableFilterComposer,
      $$SupplierTableTableOrderingComposer,
      $$SupplierTableTableAnnotationComposer,
      $$SupplierTableTableCreateCompanionBuilder,
      $$SupplierTableTableUpdateCompanionBuilder,
      (
        SupplierTableData,
        BaseReferences<_$AppDatabase, $SupplierTableTable, SupplierTableData>,
      ),
      SupplierTableData,
      PrefetchHooks Function()
    >;
typedef $$SupplierProductsTableTableCreateCompanionBuilder =
    SupplierProductsTableCompanion Function({
      required String id,
      required String tokoId,
      required String supplierId,
      required String produkId,
      Value<double> harga,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SupplierProductsTableTableUpdateCompanionBuilder =
    SupplierProductsTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> supplierId,
      Value<String> produkId,
      Value<double> harga,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$SupplierProductsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SupplierProductsTableTable> {
  $$SupplierProductsTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get harga => $composableBuilder(
    column: $table.harga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SupplierProductsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SupplierProductsTableTable> {
  $$SupplierProductsTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get harga => $composableBuilder(
    column: $table.harga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SupplierProductsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupplierProductsTableTable> {
  $$SupplierProductsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<double> get harga =>
      $composableBuilder(column: $table.harga, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SupplierProductsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupplierProductsTableTable,
          SupplierProductsTableData,
          $$SupplierProductsTableTableFilterComposer,
          $$SupplierProductsTableTableOrderingComposer,
          $$SupplierProductsTableTableAnnotationComposer,
          $$SupplierProductsTableTableCreateCompanionBuilder,
          $$SupplierProductsTableTableUpdateCompanionBuilder,
          (
            SupplierProductsTableData,
            BaseReferences<
              _$AppDatabase,
              $SupplierProductsTableTable,
              SupplierProductsTableData
            >,
          ),
          SupplierProductsTableData,
          PrefetchHooks Function()
        > {
  $$SupplierProductsTableTableTableManager(
    _$AppDatabase db,
    $SupplierProductsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupplierProductsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$SupplierProductsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SupplierProductsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> supplierId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<double> harga = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplierProductsTableCompanion(
                id: id,
                tokoId: tokoId,
                supplierId: supplierId,
                produkId: produkId,
                harga: harga,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String supplierId,
                required String produkId,
                Value<double> harga = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplierProductsTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                supplierId: supplierId,
                produkId: produkId,
                harga: harga,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SupplierProductsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupplierProductsTableTable,
      SupplierProductsTableData,
      $$SupplierProductsTableTableFilterComposer,
      $$SupplierProductsTableTableOrderingComposer,
      $$SupplierProductsTableTableAnnotationComposer,
      $$SupplierProductsTableTableCreateCompanionBuilder,
      $$SupplierProductsTableTableUpdateCompanionBuilder,
      (
        SupplierProductsTableData,
        BaseReferences<
          _$AppDatabase,
          $SupplierProductsTableTable,
          SupplierProductsTableData
        >,
      ),
      SupplierProductsTableData,
      PrefetchHooks Function()
    >;
typedef $$TransaksiTableTableCreateCompanionBuilder =
    TransaksiTableCompanion Function({
      required String id,
      required String tokoId,
      Value<String?> kasirId,
      Value<double> totalHarga,
      Value<double> jumlahBayar,
      Value<double> kembalian,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$TransaksiTableTableUpdateCompanionBuilder =
    TransaksiTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String?> kasirId,
      Value<double> totalHarga,
      Value<double> jumlahBayar,
      Value<double> kembalian,
      Value<String> status,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$TransaksiTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransaksiTableTable> {
  $$TransaksiTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kasirId => $composableBuilder(
    column: $table.kasirId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jumlahBayar => $composableBuilder(
    column: $table.jumlahBayar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get kembalian => $composableBuilder(
    column: $table.kembalian,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransaksiTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransaksiTableTable> {
  $$TransaksiTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kasirId => $composableBuilder(
    column: $table.kasirId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jumlahBayar => $composableBuilder(
    column: $table.jumlahBayar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get kembalian => $composableBuilder(
    column: $table.kembalian,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransaksiTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransaksiTableTable> {
  $$TransaksiTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get kasirId =>
      $composableBuilder(column: $table.kasirId, builder: (column) => column);

  GeneratedColumn<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => column,
  );

  GeneratedColumn<double> get jumlahBayar => $composableBuilder(
    column: $table.jumlahBayar,
    builder: (column) => column,
  );

  GeneratedColumn<double> get kembalian =>
      $composableBuilder(column: $table.kembalian, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$TransaksiTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransaksiTableTable,
          TransaksiTableData,
          $$TransaksiTableTableFilterComposer,
          $$TransaksiTableTableOrderingComposer,
          $$TransaksiTableTableAnnotationComposer,
          $$TransaksiTableTableCreateCompanionBuilder,
          $$TransaksiTableTableUpdateCompanionBuilder,
          (
            TransaksiTableData,
            BaseReferences<
              _$AppDatabase,
              $TransaksiTableTable,
              TransaksiTableData
            >,
          ),
          TransaksiTableData,
          PrefetchHooks Function()
        > {
  $$TransaksiTableTableTableManager(
    _$AppDatabase db,
    $TransaksiTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransaksiTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransaksiTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransaksiTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String?> kasirId = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<double> jumlahBayar = const Value.absent(),
                Value<double> kembalian = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransaksiTableCompanion(
                id: id,
                tokoId: tokoId,
                kasirId: kasirId,
                totalHarga: totalHarga,
                jumlahBayar: jumlahBayar,
                kembalian: kembalian,
                status: status,
                updatedAt: updatedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                Value<String?> kasirId = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<double> jumlahBayar = const Value.absent(),
                Value<double> kembalian = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransaksiTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                kasirId: kasirId,
                totalHarga: totalHarga,
                jumlahBayar: jumlahBayar,
                kembalian: kembalian,
                status: status,
                updatedAt: updatedAt,
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

typedef $$TransaksiTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransaksiTableTable,
      TransaksiTableData,
      $$TransaksiTableTableFilterComposer,
      $$TransaksiTableTableOrderingComposer,
      $$TransaksiTableTableAnnotationComposer,
      $$TransaksiTableTableCreateCompanionBuilder,
      $$TransaksiTableTableUpdateCompanionBuilder,
      (
        TransaksiTableData,
        BaseReferences<_$AppDatabase, $TransaksiTableTable, TransaksiTableData>,
      ),
      TransaksiTableData,
      PrefetchHooks Function()
    >;
typedef $$ItemTransaksiTableTableCreateCompanionBuilder =
    ItemTransaksiTableCompanion Function({
      required String id,
      required String tokoId,
      required String transaksiId,
      required String produkId,
      Value<int> jumlah,
      Value<double> hargaSatuan,
      Value<double> subtotal,
      Value<int> rowid,
    });
typedef $$ItemTransaksiTableTableUpdateCompanionBuilder =
    ItemTransaksiTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> transaksiId,
      Value<String> produkId,
      Value<int> jumlah,
      Value<double> hargaSatuan,
      Value<double> subtotal,
      Value<int> rowid,
    });

class $$ItemTransaksiTableTableFilterComposer
    extends Composer<_$AppDatabase, $ItemTransaksiTableTable> {
  $$ItemTransaksiTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ItemTransaksiTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemTransaksiTableTable> {
  $$ItemTransaksiTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemTransaksiTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemTransaksiTableTable> {
  $$ItemTransaksiTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<int> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<double> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);
}

class $$ItemTransaksiTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemTransaksiTableTable,
          ItemTransaksiTableData,
          $$ItemTransaksiTableTableFilterComposer,
          $$ItemTransaksiTableTableOrderingComposer,
          $$ItemTransaksiTableTableAnnotationComposer,
          $$ItemTransaksiTableTableCreateCompanionBuilder,
          $$ItemTransaksiTableTableUpdateCompanionBuilder,
          (
            ItemTransaksiTableData,
            BaseReferences<
              _$AppDatabase,
              $ItemTransaksiTableTable,
              ItemTransaksiTableData
            >,
          ),
          ItemTransaksiTableData,
          PrefetchHooks Function()
        > {
  $$ItemTransaksiTableTableTableManager(
    _$AppDatabase db,
    $ItemTransaksiTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemTransaksiTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemTransaksiTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemTransaksiTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> transaksiId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemTransaksiTableCompanion(
                id: id,
                tokoId: tokoId,
                transaksiId: transaksiId,
                produkId: produkId,
                jumlah: jumlah,
                hargaSatuan: hargaSatuan,
                subtotal: subtotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String transaksiId,
                required String produkId,
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemTransaksiTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                transaksiId: transaksiId,
                produkId: produkId,
                jumlah: jumlah,
                hargaSatuan: hargaSatuan,
                subtotal: subtotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ItemTransaksiTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemTransaksiTableTable,
      ItemTransaksiTableData,
      $$ItemTransaksiTableTableFilterComposer,
      $$ItemTransaksiTableTableOrderingComposer,
      $$ItemTransaksiTableTableAnnotationComposer,
      $$ItemTransaksiTableTableCreateCompanionBuilder,
      $$ItemTransaksiTableTableUpdateCompanionBuilder,
      (
        ItemTransaksiTableData,
        BaseReferences<
          _$AppDatabase,
          $ItemTransaksiTableTable,
          ItemTransaksiTableData
        >,
      ),
      ItemTransaksiTableData,
      PrefetchHooks Function()
    >;
typedef $$HutangPiutangTableTableCreateCompanionBuilder =
    HutangPiutangTableCompanion Function({
      required String id,
      required String tokoId,
      Value<String?> transaksiId,
      required String namaPelanggan,
      Value<double> jumlah,
      Value<String> status,
      Value<DateTime?> tanggalJatuhTempo,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$HutangPiutangTableTableUpdateCompanionBuilder =
    HutangPiutangTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String?> transaksiId,
      Value<String> namaPelanggan,
      Value<double> jumlah,
      Value<String> status,
      Value<DateTime?> tanggalJatuhTempo,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$HutangPiutangTableTableFilterComposer
    extends Composer<_$AppDatabase, $HutangPiutangTableTable> {
  $$HutangPiutangTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaPelanggan => $composableBuilder(
    column: $table.namaPelanggan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggalJatuhTempo => $composableBuilder(
    column: $table.tanggalJatuhTempo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HutangPiutangTableTableOrderingComposer
    extends Composer<_$AppDatabase, $HutangPiutangTableTable> {
  $$HutangPiutangTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaPelanggan => $composableBuilder(
    column: $table.namaPelanggan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggalJatuhTempo => $composableBuilder(
    column: $table.tanggalJatuhTempo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HutangPiutangTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $HutangPiutangTableTable> {
  $$HutangPiutangTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get namaPelanggan => $composableBuilder(
    column: $table.namaPelanggan,
    builder: (column) => column,
  );

  GeneratedColumn<double> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get tanggalJatuhTempo => $composableBuilder(
    column: $table.tanggalJatuhTempo,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$HutangPiutangTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HutangPiutangTableTable,
          HutangPiutangTableData,
          $$HutangPiutangTableTableFilterComposer,
          $$HutangPiutangTableTableOrderingComposer,
          $$HutangPiutangTableTableAnnotationComposer,
          $$HutangPiutangTableTableCreateCompanionBuilder,
          $$HutangPiutangTableTableUpdateCompanionBuilder,
          (
            HutangPiutangTableData,
            BaseReferences<
              _$AppDatabase,
              $HutangPiutangTableTable,
              HutangPiutangTableData
            >,
          ),
          HutangPiutangTableData,
          PrefetchHooks Function()
        > {
  $$HutangPiutangTableTableTableManager(
    _$AppDatabase db,
    $HutangPiutangTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HutangPiutangTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HutangPiutangTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HutangPiutangTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String?> transaksiId = const Value.absent(),
                Value<String> namaPelanggan = const Value.absent(),
                Value<double> jumlah = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> tanggalJatuhTempo = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HutangPiutangTableCompanion(
                id: id,
                tokoId: tokoId,
                transaksiId: transaksiId,
                namaPelanggan: namaPelanggan,
                jumlah: jumlah,
                status: status,
                tanggalJatuhTempo: tanggalJatuhTempo,
                updatedAt: updatedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                Value<String?> transaksiId = const Value.absent(),
                required String namaPelanggan,
                Value<double> jumlah = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> tanggalJatuhTempo = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HutangPiutangTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                transaksiId: transaksiId,
                namaPelanggan: namaPelanggan,
                jumlah: jumlah,
                status: status,
                tanggalJatuhTempo: tanggalJatuhTempo,
                updatedAt: updatedAt,
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

typedef $$HutangPiutangTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HutangPiutangTableTable,
      HutangPiutangTableData,
      $$HutangPiutangTableTableFilterComposer,
      $$HutangPiutangTableTableOrderingComposer,
      $$HutangPiutangTableTableAnnotationComposer,
      $$HutangPiutangTableTableCreateCompanionBuilder,
      $$HutangPiutangTableTableUpdateCompanionBuilder,
      (
        HutangPiutangTableData,
        BaseReferences<
          _$AppDatabase,
          $HutangPiutangTableTable,
          HutangPiutangTableData
        >,
      ),
      HutangPiutangTableData,
      PrefetchHooks Function()
    >;
typedef $$RiwayatStokTableTableCreateCompanionBuilder =
    RiwayatStokTableCompanion Function({
      required String id,
      required String tokoId,
      required String produkId,
      required String tipe,
      Value<int> jumlah,
      Value<String?> keterangan,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$RiwayatStokTableTableUpdateCompanionBuilder =
    RiwayatStokTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> produkId,
      Value<String> tipe,
      Value<int> jumlah,
      Value<String?> keterangan,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RiwayatStokTableTableFilterComposer
    extends Composer<_$AppDatabase, $RiwayatStokTableTable> {
  $$RiwayatStokTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipe => $composableBuilder(
    column: $table.tipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RiwayatStokTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RiwayatStokTableTable> {
  $$RiwayatStokTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipe => $composableBuilder(
    column: $table.tipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RiwayatStokTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RiwayatStokTableTable> {
  $$RiwayatStokTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<String> get tipe =>
      $composableBuilder(column: $table.tipe, builder: (column) => column);

  GeneratedColumn<int> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RiwayatStokTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RiwayatStokTableTable,
          RiwayatStokTableData,
          $$RiwayatStokTableTableFilterComposer,
          $$RiwayatStokTableTableOrderingComposer,
          $$RiwayatStokTableTableAnnotationComposer,
          $$RiwayatStokTableTableCreateCompanionBuilder,
          $$RiwayatStokTableTableUpdateCompanionBuilder,
          (
            RiwayatStokTableData,
            BaseReferences<
              _$AppDatabase,
              $RiwayatStokTableTable,
              RiwayatStokTableData
            >,
          ),
          RiwayatStokTableData,
          PrefetchHooks Function()
        > {
  $$RiwayatStokTableTableTableManager(
    _$AppDatabase db,
    $RiwayatStokTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RiwayatStokTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RiwayatStokTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RiwayatStokTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String> tipe = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<String?> keterangan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatStokTableCompanion(
                id: id,
                tokoId: tokoId,
                produkId: produkId,
                tipe: tipe,
                jumlah: jumlah,
                keterangan: keterangan,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String produkId,
                required String tipe,
                Value<int> jumlah = const Value.absent(),
                Value<String?> keterangan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatStokTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                produkId: produkId,
                tipe: tipe,
                jumlah: jumlah,
                keterangan: keterangan,
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

typedef $$RiwayatStokTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RiwayatStokTableTable,
      RiwayatStokTableData,
      $$RiwayatStokTableTableFilterComposer,
      $$RiwayatStokTableTableOrderingComposer,
      $$RiwayatStokTableTableAnnotationComposer,
      $$RiwayatStokTableTableCreateCompanionBuilder,
      $$RiwayatStokTableTableUpdateCompanionBuilder,
      (
        RiwayatStokTableData,
        BaseReferences<
          _$AppDatabase,
          $RiwayatStokTableTable,
          RiwayatStokTableData
        >,
      ),
      RiwayatStokTableData,
      PrefetchHooks Function()
    >;
typedef $$PembelianTableTableCreateCompanionBuilder =
    PembelianTableCompanion Function({
      required String id,
      required String tokoId,
      Value<String?> supplierId,
      Value<String?> namaSupplier,
      Value<double> totalHarga,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PembelianTableTableUpdateCompanionBuilder =
    PembelianTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String?> supplierId,
      Value<String?> namaSupplier,
      Value<double> totalHarga,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PembelianTableTableFilterComposer
    extends Composer<_$AppDatabase, $PembelianTableTable> {
  $$PembelianTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PembelianTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PembelianTableTable> {
  $$PembelianTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PembelianTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PembelianTableTable> {
  $$PembelianTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PembelianTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PembelianTableTable,
          PembelianTableData,
          $$PembelianTableTableFilterComposer,
          $$PembelianTableTableOrderingComposer,
          $$PembelianTableTableAnnotationComposer,
          $$PembelianTableTableCreateCompanionBuilder,
          $$PembelianTableTableUpdateCompanionBuilder,
          (
            PembelianTableData,
            BaseReferences<
              _$AppDatabase,
              $PembelianTableTable,
              PembelianTableData
            >,
          ),
          PembelianTableData,
          PrefetchHooks Function()
        > {
  $$PembelianTableTableTableManager(
    _$AppDatabase db,
    $PembelianTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PembelianTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PembelianTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PembelianTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> namaSupplier = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PembelianTableCompanion(
                id: id,
                tokoId: tokoId,
                supplierId: supplierId,
                namaSupplier: namaSupplier,
                totalHarga: totalHarga,
                updatedAt: updatedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                Value<String?> supplierId = const Value.absent(),
                Value<String?> namaSupplier = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PembelianTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                supplierId: supplierId,
                namaSupplier: namaSupplier,
                totalHarga: totalHarga,
                updatedAt: updatedAt,
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

typedef $$PembelianTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PembelianTableTable,
      PembelianTableData,
      $$PembelianTableTableFilterComposer,
      $$PembelianTableTableOrderingComposer,
      $$PembelianTableTableAnnotationComposer,
      $$PembelianTableTableCreateCompanionBuilder,
      $$PembelianTableTableUpdateCompanionBuilder,
      (
        PembelianTableData,
        BaseReferences<_$AppDatabase, $PembelianTableTable, PembelianTableData>,
      ),
      PembelianTableData,
      PrefetchHooks Function()
    >;
typedef $$ItemPembelianTableTableCreateCompanionBuilder =
    ItemPembelianTableCompanion Function({
      required String id,
      required String tokoId,
      required String pembelianId,
      required String produkId,
      Value<int> jumlah,
      Value<double> hargaBeliSatuan,
      Value<double> subtotal,
      Value<String?> satuanId,
      Value<double> konversi,
      Value<int> rowid,
    });
typedef $$ItemPembelianTableTableUpdateCompanionBuilder =
    ItemPembelianTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> pembelianId,
      Value<String> produkId,
      Value<int> jumlah,
      Value<double> hargaBeliSatuan,
      Value<double> subtotal,
      Value<String?> satuanId,
      Value<double> konversi,
      Value<int> rowid,
    });

class $$ItemPembelianTableTableFilterComposer
    extends Composer<_$AppDatabase, $ItemPembelianTableTable> {
  $$ItemPembelianTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pembelianId => $composableBuilder(
    column: $table.pembelianId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaBeliSatuan => $composableBuilder(
    column: $table.hargaBeliSatuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get satuanId => $composableBuilder(
    column: $table.satuanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ItemPembelianTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ItemPembelianTableTable> {
  $$ItemPembelianTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pembelianId => $composableBuilder(
    column: $table.pembelianId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaBeliSatuan => $composableBuilder(
    column: $table.hargaBeliSatuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get satuanId => $composableBuilder(
    column: $table.satuanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ItemPembelianTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ItemPembelianTableTable> {
  $$ItemPembelianTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get pembelianId => $composableBuilder(
    column: $table.pembelianId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<int> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<double> get hargaBeliSatuan => $composableBuilder(
    column: $table.hargaBeliSatuan,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<String> get satuanId =>
      $composableBuilder(column: $table.satuanId, builder: (column) => column);

  GeneratedColumn<double> get konversi =>
      $composableBuilder(column: $table.konversi, builder: (column) => column);
}

class $$ItemPembelianTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ItemPembelianTableTable,
          ItemPembelianTableData,
          $$ItemPembelianTableTableFilterComposer,
          $$ItemPembelianTableTableOrderingComposer,
          $$ItemPembelianTableTableAnnotationComposer,
          $$ItemPembelianTableTableCreateCompanionBuilder,
          $$ItemPembelianTableTableUpdateCompanionBuilder,
          (
            ItemPembelianTableData,
            BaseReferences<
              _$AppDatabase,
              $ItemPembelianTableTable,
              ItemPembelianTableData
            >,
          ),
          ItemPembelianTableData,
          PrefetchHooks Function()
        > {
  $$ItemPembelianTableTableTableManager(
    _$AppDatabase db,
    $ItemPembelianTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ItemPembelianTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ItemPembelianTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ItemPembelianTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> pembelianId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaBeliSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemPembelianTableCompanion(
                id: id,
                tokoId: tokoId,
                pembelianId: pembelianId,
                produkId: produkId,
                jumlah: jumlah,
                hargaBeliSatuan: hargaBeliSatuan,
                subtotal: subtotal,
                satuanId: satuanId,
                konversi: konversi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String pembelianId,
                required String produkId,
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaBeliSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemPembelianTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                pembelianId: pembelianId,
                produkId: produkId,
                jumlah: jumlah,
                hargaBeliSatuan: hargaBeliSatuan,
                subtotal: subtotal,
                satuanId: satuanId,
                konversi: konversi,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ItemPembelianTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ItemPembelianTableTable,
      ItemPembelianTableData,
      $$ItemPembelianTableTableFilterComposer,
      $$ItemPembelianTableTableOrderingComposer,
      $$ItemPembelianTableTableAnnotationComposer,
      $$ItemPembelianTableTableCreateCompanionBuilder,
      $$ItemPembelianTableTableUpdateCompanionBuilder,
      (
        ItemPembelianTableData,
        BaseReferences<
          _$AppDatabase,
          $ItemPembelianTableTable,
          ItemPembelianTableData
        >,
      ),
      ItemPembelianTableData,
      PrefetchHooks Function()
    >;
typedef $$PendingOrderTableTableCreateCompanionBuilder =
    PendingOrderTableCompanion Function({
      required String id,
      required String tokoId,
      required String namaPelanggan,
      Value<String?> catatan,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PendingOrderTableTableUpdateCompanionBuilder =
    PendingOrderTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> namaPelanggan,
      Value<String?> catatan,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PendingOrderTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingOrderTableTable> {
  $$PendingOrderTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaPelanggan => $composableBuilder(
    column: $table.namaPelanggan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingOrderTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingOrderTableTable> {
  $$PendingOrderTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaPelanggan => $composableBuilder(
    column: $table.namaPelanggan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catatan => $composableBuilder(
    column: $table.catatan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingOrderTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingOrderTableTable> {
  $$PendingOrderTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get namaPelanggan => $composableBuilder(
    column: $table.namaPelanggan,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingOrderTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingOrderTableTable,
          PendingOrderTableData,
          $$PendingOrderTableTableFilterComposer,
          $$PendingOrderTableTableOrderingComposer,
          $$PendingOrderTableTableAnnotationComposer,
          $$PendingOrderTableTableCreateCompanionBuilder,
          $$PendingOrderTableTableUpdateCompanionBuilder,
          (
            PendingOrderTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingOrderTableTable,
              PendingOrderTableData
            >,
          ),
          PendingOrderTableData,
          PrefetchHooks Function()
        > {
  $$PendingOrderTableTableTableManager(
    _$AppDatabase db,
    $PendingOrderTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOrderTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PendingOrderTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PendingOrderTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> namaPelanggan = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOrderTableCompanion(
                id: id,
                tokoId: tokoId,
                namaPelanggan: namaPelanggan,
                catatan: catatan,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String namaPelanggan,
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOrderTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                namaPelanggan: namaPelanggan,
                catatan: catatan,
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

typedef $$PendingOrderTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingOrderTableTable,
      PendingOrderTableData,
      $$PendingOrderTableTableFilterComposer,
      $$PendingOrderTableTableOrderingComposer,
      $$PendingOrderTableTableAnnotationComposer,
      $$PendingOrderTableTableCreateCompanionBuilder,
      $$PendingOrderTableTableUpdateCompanionBuilder,
      (
        PendingOrderTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingOrderTableTable,
          PendingOrderTableData
        >,
      ),
      PendingOrderTableData,
      PrefetchHooks Function()
    >;
typedef $$PendingOrderItemTableTableCreateCompanionBuilder =
    PendingOrderItemTableCompanion Function({
      required String id,
      required String tokoId,
      required String pendingOrderId,
      required String produkId,
      required String namaProduk,
      Value<double> hargaJual,
      Value<int> jumlah,
      Value<int> diskonTipe,
      Value<double> diskonValue,
      Value<double> subtotal,
      Value<int> rowid,
    });
typedef $$PendingOrderItemTableTableUpdateCompanionBuilder =
    PendingOrderItemTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> pendingOrderId,
      Value<String> produkId,
      Value<String> namaProduk,
      Value<double> hargaJual,
      Value<int> jumlah,
      Value<int> diskonTipe,
      Value<double> diskonValue,
      Value<double> subtotal,
      Value<int> rowid,
    });

class $$PendingOrderItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingOrderItemTableTable> {
  $$PendingOrderItemTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendingOrderId => $composableBuilder(
    column: $table.pendingOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get diskonValue => $composableBuilder(
    column: $table.diskonValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingOrderItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingOrderItemTableTable> {
  $$PendingOrderItemTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingOrderId => $composableBuilder(
    column: $table.pendingOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaJual => $composableBuilder(
    column: $table.hargaJual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get diskonValue => $composableBuilder(
    column: $table.diskonValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingOrderItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingOrderItemTableTable> {
  $$PendingOrderItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get pendingOrderId => $composableBuilder(
    column: $table.pendingOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hargaJual =>
      $composableBuilder(column: $table.hargaJual, builder: (column) => column);

  GeneratedColumn<int> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => column,
  );

  GeneratedColumn<double> get diskonValue => $composableBuilder(
    column: $table.diskonValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);
}

class $$PendingOrderItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingOrderItemTableTable,
          PendingOrderItemTableData,
          $$PendingOrderItemTableTableFilterComposer,
          $$PendingOrderItemTableTableOrderingComposer,
          $$PendingOrderItemTableTableAnnotationComposer,
          $$PendingOrderItemTableTableCreateCompanionBuilder,
          $$PendingOrderItemTableTableUpdateCompanionBuilder,
          (
            PendingOrderItemTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingOrderItemTableTable,
              PendingOrderItemTableData
            >,
          ),
          PendingOrderItemTableData,
          PrefetchHooks Function()
        > {
  $$PendingOrderItemTableTableTableManager(
    _$AppDatabase db,
    $PendingOrderItemTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingOrderItemTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PendingOrderItemTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingOrderItemTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> pendingOrderId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String> namaProduk = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<int> diskonTipe = const Value.absent(),
                Value<double> diskonValue = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOrderItemTableCompanion(
                id: id,
                tokoId: tokoId,
                pendingOrderId: pendingOrderId,
                produkId: produkId,
                namaProduk: namaProduk,
                hargaJual: hargaJual,
                jumlah: jumlah,
                diskonTipe: diskonTipe,
                diskonValue: diskonValue,
                subtotal: subtotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String pendingOrderId,
                required String produkId,
                required String namaProduk,
                Value<double> hargaJual = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<int> diskonTipe = const Value.absent(),
                Value<double> diskonValue = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOrderItemTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                pendingOrderId: pendingOrderId,
                produkId: produkId,
                namaProduk: namaProduk,
                hargaJual: hargaJual,
                jumlah: jumlah,
                diskonTipe: diskonTipe,
                diskonValue: diskonValue,
                subtotal: subtotal,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingOrderItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingOrderItemTableTable,
      PendingOrderItemTableData,
      $$PendingOrderItemTableTableFilterComposer,
      $$PendingOrderItemTableTableOrderingComposer,
      $$PendingOrderItemTableTableAnnotationComposer,
      $$PendingOrderItemTableTableCreateCompanionBuilder,
      $$PendingOrderItemTableTableUpdateCompanionBuilder,
      (
        PendingOrderItemTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingOrderItemTableTable,
          PendingOrderItemTableData
        >,
      ),
      PendingOrderItemTableData,
      PrefetchHooks Function()
    >;
typedef $$PendingPembelianTableTableCreateCompanionBuilder =
    PendingPembelianTableCompanion Function({
      required String id,
      required String tokoId,
      Value<String?> supplierId,
      Value<String?> namaSupplier,
      Value<bool> isPpnEnabled,
      Value<double> ppnPercent,
      Value<int> diskonTipe,
      Value<double> diskonPersen,
      Value<double> diskonNominal,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PendingPembelianTableTableUpdateCompanionBuilder =
    PendingPembelianTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String?> supplierId,
      Value<String?> namaSupplier,
      Value<bool> isPpnEnabled,
      Value<double> ppnPercent,
      Value<int> diskonTipe,
      Value<double> diskonPersen,
      Value<double> diskonNominal,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PendingPembelianTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingPembelianTableTable> {
  $$PendingPembelianTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPpnEnabled => $composableBuilder(
    column: $table.isPpnEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ppnPercent => $composableBuilder(
    column: $table.ppnPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get diskonPersen => $composableBuilder(
    column: $table.diskonPersen,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get diskonNominal => $composableBuilder(
    column: $table.diskonNominal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingPembelianTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingPembelianTableTable> {
  $$PendingPembelianTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPpnEnabled => $composableBuilder(
    column: $table.isPpnEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ppnPercent => $composableBuilder(
    column: $table.ppnPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get diskonPersen => $composableBuilder(
    column: $table.diskonPersen,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get diskonNominal => $composableBuilder(
    column: $table.diskonNominal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingPembelianTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingPembelianTableTable> {
  $$PendingPembelianTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPpnEnabled => $composableBuilder(
    column: $table.isPpnEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<double> get ppnPercent => $composableBuilder(
    column: $table.ppnPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => column,
  );

  GeneratedColumn<double> get diskonPersen => $composableBuilder(
    column: $table.diskonPersen,
    builder: (column) => column,
  );

  GeneratedColumn<double> get diskonNominal => $composableBuilder(
    column: $table.diskonNominal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingPembelianTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingPembelianTableTable,
          PendingPembelianTableData,
          $$PendingPembelianTableTableFilterComposer,
          $$PendingPembelianTableTableOrderingComposer,
          $$PendingPembelianTableTableAnnotationComposer,
          $$PendingPembelianTableTableCreateCompanionBuilder,
          $$PendingPembelianTableTableUpdateCompanionBuilder,
          (
            PendingPembelianTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingPembelianTableTable,
              PendingPembelianTableData
            >,
          ),
          PendingPembelianTableData,
          PrefetchHooks Function()
        > {
  $$PendingPembelianTableTableTableManager(
    _$AppDatabase db,
    $PendingPembelianTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingPembelianTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PendingPembelianTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingPembelianTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> namaSupplier = const Value.absent(),
                Value<bool> isPpnEnabled = const Value.absent(),
                Value<double> ppnPercent = const Value.absent(),
                Value<int> diskonTipe = const Value.absent(),
                Value<double> diskonPersen = const Value.absent(),
                Value<double> diskonNominal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingPembelianTableCompanion(
                id: id,
                tokoId: tokoId,
                supplierId: supplierId,
                namaSupplier: namaSupplier,
                isPpnEnabled: isPpnEnabled,
                ppnPercent: ppnPercent,
                diskonTipe: diskonTipe,
                diskonPersen: diskonPersen,
                diskonNominal: diskonNominal,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                Value<String?> supplierId = const Value.absent(),
                Value<String?> namaSupplier = const Value.absent(),
                Value<bool> isPpnEnabled = const Value.absent(),
                Value<double> ppnPercent = const Value.absent(),
                Value<int> diskonTipe = const Value.absent(),
                Value<double> diskonPersen = const Value.absent(),
                Value<double> diskonNominal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingPembelianTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                supplierId: supplierId,
                namaSupplier: namaSupplier,
                isPpnEnabled: isPpnEnabled,
                ppnPercent: ppnPercent,
                diskonTipe: diskonTipe,
                diskonPersen: diskonPersen,
                diskonNominal: diskonNominal,
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

typedef $$PendingPembelianTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingPembelianTableTable,
      PendingPembelianTableData,
      $$PendingPembelianTableTableFilterComposer,
      $$PendingPembelianTableTableOrderingComposer,
      $$PendingPembelianTableTableAnnotationComposer,
      $$PendingPembelianTableTableCreateCompanionBuilder,
      $$PendingPembelianTableTableUpdateCompanionBuilder,
      (
        PendingPembelianTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingPembelianTableTable,
          PendingPembelianTableData
        >,
      ),
      PendingPembelianTableData,
      PrefetchHooks Function()
    >;
typedef $$PendingPembelianItemTableTableCreateCompanionBuilder =
    PendingPembelianItemTableCompanion Function({
      required String id,
      required String tokoId,
      required String pendingPembelianId,
      required String produkId,
      required String namaProduk,
      Value<int> jumlah,
      Value<double> hargaBeliSatuan,
      Value<double> hargaBeliLama,
      Value<int> diskonTipe,
      Value<double> diskonValue,
      Value<String?> satuanId,
      Value<double> konversi,
      Value<int> rowid,
    });
typedef $$PendingPembelianItemTableTableUpdateCompanionBuilder =
    PendingPembelianItemTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> pendingPembelianId,
      Value<String> produkId,
      Value<String> namaProduk,
      Value<int> jumlah,
      Value<double> hargaBeliSatuan,
      Value<double> hargaBeliLama,
      Value<int> diskonTipe,
      Value<double> diskonValue,
      Value<String?> satuanId,
      Value<double> konversi,
      Value<int> rowid,
    });

class $$PendingPembelianItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingPembelianItemTableTable> {
  $$PendingPembelianItemTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pendingPembelianId => $composableBuilder(
    column: $table.pendingPembelianId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaBeliSatuan => $composableBuilder(
    column: $table.hargaBeliSatuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaBeliLama => $composableBuilder(
    column: $table.hargaBeliLama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get diskonValue => $composableBuilder(
    column: $table.diskonValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get satuanId => $composableBuilder(
    column: $table.satuanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingPembelianItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingPembelianItemTableTable> {
  $$PendingPembelianItemTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pendingPembelianId => $composableBuilder(
    column: $table.pendingPembelianId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaBeliSatuan => $composableBuilder(
    column: $table.hargaBeliSatuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaBeliLama => $composableBuilder(
    column: $table.hargaBeliLama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get diskonValue => $composableBuilder(
    column: $table.diskonValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get satuanId => $composableBuilder(
    column: $table.satuanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingPembelianItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingPembelianItemTableTable> {
  $$PendingPembelianItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get pendingPembelianId => $composableBuilder(
    column: $table.pendingPembelianId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => column,
  );

  GeneratedColumn<int> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<double> get hargaBeliSatuan => $composableBuilder(
    column: $table.hargaBeliSatuan,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hargaBeliLama => $composableBuilder(
    column: $table.hargaBeliLama,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diskonTipe => $composableBuilder(
    column: $table.diskonTipe,
    builder: (column) => column,
  );

  GeneratedColumn<double> get diskonValue => $composableBuilder(
    column: $table.diskonValue,
    builder: (column) => column,
  );

  GeneratedColumn<String> get satuanId =>
      $composableBuilder(column: $table.satuanId, builder: (column) => column);

  GeneratedColumn<double> get konversi =>
      $composableBuilder(column: $table.konversi, builder: (column) => column);
}

class $$PendingPembelianItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingPembelianItemTableTable,
          PendingPembelianItemTableData,
          $$PendingPembelianItemTableTableFilterComposer,
          $$PendingPembelianItemTableTableOrderingComposer,
          $$PendingPembelianItemTableTableAnnotationComposer,
          $$PendingPembelianItemTableTableCreateCompanionBuilder,
          $$PendingPembelianItemTableTableUpdateCompanionBuilder,
          (
            PendingPembelianItemTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingPembelianItemTableTable,
              PendingPembelianItemTableData
            >,
          ),
          PendingPembelianItemTableData,
          PrefetchHooks Function()
        > {
  $$PendingPembelianItemTableTableTableManager(
    _$AppDatabase db,
    $PendingPembelianItemTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingPembelianItemTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PendingPembelianItemTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingPembelianItemTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> pendingPembelianId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String> namaProduk = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaBeliSatuan = const Value.absent(),
                Value<double> hargaBeliLama = const Value.absent(),
                Value<int> diskonTipe = const Value.absent(),
                Value<double> diskonValue = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingPembelianItemTableCompanion(
                id: id,
                tokoId: tokoId,
                pendingPembelianId: pendingPembelianId,
                produkId: produkId,
                namaProduk: namaProduk,
                jumlah: jumlah,
                hargaBeliSatuan: hargaBeliSatuan,
                hargaBeliLama: hargaBeliLama,
                diskonTipe: diskonTipe,
                diskonValue: diskonValue,
                satuanId: satuanId,
                konversi: konversi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String pendingPembelianId,
                required String produkId,
                required String namaProduk,
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaBeliSatuan = const Value.absent(),
                Value<double> hargaBeliLama = const Value.absent(),
                Value<int> diskonTipe = const Value.absent(),
                Value<double> diskonValue = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingPembelianItemTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                pendingPembelianId: pendingPembelianId,
                produkId: produkId,
                namaProduk: namaProduk,
                jumlah: jumlah,
                hargaBeliSatuan: hargaBeliSatuan,
                hargaBeliLama: hargaBeliLama,
                diskonTipe: diskonTipe,
                diskonValue: diskonValue,
                satuanId: satuanId,
                konversi: konversi,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingPembelianItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingPembelianItemTableTable,
      PendingPembelianItemTableData,
      $$PendingPembelianItemTableTableFilterComposer,
      $$PendingPembelianItemTableTableOrderingComposer,
      $$PendingPembelianItemTableTableAnnotationComposer,
      $$PendingPembelianItemTableTableCreateCompanionBuilder,
      $$PendingPembelianItemTableTableUpdateCompanionBuilder,
      (
        PendingPembelianItemTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingPembelianItemTableTable,
          PendingPembelianItemTableData
        >,
      ),
      PendingPembelianItemTableData,
      PrefetchHooks Function()
    >;
typedef $$NotifikasiTableTableCreateCompanionBuilder =
    NotifikasiTableCompanion Function({
      required String id,
      required String tokoId,
      required String judul,
      required String pesan,
      Value<String> tipe,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$NotifikasiTableTableUpdateCompanionBuilder =
    NotifikasiTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> judul,
      Value<String> pesan,
      Value<String> tipe,
      Value<bool> isRead,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$NotifikasiTableTableFilterComposer
    extends Composer<_$AppDatabase, $NotifikasiTableTable> {
  $$NotifikasiTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pesan => $composableBuilder(
    column: $table.pesan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tipe => $composableBuilder(
    column: $table.tipe,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotifikasiTableTableOrderingComposer
    extends Composer<_$AppDatabase, $NotifikasiTableTable> {
  $$NotifikasiTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get judul => $composableBuilder(
    column: $table.judul,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pesan => $composableBuilder(
    column: $table.pesan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tipe => $composableBuilder(
    column: $table.tipe,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRead => $composableBuilder(
    column: $table.isRead,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotifikasiTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotifikasiTableTable> {
  $$NotifikasiTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get judul =>
      $composableBuilder(column: $table.judul, builder: (column) => column);

  GeneratedColumn<String> get pesan =>
      $composableBuilder(column: $table.pesan, builder: (column) => column);

  GeneratedColumn<String> get tipe =>
      $composableBuilder(column: $table.tipe, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NotifikasiTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotifikasiTableTable,
          NotifikasiTableData,
          $$NotifikasiTableTableFilterComposer,
          $$NotifikasiTableTableOrderingComposer,
          $$NotifikasiTableTableAnnotationComposer,
          $$NotifikasiTableTableCreateCompanionBuilder,
          $$NotifikasiTableTableUpdateCompanionBuilder,
          (
            NotifikasiTableData,
            BaseReferences<
              _$AppDatabase,
              $NotifikasiTableTable,
              NotifikasiTableData
            >,
          ),
          NotifikasiTableData,
          PrefetchHooks Function()
        > {
  $$NotifikasiTableTableTableManager(
    _$AppDatabase db,
    $NotifikasiTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotifikasiTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotifikasiTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotifikasiTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> judul = const Value.absent(),
                Value<String> pesan = const Value.absent(),
                Value<String> tipe = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotifikasiTableCompanion(
                id: id,
                tokoId: tokoId,
                judul: judul,
                pesan: pesan,
                tipe: tipe,
                isRead: isRead,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String judul,
                required String pesan,
                Value<String> tipe = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotifikasiTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                judul: judul,
                pesan: pesan,
                tipe: tipe,
                isRead: isRead,
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

typedef $$NotifikasiTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotifikasiTableTable,
      NotifikasiTableData,
      $$NotifikasiTableTableFilterComposer,
      $$NotifikasiTableTableOrderingComposer,
      $$NotifikasiTableTableAnnotationComposer,
      $$NotifikasiTableTableCreateCompanionBuilder,
      $$NotifikasiTableTableUpdateCompanionBuilder,
      (
        NotifikasiTableData,
        BaseReferences<
          _$AppDatabase,
          $NotifikasiTableTable,
          NotifikasiTableData
        >,
      ),
      NotifikasiTableData,
      PrefetchHooks Function()
    >;
typedef $$PendingSyncQueueTableTableCreateCompanionBuilder =
    PendingSyncQueueTableCompanion Function({
      Value<int> id,
      required String targetTable,
      required String operation,
      required String recordId,
      required String payload,
      Value<DateTime> createdAt,
    });
typedef $$PendingSyncQueueTableTableUpdateCompanionBuilder =
    PendingSyncQueueTableCompanion Function({
      Value<int> id,
      Value<String> targetTable,
      Value<String> operation,
      Value<String> recordId,
      Value<String> payload,
      Value<DateTime> createdAt,
    });

class $$PendingSyncQueueTableTableFilterComposer
    extends Composer<_$AppDatabase, $PendingSyncQueueTableTable> {
  $$PendingSyncQueueTableTableFilterComposer({
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

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingSyncQueueTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PendingSyncQueueTableTable> {
  $$PendingSyncQueueTableTableOrderingComposer({
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

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingSyncQueueTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PendingSyncQueueTableTable> {
  $$PendingSyncQueueTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PendingSyncQueueTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PendingSyncQueueTableTable,
          PendingSyncQueueTableData,
          $$PendingSyncQueueTableTableFilterComposer,
          $$PendingSyncQueueTableTableOrderingComposer,
          $$PendingSyncQueueTableTableAnnotationComposer,
          $$PendingSyncQueueTableTableCreateCompanionBuilder,
          $$PendingSyncQueueTableTableUpdateCompanionBuilder,
          (
            PendingSyncQueueTableData,
            BaseReferences<
              _$AppDatabase,
              $PendingSyncQueueTableTable,
              PendingSyncQueueTableData
            >,
          ),
          PendingSyncQueueTableData,
          PrefetchHooks Function()
        > {
  $$PendingSyncQueueTableTableTableManager(
    _$AppDatabase db,
    $PendingSyncQueueTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PendingSyncQueueTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PendingSyncQueueTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PendingSyncQueueTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingSyncQueueTableCompanion(
                id: id,
                targetTable: targetTable,
                operation: operation,
                recordId: recordId,
                payload: payload,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String targetTable,
                required String operation,
                required String recordId,
                required String payload,
                Value<DateTime> createdAt = const Value.absent(),
              }) => PendingSyncQueueTableCompanion.insert(
                id: id,
                targetTable: targetTable,
                operation: operation,
                recordId: recordId,
                payload: payload,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingSyncQueueTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PendingSyncQueueTableTable,
      PendingSyncQueueTableData,
      $$PendingSyncQueueTableTableFilterComposer,
      $$PendingSyncQueueTableTableOrderingComposer,
      $$PendingSyncQueueTableTableAnnotationComposer,
      $$PendingSyncQueueTableTableCreateCompanionBuilder,
      $$PendingSyncQueueTableTableUpdateCompanionBuilder,
      (
        PendingSyncQueueTableData,
        BaseReferences<
          _$AppDatabase,
          $PendingSyncQueueTableTable,
          PendingSyncQueueTableData
        >,
      ),
      PendingSyncQueueTableData,
      PrefetchHooks Function()
    >;
typedef $$RiwayatHargaTableTableCreateCompanionBuilder =
    RiwayatHargaTableCompanion Function({
      required String id,
      required String tokoId,
      required String produkId,
      required double hargaBeliLama,
      required double hargaBeliBaru,
      required double hargaJualLama,
      required double hargaJualBaru,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$RiwayatHargaTableTableUpdateCompanionBuilder =
    RiwayatHargaTableCompanion Function({
      Value<String> id,
      Value<String> tokoId,
      Value<String> produkId,
      Value<double> hargaBeliLama,
      Value<double> hargaBeliBaru,
      Value<double> hargaJualLama,
      Value<double> hargaJualBaru,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RiwayatHargaTableTableFilterComposer
    extends Composer<_$AppDatabase, $RiwayatHargaTableTable> {
  $$RiwayatHargaTableTableFilterComposer({
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

  ColumnFilters<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaBeliLama => $composableBuilder(
    column: $table.hargaBeliLama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaBeliBaru => $composableBuilder(
    column: $table.hargaBeliBaru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaJualLama => $composableBuilder(
    column: $table.hargaJualLama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaJualBaru => $composableBuilder(
    column: $table.hargaJualBaru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RiwayatHargaTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RiwayatHargaTableTable> {
  $$RiwayatHargaTableTableOrderingComposer({
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

  ColumnOrderings<String> get tokoId => $composableBuilder(
    column: $table.tokoId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaBeliLama => $composableBuilder(
    column: $table.hargaBeliLama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaBeliBaru => $composableBuilder(
    column: $table.hargaBeliBaru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaJualLama => $composableBuilder(
    column: $table.hargaJualLama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaJualBaru => $composableBuilder(
    column: $table.hargaJualBaru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RiwayatHargaTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RiwayatHargaTableTable> {
  $$RiwayatHargaTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tokoId =>
      $composableBuilder(column: $table.tokoId, builder: (column) => column);

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<double> get hargaBeliLama => $composableBuilder(
    column: $table.hargaBeliLama,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hargaBeliBaru => $composableBuilder(
    column: $table.hargaBeliBaru,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hargaJualLama => $composableBuilder(
    column: $table.hargaJualLama,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hargaJualBaru => $composableBuilder(
    column: $table.hargaJualBaru,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RiwayatHargaTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RiwayatHargaTableTable,
          RiwayatHargaTableData,
          $$RiwayatHargaTableTableFilterComposer,
          $$RiwayatHargaTableTableOrderingComposer,
          $$RiwayatHargaTableTableAnnotationComposer,
          $$RiwayatHargaTableTableCreateCompanionBuilder,
          $$RiwayatHargaTableTableUpdateCompanionBuilder,
          (
            RiwayatHargaTableData,
            BaseReferences<
              _$AppDatabase,
              $RiwayatHargaTableTable,
              RiwayatHargaTableData
            >,
          ),
          RiwayatHargaTableData,
          PrefetchHooks Function()
        > {
  $$RiwayatHargaTableTableTableManager(
    _$AppDatabase db,
    $RiwayatHargaTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RiwayatHargaTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RiwayatHargaTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RiwayatHargaTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> tokoId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<double> hargaBeliLama = const Value.absent(),
                Value<double> hargaBeliBaru = const Value.absent(),
                Value<double> hargaJualLama = const Value.absent(),
                Value<double> hargaJualBaru = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatHargaTableCompanion(
                id: id,
                tokoId: tokoId,
                produkId: produkId,
                hargaBeliLama: hargaBeliLama,
                hargaBeliBaru: hargaBeliBaru,
                hargaJualLama: hargaJualLama,
                hargaJualBaru: hargaJualBaru,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String tokoId,
                required String produkId,
                required double hargaBeliLama,
                required double hargaBeliBaru,
                required double hargaJualLama,
                required double hargaJualBaru,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatHargaTableCompanion.insert(
                id: id,
                tokoId: tokoId,
                produkId: produkId,
                hargaBeliLama: hargaBeliLama,
                hargaBeliBaru: hargaBeliBaru,
                hargaJualLama: hargaJualLama,
                hargaJualBaru: hargaJualBaru,
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

typedef $$RiwayatHargaTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RiwayatHargaTableTable,
      RiwayatHargaTableData,
      $$RiwayatHargaTableTableFilterComposer,
      $$RiwayatHargaTableTableOrderingComposer,
      $$RiwayatHargaTableTableAnnotationComposer,
      $$RiwayatHargaTableTableCreateCompanionBuilder,
      $$RiwayatHargaTableTableUpdateCompanionBuilder,
      (
        RiwayatHargaTableData,
        BaseReferences<
          _$AppDatabase,
          $RiwayatHargaTableTable,
          RiwayatHargaTableData
        >,
      ),
      RiwayatHargaTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TokoTableTableTableManager get tokoTable =>
      $$TokoTableTableTableManager(_db, _db.tokoTable);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$ProdukTableTableTableManager get produkTable =>
      $$ProdukTableTableTableManager(_db, _db.produkTable);
  $$SatuanProdukTableTableTableManager get satuanProdukTable =>
      $$SatuanProdukTableTableTableManager(_db, _db.satuanProdukTable);
  $$SupplierTableTableTableManager get supplierTable =>
      $$SupplierTableTableTableManager(_db, _db.supplierTable);
  $$SupplierProductsTableTableTableManager get supplierProductsTable =>
      $$SupplierProductsTableTableTableManager(_db, _db.supplierProductsTable);
  $$TransaksiTableTableTableManager get transaksiTable =>
      $$TransaksiTableTableTableManager(_db, _db.transaksiTable);
  $$ItemTransaksiTableTableTableManager get itemTransaksiTable =>
      $$ItemTransaksiTableTableTableManager(_db, _db.itemTransaksiTable);
  $$HutangPiutangTableTableTableManager get hutangPiutangTable =>
      $$HutangPiutangTableTableTableManager(_db, _db.hutangPiutangTable);
  $$RiwayatStokTableTableTableManager get riwayatStokTable =>
      $$RiwayatStokTableTableTableManager(_db, _db.riwayatStokTable);
  $$PembelianTableTableTableManager get pembelianTable =>
      $$PembelianTableTableTableManager(_db, _db.pembelianTable);
  $$ItemPembelianTableTableTableManager get itemPembelianTable =>
      $$ItemPembelianTableTableTableManager(_db, _db.itemPembelianTable);
  $$PendingOrderTableTableTableManager get pendingOrderTable =>
      $$PendingOrderTableTableTableManager(_db, _db.pendingOrderTable);
  $$PendingOrderItemTableTableTableManager get pendingOrderItemTable =>
      $$PendingOrderItemTableTableTableManager(_db, _db.pendingOrderItemTable);
  $$PendingPembelianTableTableTableManager get pendingPembelianTable =>
      $$PendingPembelianTableTableTableManager(_db, _db.pendingPembelianTable);
  $$PendingPembelianItemTableTableTableManager get pendingPembelianItemTable =>
      $$PendingPembelianItemTableTableTableManager(
        _db,
        _db.pendingPembelianItemTable,
      );
  $$NotifikasiTableTableTableManager get notifikasiTable =>
      $$NotifikasiTableTableTableManager(_db, _db.notifikasiTable);
  $$PendingSyncQueueTableTableTableManager get pendingSyncQueueTable =>
      $$PendingSyncQueueTableTableTableManager(_db, _db.pendingSyncQueueTable);
  $$RiwayatHargaTableTableTableManager get riwayatHargaTable =>
      $$RiwayatHargaTableTableTableManager(_db, _db.riwayatHargaTable);
}
