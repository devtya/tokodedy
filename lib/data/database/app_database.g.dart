// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
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
  List<GeneratedColumn> get $columns => [id, nama, role, createdAt];
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
  final String? nama;
  final String role;
  final DateTime createdAt;
  const UserTableData({
    required this.id,
    this.nama,
    required this.role,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
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
      'nama': serializer.toJson<String?>(nama),
      'role': serializer.toJson<String>(role),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserTableData copyWith({
    String? id,
    Value<String?> nama = const Value.absent(),
    String? role,
    DateTime? createdAt,
  }) => UserTableData(
    id: id ?? this.id,
    nama: nama.present ? nama.value : this.nama,
    role: role ?? this.role,
    createdAt: createdAt ?? this.createdAt,
  );
  UserTableData copyWithCompanion(UserTableCompanion data) {
    return UserTableData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      role: data.role.present ? data.role.value : this.role,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserTableData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('role: $role, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, nama, role, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserTableData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.role == this.role &&
          other.createdAt == this.createdAt);
}

class UserTableCompanion extends UpdateCompanion<UserTableData> {
  final Value<String> id;
  final Value<String?> nama;
  final Value<String> role;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const UserTableCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserTableCompanion.insert({
    required String id,
    this.nama = const Value.absent(),
    this.role = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<UserTableData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? role,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (role != null) 'role': role,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? nama,
    Value<String>? role,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return UserTableCompanion(
      id: id ?? this.id,
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
    defaultValue: const Constant(0.0),
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
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    nama,
    barcode,
    hargaBeli,
    hargaJual,
    stok,
    stokMinimum,
    kategori,
    satuan,
    imageUrl,
    isArchived,
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
    if (data.containsKey('stok_minimum')) {
      context.handle(
        _stokMinimumMeta,
        stokMinimum.isAcceptableOrUnknown(
          data['stok_minimum']!,
          _stokMinimumMeta,
        ),
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
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
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
      stokMinimum: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stok_minimum'],
      ),
      kategori: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori'],
      ),
      satuan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}satuan'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
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
  $ProdukTableTable createAlias(String alias) {
    return $ProdukTableTable(attachedDatabase, alias);
  }
}

class ProdukTableData extends DataClass implements Insertable<ProdukTableData> {
  final String id;
  final String nama;
  final String? barcode;
  final double hargaBeli;
  final double hargaJual;
  final int stok;
  final int? stokMinimum;
  final String? kategori;
  final String satuan;
  final String? imageUrl;
  final bool isArchived;
  final DateTime updatedAt;
  final DateTime createdAt;
  const ProdukTableData({
    required this.id,
    required this.nama,
    this.barcode,
    required this.hargaBeli,
    required this.hargaJual,
    required this.stok,
    this.stokMinimum,
    this.kategori,
    required this.satuan,
    this.imageUrl,
    required this.isArchived,
    required this.updatedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['harga_beli'] = Variable<double>(hargaBeli);
    map['harga_jual'] = Variable<double>(hargaJual);
    map['stok'] = Variable<int>(stok);
    if (!nullToAbsent || stokMinimum != null) {
      map['stok_minimum'] = Variable<int>(stokMinimum);
    }
    if (!nullToAbsent || kategori != null) {
      map['kategori'] = Variable<String>(kategori);
    }
    map['satuan'] = Variable<String>(satuan);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProdukTableCompanion toCompanion(bool nullToAbsent) {
    return ProdukTableCompanion(
      id: Value(id),
      nama: Value(nama),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      hargaBeli: Value(hargaBeli),
      hargaJual: Value(hargaJual),
      stok: Value(stok),
      stokMinimum: stokMinimum == null && nullToAbsent
          ? const Value.absent()
          : Value(stokMinimum),
      kategori: kategori == null && nullToAbsent
          ? const Value.absent()
          : Value(kategori),
      satuan: Value(satuan),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      isArchived: Value(isArchived),
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
      nama: serializer.fromJson<String>(json['nama']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      hargaBeli: serializer.fromJson<double>(json['hargaBeli']),
      hargaJual: serializer.fromJson<double>(json['hargaJual']),
      stok: serializer.fromJson<int>(json['stok']),
      stokMinimum: serializer.fromJson<int?>(json['stokMinimum']),
      kategori: serializer.fromJson<String?>(json['kategori']),
      satuan: serializer.fromJson<String>(json['satuan']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'barcode': serializer.toJson<String?>(barcode),
      'hargaBeli': serializer.toJson<double>(hargaBeli),
      'hargaJual': serializer.toJson<double>(hargaJual),
      'stok': serializer.toJson<int>(stok),
      'stokMinimum': serializer.toJson<int?>(stokMinimum),
      'kategori': serializer.toJson<String?>(kategori),
      'satuan': serializer.toJson<String>(satuan),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'isArchived': serializer.toJson<bool>(isArchived),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProdukTableData copyWith({
    String? id,
    String? nama,
    Value<String?> barcode = const Value.absent(),
    double? hargaBeli,
    double? hargaJual,
    int? stok,
    Value<int?> stokMinimum = const Value.absent(),
    Value<String?> kategori = const Value.absent(),
    String? satuan,
    Value<String?> imageUrl = const Value.absent(),
    bool? isArchived,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => ProdukTableData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    barcode: barcode.present ? barcode.value : this.barcode,
    hargaBeli: hargaBeli ?? this.hargaBeli,
    hargaJual: hargaJual ?? this.hargaJual,
    stok: stok ?? this.stok,
    stokMinimum: stokMinimum.present ? stokMinimum.value : this.stokMinimum,
    kategori: kategori.present ? kategori.value : this.kategori,
    satuan: satuan ?? this.satuan,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    isArchived: isArchived ?? this.isArchived,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  ProdukTableData copyWithCompanion(ProdukTableCompanion data) {
    return ProdukTableData(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      hargaBeli: data.hargaBeli.present ? data.hargaBeli.value : this.hargaBeli,
      hargaJual: data.hargaJual.present ? data.hargaJual.value : this.hargaJual,
      stok: data.stok.present ? data.stok.value : this.stok,
      stokMinimum: data.stokMinimum.present
          ? data.stokMinimum.value
          : this.stokMinimum,
      kategori: data.kategori.present ? data.kategori.value : this.kategori,
      satuan: data.satuan.present ? data.satuan.value : this.satuan,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProdukTableData(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('barcode: $barcode, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('stok: $stok, ')
          ..write('stokMinimum: $stokMinimum, ')
          ..write('kategori: $kategori, ')
          ..write('satuan: $satuan, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isArchived: $isArchived, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nama,
    barcode,
    hargaBeli,
    hargaJual,
    stok,
    stokMinimum,
    kategori,
    satuan,
    imageUrl,
    isArchived,
    updatedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProdukTableData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.barcode == this.barcode &&
          other.hargaBeli == this.hargaBeli &&
          other.hargaJual == this.hargaJual &&
          other.stok == this.stok &&
          other.stokMinimum == this.stokMinimum &&
          other.kategori == this.kategori &&
          other.satuan == this.satuan &&
          other.imageUrl == this.imageUrl &&
          other.isArchived == this.isArchived &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class ProdukTableCompanion extends UpdateCompanion<ProdukTableData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String?> barcode;
  final Value<double> hargaBeli;
  final Value<double> hargaJual;
  final Value<int> stok;
  final Value<int?> stokMinimum;
  final Value<String?> kategori;
  final Value<String> satuan;
  final Value<String?> imageUrl;
  final Value<bool> isArchived;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProdukTableCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.barcode = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.stok = const Value.absent(),
    this.stokMinimum = const Value.absent(),
    this.kategori = const Value.absent(),
    this.satuan = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProdukTableCompanion.insert({
    required String id,
    required String nama,
    this.barcode = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.stok = const Value.absent(),
    this.stokMinimum = const Value.absent(),
    this.kategori = const Value.absent(),
    this.satuan = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama);
  static Insertable<ProdukTableData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? barcode,
    Expression<double>? hargaBeli,
    Expression<double>? hargaJual,
    Expression<int>? stok,
    Expression<int>? stokMinimum,
    Expression<String>? kategori,
    Expression<String>? satuan,
    Expression<String>? imageUrl,
    Expression<bool>? isArchived,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (barcode != null) 'barcode': barcode,
      if (hargaBeli != null) 'harga_beli': hargaBeli,
      if (hargaJual != null) 'harga_jual': hargaJual,
      if (stok != null) 'stok': stok,
      if (stokMinimum != null) 'stok_minimum': stokMinimum,
      if (kategori != null) 'kategori': kategori,
      if (satuan != null) 'satuan': satuan,
      if (imageUrl != null) 'image_url': imageUrl,
      if (isArchived != null) 'is_archived': isArchived,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProdukTableCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String?>? barcode,
    Value<double>? hargaBeli,
    Value<double>? hargaJual,
    Value<int>? stok,
    Value<int?>? stokMinimum,
    Value<String?>? kategori,
    Value<String>? satuan,
    Value<String?>? imageUrl,
    Value<bool>? isArchived,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProdukTableCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      barcode: barcode ?? this.barcode,
      hargaBeli: hargaBeli ?? this.hargaBeli,
      hargaJual: hargaJual ?? this.hargaJual,
      stok: stok ?? this.stok,
      stokMinimum: stokMinimum ?? this.stokMinimum,
      kategori: kategori ?? this.kategori,
      satuan: satuan ?? this.satuan,
      imageUrl: imageUrl ?? this.imageUrl,
      isArchived: isArchived ?? this.isArchived,
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
    if (stokMinimum.present) {
      map['stok_minimum'] = Variable<int>(stokMinimum.value);
    }
    if (kategori.present) {
      map['kategori'] = Variable<String>(kategori.value);
    }
    if (satuan.present) {
      map['satuan'] = Variable<String>(satuan.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
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
          ..write('nama: $nama, ')
          ..write('barcode: $barcode, ')
          ..write('hargaBeli: $hargaBeli, ')
          ..write('hargaJual: $hargaJual, ')
          ..write('stok: $stok, ')
          ..write('stokMinimum: $stokMinimum, ')
          ..write('kategori: $kategori, ')
          ..write('satuan: $satuan, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('isArchived: $isArchived, ')
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {produkId, nama},
  ];
  @override
  SatuanProdukTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SatuanProdukTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
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
  final String produkId;
  final String nama;
  final double konversi;
  final double hargaBeli;
  final double hargaJual;
  final DateTime updatedAt;
  const SatuanProdukTableData({
    required this.id,
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
    String? produkId,
    String? nama,
    double? konversi,
    double? hargaBeli,
    double? hargaJual,
    DateTime? updatedAt,
  }) => SatuanProdukTableData(
    id: id ?? this.id,
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
  final Value<String> produkId;
  final Value<String> nama;
  final Value<double> konversi;
  final Value<double> hargaBeli;
  final Value<double> hargaJual;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SatuanProdukTableCompanion({
    this.id = const Value.absent(),
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
    required String produkId,
    required String nama,
    this.konversi = const Value.absent(),
    this.hargaBeli = const Value.absent(),
    this.hargaJual = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       produkId = Value(produkId),
       nama = Value(nama);
  static Insertable<SatuanProdukTableData> custom({
    Expression<String>? id,
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

class $RiwayatPerubahanProdukTableTable extends RiwayatPerubahanProdukTable
    with
        TableInfo<
          $RiwayatPerubahanProdukTableTable,
          RiwayatPerubahanProdukTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RiwayatPerubahanProdukTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _kolomDiubahMeta = const VerificationMeta(
    'kolomDiubah',
  );
  @override
  late final GeneratedColumn<String> kolomDiubah = GeneratedColumn<String>(
    'kolom_diubah',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nilaiLamaMeta = const VerificationMeta(
    'nilaiLama',
  );
  @override
  late final GeneratedColumn<String> nilaiLama = GeneratedColumn<String>(
    'nilai_lama',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nilaiBaruMeta = const VerificationMeta(
    'nilaiBaru',
  );
  @override
  late final GeneratedColumn<String> nilaiBaru = GeneratedColumn<String>(
    'nilai_baru',
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
    produkId,
    kolomDiubah,
    nilaiLama,
    nilaiBaru,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'riwayat_perubahan_produk_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<RiwayatPerubahanProdukTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('produk_id')) {
      context.handle(
        _produkIdMeta,
        produkId.isAcceptableOrUnknown(data['produk_id']!, _produkIdMeta),
      );
    } else if (isInserting) {
      context.missing(_produkIdMeta);
    }
    if (data.containsKey('kolom_diubah')) {
      context.handle(
        _kolomDiubahMeta,
        kolomDiubah.isAcceptableOrUnknown(
          data['kolom_diubah']!,
          _kolomDiubahMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_kolomDiubahMeta);
    }
    if (data.containsKey('nilai_lama')) {
      context.handle(
        _nilaiLamaMeta,
        nilaiLama.isAcceptableOrUnknown(data['nilai_lama']!, _nilaiLamaMeta),
      );
    } else if (isInserting) {
      context.missing(_nilaiLamaMeta);
    }
    if (data.containsKey('nilai_baru')) {
      context.handle(
        _nilaiBaruMeta,
        nilaiBaru.isAcceptableOrUnknown(data['nilai_baru']!, _nilaiBaruMeta),
      );
    } else if (isInserting) {
      context.missing(_nilaiBaruMeta);
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
  RiwayatPerubahanProdukTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RiwayatPerubahanProdukTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      kolomDiubah: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kolom_diubah'],
      )!,
      nilaiLama: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nilai_lama'],
      )!,
      nilaiBaru: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nilai_baru'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RiwayatPerubahanProdukTableTable createAlias(String alias) {
    return $RiwayatPerubahanProdukTableTable(attachedDatabase, alias);
  }
}

class RiwayatPerubahanProdukTableData extends DataClass
    implements Insertable<RiwayatPerubahanProdukTableData> {
  final String id;
  final String produkId;
  final String kolomDiubah;
  final String nilaiLama;
  final String nilaiBaru;
  final DateTime createdAt;
  const RiwayatPerubahanProdukTableData({
    required this.id,
    required this.produkId,
    required this.kolomDiubah,
    required this.nilaiLama,
    required this.nilaiBaru,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['produk_id'] = Variable<String>(produkId);
    map['kolom_diubah'] = Variable<String>(kolomDiubah);
    map['nilai_lama'] = Variable<String>(nilaiLama);
    map['nilai_baru'] = Variable<String>(nilaiBaru);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RiwayatPerubahanProdukTableCompanion toCompanion(bool nullToAbsent) {
    return RiwayatPerubahanProdukTableCompanion(
      id: Value(id),
      produkId: Value(produkId),
      kolomDiubah: Value(kolomDiubah),
      nilaiLama: Value(nilaiLama),
      nilaiBaru: Value(nilaiBaru),
      createdAt: Value(createdAt),
    );
  }

  factory RiwayatPerubahanProdukTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RiwayatPerubahanProdukTableData(
      id: serializer.fromJson<String>(json['id']),
      produkId: serializer.fromJson<String>(json['produkId']),
      kolomDiubah: serializer.fromJson<String>(json['kolomDiubah']),
      nilaiLama: serializer.fromJson<String>(json['nilaiLama']),
      nilaiBaru: serializer.fromJson<String>(json['nilaiBaru']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'produkId': serializer.toJson<String>(produkId),
      'kolomDiubah': serializer.toJson<String>(kolomDiubah),
      'nilaiLama': serializer.toJson<String>(nilaiLama),
      'nilaiBaru': serializer.toJson<String>(nilaiBaru),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RiwayatPerubahanProdukTableData copyWith({
    String? id,
    String? produkId,
    String? kolomDiubah,
    String? nilaiLama,
    String? nilaiBaru,
    DateTime? createdAt,
  }) => RiwayatPerubahanProdukTableData(
    id: id ?? this.id,
    produkId: produkId ?? this.produkId,
    kolomDiubah: kolomDiubah ?? this.kolomDiubah,
    nilaiLama: nilaiLama ?? this.nilaiLama,
    nilaiBaru: nilaiBaru ?? this.nilaiBaru,
    createdAt: createdAt ?? this.createdAt,
  );
  RiwayatPerubahanProdukTableData copyWithCompanion(
    RiwayatPerubahanProdukTableCompanion data,
  ) {
    return RiwayatPerubahanProdukTableData(
      id: data.id.present ? data.id.value : this.id,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      kolomDiubah: data.kolomDiubah.present
          ? data.kolomDiubah.value
          : this.kolomDiubah,
      nilaiLama: data.nilaiLama.present ? data.nilaiLama.value : this.nilaiLama,
      nilaiBaru: data.nilaiBaru.present ? data.nilaiBaru.value : this.nilaiBaru,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RiwayatPerubahanProdukTableData(')
          ..write('id: $id, ')
          ..write('produkId: $produkId, ')
          ..write('kolomDiubah: $kolomDiubah, ')
          ..write('nilaiLama: $nilaiLama, ')
          ..write('nilaiBaru: $nilaiBaru, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, produkId, kolomDiubah, nilaiLama, nilaiBaru, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiwayatPerubahanProdukTableData &&
          other.id == this.id &&
          other.produkId == this.produkId &&
          other.kolomDiubah == this.kolomDiubah &&
          other.nilaiLama == this.nilaiLama &&
          other.nilaiBaru == this.nilaiBaru &&
          other.createdAt == this.createdAt);
}

class RiwayatPerubahanProdukTableCompanion
    extends UpdateCompanion<RiwayatPerubahanProdukTableData> {
  final Value<String> id;
  final Value<String> produkId;
  final Value<String> kolomDiubah;
  final Value<String> nilaiLama;
  final Value<String> nilaiBaru;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RiwayatPerubahanProdukTableCompanion({
    this.id = const Value.absent(),
    this.produkId = const Value.absent(),
    this.kolomDiubah = const Value.absent(),
    this.nilaiLama = const Value.absent(),
    this.nilaiBaru = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RiwayatPerubahanProdukTableCompanion.insert({
    required String id,
    required String produkId,
    required String kolomDiubah,
    required String nilaiLama,
    required String nilaiBaru,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       produkId = Value(produkId),
       kolomDiubah = Value(kolomDiubah),
       nilaiLama = Value(nilaiLama),
       nilaiBaru = Value(nilaiBaru);
  static Insertable<RiwayatPerubahanProdukTableData> custom({
    Expression<String>? id,
    Expression<String>? produkId,
    Expression<String>? kolomDiubah,
    Expression<String>? nilaiLama,
    Expression<String>? nilaiBaru,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (produkId != null) 'produk_id': produkId,
      if (kolomDiubah != null) 'kolom_diubah': kolomDiubah,
      if (nilaiLama != null) 'nilai_lama': nilaiLama,
      if (nilaiBaru != null) 'nilai_baru': nilaiBaru,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RiwayatPerubahanProdukTableCompanion copyWith({
    Value<String>? id,
    Value<String>? produkId,
    Value<String>? kolomDiubah,
    Value<String>? nilaiLama,
    Value<String>? nilaiBaru,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RiwayatPerubahanProdukTableCompanion(
      id: id ?? this.id,
      produkId: produkId ?? this.produkId,
      kolomDiubah: kolomDiubah ?? this.kolomDiubah,
      nilaiLama: nilaiLama ?? this.nilaiLama,
      nilaiBaru: nilaiBaru ?? this.nilaiBaru,
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
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (kolomDiubah.present) {
      map['kolom_diubah'] = Variable<String>(kolomDiubah.value);
    }
    if (nilaiLama.present) {
      map['nilai_lama'] = Variable<String>(nilaiLama.value);
    }
    if (nilaiBaru.present) {
      map['nilai_baru'] = Variable<String>(nilaiBaru.value);
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
    return (StringBuffer('RiwayatPerubahanProdukTableCompanion(')
          ..write('id: $id, ')
          ..write('produkId: $produkId, ')
          ..write('kolomDiubah: $kolomDiubah, ')
          ..write('nilaiLama: $nilaiLama, ')
          ..write('nilaiBaru: $nilaiBaru, ')
          ..write('createdAt: $createdAt, ')
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
  final String nama;
  final String? telepon;
  final String? alamat;
  final DateTime updatedAt;
  final DateTime createdAt;
  const SupplierTableData({
    required this.id,
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
      'nama': serializer.toJson<String>(nama),
      'telepon': serializer.toJson<String?>(telepon),
      'alamat': serializer.toJson<String?>(alamat),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupplierTableData copyWith({
    String? id,
    String? nama,
    Value<String?> telepon = const Value.absent(),
    Value<String?> alamat = const Value.absent(),
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => SupplierTableData(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    telepon: telepon.present ? telepon.value : this.telepon,
    alamat: alamat.present ? alamat.value : this.alamat,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  SupplierTableData copyWithCompanion(SupplierTableCompanion data) {
    return SupplierTableData(
      id: data.id.present ? data.id.value : this.id,
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
      Object.hash(id, nama, telepon, alamat, updatedAt, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierTableData &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.telepon == this.telepon &&
          other.alamat == this.alamat &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class SupplierTableCompanion extends UpdateCompanion<SupplierTableData> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String?> telepon;
  final Value<String?> alamat;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SupplierTableCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplierTableCompanion.insert({
    required String id,
    required String nama,
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama);
  static Insertable<SupplierTableData> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? telepon,
    Expression<String>? alamat,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
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
    Value<String>? nama,
    Value<String?>? telepon,
    Value<String?>? alamat,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SupplierTableCompanion(
      id: id ?? this.id,
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
  final String supplierId;
  final String produkId;
  final double harga;
  final DateTime updatedAt;
  const SupplierProductsTableData({
    required this.id,
    required this.supplierId,
    required this.produkId,
    required this.harga,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['supplier_id'] = Variable<String>(supplierId);
    map['produk_id'] = Variable<String>(produkId);
    map['harga'] = Variable<double>(harga);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SupplierProductsTableCompanion toCompanion(bool nullToAbsent) {
    return SupplierProductsTableCompanion(
      id: Value(id),
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
      'supplierId': serializer.toJson<String>(supplierId),
      'produkId': serializer.toJson<String>(produkId),
      'harga': serializer.toJson<double>(harga),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SupplierProductsTableData copyWith({
    String? id,
    String? supplierId,
    String? produkId,
    double? harga,
    DateTime? updatedAt,
  }) => SupplierProductsTableData(
    id: id ?? this.id,
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
          ..write('supplierId: $supplierId, ')
          ..write('produkId: $produkId, ')
          ..write('harga: $harga, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, supplierId, produkId, harga, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupplierProductsTableData &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.produkId == this.produkId &&
          other.harga == this.harga &&
          other.updatedAt == this.updatedAt);
}

class SupplierProductsTableCompanion
    extends UpdateCompanion<SupplierProductsTableData> {
  final Value<String> id;
  final Value<String> supplierId;
  final Value<String> produkId;
  final Value<double> harga;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SupplierProductsTableCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.harga = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SupplierProductsTableCompanion.insert({
    required String id,
    required String supplierId,
    required String produkId,
    this.harga = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       supplierId = Value(supplierId),
       produkId = Value(produkId);
  static Insertable<SupplierProductsTableData> custom({
    Expression<String>? id,
    Expression<String>? supplierId,
    Expression<String>? produkId,
    Expression<double>? harga,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (produkId != null) 'produk_id': produkId,
      if (harga != null) 'harga': harga,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SupplierProductsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? supplierId,
    Value<String>? produkId,
    Value<double>? harga,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SupplierProductsTableCompanion(
      id: id ?? this.id,
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
  final String? kasirId;
  final double totalHarga;
  final double jumlahBayar;
  final double kembalian;
  final String status;
  final DateTime updatedAt;
  final DateTime createdAt;
  const TransaksiTableData({
    required this.id,
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
    Value<String?> kasirId = const Value.absent(),
    double? totalHarga,
    double? jumlahBayar,
    double? kembalian,
    String? status,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => TransaksiTableData(
    id: id ?? this.id,
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
    this.kasirId = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.jumlahBayar = const Value.absent(),
    this.kembalian = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<TransaksiTableData> custom({
    Expression<String>? id,
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
  static const VerificationMeta _namaProdukMeta = const VerificationMeta(
    'namaProduk',
  );
  @override
  late final GeneratedColumn<String> namaProduk = GeneratedColumn<String>(
    'nama_produk',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    transaksiId,
    produkId,
    namaProduk,
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
    if (data.containsKey('nama_produk')) {
      context.handle(
        _namaProdukMeta,
        namaProduk.isAcceptableOrUnknown(data['nama_produk']!, _namaProdukMeta),
      );
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
      transaksiId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaksi_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      ),
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
  final String transaksiId;
  final String produkId;
  final String? namaProduk;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;
  const ItemTransaksiTableData({
    required this.id,
    required this.transaksiId,
    required this.produkId,
    this.namaProduk,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaksi_id'] = Variable<String>(transaksiId);
    map['produk_id'] = Variable<String>(produkId);
    if (!nullToAbsent || namaProduk != null) {
      map['nama_produk'] = Variable<String>(namaProduk);
    }
    map['jumlah'] = Variable<int>(jumlah);
    map['harga_satuan'] = Variable<double>(hargaSatuan);
    map['subtotal'] = Variable<double>(subtotal);
    return map;
  }

  ItemTransaksiTableCompanion toCompanion(bool nullToAbsent) {
    return ItemTransaksiTableCompanion(
      id: Value(id),
      transaksiId: Value(transaksiId),
      produkId: Value(produkId),
      namaProduk: namaProduk == null && nullToAbsent
          ? const Value.absent()
          : Value(namaProduk),
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
      transaksiId: serializer.fromJson<String>(json['transaksiId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      namaProduk: serializer.fromJson<String?>(json['namaProduk']),
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
      'transaksiId': serializer.toJson<String>(transaksiId),
      'produkId': serializer.toJson<String>(produkId),
      'namaProduk': serializer.toJson<String?>(namaProduk),
      'jumlah': serializer.toJson<int>(jumlah),
      'hargaSatuan': serializer.toJson<double>(hargaSatuan),
      'subtotal': serializer.toJson<double>(subtotal),
    };
  }

  ItemTransaksiTableData copyWith({
    String? id,
    String? transaksiId,
    String? produkId,
    Value<String?> namaProduk = const Value.absent(),
    int? jumlah,
    double? hargaSatuan,
    double? subtotal,
  }) => ItemTransaksiTableData(
    id: id ?? this.id,
    transaksiId: transaksiId ?? this.transaksiId,
    produkId: produkId ?? this.produkId,
    namaProduk: namaProduk.present ? namaProduk.value : this.namaProduk,
    jumlah: jumlah ?? this.jumlah,
    hargaSatuan: hargaSatuan ?? this.hargaSatuan,
    subtotal: subtotal ?? this.subtotal,
  );
  ItemTransaksiTableData copyWithCompanion(ItemTransaksiTableCompanion data) {
    return ItemTransaksiTableData(
      id: data.id.present ? data.id.value : this.id,
      transaksiId: data.transaksiId.present
          ? data.transaksiId.value
          : this.transaksiId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
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
          ..write('transaksiId: $transaksiId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('jumlah: $jumlah, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('subtotal: $subtotal')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    transaksiId,
    produkId,
    namaProduk,
    jumlah,
    hargaSatuan,
    subtotal,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemTransaksiTableData &&
          other.id == this.id &&
          other.transaksiId == this.transaksiId &&
          other.produkId == this.produkId &&
          other.namaProduk == this.namaProduk &&
          other.jumlah == this.jumlah &&
          other.hargaSatuan == this.hargaSatuan &&
          other.subtotal == this.subtotal);
}

class ItemTransaksiTableCompanion
    extends UpdateCompanion<ItemTransaksiTableData> {
  final Value<String> id;
  final Value<String> transaksiId;
  final Value<String> produkId;
  final Value<String?> namaProduk;
  final Value<int> jumlah;
  final Value<double> hargaSatuan;
  final Value<double> subtotal;
  final Value<int> rowid;
  const ItemTransaksiTableCompanion({
    this.id = const Value.absent(),
    this.transaksiId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.namaProduk = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemTransaksiTableCompanion.insert({
    required String id,
    required String transaksiId,
    required String produkId,
    this.namaProduk = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transaksiId = Value(transaksiId),
       produkId = Value(produkId);
  static Insertable<ItemTransaksiTableData> custom({
    Expression<String>? id,
    Expression<String>? transaksiId,
    Expression<String>? produkId,
    Expression<String>? namaProduk,
    Expression<int>? jumlah,
    Expression<double>? hargaSatuan,
    Expression<double>? subtotal,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transaksiId != null) 'transaksi_id': transaksiId,
      if (produkId != null) 'produk_id': produkId,
      if (namaProduk != null) 'nama_produk': namaProduk,
      if (jumlah != null) 'jumlah': jumlah,
      if (hargaSatuan != null) 'harga_satuan': hargaSatuan,
      if (subtotal != null) 'subtotal': subtotal,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ItemTransaksiTableCompanion copyWith({
    Value<String>? id,
    Value<String>? transaksiId,
    Value<String>? produkId,
    Value<String?>? namaProduk,
    Value<int>? jumlah,
    Value<double>? hargaSatuan,
    Value<double>? subtotal,
    Value<int>? rowid,
  }) {
    return ItemTransaksiTableCompanion(
      id: id ?? this.id,
      transaksiId: transaksiId ?? this.transaksiId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
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
    if (transaksiId.present) {
      map['transaksi_id'] = Variable<String>(transaksiId.value);
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
          ..write('transaksiId: $transaksiId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
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
  final String? transaksiId;
  final String namaPelanggan;
  final double jumlah;
  final String status;
  final DateTime? tanggalJatuhTempo;
  final DateTime updatedAt;
  final DateTime createdAt;
  const HutangPiutangTableData({
    required this.id,
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
    Value<String?> transaksiId = const Value.absent(),
    String? namaPelanggan,
    double? jumlah,
    String? status,
    Value<DateTime?> tanggalJatuhTempo = const Value.absent(),
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => HutangPiutangTableData(
    id: id ?? this.id,
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
    this.transaksiId = const Value.absent(),
    required String namaPelanggan,
    this.jumlah = const Value.absent(),
    this.status = const Value.absent(),
    this.tanggalJatuhTempo = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namaPelanggan = Value(namaPelanggan);
  static Insertable<HutangPiutangTableData> custom({
    Expression<String>? id,
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
  final String produkId;
  final String tipe;
  final int jumlah;
  final String? keterangan;
  final DateTime createdAt;
  const RiwayatStokTableData({
    required this.id,
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
      'produkId': serializer.toJson<String>(produkId),
      'tipe': serializer.toJson<String>(tipe),
      'jumlah': serializer.toJson<int>(jumlah),
      'keterangan': serializer.toJson<String?>(keterangan),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RiwayatStokTableData copyWith({
    String? id,
    String? produkId,
    String? tipe,
    int? jumlah,
    Value<String?> keterangan = const Value.absent(),
    DateTime? createdAt,
  }) => RiwayatStokTableData(
    id: id ?? this.id,
    produkId: produkId ?? this.produkId,
    tipe: tipe ?? this.tipe,
    jumlah: jumlah ?? this.jumlah,
    keterangan: keterangan.present ? keterangan.value : this.keterangan,
    createdAt: createdAt ?? this.createdAt,
  );
  RiwayatStokTableData copyWithCompanion(RiwayatStokTableCompanion data) {
    return RiwayatStokTableData(
      id: data.id.present ? data.id.value : this.id,
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
      Object.hash(id, produkId, tipe, jumlah, keterangan, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RiwayatStokTableData &&
          other.id == this.id &&
          other.produkId == this.produkId &&
          other.tipe == this.tipe &&
          other.jumlah == this.jumlah &&
          other.keterangan == this.keterangan &&
          other.createdAt == this.createdAt);
}

class RiwayatStokTableCompanion extends UpdateCompanion<RiwayatStokTableData> {
  final Value<String> id;
  final Value<String> produkId;
  final Value<String> tipe;
  final Value<int> jumlah;
  final Value<String?> keterangan;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RiwayatStokTableCompanion({
    this.id = const Value.absent(),
    this.produkId = const Value.absent(),
    this.tipe = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RiwayatStokTableCompanion.insert({
    required String id,
    required String produkId,
    required String tipe,
    this.jumlah = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       produkId = Value(produkId),
       tipe = Value(tipe);
  static Insertable<RiwayatStokTableData> custom({
    Expression<String>? id,
    Expression<String>? produkId,
    Expression<String>? tipe,
    Expression<int>? jumlah,
    Expression<String>? keterangan,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
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
    Value<String>? produkId,
    Value<String>? tipe,
    Value<int>? jumlah,
    Value<String?>? keterangan,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RiwayatStokTableCompanion(
      id: id ?? this.id,
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
  final String? supplierId;
  final String? namaSupplier;
  final double totalHarga;
  final DateTime updatedAt;
  final DateTime createdAt;
  const PembelianTableData({
    required this.id,
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
      'supplierId': serializer.toJson<String?>(supplierId),
      'namaSupplier': serializer.toJson<String?>(namaSupplier),
      'totalHarga': serializer.toJson<double>(totalHarga),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PembelianTableData copyWith({
    String? id,
    Value<String?> supplierId = const Value.absent(),
    Value<String?> namaSupplier = const Value.absent(),
    double? totalHarga,
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => PembelianTableData(
    id: id ?? this.id,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    namaSupplier: namaSupplier.present ? namaSupplier.value : this.namaSupplier,
    totalHarga: totalHarga ?? this.totalHarga,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  PembelianTableData copyWithCompanion(PembelianTableCompanion data) {
    return PembelianTableData(
      id: data.id.present ? data.id.value : this.id,
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
          other.supplierId == this.supplierId &&
          other.namaSupplier == this.namaSupplier &&
          other.totalHarga == this.totalHarga &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class PembelianTableCompanion extends UpdateCompanion<PembelianTableData> {
  final Value<String> id;
  final Value<String?> supplierId;
  final Value<String?> namaSupplier;
  final Value<double> totalHarga;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PembelianTableCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PembelianTableCompanion.insert({
    required String id,
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<PembelianTableData> custom({
    Expression<String>? id,
    Expression<String>? supplierId,
    Expression<String>? namaSupplier,
    Expression<double>? totalHarga,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
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
    Value<String?>? supplierId,
    Value<String?>? namaSupplier,
    Value<double>? totalHarga,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PembelianTableCompanion(
      id: id ?? this.id,
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
  static const VerificationMeta _namaProdukMeta = const VerificationMeta(
    'namaProduk',
  );
  @override
  late final GeneratedColumn<String> namaProduk = GeneratedColumn<String>(
    'nama_produk',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    pembelianId,
    produkId,
    namaProduk,
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
    if (data.containsKey('nama_produk')) {
      context.handle(
        _namaProdukMeta,
        namaProduk.isAcceptableOrUnknown(data['nama_produk']!, _namaProdukMeta),
      );
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
      pembelianId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pembelian_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      ),
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
  final String pembelianId;
  final String produkId;
  final String? namaProduk;
  final int jumlah;
  final double hargaBeliSatuan;
  final double subtotal;
  final String? satuanId;
  final double konversi;
  const ItemPembelianTableData({
    required this.id,
    required this.pembelianId,
    required this.produkId,
    this.namaProduk,
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
    map['pembelian_id'] = Variable<String>(pembelianId);
    map['produk_id'] = Variable<String>(produkId);
    if (!nullToAbsent || namaProduk != null) {
      map['nama_produk'] = Variable<String>(namaProduk);
    }
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
      pembelianId: Value(pembelianId),
      produkId: Value(produkId),
      namaProduk: namaProduk == null && nullToAbsent
          ? const Value.absent()
          : Value(namaProduk),
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
      pembelianId: serializer.fromJson<String>(json['pembelianId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      namaProduk: serializer.fromJson<String?>(json['namaProduk']),
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
      'pembelianId': serializer.toJson<String>(pembelianId),
      'produkId': serializer.toJson<String>(produkId),
      'namaProduk': serializer.toJson<String?>(namaProduk),
      'jumlah': serializer.toJson<int>(jumlah),
      'hargaBeliSatuan': serializer.toJson<double>(hargaBeliSatuan),
      'subtotal': serializer.toJson<double>(subtotal),
      'satuanId': serializer.toJson<String?>(satuanId),
      'konversi': serializer.toJson<double>(konversi),
    };
  }

  ItemPembelianTableData copyWith({
    String? id,
    String? pembelianId,
    String? produkId,
    Value<String?> namaProduk = const Value.absent(),
    int? jumlah,
    double? hargaBeliSatuan,
    double? subtotal,
    Value<String?> satuanId = const Value.absent(),
    double? konversi,
  }) => ItemPembelianTableData(
    id: id ?? this.id,
    pembelianId: pembelianId ?? this.pembelianId,
    produkId: produkId ?? this.produkId,
    namaProduk: namaProduk.present ? namaProduk.value : this.namaProduk,
    jumlah: jumlah ?? this.jumlah,
    hargaBeliSatuan: hargaBeliSatuan ?? this.hargaBeliSatuan,
    subtotal: subtotal ?? this.subtotal,
    satuanId: satuanId.present ? satuanId.value : this.satuanId,
    konversi: konversi ?? this.konversi,
  );
  ItemPembelianTableData copyWithCompanion(ItemPembelianTableCompanion data) {
    return ItemPembelianTableData(
      id: data.id.present ? data.id.value : this.id,
      pembelianId: data.pembelianId.present
          ? data.pembelianId.value
          : this.pembelianId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
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
          ..write('pembelianId: $pembelianId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
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
    pembelianId,
    produkId,
    namaProduk,
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
          other.pembelianId == this.pembelianId &&
          other.produkId == this.produkId &&
          other.namaProduk == this.namaProduk &&
          other.jumlah == this.jumlah &&
          other.hargaBeliSatuan == this.hargaBeliSatuan &&
          other.subtotal == this.subtotal &&
          other.satuanId == this.satuanId &&
          other.konversi == this.konversi);
}

class ItemPembelianTableCompanion
    extends UpdateCompanion<ItemPembelianTableData> {
  final Value<String> id;
  final Value<String> pembelianId;
  final Value<String> produkId;
  final Value<String?> namaProduk;
  final Value<int> jumlah;
  final Value<double> hargaBeliSatuan;
  final Value<double> subtotal;
  final Value<String?> satuanId;
  final Value<double> konversi;
  final Value<int> rowid;
  const ItemPembelianTableCompanion({
    this.id = const Value.absent(),
    this.pembelianId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.namaProduk = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.hargaBeliSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ItemPembelianTableCompanion.insert({
    required String id,
    required String pembelianId,
    required String produkId,
    this.namaProduk = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.hargaBeliSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       pembelianId = Value(pembelianId),
       produkId = Value(produkId);
  static Insertable<ItemPembelianTableData> custom({
    Expression<String>? id,
    Expression<String>? pembelianId,
    Expression<String>? produkId,
    Expression<String>? namaProduk,
    Expression<int>? jumlah,
    Expression<double>? hargaBeliSatuan,
    Expression<double>? subtotal,
    Expression<String>? satuanId,
    Expression<double>? konversi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pembelianId != null) 'pembelian_id': pembelianId,
      if (produkId != null) 'produk_id': produkId,
      if (namaProduk != null) 'nama_produk': namaProduk,
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
    Value<String>? pembelianId,
    Value<String>? produkId,
    Value<String?>? namaProduk,
    Value<int>? jumlah,
    Value<double>? hargaBeliSatuan,
    Value<double>? subtotal,
    Value<String?>? satuanId,
    Value<double>? konversi,
    Value<int>? rowid,
  }) {
    return ItemPembelianTableCompanion(
      id: id ?? this.id,
      pembelianId: pembelianId ?? this.pembelianId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
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
    if (pembelianId.present) {
      map['pembelian_id'] = Variable<String>(pembelianId.value);
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
          ..write('pembelianId: $pembelianId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
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

class $PurchaseOrderTableTable extends PurchaseOrderTable
    with TableInfo<$PurchaseOrderTableTable, PurchaseOrderTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseOrderTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
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
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
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
    supplierId,
    namaSupplier,
    status,
    totalHarga,
    notes,
    updatedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_order_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseOrderTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
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
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total_harga')) {
      context.handle(
        _totalHargaMeta,
        totalHarga.isAcceptableOrUnknown(data['total_harga']!, _totalHargaMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
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
  PurchaseOrderTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseOrderTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      supplierId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier_id'],
      ),
      namaSupplier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_supplier'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalHarga: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_harga'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
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
  $PurchaseOrderTableTable createAlias(String alias) {
    return $PurchaseOrderTableTable(attachedDatabase, alias);
  }
}

class PurchaseOrderTableData extends DataClass
    implements Insertable<PurchaseOrderTableData> {
  final String id;
  final String? supplierId;
  final String? namaSupplier;
  final String status;
  final double totalHarga;
  final String? notes;
  final DateTime updatedAt;
  final DateTime createdAt;
  const PurchaseOrderTableData({
    required this.id,
    this.supplierId,
    this.namaSupplier,
    required this.status,
    required this.totalHarga,
    this.notes,
    required this.updatedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || supplierId != null) {
      map['supplier_id'] = Variable<String>(supplierId);
    }
    if (!nullToAbsent || namaSupplier != null) {
      map['nama_supplier'] = Variable<String>(namaSupplier);
    }
    map['status'] = Variable<String>(status);
    map['total_harga'] = Variable<double>(totalHarga);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PurchaseOrderTableCompanion toCompanion(bool nullToAbsent) {
    return PurchaseOrderTableCompanion(
      id: Value(id),
      supplierId: supplierId == null && nullToAbsent
          ? const Value.absent()
          : Value(supplierId),
      namaSupplier: namaSupplier == null && nullToAbsent
          ? const Value.absent()
          : Value(namaSupplier),
      status: Value(status),
      totalHarga: Value(totalHarga),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      updatedAt: Value(updatedAt),
      createdAt: Value(createdAt),
    );
  }

  factory PurchaseOrderTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseOrderTableData(
      id: serializer.fromJson<String>(json['id']),
      supplierId: serializer.fromJson<String?>(json['supplierId']),
      namaSupplier: serializer.fromJson<String?>(json['namaSupplier']),
      status: serializer.fromJson<String>(json['status']),
      totalHarga: serializer.fromJson<double>(json['totalHarga']),
      notes: serializer.fromJson<String?>(json['notes']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'supplierId': serializer.toJson<String?>(supplierId),
      'namaSupplier': serializer.toJson<String?>(namaSupplier),
      'status': serializer.toJson<String>(status),
      'totalHarga': serializer.toJson<double>(totalHarga),
      'notes': serializer.toJson<String?>(notes),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PurchaseOrderTableData copyWith({
    String? id,
    Value<String?> supplierId = const Value.absent(),
    Value<String?> namaSupplier = const Value.absent(),
    String? status,
    double? totalHarga,
    Value<String?> notes = const Value.absent(),
    DateTime? updatedAt,
    DateTime? createdAt,
  }) => PurchaseOrderTableData(
    id: id ?? this.id,
    supplierId: supplierId.present ? supplierId.value : this.supplierId,
    namaSupplier: namaSupplier.present ? namaSupplier.value : this.namaSupplier,
    status: status ?? this.status,
    totalHarga: totalHarga ?? this.totalHarga,
    notes: notes.present ? notes.value : this.notes,
    updatedAt: updatedAt ?? this.updatedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  PurchaseOrderTableData copyWithCompanion(PurchaseOrderTableCompanion data) {
    return PurchaseOrderTableData(
      id: data.id.present ? data.id.value : this.id,
      supplierId: data.supplierId.present
          ? data.supplierId.value
          : this.supplierId,
      namaSupplier: data.namaSupplier.present
          ? data.namaSupplier.value
          : this.namaSupplier,
      status: data.status.present ? data.status.value : this.status,
      totalHarga: data.totalHarga.present
          ? data.totalHarga.value
          : this.totalHarga,
      notes: data.notes.present ? data.notes.value : this.notes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrderTableData(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('namaSupplier: $namaSupplier, ')
          ..write('status: $status, ')
          ..write('totalHarga: $totalHarga, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    supplierId,
    namaSupplier,
    status,
    totalHarga,
    notes,
    updatedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseOrderTableData &&
          other.id == this.id &&
          other.supplierId == this.supplierId &&
          other.namaSupplier == this.namaSupplier &&
          other.status == this.status &&
          other.totalHarga == this.totalHarga &&
          other.notes == this.notes &&
          other.updatedAt == this.updatedAt &&
          other.createdAt == this.createdAt);
}

class PurchaseOrderTableCompanion
    extends UpdateCompanion<PurchaseOrderTableData> {
  final Value<String> id;
  final Value<String?> supplierId;
  final Value<String?> namaSupplier;
  final Value<String> status;
  final Value<double> totalHarga;
  final Value<String?> notes;
  final Value<DateTime> updatedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PurchaseOrderTableCompanion({
    this.id = const Value.absent(),
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.status = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseOrderTableCompanion.insert({
    required String id,
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.status = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.notes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<PurchaseOrderTableData> custom({
    Expression<String>? id,
    Expression<String>? supplierId,
    Expression<String>? namaSupplier,
    Expression<String>? status,
    Expression<double>? totalHarga,
    Expression<String>? notes,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (supplierId != null) 'supplier_id': supplierId,
      if (namaSupplier != null) 'nama_supplier': namaSupplier,
      if (status != null) 'status': status,
      if (totalHarga != null) 'total_harga': totalHarga,
      if (notes != null) 'notes': notes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseOrderTableCompanion copyWith({
    Value<String>? id,
    Value<String?>? supplierId,
    Value<String?>? namaSupplier,
    Value<String>? status,
    Value<double>? totalHarga,
    Value<String?>? notes,
    Value<DateTime>? updatedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PurchaseOrderTableCompanion(
      id: id ?? this.id,
      supplierId: supplierId ?? this.supplierId,
      namaSupplier: namaSupplier ?? this.namaSupplier,
      status: status ?? this.status,
      totalHarga: totalHarga ?? this.totalHarga,
      notes: notes ?? this.notes,
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
    if (supplierId.present) {
      map['supplier_id'] = Variable<String>(supplierId.value);
    }
    if (namaSupplier.present) {
      map['nama_supplier'] = Variable<String>(namaSupplier.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalHarga.present) {
      map['total_harga'] = Variable<double>(totalHarga.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
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
    return (StringBuffer('PurchaseOrderTableCompanion(')
          ..write('id: $id, ')
          ..write('supplierId: $supplierId, ')
          ..write('namaSupplier: $namaSupplier, ')
          ..write('status: $status, ')
          ..write('totalHarga: $totalHarga, ')
          ..write('notes: $notes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PurchaseOrderItemTableTable extends PurchaseOrderItemTable
    with TableInfo<$PurchaseOrderItemTableTable, PurchaseOrderItemTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PurchaseOrderItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _poIdMeta = const VerificationMeta('poId');
  @override
  late final GeneratedColumn<String> poId = GeneratedColumn<String>(
    'po_id',
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
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qtyPesanMeta = const VerificationMeta(
    'qtyPesan',
  );
  @override
  late final GeneratedColumn<int> qtyPesan = GeneratedColumn<int>(
    'qty_pesan',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _qtyTerimaMeta = const VerificationMeta(
    'qtyTerima',
  );
  @override
  late final GeneratedColumn<int> qtyTerima = GeneratedColumn<int>(
    'qty_terima',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
    poId,
    produkId,
    namaProduk,
    qtyPesan,
    qtyTerima,
    hargaSatuan,
    subtotal,
    satuanId,
    konversi,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'purchase_order_item_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PurchaseOrderItemTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('po_id')) {
      context.handle(
        _poIdMeta,
        poId.isAcceptableOrUnknown(data['po_id']!, _poIdMeta),
      );
    } else if (isInserting) {
      context.missing(_poIdMeta);
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
    }
    if (data.containsKey('qty_pesan')) {
      context.handle(
        _qtyPesanMeta,
        qtyPesan.isAcceptableOrUnknown(data['qty_pesan']!, _qtyPesanMeta),
      );
    }
    if (data.containsKey('qty_terima')) {
      context.handle(
        _qtyTerimaMeta,
        qtyTerima.isAcceptableOrUnknown(data['qty_terima']!, _qtyTerimaMeta),
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
  PurchaseOrderItemTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PurchaseOrderItemTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      poId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}po_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      ),
      qtyPesan: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_pesan'],
      )!,
      qtyTerima: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty_terima'],
      )!,
      hargaSatuan: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_satuan'],
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
  $PurchaseOrderItemTableTable createAlias(String alias) {
    return $PurchaseOrderItemTableTable(attachedDatabase, alias);
  }
}

class PurchaseOrderItemTableData extends DataClass
    implements Insertable<PurchaseOrderItemTableData> {
  final String id;
  final String poId;
  final String produkId;
  final String? namaProduk;
  final int qtyPesan;
  final int qtyTerima;
  final double hargaSatuan;
  final double subtotal;
  final String? satuanId;
  final double konversi;
  const PurchaseOrderItemTableData({
    required this.id,
    required this.poId,
    required this.produkId,
    this.namaProduk,
    required this.qtyPesan,
    required this.qtyTerima,
    required this.hargaSatuan,
    required this.subtotal,
    this.satuanId,
    required this.konversi,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['po_id'] = Variable<String>(poId);
    map['produk_id'] = Variable<String>(produkId);
    if (!nullToAbsent || namaProduk != null) {
      map['nama_produk'] = Variable<String>(namaProduk);
    }
    map['qty_pesan'] = Variable<int>(qtyPesan);
    map['qty_terima'] = Variable<int>(qtyTerima);
    map['harga_satuan'] = Variable<double>(hargaSatuan);
    map['subtotal'] = Variable<double>(subtotal);
    if (!nullToAbsent || satuanId != null) {
      map['satuan_id'] = Variable<String>(satuanId);
    }
    map['konversi'] = Variable<double>(konversi);
    return map;
  }

  PurchaseOrderItemTableCompanion toCompanion(bool nullToAbsent) {
    return PurchaseOrderItemTableCompanion(
      id: Value(id),
      poId: Value(poId),
      produkId: Value(produkId),
      namaProduk: namaProduk == null && nullToAbsent
          ? const Value.absent()
          : Value(namaProduk),
      qtyPesan: Value(qtyPesan),
      qtyTerima: Value(qtyTerima),
      hargaSatuan: Value(hargaSatuan),
      subtotal: Value(subtotal),
      satuanId: satuanId == null && nullToAbsent
          ? const Value.absent()
          : Value(satuanId),
      konversi: Value(konversi),
    );
  }

  factory PurchaseOrderItemTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PurchaseOrderItemTableData(
      id: serializer.fromJson<String>(json['id']),
      poId: serializer.fromJson<String>(json['poId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      namaProduk: serializer.fromJson<String?>(json['namaProduk']),
      qtyPesan: serializer.fromJson<int>(json['qtyPesan']),
      qtyTerima: serializer.fromJson<int>(json['qtyTerima']),
      hargaSatuan: serializer.fromJson<double>(json['hargaSatuan']),
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
      'poId': serializer.toJson<String>(poId),
      'produkId': serializer.toJson<String>(produkId),
      'namaProduk': serializer.toJson<String?>(namaProduk),
      'qtyPesan': serializer.toJson<int>(qtyPesan),
      'qtyTerima': serializer.toJson<int>(qtyTerima),
      'hargaSatuan': serializer.toJson<double>(hargaSatuan),
      'subtotal': serializer.toJson<double>(subtotal),
      'satuanId': serializer.toJson<String?>(satuanId),
      'konversi': serializer.toJson<double>(konversi),
    };
  }

  PurchaseOrderItemTableData copyWith({
    String? id,
    String? poId,
    String? produkId,
    Value<String?> namaProduk = const Value.absent(),
    int? qtyPesan,
    int? qtyTerima,
    double? hargaSatuan,
    double? subtotal,
    Value<String?> satuanId = const Value.absent(),
    double? konversi,
  }) => PurchaseOrderItemTableData(
    id: id ?? this.id,
    poId: poId ?? this.poId,
    produkId: produkId ?? this.produkId,
    namaProduk: namaProduk.present ? namaProduk.value : this.namaProduk,
    qtyPesan: qtyPesan ?? this.qtyPesan,
    qtyTerima: qtyTerima ?? this.qtyTerima,
    hargaSatuan: hargaSatuan ?? this.hargaSatuan,
    subtotal: subtotal ?? this.subtotal,
    satuanId: satuanId.present ? satuanId.value : this.satuanId,
    konversi: konversi ?? this.konversi,
  );
  PurchaseOrderItemTableData copyWithCompanion(
    PurchaseOrderItemTableCompanion data,
  ) {
    return PurchaseOrderItemTableData(
      id: data.id.present ? data.id.value : this.id,
      poId: data.poId.present ? data.poId.value : this.poId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
      qtyPesan: data.qtyPesan.present ? data.qtyPesan.value : this.qtyPesan,
      qtyTerima: data.qtyTerima.present ? data.qtyTerima.value : this.qtyTerima,
      hargaSatuan: data.hargaSatuan.present
          ? data.hargaSatuan.value
          : this.hargaSatuan,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      satuanId: data.satuanId.present ? data.satuanId.value : this.satuanId,
      konversi: data.konversi.present ? data.konversi.value : this.konversi,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PurchaseOrderItemTableData(')
          ..write('id: $id, ')
          ..write('poId: $poId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('qtyPesan: $qtyPesan, ')
          ..write('qtyTerima: $qtyTerima, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('subtotal: $subtotal, ')
          ..write('satuanId: $satuanId, ')
          ..write('konversi: $konversi')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    poId,
    produkId,
    namaProduk,
    qtyPesan,
    qtyTerima,
    hargaSatuan,
    subtotal,
    satuanId,
    konversi,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PurchaseOrderItemTableData &&
          other.id == this.id &&
          other.poId == this.poId &&
          other.produkId == this.produkId &&
          other.namaProduk == this.namaProduk &&
          other.qtyPesan == this.qtyPesan &&
          other.qtyTerima == this.qtyTerima &&
          other.hargaSatuan == this.hargaSatuan &&
          other.subtotal == this.subtotal &&
          other.satuanId == this.satuanId &&
          other.konversi == this.konversi);
}

class PurchaseOrderItemTableCompanion
    extends UpdateCompanion<PurchaseOrderItemTableData> {
  final Value<String> id;
  final Value<String> poId;
  final Value<String> produkId;
  final Value<String?> namaProduk;
  final Value<int> qtyPesan;
  final Value<int> qtyTerima;
  final Value<double> hargaSatuan;
  final Value<double> subtotal;
  final Value<String?> satuanId;
  final Value<double> konversi;
  final Value<int> rowid;
  const PurchaseOrderItemTableCompanion({
    this.id = const Value.absent(),
    this.poId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.namaProduk = const Value.absent(),
    this.qtyPesan = const Value.absent(),
    this.qtyTerima = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PurchaseOrderItemTableCompanion.insert({
    required String id,
    required String poId,
    required String produkId,
    this.namaProduk = const Value.absent(),
    this.qtyPesan = const Value.absent(),
    this.qtyTerima = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       poId = Value(poId),
       produkId = Value(produkId);
  static Insertable<PurchaseOrderItemTableData> custom({
    Expression<String>? id,
    Expression<String>? poId,
    Expression<String>? produkId,
    Expression<String>? namaProduk,
    Expression<int>? qtyPesan,
    Expression<int>? qtyTerima,
    Expression<double>? hargaSatuan,
    Expression<double>? subtotal,
    Expression<String>? satuanId,
    Expression<double>? konversi,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (poId != null) 'po_id': poId,
      if (produkId != null) 'produk_id': produkId,
      if (namaProduk != null) 'nama_produk': namaProduk,
      if (qtyPesan != null) 'qty_pesan': qtyPesan,
      if (qtyTerima != null) 'qty_terima': qtyTerima,
      if (hargaSatuan != null) 'harga_satuan': hargaSatuan,
      if (subtotal != null) 'subtotal': subtotal,
      if (satuanId != null) 'satuan_id': satuanId,
      if (konversi != null) 'konversi': konversi,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PurchaseOrderItemTableCompanion copyWith({
    Value<String>? id,
    Value<String>? poId,
    Value<String>? produkId,
    Value<String?>? namaProduk,
    Value<int>? qtyPesan,
    Value<int>? qtyTerima,
    Value<double>? hargaSatuan,
    Value<double>? subtotal,
    Value<String?>? satuanId,
    Value<double>? konversi,
    Value<int>? rowid,
  }) {
    return PurchaseOrderItemTableCompanion(
      id: id ?? this.id,
      poId: poId ?? this.poId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      qtyPesan: qtyPesan ?? this.qtyPesan,
      qtyTerima: qtyTerima ?? this.qtyTerima,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
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
    if (poId.present) {
      map['po_id'] = Variable<String>(poId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (namaProduk.present) {
      map['nama_produk'] = Variable<String>(namaProduk.value);
    }
    if (qtyPesan.present) {
      map['qty_pesan'] = Variable<int>(qtyPesan.value);
    }
    if (qtyTerima.present) {
      map['qty_terima'] = Variable<int>(qtyTerima.value);
    }
    if (hargaSatuan.present) {
      map['harga_satuan'] = Variable<double>(hargaSatuan.value);
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
    return (StringBuffer('PurchaseOrderItemTableCompanion(')
          ..write('id: $id, ')
          ..write('poId: $poId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('qtyPesan: $qtyPesan, ')
          ..write('qtyTerima: $qtyTerima, ')
          ..write('hargaSatuan: $hargaSatuan, ')
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
  List<GeneratedColumn> get $columns => [id, namaPelanggan, catatan, createdAt];
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
  final String namaPelanggan;
  final String? catatan;
  final DateTime createdAt;
  const PendingOrderTableData({
    required this.id,
    required this.namaPelanggan,
    this.catatan,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
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
      'namaPelanggan': serializer.toJson<String>(namaPelanggan),
      'catatan': serializer.toJson<String?>(catatan),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PendingOrderTableData copyWith({
    String? id,
    String? namaPelanggan,
    Value<String?> catatan = const Value.absent(),
    DateTime? createdAt,
  }) => PendingOrderTableData(
    id: id ?? this.id,
    namaPelanggan: namaPelanggan ?? this.namaPelanggan,
    catatan: catatan.present ? catatan.value : this.catatan,
    createdAt: createdAt ?? this.createdAt,
  );
  PendingOrderTableData copyWithCompanion(PendingOrderTableCompanion data) {
    return PendingOrderTableData(
      id: data.id.present ? data.id.value : this.id,
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
          ..write('namaPelanggan: $namaPelanggan, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, namaPelanggan, catatan, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingOrderTableData &&
          other.id == this.id &&
          other.namaPelanggan == this.namaPelanggan &&
          other.catatan == this.catatan &&
          other.createdAt == this.createdAt);
}

class PendingOrderTableCompanion
    extends UpdateCompanion<PendingOrderTableData> {
  final Value<String> id;
  final Value<String> namaPelanggan;
  final Value<String?> catatan;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const PendingOrderTableCompanion({
    this.id = const Value.absent(),
    this.namaPelanggan = const Value.absent(),
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PendingOrderTableCompanion.insert({
    required String id,
    required String namaPelanggan,
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       namaPelanggan = Value(namaPelanggan);
  static Insertable<PendingOrderTableData> custom({
    Expression<String>? id,
    Expression<String>? namaPelanggan,
    Expression<String>? catatan,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namaPelanggan != null) 'nama_pelanggan': namaPelanggan,
      if (catatan != null) 'catatan': catatan,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PendingOrderTableCompanion copyWith({
    Value<String>? id,
    Value<String>? namaPelanggan,
    Value<String?>? catatan,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return PendingOrderTableCompanion(
      id: id ?? this.id,
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
       pendingOrderId = Value(pendingOrderId),
       produkId = Value(produkId),
       namaProduk = Value(namaProduk);
  static Insertable<PendingOrderItemTableData> custom({
    Expression<String>? id,
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
    this.supplierId = const Value.absent(),
    this.namaSupplier = const Value.absent(),
    this.isPpnEnabled = const Value.absent(),
    this.ppnPercent = const Value.absent(),
    this.diskonTipe = const Value.absent(),
    this.diskonPersen = const Value.absent(),
    this.diskonNominal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<PendingPembelianTableData> custom({
    Expression<String>? id,
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
       pendingPembelianId = Value(pendingPembelianId),
       produkId = Value(produkId),
       namaProduk = Value(namaProduk);
  static Insertable<PendingPembelianItemTableData> custom({
    Expression<String>? id,
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
  final String judul;
  final String pesan;
  final String tipe;
  final bool isRead;
  final DateTime createdAt;
  const NotifikasiTableData({
    required this.id,
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
      'judul': serializer.toJson<String>(judul),
      'pesan': serializer.toJson<String>(pesan),
      'tipe': serializer.toJson<String>(tipe),
      'isRead': serializer.toJson<bool>(isRead),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NotifikasiTableData copyWith({
    String? id,
    String? judul,
    String? pesan,
    String? tipe,
    bool? isRead,
    DateTime? createdAt,
  }) => NotifikasiTableData(
    id: id ?? this.id,
    judul: judul ?? this.judul,
    pesan: pesan ?? this.pesan,
    tipe: tipe ?? this.tipe,
    isRead: isRead ?? this.isRead,
    createdAt: createdAt ?? this.createdAt,
  );
  NotifikasiTableData copyWithCompanion(NotifikasiTableCompanion data) {
    return NotifikasiTableData(
      id: data.id.present ? data.id.value : this.id,
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
          ..write('judul: $judul, ')
          ..write('pesan: $pesan, ')
          ..write('tipe: $tipe, ')
          ..write('isRead: $isRead, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, judul, pesan, tipe, isRead, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotifikasiTableData &&
          other.id == this.id &&
          other.judul == this.judul &&
          other.pesan == this.pesan &&
          other.tipe == this.tipe &&
          other.isRead == this.isRead &&
          other.createdAt == this.createdAt);
}

class NotifikasiTableCompanion extends UpdateCompanion<NotifikasiTableData> {
  final Value<String> id;
  final Value<String> judul;
  final Value<String> pesan;
  final Value<String> tipe;
  final Value<bool> isRead;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NotifikasiTableCompanion({
    this.id = const Value.absent(),
    this.judul = const Value.absent(),
    this.pesan = const Value.absent(),
    this.tipe = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotifikasiTableCompanion.insert({
    required String id,
    required String judul,
    required String pesan,
    this.tipe = const Value.absent(),
    this.isRead = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       judul = Value(judul),
       pesan = Value(pesan);
  static Insertable<NotifikasiTableData> custom({
    Expression<String>? id,
    Expression<String>? judul,
    Expression<String>? pesan,
    Expression<String>? tipe,
    Expression<bool>? isRead,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
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
    Value<String>? judul,
    Value<String>? pesan,
    Value<String>? tipe,
    Value<bool>? isRead,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return NotifikasiTableCompanion(
      id: id ?? this.id,
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
  final String produkId;
  final double hargaBeliLama;
  final double hargaBeliBaru;
  final double hargaJualLama;
  final double hargaJualBaru;
  final DateTime createdAt;
  const RiwayatHargaTableData({
    required this.id,
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
    String? produkId,
    double? hargaBeliLama,
    double? hargaBeliBaru,
    double? hargaJualLama,
    double? hargaJualBaru,
    DateTime? createdAt,
  }) => RiwayatHargaTableData(
    id: id ?? this.id,
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
  final Value<String> produkId;
  final Value<double> hargaBeliLama;
  final Value<double> hargaBeliBaru;
  final Value<double> hargaJualLama;
  final Value<double> hargaJualBaru;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RiwayatHargaTableCompanion({
    this.id = const Value.absent(),
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
    required String produkId,
    required double hargaBeliLama,
    required double hargaBeliBaru,
    required double hargaJualLama,
    required double hargaJualBaru,
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       produkId = Value(produkId),
       hargaBeliLama = Value(hargaBeliLama),
       hargaBeliBaru = Value(hargaBeliBaru),
       hargaJualLama = Value(hargaJualLama),
       hargaJualBaru = Value(hargaJualBaru);
  static Insertable<RiwayatHargaTableData> custom({
    Expression<String>? id,
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

class $LocalAuthTableTable extends LocalAuthTable
    with TableInfo<$LocalAuthTableTable, LocalAuthTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAuthTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinSaltMeta = const VerificationMeta(
    'pinSalt',
  );
  @override
  late final GeneratedColumn<String> pinSalt = GeneratedColumn<String>(
    'pin_salt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinLengthMeta = const VerificationMeta(
    'pinLength',
  );
  @override
  late final GeneratedColumn<int> pinLength = GeneratedColumn<int>(
    'pin_length',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(6),
  );
  static const VerificationMeta _biometricEnabledMeta = const VerificationMeta(
    'biometricEnabled',
  );
  @override
  late final GeneratedColumn<bool> biometricEnabled = GeneratedColumn<bool>(
    'biometric_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("biometric_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _failedAttemptsMeta = const VerificationMeta(
    'failedAttempts',
  );
  @override
  late final GeneratedColumn<int> failedAttempts = GeneratedColumn<int>(
    'failed_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lockoutUntilMeta = const VerificationMeta(
    'lockoutUntil',
  );
  @override
  late final GeneratedColumn<DateTime> lockoutUntil = GeneratedColumn<DateTime>(
    'lockout_until',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    pinHash,
    pinSalt,
    pinLength,
    biometricEnabled,
    failedAttempts,
    lockoutUntil,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_auth_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAuthTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('pin_salt')) {
      context.handle(
        _pinSaltMeta,
        pinSalt.isAcceptableOrUnknown(data['pin_salt']!, _pinSaltMeta),
      );
    }
    if (data.containsKey('pin_length')) {
      context.handle(
        _pinLengthMeta,
        pinLength.isAcceptableOrUnknown(data['pin_length']!, _pinLengthMeta),
      );
    }
    if (data.containsKey('biometric_enabled')) {
      context.handle(
        _biometricEnabledMeta,
        biometricEnabled.isAcceptableOrUnknown(
          data['biometric_enabled']!,
          _biometricEnabledMeta,
        ),
      );
    }
    if (data.containsKey('failed_attempts')) {
      context.handle(
        _failedAttemptsMeta,
        failedAttempts.isAcceptableOrUnknown(
          data['failed_attempts']!,
          _failedAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('lockout_until')) {
      context.handle(
        _lockoutUntilMeta,
        lockoutUntil.isAcceptableOrUnknown(
          data['lockout_until']!,
          _lockoutUntilMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  LocalAuthTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAuthTableData(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      pinSalt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_salt'],
      ),
      pinLength: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pin_length'],
      )!,
      biometricEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}biometric_enabled'],
      )!,
      failedAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}failed_attempts'],
      )!,
      lockoutUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}lockout_until'],
      ),
    );
  }

  @override
  $LocalAuthTableTable createAlias(String alias) {
    return $LocalAuthTableTable(attachedDatabase, alias);
  }
}

class LocalAuthTableData extends DataClass
    implements Insertable<LocalAuthTableData> {
  final String userId;
  final String pinHash;
  final String? pinSalt;
  final int pinLength;
  final bool biometricEnabled;
  final int failedAttempts;
  final DateTime? lockoutUntil;
  const LocalAuthTableData({
    required this.userId,
    required this.pinHash,
    this.pinSalt,
    required this.pinLength,
    required this.biometricEnabled,
    required this.failedAttempts,
    this.lockoutUntil,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['pin_hash'] = Variable<String>(pinHash);
    if (!nullToAbsent || pinSalt != null) {
      map['pin_salt'] = Variable<String>(pinSalt);
    }
    map['pin_length'] = Variable<int>(pinLength);
    map['biometric_enabled'] = Variable<bool>(biometricEnabled);
    map['failed_attempts'] = Variable<int>(failedAttempts);
    if (!nullToAbsent || lockoutUntil != null) {
      map['lockout_until'] = Variable<DateTime>(lockoutUntil);
    }
    return map;
  }

  LocalAuthTableCompanion toCompanion(bool nullToAbsent) {
    return LocalAuthTableCompanion(
      userId: Value(userId),
      pinHash: Value(pinHash),
      pinSalt: pinSalt == null && nullToAbsent
          ? const Value.absent()
          : Value(pinSalt),
      pinLength: Value(pinLength),
      biometricEnabled: Value(biometricEnabled),
      failedAttempts: Value(failedAttempts),
      lockoutUntil: lockoutUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(lockoutUntil),
    );
  }

  factory LocalAuthTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAuthTableData(
      userId: serializer.fromJson<String>(json['userId']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      pinSalt: serializer.fromJson<String?>(json['pinSalt']),
      pinLength: serializer.fromJson<int>(json['pinLength']),
      biometricEnabled: serializer.fromJson<bool>(json['biometricEnabled']),
      failedAttempts: serializer.fromJson<int>(json['failedAttempts']),
      lockoutUntil: serializer.fromJson<DateTime?>(json['lockoutUntil']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'pinHash': serializer.toJson<String>(pinHash),
      'pinSalt': serializer.toJson<String?>(pinSalt),
      'pinLength': serializer.toJson<int>(pinLength),
      'biometricEnabled': serializer.toJson<bool>(biometricEnabled),
      'failedAttempts': serializer.toJson<int>(failedAttempts),
      'lockoutUntil': serializer.toJson<DateTime?>(lockoutUntil),
    };
  }

  LocalAuthTableData copyWith({
    String? userId,
    String? pinHash,
    Value<String?> pinSalt = const Value.absent(),
    int? pinLength,
    bool? biometricEnabled,
    int? failedAttempts,
    Value<DateTime?> lockoutUntil = const Value.absent(),
  }) => LocalAuthTableData(
    userId: userId ?? this.userId,
    pinHash: pinHash ?? this.pinHash,
    pinSalt: pinSalt.present ? pinSalt.value : this.pinSalt,
    pinLength: pinLength ?? this.pinLength,
    biometricEnabled: biometricEnabled ?? this.biometricEnabled,
    failedAttempts: failedAttempts ?? this.failedAttempts,
    lockoutUntil: lockoutUntil.present ? lockoutUntil.value : this.lockoutUntil,
  );
  LocalAuthTableData copyWithCompanion(LocalAuthTableCompanion data) {
    return LocalAuthTableData(
      userId: data.userId.present ? data.userId.value : this.userId,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      pinSalt: data.pinSalt.present ? data.pinSalt.value : this.pinSalt,
      pinLength: data.pinLength.present ? data.pinLength.value : this.pinLength,
      biometricEnabled: data.biometricEnabled.present
          ? data.biometricEnabled.value
          : this.biometricEnabled,
      failedAttempts: data.failedAttempts.present
          ? data.failedAttempts.value
          : this.failedAttempts,
      lockoutUntil: data.lockoutUntil.present
          ? data.lockoutUntil.value
          : this.lockoutUntil,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAuthTableData(')
          ..write('userId: $userId, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinLength: $pinLength, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockoutUntil: $lockoutUntil')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    pinHash,
    pinSalt,
    pinLength,
    biometricEnabled,
    failedAttempts,
    lockoutUntil,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAuthTableData &&
          other.userId == this.userId &&
          other.pinHash == this.pinHash &&
          other.pinSalt == this.pinSalt &&
          other.pinLength == this.pinLength &&
          other.biometricEnabled == this.biometricEnabled &&
          other.failedAttempts == this.failedAttempts &&
          other.lockoutUntil == this.lockoutUntil);
}

class LocalAuthTableCompanion extends UpdateCompanion<LocalAuthTableData> {
  final Value<String> userId;
  final Value<String> pinHash;
  final Value<String?> pinSalt;
  final Value<int> pinLength;
  final Value<bool> biometricEnabled;
  final Value<int> failedAttempts;
  final Value<DateTime?> lockoutUntil;
  final Value<int> rowid;
  const LocalAuthTableCompanion({
    this.userId = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.pinSalt = const Value.absent(),
    this.pinLength = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockoutUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAuthTableCompanion.insert({
    required String userId,
    required String pinHash,
    this.pinSalt = const Value.absent(),
    this.pinLength = const Value.absent(),
    this.biometricEnabled = const Value.absent(),
    this.failedAttempts = const Value.absent(),
    this.lockoutUntil = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       pinHash = Value(pinHash);
  static Insertable<LocalAuthTableData> custom({
    Expression<String>? userId,
    Expression<String>? pinHash,
    Expression<String>? pinSalt,
    Expression<int>? pinLength,
    Expression<bool>? biometricEnabled,
    Expression<int>? failedAttempts,
    Expression<DateTime>? lockoutUntil,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (pinHash != null) 'pin_hash': pinHash,
      if (pinSalt != null) 'pin_salt': pinSalt,
      if (pinLength != null) 'pin_length': pinLength,
      if (biometricEnabled != null) 'biometric_enabled': biometricEnabled,
      if (failedAttempts != null) 'failed_attempts': failedAttempts,
      if (lockoutUntil != null) 'lockout_until': lockoutUntil,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAuthTableCompanion copyWith({
    Value<String>? userId,
    Value<String>? pinHash,
    Value<String?>? pinSalt,
    Value<int>? pinLength,
    Value<bool>? biometricEnabled,
    Value<int>? failedAttempts,
    Value<DateTime?>? lockoutUntil,
    Value<int>? rowid,
  }) {
    return LocalAuthTableCompanion(
      userId: userId ?? this.userId,
      pinHash: pinHash ?? this.pinHash,
      pinSalt: pinSalt ?? this.pinSalt,
      pinLength: pinLength ?? this.pinLength,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (pinSalt.present) {
      map['pin_salt'] = Variable<String>(pinSalt.value);
    }
    if (pinLength.present) {
      map['pin_length'] = Variable<int>(pinLength.value);
    }
    if (biometricEnabled.present) {
      map['biometric_enabled'] = Variable<bool>(biometricEnabled.value);
    }
    if (failedAttempts.present) {
      map['failed_attempts'] = Variable<int>(failedAttempts.value);
    }
    if (lockoutUntil.present) {
      map['lockout_until'] = Variable<DateTime>(lockoutUntil.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAuthTableCompanion(')
          ..write('userId: $userId, ')
          ..write('pinHash: $pinHash, ')
          ..write('pinSalt: $pinSalt, ')
          ..write('pinLength: $pinLength, ')
          ..write('biometricEnabled: $biometricEnabled, ')
          ..write('failedAttempts: $failedAttempts, ')
          ..write('lockoutUntil: $lockoutUntil, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OnlineCustomerTableTable extends OnlineCustomerTable
    with TableInfo<$OnlineCustomerTableTable, OnlineCustomer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnlineCustomerTableTable(this.attachedDatabase, [this._alias]);
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
    nama,
    telepon,
    alamat,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'online_customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnlineCustomer> instance, {
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
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
  OnlineCustomer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnlineCustomer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OnlineCustomerTableTable createAlias(String alias) {
    return $OnlineCustomerTableTable(attachedDatabase, alias);
  }
}

class OnlineCustomer extends DataClass implements Insertable<OnlineCustomer> {
  final String id;
  final String nama;
  final String? telepon;
  final String? alamat;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OnlineCustomer({
    required this.id,
    required this.nama,
    this.telepon,
    this.alamat,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['nama'] = Variable<String>(nama);
    if (!nullToAbsent || telepon != null) {
      map['telepon'] = Variable<String>(telepon);
    }
    if (!nullToAbsent || alamat != null) {
      map['alamat'] = Variable<String>(alamat);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OnlineCustomerTableCompanion toCompanion(bool nullToAbsent) {
    return OnlineCustomerTableCompanion(
      id: Value(id),
      nama: Value(nama),
      telepon: telepon == null && nullToAbsent
          ? const Value.absent()
          : Value(telepon),
      alamat: alamat == null && nullToAbsent
          ? const Value.absent()
          : Value(alamat),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OnlineCustomer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnlineCustomer(
      id: serializer.fromJson<String>(json['id']),
      nama: serializer.fromJson<String>(json['nama']),
      telepon: serializer.fromJson<String?>(json['telepon']),
      alamat: serializer.fromJson<String?>(json['alamat']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nama': serializer.toJson<String>(nama),
      'telepon': serializer.toJson<String?>(telepon),
      'alamat': serializer.toJson<String?>(alamat),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OnlineCustomer copyWith({
    String? id,
    String? nama,
    Value<String?> telepon = const Value.absent(),
    Value<String?> alamat = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OnlineCustomer(
    id: id ?? this.id,
    nama: nama ?? this.nama,
    telepon: telepon.present ? telepon.value : this.telepon,
    alamat: alamat.present ? alamat.value : this.alamat,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OnlineCustomer copyWithCompanion(OnlineCustomerTableCompanion data) {
    return OnlineCustomer(
      id: data.id.present ? data.id.value : this.id,
      nama: data.nama.present ? data.nama.value : this.nama,
      telepon: data.telepon.present ? data.telepon.value : this.telepon,
      alamat: data.alamat.present ? data.alamat.value : this.alamat,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnlineCustomer(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('telepon: $telepon, ')
          ..write('alamat: $alamat, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, nama, telepon, alamat, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnlineCustomer &&
          other.id == this.id &&
          other.nama == this.nama &&
          other.telepon == this.telepon &&
          other.alamat == this.alamat &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OnlineCustomerTableCompanion extends UpdateCompanion<OnlineCustomer> {
  final Value<String> id;
  final Value<String> nama;
  final Value<String?> telepon;
  final Value<String?> alamat;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OnlineCustomerTableCompanion({
    this.id = const Value.absent(),
    this.nama = const Value.absent(),
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OnlineCustomerTableCompanion.insert({
    required String id,
    required String nama,
    this.telepon = const Value.absent(),
    this.alamat = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       nama = Value(nama);
  static Insertable<OnlineCustomer> custom({
    Expression<String>? id,
    Expression<String>? nama,
    Expression<String>? telepon,
    Expression<String>? alamat,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nama != null) 'nama': nama,
      if (telepon != null) 'telepon': telepon,
      if (alamat != null) 'alamat': alamat,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OnlineCustomerTableCompanion copyWith({
    Value<String>? id,
    Value<String>? nama,
    Value<String?>? telepon,
    Value<String?>? alamat,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OnlineCustomerTableCompanion(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      createdAt: createdAt ?? this.createdAt,
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
    if (nama.present) {
      map['nama'] = Variable<String>(nama.value);
    }
    if (telepon.present) {
      map['telepon'] = Variable<String>(telepon.value);
    }
    if (alamat.present) {
      map['alamat'] = Variable<String>(alamat.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('OnlineCustomerTableCompanion(')
          ..write('id: $id, ')
          ..write('nama: $nama, ')
          ..write('telepon: $telepon, ')
          ..write('alamat: $alamat, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OnlineOrderTableTable extends OnlineOrderTable
    with TableInfo<$OnlineOrderTableTable, OnlineOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnlineOrderTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES online_customers (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
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
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _metodePengirimanMeta = const VerificationMeta(
    'metodePengiriman',
  );
  @override
  late final GeneratedColumn<String> metodePengiriman = GeneratedColumn<String>(
    'metode_pengiriman',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pickup'),
  );
  static const VerificationMeta _alamatPengirimanMeta = const VerificationMeta(
    'alamatPengiriman',
  );
  @override
  late final GeneratedColumn<String> alamatPengiriman = GeneratedColumn<String>(
    'alamat_pengiriman',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    customerId,
    status,
    totalHarga,
    metodePengiriman,
    alamatPengiriman,
    catatan,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'online_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnlineOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_customerIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('total_harga')) {
      context.handle(
        _totalHargaMeta,
        totalHarga.isAcceptableOrUnknown(data['total_harga']!, _totalHargaMeta),
      );
    }
    if (data.containsKey('metode_pengiriman')) {
      context.handle(
        _metodePengirimanMeta,
        metodePengiriman.isAcceptableOrUnknown(
          data['metode_pengiriman']!,
          _metodePengirimanMeta,
        ),
      );
    }
    if (data.containsKey('alamat_pengiriman')) {
      context.handle(
        _alamatPengirimanMeta,
        alamatPengiriman.isAcceptableOrUnknown(
          data['alamat_pengiriman']!,
          _alamatPengirimanMeta,
        ),
      );
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
  OnlineOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnlineOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      totalHarga: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_harga'],
      )!,
      metodePengiriman: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metode_pengiriman'],
      )!,
      alamatPengiriman: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alamat_pengiriman'],
      ),
      catatan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catatan'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $OnlineOrderTableTable createAlias(String alias) {
    return $OnlineOrderTableTable(attachedDatabase, alias);
  }
}

class OnlineOrder extends DataClass implements Insertable<OnlineOrder> {
  final String id;
  final String customerId;
  final String status;
  final double totalHarga;
  final String metodePengiriman;
  final String? alamatPengiriman;
  final String? catatan;
  final DateTime createdAt;
  final DateTime updatedAt;
  const OnlineOrder({
    required this.id,
    required this.customerId,
    required this.status,
    required this.totalHarga,
    required this.metodePengiriman,
    this.alamatPengiriman,
    this.catatan,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['customer_id'] = Variable<String>(customerId);
    map['status'] = Variable<String>(status);
    map['total_harga'] = Variable<double>(totalHarga);
    map['metode_pengiriman'] = Variable<String>(metodePengiriman);
    if (!nullToAbsent || alamatPengiriman != null) {
      map['alamat_pengiriman'] = Variable<String>(alamatPengiriman);
    }
    if (!nullToAbsent || catatan != null) {
      map['catatan'] = Variable<String>(catatan);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  OnlineOrderTableCompanion toCompanion(bool nullToAbsent) {
    return OnlineOrderTableCompanion(
      id: Value(id),
      customerId: Value(customerId),
      status: Value(status),
      totalHarga: Value(totalHarga),
      metodePengiriman: Value(metodePengiriman),
      alamatPengiriman: alamatPengiriman == null && nullToAbsent
          ? const Value.absent()
          : Value(alamatPengiriman),
      catatan: catatan == null && nullToAbsent
          ? const Value.absent()
          : Value(catatan),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory OnlineOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnlineOrder(
      id: serializer.fromJson<String>(json['id']),
      customerId: serializer.fromJson<String>(json['customerId']),
      status: serializer.fromJson<String>(json['status']),
      totalHarga: serializer.fromJson<double>(json['totalHarga']),
      metodePengiriman: serializer.fromJson<String>(json['metodePengiriman']),
      alamatPengiriman: serializer.fromJson<String?>(json['alamatPengiriman']),
      catatan: serializer.fromJson<String?>(json['catatan']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'customerId': serializer.toJson<String>(customerId),
      'status': serializer.toJson<String>(status),
      'totalHarga': serializer.toJson<double>(totalHarga),
      'metodePengiriman': serializer.toJson<String>(metodePengiriman),
      'alamatPengiriman': serializer.toJson<String?>(alamatPengiriman),
      'catatan': serializer.toJson<String?>(catatan),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  OnlineOrder copyWith({
    String? id,
    String? customerId,
    String? status,
    double? totalHarga,
    String? metodePengiriman,
    Value<String?> alamatPengiriman = const Value.absent(),
    Value<String?> catatan = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => OnlineOrder(
    id: id ?? this.id,
    customerId: customerId ?? this.customerId,
    status: status ?? this.status,
    totalHarga: totalHarga ?? this.totalHarga,
    metodePengiriman: metodePengiriman ?? this.metodePengiriman,
    alamatPengiriman: alamatPengiriman.present
        ? alamatPengiriman.value
        : this.alamatPengiriman,
    catatan: catatan.present ? catatan.value : this.catatan,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  OnlineOrder copyWithCompanion(OnlineOrderTableCompanion data) {
    return OnlineOrder(
      id: data.id.present ? data.id.value : this.id,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      status: data.status.present ? data.status.value : this.status,
      totalHarga: data.totalHarga.present
          ? data.totalHarga.value
          : this.totalHarga,
      metodePengiriman: data.metodePengiriman.present
          ? data.metodePengiriman.value
          : this.metodePengiriman,
      alamatPengiriman: data.alamatPengiriman.present
          ? data.alamatPengiriman.value
          : this.alamatPengiriman,
      catatan: data.catatan.present ? data.catatan.value : this.catatan,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnlineOrder(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('totalHarga: $totalHarga, ')
          ..write('metodePengiriman: $metodePengiriman, ')
          ..write('alamatPengiriman: $alamatPengiriman, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerId,
    status,
    totalHarga,
    metodePengiriman,
    alamatPengiriman,
    catatan,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnlineOrder &&
          other.id == this.id &&
          other.customerId == this.customerId &&
          other.status == this.status &&
          other.totalHarga == this.totalHarga &&
          other.metodePengiriman == this.metodePengiriman &&
          other.alamatPengiriman == this.alamatPengiriman &&
          other.catatan == this.catatan &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class OnlineOrderTableCompanion extends UpdateCompanion<OnlineOrder> {
  final Value<String> id;
  final Value<String> customerId;
  final Value<String> status;
  final Value<double> totalHarga;
  final Value<String> metodePengiriman;
  final Value<String?> alamatPengiriman;
  final Value<String?> catatan;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const OnlineOrderTableCompanion({
    this.id = const Value.absent(),
    this.customerId = const Value.absent(),
    this.status = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.metodePengiriman = const Value.absent(),
    this.alamatPengiriman = const Value.absent(),
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OnlineOrderTableCompanion.insert({
    required String id,
    required String customerId,
    this.status = const Value.absent(),
    this.totalHarga = const Value.absent(),
    this.metodePengiriman = const Value.absent(),
    this.alamatPengiriman = const Value.absent(),
    this.catatan = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       customerId = Value(customerId);
  static Insertable<OnlineOrder> custom({
    Expression<String>? id,
    Expression<String>? customerId,
    Expression<String>? status,
    Expression<double>? totalHarga,
    Expression<String>? metodePengiriman,
    Expression<String>? alamatPengiriman,
    Expression<String>? catatan,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerId != null) 'customer_id': customerId,
      if (status != null) 'status': status,
      if (totalHarga != null) 'total_harga': totalHarga,
      if (metodePengiriman != null) 'metode_pengiriman': metodePengiriman,
      if (alamatPengiriman != null) 'alamat_pengiriman': alamatPengiriman,
      if (catatan != null) 'catatan': catatan,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OnlineOrderTableCompanion copyWith({
    Value<String>? id,
    Value<String>? customerId,
    Value<String>? status,
    Value<double>? totalHarga,
    Value<String>? metodePengiriman,
    Value<String?>? alamatPengiriman,
    Value<String?>? catatan,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return OnlineOrderTableCompanion(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      totalHarga: totalHarga ?? this.totalHarga,
      metodePengiriman: metodePengiriman ?? this.metodePengiriman,
      alamatPengiriman: alamatPengiriman ?? this.alamatPengiriman,
      catatan: catatan ?? this.catatan,
      createdAt: createdAt ?? this.createdAt,
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
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (totalHarga.present) {
      map['total_harga'] = Variable<double>(totalHarga.value);
    }
    if (metodePengiriman.present) {
      map['metode_pengiriman'] = Variable<String>(metodePengiriman.value);
    }
    if (alamatPengiriman.present) {
      map['alamat_pengiriman'] = Variable<String>(alamatPengiriman.value);
    }
    if (catatan.present) {
      map['catatan'] = Variable<String>(catatan.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('OnlineOrderTableCompanion(')
          ..write('id: $id, ')
          ..write('customerId: $customerId, ')
          ..write('status: $status, ')
          ..write('totalHarga: $totalHarga, ')
          ..write('metodePengiriman: $metodePengiriman, ')
          ..write('alamatPengiriman: $alamatPengiriman, ')
          ..write('catatan: $catatan, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OnlineOrderItemTableTable extends OnlineOrderItemTable
    with TableInfo<$OnlineOrderItemTableTable, OnlineOrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnlineOrderItemTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _onlineOrderIdMeta = const VerificationMeta(
    'onlineOrderId',
  );
  @override
  late final GeneratedColumn<String> onlineOrderId = GeneratedColumn<String>(
    'online_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES online_orders (id)',
    ),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES produk_table (id)',
    ),
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
    defaultValue: const Constant(0.0),
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
    defaultValue: const Constant(0.0),
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES satuan_produk_table (id)',
    ),
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
  static const VerificationMeta _isUnavailableMeta = const VerificationMeta(
    'isUnavailable',
  );
  @override
  late final GeneratedColumn<bool> isUnavailable = GeneratedColumn<bool>(
    'is_unavailable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_unavailable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    onlineOrderId,
    produkId,
    namaProduk,
    hargaSatuan,
    jumlah,
    subtotal,
    satuanId,
    konversi,
    isUnavailable,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'online_order_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnlineOrderItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('online_order_id')) {
      context.handle(
        _onlineOrderIdMeta,
        onlineOrderId.isAcceptableOrUnknown(
          data['online_order_id']!,
          _onlineOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_onlineOrderIdMeta);
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
    if (data.containsKey('harga_satuan')) {
      context.handle(
        _hargaSatuanMeta,
        hargaSatuan.isAcceptableOrUnknown(
          data['harga_satuan']!,
          _hargaSatuanMeta,
        ),
      );
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
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
    if (data.containsKey('is_unavailable')) {
      context.handle(
        _isUnavailableMeta,
        isUnavailable.isAcceptableOrUnknown(
          data['is_unavailable']!,
          _isUnavailableMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OnlineOrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnlineOrderItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      onlineOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}online_order_id'],
      )!,
      produkId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}produk_id'],
      )!,
      namaProduk: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}nama_produk'],
      )!,
      hargaSatuan: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}harga_satuan'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}jumlah'],
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
      isUnavailable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_unavailable'],
      )!,
    );
  }

  @override
  $OnlineOrderItemTableTable createAlias(String alias) {
    return $OnlineOrderItemTableTable(attachedDatabase, alias);
  }
}

class OnlineOrderItem extends DataClass implements Insertable<OnlineOrderItem> {
  final String id;
  final String onlineOrderId;
  final String produkId;
  final String namaProduk;
  final double hargaSatuan;
  final int jumlah;
  final double subtotal;
  final String? satuanId;
  final double konversi;
  final bool isUnavailable;
  const OnlineOrderItem({
    required this.id,
    required this.onlineOrderId,
    required this.produkId,
    required this.namaProduk,
    required this.hargaSatuan,
    required this.jumlah,
    required this.subtotal,
    this.satuanId,
    required this.konversi,
    required this.isUnavailable,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['online_order_id'] = Variable<String>(onlineOrderId);
    map['produk_id'] = Variable<String>(produkId);
    map['nama_produk'] = Variable<String>(namaProduk);
    map['harga_satuan'] = Variable<double>(hargaSatuan);
    map['jumlah'] = Variable<int>(jumlah);
    map['subtotal'] = Variable<double>(subtotal);
    if (!nullToAbsent || satuanId != null) {
      map['satuan_id'] = Variable<String>(satuanId);
    }
    map['konversi'] = Variable<double>(konversi);
    map['is_unavailable'] = Variable<bool>(isUnavailable);
    return map;
  }

  OnlineOrderItemTableCompanion toCompanion(bool nullToAbsent) {
    return OnlineOrderItemTableCompanion(
      id: Value(id),
      onlineOrderId: Value(onlineOrderId),
      produkId: Value(produkId),
      namaProduk: Value(namaProduk),
      hargaSatuan: Value(hargaSatuan),
      jumlah: Value(jumlah),
      subtotal: Value(subtotal),
      satuanId: satuanId == null && nullToAbsent
          ? const Value.absent()
          : Value(satuanId),
      konversi: Value(konversi),
      isUnavailable: Value(isUnavailable),
    );
  }

  factory OnlineOrderItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnlineOrderItem(
      id: serializer.fromJson<String>(json['id']),
      onlineOrderId: serializer.fromJson<String>(json['onlineOrderId']),
      produkId: serializer.fromJson<String>(json['produkId']),
      namaProduk: serializer.fromJson<String>(json['namaProduk']),
      hargaSatuan: serializer.fromJson<double>(json['hargaSatuan']),
      jumlah: serializer.fromJson<int>(json['jumlah']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      satuanId: serializer.fromJson<String?>(json['satuanId']),
      konversi: serializer.fromJson<double>(json['konversi']),
      isUnavailable: serializer.fromJson<bool>(json['isUnavailable']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'onlineOrderId': serializer.toJson<String>(onlineOrderId),
      'produkId': serializer.toJson<String>(produkId),
      'namaProduk': serializer.toJson<String>(namaProduk),
      'hargaSatuan': serializer.toJson<double>(hargaSatuan),
      'jumlah': serializer.toJson<int>(jumlah),
      'subtotal': serializer.toJson<double>(subtotal),
      'satuanId': serializer.toJson<String?>(satuanId),
      'konversi': serializer.toJson<double>(konversi),
      'isUnavailable': serializer.toJson<bool>(isUnavailable),
    };
  }

  OnlineOrderItem copyWith({
    String? id,
    String? onlineOrderId,
    String? produkId,
    String? namaProduk,
    double? hargaSatuan,
    int? jumlah,
    double? subtotal,
    Value<String?> satuanId = const Value.absent(),
    double? konversi,
    bool? isUnavailable,
  }) => OnlineOrderItem(
    id: id ?? this.id,
    onlineOrderId: onlineOrderId ?? this.onlineOrderId,
    produkId: produkId ?? this.produkId,
    namaProduk: namaProduk ?? this.namaProduk,
    hargaSatuan: hargaSatuan ?? this.hargaSatuan,
    jumlah: jumlah ?? this.jumlah,
    subtotal: subtotal ?? this.subtotal,
    satuanId: satuanId.present ? satuanId.value : this.satuanId,
    konversi: konversi ?? this.konversi,
    isUnavailable: isUnavailable ?? this.isUnavailable,
  );
  OnlineOrderItem copyWithCompanion(OnlineOrderItemTableCompanion data) {
    return OnlineOrderItem(
      id: data.id.present ? data.id.value : this.id,
      onlineOrderId: data.onlineOrderId.present
          ? data.onlineOrderId.value
          : this.onlineOrderId,
      produkId: data.produkId.present ? data.produkId.value : this.produkId,
      namaProduk: data.namaProduk.present
          ? data.namaProduk.value
          : this.namaProduk,
      hargaSatuan: data.hargaSatuan.present
          ? data.hargaSatuan.value
          : this.hargaSatuan,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      satuanId: data.satuanId.present ? data.satuanId.value : this.satuanId,
      konversi: data.konversi.present ? data.konversi.value : this.konversi,
      isUnavailable: data.isUnavailable.present
          ? data.isUnavailable.value
          : this.isUnavailable,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnlineOrderItem(')
          ..write('id: $id, ')
          ..write('onlineOrderId: $onlineOrderId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('jumlah: $jumlah, ')
          ..write('subtotal: $subtotal, ')
          ..write('satuanId: $satuanId, ')
          ..write('konversi: $konversi, ')
          ..write('isUnavailable: $isUnavailable')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    onlineOrderId,
    produkId,
    namaProduk,
    hargaSatuan,
    jumlah,
    subtotal,
    satuanId,
    konversi,
    isUnavailable,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnlineOrderItem &&
          other.id == this.id &&
          other.onlineOrderId == this.onlineOrderId &&
          other.produkId == this.produkId &&
          other.namaProduk == this.namaProduk &&
          other.hargaSatuan == this.hargaSatuan &&
          other.jumlah == this.jumlah &&
          other.subtotal == this.subtotal &&
          other.satuanId == this.satuanId &&
          other.konversi == this.konversi &&
          other.isUnavailable == this.isUnavailable);
}

class OnlineOrderItemTableCompanion extends UpdateCompanion<OnlineOrderItem> {
  final Value<String> id;
  final Value<String> onlineOrderId;
  final Value<String> produkId;
  final Value<String> namaProduk;
  final Value<double> hargaSatuan;
  final Value<int> jumlah;
  final Value<double> subtotal;
  final Value<String?> satuanId;
  final Value<double> konversi;
  final Value<bool> isUnavailable;
  final Value<int> rowid;
  const OnlineOrderItemTableCompanion({
    this.id = const Value.absent(),
    this.onlineOrderId = const Value.absent(),
    this.produkId = const Value.absent(),
    this.namaProduk = const Value.absent(),
    this.hargaSatuan = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.isUnavailable = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OnlineOrderItemTableCompanion.insert({
    required String id,
    required String onlineOrderId,
    required String produkId,
    required String namaProduk,
    this.hargaSatuan = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.satuanId = const Value.absent(),
    this.konversi = const Value.absent(),
    this.isUnavailable = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       onlineOrderId = Value(onlineOrderId),
       produkId = Value(produkId),
       namaProduk = Value(namaProduk);
  static Insertable<OnlineOrderItem> custom({
    Expression<String>? id,
    Expression<String>? onlineOrderId,
    Expression<String>? produkId,
    Expression<String>? namaProduk,
    Expression<double>? hargaSatuan,
    Expression<int>? jumlah,
    Expression<double>? subtotal,
    Expression<String>? satuanId,
    Expression<double>? konversi,
    Expression<bool>? isUnavailable,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (onlineOrderId != null) 'online_order_id': onlineOrderId,
      if (produkId != null) 'produk_id': produkId,
      if (namaProduk != null) 'nama_produk': namaProduk,
      if (hargaSatuan != null) 'harga_satuan': hargaSatuan,
      if (jumlah != null) 'jumlah': jumlah,
      if (subtotal != null) 'subtotal': subtotal,
      if (satuanId != null) 'satuan_id': satuanId,
      if (konversi != null) 'konversi': konversi,
      if (isUnavailable != null) 'is_unavailable': isUnavailable,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OnlineOrderItemTableCompanion copyWith({
    Value<String>? id,
    Value<String>? onlineOrderId,
    Value<String>? produkId,
    Value<String>? namaProduk,
    Value<double>? hargaSatuan,
    Value<int>? jumlah,
    Value<double>? subtotal,
    Value<String?>? satuanId,
    Value<double>? konversi,
    Value<bool>? isUnavailable,
    Value<int>? rowid,
  }) {
    return OnlineOrderItemTableCompanion(
      id: id ?? this.id,
      onlineOrderId: onlineOrderId ?? this.onlineOrderId,
      produkId: produkId ?? this.produkId,
      namaProduk: namaProduk ?? this.namaProduk,
      hargaSatuan: hargaSatuan ?? this.hargaSatuan,
      jumlah: jumlah ?? this.jumlah,
      subtotal: subtotal ?? this.subtotal,
      satuanId: satuanId ?? this.satuanId,
      konversi: konversi ?? this.konversi,
      isUnavailable: isUnavailable ?? this.isUnavailable,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (onlineOrderId.present) {
      map['online_order_id'] = Variable<String>(onlineOrderId.value);
    }
    if (produkId.present) {
      map['produk_id'] = Variable<String>(produkId.value);
    }
    if (namaProduk.present) {
      map['nama_produk'] = Variable<String>(namaProduk.value);
    }
    if (hargaSatuan.present) {
      map['harga_satuan'] = Variable<double>(hargaSatuan.value);
    }
    if (jumlah.present) {
      map['jumlah'] = Variable<int>(jumlah.value);
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
    if (isUnavailable.present) {
      map['is_unavailable'] = Variable<bool>(isUnavailable.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OnlineOrderItemTableCompanion(')
          ..write('id: $id, ')
          ..write('onlineOrderId: $onlineOrderId, ')
          ..write('produkId: $produkId, ')
          ..write('namaProduk: $namaProduk, ')
          ..write('hargaSatuan: $hargaSatuan, ')
          ..write('jumlah: $jumlah, ')
          ..write('subtotal: $subtotal, ')
          ..write('satuanId: $satuanId, ')
          ..write('konversi: $konversi, ')
          ..write('isUnavailable: $isUnavailable, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KasHarianTableTable extends KasHarianTable
    with TableInfo<$KasHarianTableTable, KasHarianTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KasHarianTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modalAwalMeta = const VerificationMeta(
    'modalAwal',
  );
  @override
  late final GeneratedColumn<double> modalAwal = GeneratedColumn<double>(
    'modal_awal',
    aliasedName,
    false,
    type: DriftSqlType.double,
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
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
    modalAwal,
    keterangan,
    tanggal,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'kas_harian_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<KasHarianTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('modal_awal')) {
      context.handle(
        _modalAwalMeta,
        modalAwal.isAcceptableOrUnknown(data['modal_awal']!, _modalAwalMeta),
      );
    }
    if (data.containsKey('keterangan')) {
      context.handle(
        _keteranganMeta,
        keterangan.isAcceptableOrUnknown(data['keterangan']!, _keteranganMeta),
      );
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
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
  KasHarianTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KasHarianTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      modalAwal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}modal_awal'],
      )!,
      keterangan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keterangan'],
      ),
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $KasHarianTableTable createAlias(String alias) {
    return $KasHarianTableTable(attachedDatabase, alias);
  }
}

class KasHarianTableData extends DataClass
    implements Insertable<KasHarianTableData> {
  final String id;
  final double modalAwal;
  final String? keterangan;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime updatedAt;
  const KasHarianTableData({
    required this.id,
    required this.modalAwal,
    this.keterangan,
    required this.tanggal,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['modal_awal'] = Variable<double>(modalAwal);
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    map['tanggal'] = Variable<DateTime>(tanggal);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  KasHarianTableCompanion toCompanion(bool nullToAbsent) {
    return KasHarianTableCompanion(
      id: Value(id),
      modalAwal: Value(modalAwal),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
      tanggal: Value(tanggal),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory KasHarianTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KasHarianTableData(
      id: serializer.fromJson<String>(json['id']),
      modalAwal: serializer.fromJson<double>(json['modalAwal']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'modalAwal': serializer.toJson<double>(modalAwal),
      'keterangan': serializer.toJson<String?>(keterangan),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  KasHarianTableData copyWith({
    String? id,
    double? modalAwal,
    Value<String?> keterangan = const Value.absent(),
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => KasHarianTableData(
    id: id ?? this.id,
    modalAwal: modalAwal ?? this.modalAwal,
    keterangan: keterangan.present ? keterangan.value : this.keterangan,
    tanggal: tanggal ?? this.tanggal,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  KasHarianTableData copyWithCompanion(KasHarianTableCompanion data) {
    return KasHarianTableData(
      id: data.id.present ? data.id.value : this.id,
      modalAwal: data.modalAwal.present ? data.modalAwal.value : this.modalAwal,
      keterangan: data.keterangan.present
          ? data.keterangan.value
          : this.keterangan,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KasHarianTableData(')
          ..write('id: $id, ')
          ..write('modalAwal: $modalAwal, ')
          ..write('keterangan: $keterangan, ')
          ..write('tanggal: $tanggal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, modalAwal, keterangan, tanggal, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KasHarianTableData &&
          other.id == this.id &&
          other.modalAwal == this.modalAwal &&
          other.keterangan == this.keterangan &&
          other.tanggal == this.tanggal &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class KasHarianTableCompanion extends UpdateCompanion<KasHarianTableData> {
  final Value<String> id;
  final Value<double> modalAwal;
  final Value<String?> keterangan;
  final Value<DateTime> tanggal;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const KasHarianTableCompanion({
    this.id = const Value.absent(),
    this.modalAwal = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KasHarianTableCompanion.insert({
    required String id,
    this.modalAwal = const Value.absent(),
    this.keterangan = const Value.absent(),
    required DateTime tanggal,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tanggal = Value(tanggal);
  static Insertable<KasHarianTableData> custom({
    Expression<String>? id,
    Expression<double>? modalAwal,
    Expression<String>? keterangan,
    Expression<DateTime>? tanggal,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (modalAwal != null) 'modal_awal': modalAwal,
      if (keterangan != null) 'keterangan': keterangan,
      if (tanggal != null) 'tanggal': tanggal,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KasHarianTableCompanion copyWith({
    Value<String>? id,
    Value<double>? modalAwal,
    Value<String?>? keterangan,
    Value<DateTime>? tanggal,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return KasHarianTableCompanion(
      id: id ?? this.id,
      modalAwal: modalAwal ?? this.modalAwal,
      keterangan: keterangan ?? this.keterangan,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
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
    if (modalAwal.present) {
      map['modal_awal'] = Variable<double>(modalAwal.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('KasHarianTableCompanion(')
          ..write('id: $id, ')
          ..write('modalAwal: $modalAwal, ')
          ..write('keterangan: $keterangan, ')
          ..write('tanggal: $tanggal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PengeluaranOperasionalTableTable extends PengeluaranOperasionalTable
    with
        TableInfo<
          $PengeluaranOperasionalTableTable,
          PengeluaranOperasionalTableData
        > {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PengeluaranOperasionalTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _kategoriMeta = const VerificationMeta(
    'kategori',
  );
  @override
  late final GeneratedColumn<String> kategori = GeneratedColumn<String>(
    'kategori',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Lain-lain'),
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
  static const VerificationMeta _tanggalMeta = const VerificationMeta(
    'tanggal',
  );
  @override
  late final GeneratedColumn<DateTime> tanggal = GeneratedColumn<DateTime>(
    'tanggal',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
    jumlah,
    kategori,
    keterangan,
    tanggal,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pengeluaran_operasional_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<PengeluaranOperasionalTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('jumlah')) {
      context.handle(
        _jumlahMeta,
        jumlah.isAcceptableOrUnknown(data['jumlah']!, _jumlahMeta),
      );
    }
    if (data.containsKey('kategori')) {
      context.handle(
        _kategoriMeta,
        kategori.isAcceptableOrUnknown(data['kategori']!, _kategoriMeta),
      );
    }
    if (data.containsKey('keterangan')) {
      context.handle(
        _keteranganMeta,
        keterangan.isAcceptableOrUnknown(data['keterangan']!, _keteranganMeta),
      );
    }
    if (data.containsKey('tanggal')) {
      context.handle(
        _tanggalMeta,
        tanggal.isAcceptableOrUnknown(data['tanggal']!, _tanggalMeta),
      );
    } else if (isInserting) {
      context.missing(_tanggalMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
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
  PengeluaranOperasionalTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PengeluaranOperasionalTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      jumlah: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}jumlah'],
      )!,
      kategori: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kategori'],
      )!,
      keterangan: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keterangan'],
      ),
      tanggal: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}tanggal'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PengeluaranOperasionalTableTable createAlias(String alias) {
    return $PengeluaranOperasionalTableTable(attachedDatabase, alias);
  }
}

class PengeluaranOperasionalTableData extends DataClass
    implements Insertable<PengeluaranOperasionalTableData> {
  final String id;
  final double jumlah;
  final String kategori;
  final String? keterangan;
  final DateTime tanggal;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PengeluaranOperasionalTableData({
    required this.id,
    required this.jumlah,
    required this.kategori,
    this.keterangan,
    required this.tanggal,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['jumlah'] = Variable<double>(jumlah);
    map['kategori'] = Variable<String>(kategori);
    if (!nullToAbsent || keterangan != null) {
      map['keterangan'] = Variable<String>(keterangan);
    }
    map['tanggal'] = Variable<DateTime>(tanggal);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PengeluaranOperasionalTableCompanion toCompanion(bool nullToAbsent) {
    return PengeluaranOperasionalTableCompanion(
      id: Value(id),
      jumlah: Value(jumlah),
      kategori: Value(kategori),
      keterangan: keterangan == null && nullToAbsent
          ? const Value.absent()
          : Value(keterangan),
      tanggal: Value(tanggal),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PengeluaranOperasionalTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PengeluaranOperasionalTableData(
      id: serializer.fromJson<String>(json['id']),
      jumlah: serializer.fromJson<double>(json['jumlah']),
      kategori: serializer.fromJson<String>(json['kategori']),
      keterangan: serializer.fromJson<String?>(json['keterangan']),
      tanggal: serializer.fromJson<DateTime>(json['tanggal']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'jumlah': serializer.toJson<double>(jumlah),
      'kategori': serializer.toJson<String>(kategori),
      'keterangan': serializer.toJson<String?>(keterangan),
      'tanggal': serializer.toJson<DateTime>(tanggal),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PengeluaranOperasionalTableData copyWith({
    String? id,
    double? jumlah,
    String? kategori,
    Value<String?> keterangan = const Value.absent(),
    DateTime? tanggal,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PengeluaranOperasionalTableData(
    id: id ?? this.id,
    jumlah: jumlah ?? this.jumlah,
    kategori: kategori ?? this.kategori,
    keterangan: keterangan.present ? keterangan.value : this.keterangan,
    tanggal: tanggal ?? this.tanggal,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PengeluaranOperasionalTableData copyWithCompanion(
    PengeluaranOperasionalTableCompanion data,
  ) {
    return PengeluaranOperasionalTableData(
      id: data.id.present ? data.id.value : this.id,
      jumlah: data.jumlah.present ? data.jumlah.value : this.jumlah,
      kategori: data.kategori.present ? data.kategori.value : this.kategori,
      keterangan: data.keterangan.present
          ? data.keterangan.value
          : this.keterangan,
      tanggal: data.tanggal.present ? data.tanggal.value : this.tanggal,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PengeluaranOperasionalTableData(')
          ..write('id: $id, ')
          ..write('jumlah: $jumlah, ')
          ..write('kategori: $kategori, ')
          ..write('keterangan: $keterangan, ')
          ..write('tanggal: $tanggal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    jumlah,
    kategori,
    keterangan,
    tanggal,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PengeluaranOperasionalTableData &&
          other.id == this.id &&
          other.jumlah == this.jumlah &&
          other.kategori == this.kategori &&
          other.keterangan == this.keterangan &&
          other.tanggal == this.tanggal &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PengeluaranOperasionalTableCompanion
    extends UpdateCompanion<PengeluaranOperasionalTableData> {
  final Value<String> id;
  final Value<double> jumlah;
  final Value<String> kategori;
  final Value<String?> keterangan;
  final Value<DateTime> tanggal;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PengeluaranOperasionalTableCompanion({
    this.id = const Value.absent(),
    this.jumlah = const Value.absent(),
    this.kategori = const Value.absent(),
    this.keterangan = const Value.absent(),
    this.tanggal = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PengeluaranOperasionalTableCompanion.insert({
    required String id,
    this.jumlah = const Value.absent(),
    this.kategori = const Value.absent(),
    this.keterangan = const Value.absent(),
    required DateTime tanggal,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       tanggal = Value(tanggal);
  static Insertable<PengeluaranOperasionalTableData> custom({
    Expression<String>? id,
    Expression<double>? jumlah,
    Expression<String>? kategori,
    Expression<String>? keterangan,
    Expression<DateTime>? tanggal,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (jumlah != null) 'jumlah': jumlah,
      if (kategori != null) 'kategori': kategori,
      if (keterangan != null) 'keterangan': keterangan,
      if (tanggal != null) 'tanggal': tanggal,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PengeluaranOperasionalTableCompanion copyWith({
    Value<String>? id,
    Value<double>? jumlah,
    Value<String>? kategori,
    Value<String?>? keterangan,
    Value<DateTime>? tanggal,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PengeluaranOperasionalTableCompanion(
      id: id ?? this.id,
      jumlah: jumlah ?? this.jumlah,
      kategori: kategori ?? this.kategori,
      keterangan: keterangan ?? this.keterangan,
      tanggal: tanggal ?? this.tanggal,
      createdAt: createdAt ?? this.createdAt,
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
    if (jumlah.present) {
      map['jumlah'] = Variable<double>(jumlah.value);
    }
    if (kategori.present) {
      map['kategori'] = Variable<String>(kategori.value);
    }
    if (keterangan.present) {
      map['keterangan'] = Variable<String>(keterangan.value);
    }
    if (tanggal.present) {
      map['tanggal'] = Variable<DateTime>(tanggal.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
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
    return (StringBuffer('PengeluaranOperasionalTableCompanion(')
          ..write('id: $id, ')
          ..write('jumlah: $jumlah, ')
          ..write('kategori: $kategori, ')
          ..write('keterangan: $keterangan, ')
          ..write('tanggal: $tanggal, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserTableTable userTable = $UserTableTable(this);
  late final $ProdukTableTable produkTable = $ProdukTableTable(this);
  late final $SatuanProdukTableTable satuanProdukTable =
      $SatuanProdukTableTable(this);
  late final $RiwayatPerubahanProdukTableTable riwayatPerubahanProdukTable =
      $RiwayatPerubahanProdukTableTable(this);
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
  late final $PurchaseOrderTableTable purchaseOrderTable =
      $PurchaseOrderTableTable(this);
  late final $PurchaseOrderItemTableTable purchaseOrderItemTable =
      $PurchaseOrderItemTableTable(this);
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
  late final $LocalAuthTableTable localAuthTable = $LocalAuthTableTable(this);
  late final $OnlineCustomerTableTable onlineCustomerTable =
      $OnlineCustomerTableTable(this);
  late final $OnlineOrderTableTable onlineOrderTable = $OnlineOrderTableTable(
    this,
  );
  late final $OnlineOrderItemTableTable onlineOrderItemTable =
      $OnlineOrderItemTableTable(this);
  late final $KasHarianTableTable kasHarianTable = $KasHarianTableTable(this);
  late final $PengeluaranOperasionalTableTable pengeluaranOperasionalTable =
      $PengeluaranOperasionalTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userTable,
    produkTable,
    satuanProdukTable,
    riwayatPerubahanProdukTable,
    supplierTable,
    supplierProductsTable,
    transaksiTable,
    itemTransaksiTable,
    hutangPiutangTable,
    riwayatStokTable,
    pembelianTable,
    itemPembelianTable,
    purchaseOrderTable,
    purchaseOrderItemTable,
    pendingOrderTable,
    pendingOrderItemTable,
    pendingPembelianTable,
    pendingPembelianItemTable,
    notifikasiTable,
    pendingSyncQueueTable,
    riwayatHargaTable,
    localAuthTable,
    onlineCustomerTable,
    onlineOrderTable,
    onlineOrderItemTable,
    kasHarianTable,
    pengeluaranOperasionalTable,
  ];
}

typedef $$UserTableTableCreateCompanionBuilder =
    UserTableCompanion Function({
      required String id,
      Value<String?> nama,
      Value<String> role,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$UserTableTableUpdateCompanionBuilder =
    UserTableCompanion Function({
      Value<String> id,
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
                Value<String?> nama = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion(
                id: id,
                nama: nama,
                role: role,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> nama = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserTableCompanion.insert(
                id: id,
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
      required String nama,
      Value<String?> barcode,
      Value<double> hargaBeli,
      Value<double> hargaJual,
      Value<int> stok,
      Value<int?> stokMinimum,
      Value<String?> kategori,
      Value<String> satuan,
      Value<String?> imageUrl,
      Value<bool> isArchived,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ProdukTableTableUpdateCompanionBuilder =
    ProdukTableCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<String?> barcode,
      Value<double> hargaBeli,
      Value<double> hargaJual,
      Value<int> stok,
      Value<int?> stokMinimum,
      Value<String?> kategori,
      Value<String> satuan,
      Value<String?> imageUrl,
      Value<bool> isArchived,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$ProdukTableTableReferences
    extends BaseReferences<_$AppDatabase, $ProdukTableTable, ProdukTableData> {
  $$ProdukTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OnlineOrderItemTableTable, List<OnlineOrderItem>>
  _onlineOrderItemTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.onlineOrderItemTable,
        aliasName: $_aliasNameGenerator(
          db.produkTable.id,
          db.onlineOrderItemTable.produkId,
        ),
      );

  $$OnlineOrderItemTableTableProcessedTableManager
  get onlineOrderItemTableRefs {
    final manager = $$OnlineOrderItemTableTableTableManager(
      $_db,
      $_db.onlineOrderItemTable,
    ).filter((f) => f.produkId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _onlineOrderItemTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<int> get stokMinimum => $composableBuilder(
    column: $table.stokMinimum,
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

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  Expression<bool> onlineOrderItemTableRefs(
    Expression<bool> Function($$OnlineOrderItemTableTableFilterComposer f) f,
  ) {
    final $$OnlineOrderItemTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.onlineOrderItemTable,
      getReferencedColumn: (t) => t.produkId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineOrderItemTableTableFilterComposer(
            $db: $db,
            $table: $db.onlineOrderItemTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<int> get stokMinimum => $composableBuilder(
    column: $table.stokMinimum,
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

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
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

  GeneratedColumn<int> get stokMinimum => $composableBuilder(
    column: $table.stokMinimum,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kategori =>
      $composableBuilder(column: $table.kategori, builder: (column) => column);

  GeneratedColumn<String> get satuan =>
      $composableBuilder(column: $table.satuan, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> onlineOrderItemTableRefs<T extends Object>(
    Expression<T> Function($$OnlineOrderItemTableTableAnnotationComposer a) f,
  ) {
    final $$OnlineOrderItemTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.onlineOrderItemTable,
          getReferencedColumn: (t) => t.produkId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OnlineOrderItemTableTableAnnotationComposer(
                $db: $db,
                $table: $db.onlineOrderItemTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (ProdukTableData, $$ProdukTableTableReferences),
          ProdukTableData,
          PrefetchHooks Function({bool onlineOrderItemTableRefs})
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
                Value<String> nama = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<double> hargaBeli = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<int> stok = const Value.absent(),
                Value<int?> stokMinimum = const Value.absent(),
                Value<String?> kategori = const Value.absent(),
                Value<String> satuan = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdukTableCompanion(
                id: id,
                nama: nama,
                barcode: barcode,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                stok: stok,
                stokMinimum: stokMinimum,
                kategori: kategori,
                satuan: satuan,
                imageUrl: imageUrl,
                isArchived: isArchived,
                updatedAt: updatedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                Value<String?> barcode = const Value.absent(),
                Value<double> hargaBeli = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<int> stok = const Value.absent(),
                Value<int?> stokMinimum = const Value.absent(),
                Value<String?> kategori = const Value.absent(),
                Value<String> satuan = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProdukTableCompanion.insert(
                id: id,
                nama: nama,
                barcode: barcode,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                stok: stok,
                stokMinimum: stokMinimum,
                kategori: kategori,
                satuan: satuan,
                imageUrl: imageUrl,
                isArchived: isArchived,
                updatedAt: updatedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProdukTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({onlineOrderItemTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (onlineOrderItemTableRefs) db.onlineOrderItemTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (onlineOrderItemTableRefs)
                    await $_getPrefetchedData<
                      ProdukTableData,
                      $ProdukTableTable,
                      OnlineOrderItem
                    >(
                      currentTable: table,
                      referencedTable: $$ProdukTableTableReferences
                          ._onlineOrderItemTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ProdukTableTableReferences(
                            db,
                            table,
                            p0,
                          ).onlineOrderItemTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.produkId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (ProdukTableData, $$ProdukTableTableReferences),
      ProdukTableData,
      PrefetchHooks Function({bool onlineOrderItemTableRefs})
    >;
typedef $$SatuanProdukTableTableCreateCompanionBuilder =
    SatuanProdukTableCompanion Function({
      required String id,
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
      Value<String> produkId,
      Value<String> nama,
      Value<double> konversi,
      Value<double> hargaBeli,
      Value<double> hargaJual,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SatuanProdukTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SatuanProdukTableTable,
          SatuanProdukTableData
        > {
  $$SatuanProdukTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$OnlineOrderItemTableTable, List<OnlineOrderItem>>
  _onlineOrderItemTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.onlineOrderItemTable,
        aliasName: $_aliasNameGenerator(
          db.satuanProdukTable.id,
          db.onlineOrderItemTable.satuanId,
        ),
      );

  $$OnlineOrderItemTableTableProcessedTableManager
  get onlineOrderItemTableRefs {
    final manager = $$OnlineOrderItemTableTableTableManager(
      $_db,
      $_db.onlineOrderItemTable,
    ).filter((f) => f.satuanId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _onlineOrderItemTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  Expression<bool> onlineOrderItemTableRefs(
    Expression<bool> Function($$OnlineOrderItemTableTableFilterComposer f) f,
  ) {
    final $$OnlineOrderItemTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.onlineOrderItemTable,
      getReferencedColumn: (t) => t.satuanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineOrderItemTableTableFilterComposer(
            $db: $db,
            $table: $db.onlineOrderItemTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  Expression<T> onlineOrderItemTableRefs<T extends Object>(
    Expression<T> Function($$OnlineOrderItemTableTableAnnotationComposer a) f,
  ) {
    final $$OnlineOrderItemTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.onlineOrderItemTable,
          getReferencedColumn: (t) => t.satuanId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OnlineOrderItemTableTableAnnotationComposer(
                $db: $db,
                $table: $db.onlineOrderItemTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (SatuanProdukTableData, $$SatuanProdukTableTableReferences),
          SatuanProdukTableData,
          PrefetchHooks Function({bool onlineOrderItemTableRefs})
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
                Value<String> produkId = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<double> hargaBeli = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SatuanProdukTableCompanion(
                id: id,
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
                required String produkId,
                required String nama,
                Value<double> konversi = const Value.absent(),
                Value<double> hargaBeli = const Value.absent(),
                Value<double> hargaJual = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SatuanProdukTableCompanion.insert(
                id: id,
                produkId: produkId,
                nama: nama,
                konversi: konversi,
                hargaBeli: hargaBeli,
                hargaJual: hargaJual,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SatuanProdukTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({onlineOrderItemTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (onlineOrderItemTableRefs) db.onlineOrderItemTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (onlineOrderItemTableRefs)
                    await $_getPrefetchedData<
                      SatuanProdukTableData,
                      $SatuanProdukTableTable,
                      OnlineOrderItem
                    >(
                      currentTable: table,
                      referencedTable: $$SatuanProdukTableTableReferences
                          ._onlineOrderItemTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SatuanProdukTableTableReferences(
                            db,
                            table,
                            p0,
                          ).onlineOrderItemTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.satuanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (SatuanProdukTableData, $$SatuanProdukTableTableReferences),
      SatuanProdukTableData,
      PrefetchHooks Function({bool onlineOrderItemTableRefs})
    >;
typedef $$RiwayatPerubahanProdukTableTableCreateCompanionBuilder =
    RiwayatPerubahanProdukTableCompanion Function({
      required String id,
      required String produkId,
      required String kolomDiubah,
      required String nilaiLama,
      required String nilaiBaru,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$RiwayatPerubahanProdukTableTableUpdateCompanionBuilder =
    RiwayatPerubahanProdukTableCompanion Function({
      Value<String> id,
      Value<String> produkId,
      Value<String> kolomDiubah,
      Value<String> nilaiLama,
      Value<String> nilaiBaru,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RiwayatPerubahanProdukTableTableFilterComposer
    extends Composer<_$AppDatabase, $RiwayatPerubahanProdukTableTable> {
  $$RiwayatPerubahanProdukTableTableFilterComposer({
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

  ColumnFilters<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kolomDiubah => $composableBuilder(
    column: $table.kolomDiubah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nilaiLama => $composableBuilder(
    column: $table.nilaiLama,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nilaiBaru => $composableBuilder(
    column: $table.nilaiBaru,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RiwayatPerubahanProdukTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RiwayatPerubahanProdukTableTable> {
  $$RiwayatPerubahanProdukTableTableOrderingComposer({
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

  ColumnOrderings<String> get produkId => $composableBuilder(
    column: $table.produkId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kolomDiubah => $composableBuilder(
    column: $table.kolomDiubah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nilaiLama => $composableBuilder(
    column: $table.nilaiLama,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nilaiBaru => $composableBuilder(
    column: $table.nilaiBaru,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RiwayatPerubahanProdukTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RiwayatPerubahanProdukTableTable> {
  $$RiwayatPerubahanProdukTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<String> get kolomDiubah => $composableBuilder(
    column: $table.kolomDiubah,
    builder: (column) => column,
  );

  GeneratedColumn<String> get nilaiLama =>
      $composableBuilder(column: $table.nilaiLama, builder: (column) => column);

  GeneratedColumn<String> get nilaiBaru =>
      $composableBuilder(column: $table.nilaiBaru, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RiwayatPerubahanProdukTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RiwayatPerubahanProdukTableTable,
          RiwayatPerubahanProdukTableData,
          $$RiwayatPerubahanProdukTableTableFilterComposer,
          $$RiwayatPerubahanProdukTableTableOrderingComposer,
          $$RiwayatPerubahanProdukTableTableAnnotationComposer,
          $$RiwayatPerubahanProdukTableTableCreateCompanionBuilder,
          $$RiwayatPerubahanProdukTableTableUpdateCompanionBuilder,
          (
            RiwayatPerubahanProdukTableData,
            BaseReferences<
              _$AppDatabase,
              $RiwayatPerubahanProdukTableTable,
              RiwayatPerubahanProdukTableData
            >,
          ),
          RiwayatPerubahanProdukTableData,
          PrefetchHooks Function()
        > {
  $$RiwayatPerubahanProdukTableTableTableManager(
    _$AppDatabase db,
    $RiwayatPerubahanProdukTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RiwayatPerubahanProdukTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RiwayatPerubahanProdukTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RiwayatPerubahanProdukTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String> kolomDiubah = const Value.absent(),
                Value<String> nilaiLama = const Value.absent(),
                Value<String> nilaiBaru = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatPerubahanProdukTableCompanion(
                id: id,
                produkId: produkId,
                kolomDiubah: kolomDiubah,
                nilaiLama: nilaiLama,
                nilaiBaru: nilaiBaru,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String produkId,
                required String kolomDiubah,
                required String nilaiLama,
                required String nilaiBaru,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatPerubahanProdukTableCompanion.insert(
                id: id,
                produkId: produkId,
                kolomDiubah: kolomDiubah,
                nilaiLama: nilaiLama,
                nilaiBaru: nilaiBaru,
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

typedef $$RiwayatPerubahanProdukTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RiwayatPerubahanProdukTableTable,
      RiwayatPerubahanProdukTableData,
      $$RiwayatPerubahanProdukTableTableFilterComposer,
      $$RiwayatPerubahanProdukTableTableOrderingComposer,
      $$RiwayatPerubahanProdukTableTableAnnotationComposer,
      $$RiwayatPerubahanProdukTableTableCreateCompanionBuilder,
      $$RiwayatPerubahanProdukTableTableUpdateCompanionBuilder,
      (
        RiwayatPerubahanProdukTableData,
        BaseReferences<
          _$AppDatabase,
          $RiwayatPerubahanProdukTableTable,
          RiwayatPerubahanProdukTableData
        >,
      ),
      RiwayatPerubahanProdukTableData,
      PrefetchHooks Function()
    >;
typedef $$SupplierTableTableCreateCompanionBuilder =
    SupplierTableCompanion Function({
      required String id,
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
                Value<String> nama = const Value.absent(),
                Value<String?> telepon = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplierTableCompanion(
                id: id,
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
                required String nama,
                Value<String?> telepon = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplierTableCompanion.insert(
                id: id,
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
      required String supplierId,
      required String produkId,
      Value<double> harga,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$SupplierProductsTableTableUpdateCompanionBuilder =
    SupplierProductsTableCompanion Function({
      Value<String> id,
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
                Value<String> supplierId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<double> harga = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplierProductsTableCompanion(
                id: id,
                supplierId: supplierId,
                produkId: produkId,
                harga: harga,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String supplierId,
                required String produkId,
                Value<double> harga = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SupplierProductsTableCompanion.insert(
                id: id,
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
      required String transaksiId,
      required String produkId,
      Value<String?> namaProduk,
      Value<int> jumlah,
      Value<double> hargaSatuan,
      Value<double> subtotal,
      Value<int> rowid,
    });
typedef $$ItemTransaksiTableTableUpdateCompanionBuilder =
    ItemTransaksiTableCompanion Function({
      Value<String> id,
      Value<String> transaksiId,
      Value<String> produkId,
      Value<String?> namaProduk,
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

  ColumnFilters<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
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

  ColumnOrderings<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
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

  GeneratedColumn<String> get transaksiId => $composableBuilder(
    column: $table.transaksiId,
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
                Value<String> transaksiId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String?> namaProduk = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemTransaksiTableCompanion(
                id: id,
                transaksiId: transaksiId,
                produkId: produkId,
                namaProduk: namaProduk,
                jumlah: jumlah,
                hargaSatuan: hargaSatuan,
                subtotal: subtotal,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transaksiId,
                required String produkId,
                Value<String?> namaProduk = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemTransaksiTableCompanion.insert(
                id: id,
                transaksiId: transaksiId,
                produkId: produkId,
                namaProduk: namaProduk,
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
                Value<String> produkId = const Value.absent(),
                Value<String> tipe = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<String?> keterangan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatStokTableCompanion(
                id: id,
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
                required String produkId,
                required String tipe,
                Value<int> jumlah = const Value.absent(),
                Value<String?> keterangan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatStokTableCompanion.insert(
                id: id,
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
                Value<String?> supplierId = const Value.absent(),
                Value<String?> namaSupplier = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PembelianTableCompanion(
                id: id,
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
                Value<String?> supplierId = const Value.absent(),
                Value<String?> namaSupplier = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PembelianTableCompanion.insert(
                id: id,
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
      required String pembelianId,
      required String produkId,
      Value<String?> namaProduk,
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
      Value<String> pembelianId,
      Value<String> produkId,
      Value<String?> namaProduk,
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

  ColumnFilters<String> get pembelianId => $composableBuilder(
    column: $table.pembelianId,
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

  ColumnOrderings<String> get pembelianId => $composableBuilder(
    column: $table.pembelianId,
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

  GeneratedColumn<String> get pembelianId => $composableBuilder(
    column: $table.pembelianId,
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
                Value<String> pembelianId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String?> namaProduk = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaBeliSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemPembelianTableCompanion(
                id: id,
                pembelianId: pembelianId,
                produkId: produkId,
                namaProduk: namaProduk,
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
                required String pembelianId,
                required String produkId,
                Value<String?> namaProduk = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> hargaBeliSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ItemPembelianTableCompanion.insert(
                id: id,
                pembelianId: pembelianId,
                produkId: produkId,
                namaProduk: namaProduk,
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
typedef $$PurchaseOrderTableTableCreateCompanionBuilder =
    PurchaseOrderTableCompanion Function({
      required String id,
      Value<String?> supplierId,
      Value<String?> namaSupplier,
      Value<String> status,
      Value<double> totalHarga,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PurchaseOrderTableTableUpdateCompanionBuilder =
    PurchaseOrderTableCompanion Function({
      Value<String> id,
      Value<String?> supplierId,
      Value<String?> namaSupplier,
      Value<String> status,
      Value<double> totalHarga,
      Value<String?> notes,
      Value<DateTime> updatedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$PurchaseOrderTableTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseOrderTableTable> {
  $$PurchaseOrderTableTableFilterComposer({
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

  ColumnFilters<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
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

class $$PurchaseOrderTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseOrderTableTable> {
  $$PurchaseOrderTableTableOrderingComposer({
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

  ColumnOrderings<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
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

class $$PurchaseOrderTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseOrderTableTable> {
  $$PurchaseOrderTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get supplierId => $composableBuilder(
    column: $table.supplierId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get namaSupplier => $composableBuilder(
    column: $table.namaSupplier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$PurchaseOrderTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseOrderTableTable,
          PurchaseOrderTableData,
          $$PurchaseOrderTableTableFilterComposer,
          $$PurchaseOrderTableTableOrderingComposer,
          $$PurchaseOrderTableTableAnnotationComposer,
          $$PurchaseOrderTableTableCreateCompanionBuilder,
          $$PurchaseOrderTableTableUpdateCompanionBuilder,
          (
            PurchaseOrderTableData,
            BaseReferences<
              _$AppDatabase,
              $PurchaseOrderTableTable,
              PurchaseOrderTableData
            >,
          ),
          PurchaseOrderTableData,
          PrefetchHooks Function()
        > {
  $$PurchaseOrderTableTableTableManager(
    _$AppDatabase db,
    $PurchaseOrderTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseOrderTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PurchaseOrderTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PurchaseOrderTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> supplierId = const Value.absent(),
                Value<String?> namaSupplier = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrderTableCompanion(
                id: id,
                supplierId: supplierId,
                namaSupplier: namaSupplier,
                status: status,
                totalHarga: totalHarga,
                notes: notes,
                updatedAt: updatedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> supplierId = const Value.absent(),
                Value<String?> namaSupplier = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrderTableCompanion.insert(
                id: id,
                supplierId: supplierId,
                namaSupplier: namaSupplier,
                status: status,
                totalHarga: totalHarga,
                notes: notes,
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

typedef $$PurchaseOrderTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseOrderTableTable,
      PurchaseOrderTableData,
      $$PurchaseOrderTableTableFilterComposer,
      $$PurchaseOrderTableTableOrderingComposer,
      $$PurchaseOrderTableTableAnnotationComposer,
      $$PurchaseOrderTableTableCreateCompanionBuilder,
      $$PurchaseOrderTableTableUpdateCompanionBuilder,
      (
        PurchaseOrderTableData,
        BaseReferences<
          _$AppDatabase,
          $PurchaseOrderTableTable,
          PurchaseOrderTableData
        >,
      ),
      PurchaseOrderTableData,
      PrefetchHooks Function()
    >;
typedef $$PurchaseOrderItemTableTableCreateCompanionBuilder =
    PurchaseOrderItemTableCompanion Function({
      required String id,
      required String poId,
      required String produkId,
      Value<String?> namaProduk,
      Value<int> qtyPesan,
      Value<int> qtyTerima,
      Value<double> hargaSatuan,
      Value<double> subtotal,
      Value<String?> satuanId,
      Value<double> konversi,
      Value<int> rowid,
    });
typedef $$PurchaseOrderItemTableTableUpdateCompanionBuilder =
    PurchaseOrderItemTableCompanion Function({
      Value<String> id,
      Value<String> poId,
      Value<String> produkId,
      Value<String?> namaProduk,
      Value<int> qtyPesan,
      Value<int> qtyTerima,
      Value<double> hargaSatuan,
      Value<double> subtotal,
      Value<String?> satuanId,
      Value<double> konversi,
      Value<int> rowid,
    });

class $$PurchaseOrderItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemTableTable> {
  $$PurchaseOrderItemTableTableFilterComposer({
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

  ColumnFilters<String> get poId => $composableBuilder(
    column: $table.poId,
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

  ColumnFilters<int> get qtyPesan => $composableBuilder(
    column: $table.qtyPesan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qtyTerima => $composableBuilder(
    column: $table.qtyTerima,
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

  ColumnFilters<String> get satuanId => $composableBuilder(
    column: $table.satuanId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PurchaseOrderItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemTableTable> {
  $$PurchaseOrderItemTableTableOrderingComposer({
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

  ColumnOrderings<String> get poId => $composableBuilder(
    column: $table.poId,
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

  ColumnOrderings<int> get qtyPesan => $composableBuilder(
    column: $table.qtyPesan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qtyTerima => $composableBuilder(
    column: $table.qtyTerima,
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

  ColumnOrderings<String> get satuanId => $composableBuilder(
    column: $table.satuanId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PurchaseOrderItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PurchaseOrderItemTableTable> {
  $$PurchaseOrderItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get poId =>
      $composableBuilder(column: $table.poId, builder: (column) => column);

  GeneratedColumn<String> get produkId =>
      $composableBuilder(column: $table.produkId, builder: (column) => column);

  GeneratedColumn<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => column,
  );

  GeneratedColumn<int> get qtyPesan =>
      $composableBuilder(column: $table.qtyPesan, builder: (column) => column);

  GeneratedColumn<int> get qtyTerima =>
      $composableBuilder(column: $table.qtyTerima, builder: (column) => column);

  GeneratedColumn<double> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => column,
  );

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<String> get satuanId =>
      $composableBuilder(column: $table.satuanId, builder: (column) => column);

  GeneratedColumn<double> get konversi =>
      $composableBuilder(column: $table.konversi, builder: (column) => column);
}

class $$PurchaseOrderItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PurchaseOrderItemTableTable,
          PurchaseOrderItemTableData,
          $$PurchaseOrderItemTableTableFilterComposer,
          $$PurchaseOrderItemTableTableOrderingComposer,
          $$PurchaseOrderItemTableTableAnnotationComposer,
          $$PurchaseOrderItemTableTableCreateCompanionBuilder,
          $$PurchaseOrderItemTableTableUpdateCompanionBuilder,
          (
            PurchaseOrderItemTableData,
            BaseReferences<
              _$AppDatabase,
              $PurchaseOrderItemTableTable,
              PurchaseOrderItemTableData
            >,
          ),
          PurchaseOrderItemTableData,
          PrefetchHooks Function()
        > {
  $$PurchaseOrderItemTableTableTableManager(
    _$AppDatabase db,
    $PurchaseOrderItemTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PurchaseOrderItemTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PurchaseOrderItemTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PurchaseOrderItemTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> poId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String?> namaProduk = const Value.absent(),
                Value<int> qtyPesan = const Value.absent(),
                Value<int> qtyTerima = const Value.absent(),
                Value<double> hargaSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrderItemTableCompanion(
                id: id,
                poId: poId,
                produkId: produkId,
                namaProduk: namaProduk,
                qtyPesan: qtyPesan,
                qtyTerima: qtyTerima,
                hargaSatuan: hargaSatuan,
                subtotal: subtotal,
                satuanId: satuanId,
                konversi: konversi,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String poId,
                required String produkId,
                Value<String?> namaProduk = const Value.absent(),
                Value<int> qtyPesan = const Value.absent(),
                Value<int> qtyTerima = const Value.absent(),
                Value<double> hargaSatuan = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PurchaseOrderItemTableCompanion.insert(
                id: id,
                poId: poId,
                produkId: produkId,
                namaProduk: namaProduk,
                qtyPesan: qtyPesan,
                qtyTerima: qtyTerima,
                hargaSatuan: hargaSatuan,
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

typedef $$PurchaseOrderItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PurchaseOrderItemTableTable,
      PurchaseOrderItemTableData,
      $$PurchaseOrderItemTableTableFilterComposer,
      $$PurchaseOrderItemTableTableOrderingComposer,
      $$PurchaseOrderItemTableTableAnnotationComposer,
      $$PurchaseOrderItemTableTableCreateCompanionBuilder,
      $$PurchaseOrderItemTableTableUpdateCompanionBuilder,
      (
        PurchaseOrderItemTableData,
        BaseReferences<
          _$AppDatabase,
          $PurchaseOrderItemTableTable,
          PurchaseOrderItemTableData
        >,
      ),
      PurchaseOrderItemTableData,
      PrefetchHooks Function()
    >;
typedef $$PendingOrderTableTableCreateCompanionBuilder =
    PendingOrderTableCompanion Function({
      required String id,
      required String namaPelanggan,
      Value<String?> catatan,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$PendingOrderTableTableUpdateCompanionBuilder =
    PendingOrderTableCompanion Function({
      Value<String> id,
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
                Value<String> namaPelanggan = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOrderTableCompanion(
                id: id,
                namaPelanggan: namaPelanggan,
                catatan: catatan,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String namaPelanggan,
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PendingOrderTableCompanion.insert(
                id: id,
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
                Value<String> judul = const Value.absent(),
                Value<String> pesan = const Value.absent(),
                Value<String> tipe = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotifikasiTableCompanion(
                id: id,
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
                required String judul,
                required String pesan,
                Value<String> tipe = const Value.absent(),
                Value<bool> isRead = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotifikasiTableCompanion.insert(
                id: id,
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
                Value<String> produkId = const Value.absent(),
                Value<double> hargaBeliLama = const Value.absent(),
                Value<double> hargaBeliBaru = const Value.absent(),
                Value<double> hargaJualLama = const Value.absent(),
                Value<double> hargaJualBaru = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatHargaTableCompanion(
                id: id,
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
                required String produkId,
                required double hargaBeliLama,
                required double hargaBeliBaru,
                required double hargaJualLama,
                required double hargaJualBaru,
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RiwayatHargaTableCompanion.insert(
                id: id,
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
typedef $$LocalAuthTableTableCreateCompanionBuilder =
    LocalAuthTableCompanion Function({
      required String userId,
      required String pinHash,
      Value<String?> pinSalt,
      Value<int> pinLength,
      Value<bool> biometricEnabled,
      Value<int> failedAttempts,
      Value<DateTime?> lockoutUntil,
      Value<int> rowid,
    });
typedef $$LocalAuthTableTableUpdateCompanionBuilder =
    LocalAuthTableCompanion Function({
      Value<String> userId,
      Value<String> pinHash,
      Value<String?> pinSalt,
      Value<int> pinLength,
      Value<bool> biometricEnabled,
      Value<int> failedAttempts,
      Value<DateTime?> lockoutUntil,
      Value<int> rowid,
    });

class $$LocalAuthTableTableFilterComposer
    extends Composer<_$AppDatabase, $LocalAuthTableTable> {
  $$LocalAuthTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinLength => $composableBuilder(
    column: $table.pinLength,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lockoutUntil => $composableBuilder(
    column: $table.lockoutUntil,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAuthTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalAuthTableTable> {
  $$LocalAuthTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinSalt => $composableBuilder(
    column: $table.pinSalt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinLength => $composableBuilder(
    column: $table.pinLength,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lockoutUntil => $composableBuilder(
    column: $table.lockoutUntil,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAuthTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalAuthTableTable> {
  $$LocalAuthTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get pinSalt =>
      $composableBuilder(column: $table.pinSalt, builder: (column) => column);

  GeneratedColumn<int> get pinLength =>
      $composableBuilder(column: $table.pinLength, builder: (column) => column);

  GeneratedColumn<bool> get biometricEnabled => $composableBuilder(
    column: $table.biometricEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get failedAttempts => $composableBuilder(
    column: $table.failedAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lockoutUntil => $composableBuilder(
    column: $table.lockoutUntil,
    builder: (column) => column,
  );
}

class $$LocalAuthTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalAuthTableTable,
          LocalAuthTableData,
          $$LocalAuthTableTableFilterComposer,
          $$LocalAuthTableTableOrderingComposer,
          $$LocalAuthTableTableAnnotationComposer,
          $$LocalAuthTableTableCreateCompanionBuilder,
          $$LocalAuthTableTableUpdateCompanionBuilder,
          (
            LocalAuthTableData,
            BaseReferences<
              _$AppDatabase,
              $LocalAuthTableTable,
              LocalAuthTableData
            >,
          ),
          LocalAuthTableData,
          PrefetchHooks Function()
        > {
  $$LocalAuthTableTableTableManager(
    _$AppDatabase db,
    $LocalAuthTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalAuthTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalAuthTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalAuthTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String?> pinSalt = const Value.absent(),
                Value<int> pinLength = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<int> failedAttempts = const Value.absent(),
                Value<DateTime?> lockoutUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAuthTableCompanion(
                userId: userId,
                pinHash: pinHash,
                pinSalt: pinSalt,
                pinLength: pinLength,
                biometricEnabled: biometricEnabled,
                failedAttempts: failedAttempts,
                lockoutUntil: lockoutUntil,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String pinHash,
                Value<String?> pinSalt = const Value.absent(),
                Value<int> pinLength = const Value.absent(),
                Value<bool> biometricEnabled = const Value.absent(),
                Value<int> failedAttempts = const Value.absent(),
                Value<DateTime?> lockoutUntil = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAuthTableCompanion.insert(
                userId: userId,
                pinHash: pinHash,
                pinSalt: pinSalt,
                pinLength: pinLength,
                biometricEnabled: biometricEnabled,
                failedAttempts: failedAttempts,
                lockoutUntil: lockoutUntil,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAuthTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalAuthTableTable,
      LocalAuthTableData,
      $$LocalAuthTableTableFilterComposer,
      $$LocalAuthTableTableOrderingComposer,
      $$LocalAuthTableTableAnnotationComposer,
      $$LocalAuthTableTableCreateCompanionBuilder,
      $$LocalAuthTableTableUpdateCompanionBuilder,
      (
        LocalAuthTableData,
        BaseReferences<_$AppDatabase, $LocalAuthTableTable, LocalAuthTableData>,
      ),
      LocalAuthTableData,
      PrefetchHooks Function()
    >;
typedef $$OnlineCustomerTableTableCreateCompanionBuilder =
    OnlineCustomerTableCompanion Function({
      required String id,
      required String nama,
      Value<String?> telepon,
      Value<String?> alamat,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$OnlineCustomerTableTableUpdateCompanionBuilder =
    OnlineCustomerTableCompanion Function({
      Value<String> id,
      Value<String> nama,
      Value<String?> telepon,
      Value<String?> alamat,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$OnlineCustomerTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OnlineCustomerTableTable,
          OnlineCustomer
        > {
  $$OnlineCustomerTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$OnlineOrderTableTable, List<OnlineOrder>>
  _onlineOrderTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.onlineOrderTable,
    aliasName: $_aliasNameGenerator(
      db.onlineCustomerTable.id,
      db.onlineOrderTable.customerId,
    ),
  );

  $$OnlineOrderTableTableProcessedTableManager get onlineOrderTableRefs {
    final manager = $$OnlineOrderTableTableTableManager(
      $_db,
      $_db.onlineOrderTable,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _onlineOrderTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OnlineCustomerTableTableFilterComposer
    extends Composer<_$AppDatabase, $OnlineCustomerTableTable> {
  $$OnlineCustomerTableTableFilterComposer({
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

  ColumnFilters<String> get telepon => $composableBuilder(
    column: $table.telepon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> onlineOrderTableRefs(
    Expression<bool> Function($$OnlineOrderTableTableFilterComposer f) f,
  ) {
    final $$OnlineOrderTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.onlineOrderTable,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineOrderTableTableFilterComposer(
            $db: $db,
            $table: $db.onlineOrderTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OnlineCustomerTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OnlineCustomerTableTable> {
  $$OnlineCustomerTableTableOrderingComposer({
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

  ColumnOrderings<String> get telepon => $composableBuilder(
    column: $table.telepon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alamat => $composableBuilder(
    column: $table.alamat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OnlineCustomerTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnlineCustomerTableTable> {
  $$OnlineCustomerTableTableAnnotationComposer({
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

  GeneratedColumn<String> get telepon =>
      $composableBuilder(column: $table.telepon, builder: (column) => column);

  GeneratedColumn<String> get alamat =>
      $composableBuilder(column: $table.alamat, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> onlineOrderTableRefs<T extends Object>(
    Expression<T> Function($$OnlineOrderTableTableAnnotationComposer a) f,
  ) {
    final $$OnlineOrderTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.onlineOrderTable,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineOrderTableTableAnnotationComposer(
            $db: $db,
            $table: $db.onlineOrderTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OnlineCustomerTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnlineCustomerTableTable,
          OnlineCustomer,
          $$OnlineCustomerTableTableFilterComposer,
          $$OnlineCustomerTableTableOrderingComposer,
          $$OnlineCustomerTableTableAnnotationComposer,
          $$OnlineCustomerTableTableCreateCompanionBuilder,
          $$OnlineCustomerTableTableUpdateCompanionBuilder,
          (OnlineCustomer, $$OnlineCustomerTableTableReferences),
          OnlineCustomer,
          PrefetchHooks Function({bool onlineOrderTableRefs})
        > {
  $$OnlineCustomerTableTableTableManager(
    _$AppDatabase db,
    $OnlineCustomerTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnlineCustomerTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnlineCustomerTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OnlineCustomerTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nama = const Value.absent(),
                Value<String?> telepon = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnlineCustomerTableCompanion(
                id: id,
                nama: nama,
                telepon: telepon,
                alamat: alamat,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String nama,
                Value<String?> telepon = const Value.absent(),
                Value<String?> alamat = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnlineCustomerTableCompanion.insert(
                id: id,
                nama: nama,
                telepon: telepon,
                alamat: alamat,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OnlineCustomerTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({onlineOrderTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (onlineOrderTableRefs) db.onlineOrderTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (onlineOrderTableRefs)
                    await $_getPrefetchedData<
                      OnlineCustomer,
                      $OnlineCustomerTableTable,
                      OnlineOrder
                    >(
                      currentTable: table,
                      referencedTable: $$OnlineCustomerTableTableReferences
                          ._onlineOrderTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$OnlineCustomerTableTableReferences(
                            db,
                            table,
                            p0,
                          ).onlineOrderTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$OnlineCustomerTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnlineCustomerTableTable,
      OnlineCustomer,
      $$OnlineCustomerTableTableFilterComposer,
      $$OnlineCustomerTableTableOrderingComposer,
      $$OnlineCustomerTableTableAnnotationComposer,
      $$OnlineCustomerTableTableCreateCompanionBuilder,
      $$OnlineCustomerTableTableUpdateCompanionBuilder,
      (OnlineCustomer, $$OnlineCustomerTableTableReferences),
      OnlineCustomer,
      PrefetchHooks Function({bool onlineOrderTableRefs})
    >;
typedef $$OnlineOrderTableTableCreateCompanionBuilder =
    OnlineOrderTableCompanion Function({
      required String id,
      required String customerId,
      Value<String> status,
      Value<double> totalHarga,
      Value<String> metodePengiriman,
      Value<String?> alamatPengiriman,
      Value<String?> catatan,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$OnlineOrderTableTableUpdateCompanionBuilder =
    OnlineOrderTableCompanion Function({
      Value<String> id,
      Value<String> customerId,
      Value<String> status,
      Value<double> totalHarga,
      Value<String> metodePengiriman,
      Value<String?> alamatPengiriman,
      Value<String?> catatan,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$OnlineOrderTableTableReferences
    extends BaseReferences<_$AppDatabase, $OnlineOrderTableTable, OnlineOrder> {
  $$OnlineOrderTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OnlineCustomerTableTable _customerIdTable(_$AppDatabase db) =>
      db.onlineCustomerTable.createAlias(
        $_aliasNameGenerator(
          db.onlineOrderTable.customerId,
          db.onlineCustomerTable.id,
        ),
      );

  $$OnlineCustomerTableTableProcessedTableManager get customerId {
    final $_column = $_itemColumn<String>('customer_id')!;

    final manager = $$OnlineCustomerTableTableTableManager(
      $_db,
      $_db.onlineCustomerTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$OnlineOrderItemTableTable, List<OnlineOrderItem>>
  _onlineOrderItemTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.onlineOrderItemTable,
        aliasName: $_aliasNameGenerator(
          db.onlineOrderTable.id,
          db.onlineOrderItemTable.onlineOrderId,
        ),
      );

  $$OnlineOrderItemTableTableProcessedTableManager
  get onlineOrderItemTableRefs {
    final manager = $$OnlineOrderItemTableTableTableManager(
      $_db,
      $_db.onlineOrderItemTable,
    ).filter((f) => f.onlineOrderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _onlineOrderItemTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OnlineOrderTableTableFilterComposer
    extends Composer<_$AppDatabase, $OnlineOrderTableTable> {
  $$OnlineOrderTableTableFilterComposer({
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

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metodePengiriman => $composableBuilder(
    column: $table.metodePengiriman,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alamatPengiriman => $composableBuilder(
    column: $table.alamatPengiriman,
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

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$OnlineCustomerTableTableFilterComposer get customerId {
    final $$OnlineCustomerTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.onlineCustomerTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineCustomerTableTableFilterComposer(
            $db: $db,
            $table: $db.onlineCustomerTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> onlineOrderItemTableRefs(
    Expression<bool> Function($$OnlineOrderItemTableTableFilterComposer f) f,
  ) {
    final $$OnlineOrderItemTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.onlineOrderItemTable,
      getReferencedColumn: (t) => t.onlineOrderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineOrderItemTableTableFilterComposer(
            $db: $db,
            $table: $db.onlineOrderItemTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OnlineOrderTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OnlineOrderTableTable> {
  $$OnlineOrderTableTableOrderingComposer({
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

  ColumnOrderings<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metodePengiriman => $composableBuilder(
    column: $table.metodePengiriman,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alamatPengiriman => $composableBuilder(
    column: $table.alamatPengiriman,
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

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$OnlineCustomerTableTableOrderingComposer get customerId {
    final $$OnlineCustomerTableTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.customerId,
          referencedTable: $db.onlineCustomerTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OnlineCustomerTableTableOrderingComposer(
                $db: $db,
                $table: $db.onlineCustomerTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$OnlineOrderTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnlineOrderTableTable> {
  $$OnlineOrderTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get totalHarga => $composableBuilder(
    column: $table.totalHarga,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metodePengiriman => $composableBuilder(
    column: $table.metodePengiriman,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alamatPengiriman => $composableBuilder(
    column: $table.alamatPengiriman,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catatan =>
      $composableBuilder(column: $table.catatan, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$OnlineCustomerTableTableAnnotationComposer get customerId {
    final $$OnlineCustomerTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.customerId,
          referencedTable: $db.onlineCustomerTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OnlineCustomerTableTableAnnotationComposer(
                $db: $db,
                $table: $db.onlineCustomerTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> onlineOrderItemTableRefs<T extends Object>(
    Expression<T> Function($$OnlineOrderItemTableTableAnnotationComposer a) f,
  ) {
    final $$OnlineOrderItemTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.onlineOrderItemTable,
          getReferencedColumn: (t) => t.onlineOrderId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$OnlineOrderItemTableTableAnnotationComposer(
                $db: $db,
                $table: $db.onlineOrderItemTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$OnlineOrderTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnlineOrderTableTable,
          OnlineOrder,
          $$OnlineOrderTableTableFilterComposer,
          $$OnlineOrderTableTableOrderingComposer,
          $$OnlineOrderTableTableAnnotationComposer,
          $$OnlineOrderTableTableCreateCompanionBuilder,
          $$OnlineOrderTableTableUpdateCompanionBuilder,
          (OnlineOrder, $$OnlineOrderTableTableReferences),
          OnlineOrder,
          PrefetchHooks Function({
            bool customerId,
            bool onlineOrderItemTableRefs,
          })
        > {
  $$OnlineOrderTableTableTableManager(
    _$AppDatabase db,
    $OnlineOrderTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnlineOrderTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnlineOrderTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OnlineOrderTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> customerId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<String> metodePengiriman = const Value.absent(),
                Value<String?> alamatPengiriman = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnlineOrderTableCompanion(
                id: id,
                customerId: customerId,
                status: status,
                totalHarga: totalHarga,
                metodePengiriman: metodePengiriman,
                alamatPengiriman: alamatPengiriman,
                catatan: catatan,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String customerId,
                Value<String> status = const Value.absent(),
                Value<double> totalHarga = const Value.absent(),
                Value<String> metodePengiriman = const Value.absent(),
                Value<String?> alamatPengiriman = const Value.absent(),
                Value<String?> catatan = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnlineOrderTableCompanion.insert(
                id: id,
                customerId: customerId,
                status: status,
                totalHarga: totalHarga,
                metodePengiriman: metodePengiriman,
                alamatPengiriman: alamatPengiriman,
                catatan: catatan,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OnlineOrderTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({customerId = false, onlineOrderItemTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (onlineOrderItemTableRefs) db.onlineOrderItemTable,
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
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable:
                                        $$OnlineOrderTableTableReferences
                                            ._customerIdTable(db),
                                    referencedColumn:
                                        $$OnlineOrderTableTableReferences
                                            ._customerIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (onlineOrderItemTableRefs)
                        await $_getPrefetchedData<
                          OnlineOrder,
                          $OnlineOrderTableTable,
                          OnlineOrderItem
                        >(
                          currentTable: table,
                          referencedTable: $$OnlineOrderTableTableReferences
                              ._onlineOrderItemTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OnlineOrderTableTableReferences(
                                db,
                                table,
                                p0,
                              ).onlineOrderItemTableRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.onlineOrderId == item.id,
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

typedef $$OnlineOrderTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnlineOrderTableTable,
      OnlineOrder,
      $$OnlineOrderTableTableFilterComposer,
      $$OnlineOrderTableTableOrderingComposer,
      $$OnlineOrderTableTableAnnotationComposer,
      $$OnlineOrderTableTableCreateCompanionBuilder,
      $$OnlineOrderTableTableUpdateCompanionBuilder,
      (OnlineOrder, $$OnlineOrderTableTableReferences),
      OnlineOrder,
      PrefetchHooks Function({bool customerId, bool onlineOrderItemTableRefs})
    >;
typedef $$OnlineOrderItemTableTableCreateCompanionBuilder =
    OnlineOrderItemTableCompanion Function({
      required String id,
      required String onlineOrderId,
      required String produkId,
      required String namaProduk,
      Value<double> hargaSatuan,
      Value<int> jumlah,
      Value<double> subtotal,
      Value<String?> satuanId,
      Value<double> konversi,
      Value<bool> isUnavailable,
      Value<int> rowid,
    });
typedef $$OnlineOrderItemTableTableUpdateCompanionBuilder =
    OnlineOrderItemTableCompanion Function({
      Value<String> id,
      Value<String> onlineOrderId,
      Value<String> produkId,
      Value<String> namaProduk,
      Value<double> hargaSatuan,
      Value<int> jumlah,
      Value<double> subtotal,
      Value<String?> satuanId,
      Value<double> konversi,
      Value<bool> isUnavailable,
      Value<int> rowid,
    });

final class $$OnlineOrderItemTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $OnlineOrderItemTableTable,
          OnlineOrderItem
        > {
  $$OnlineOrderItemTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $OnlineOrderTableTable _onlineOrderIdTable(_$AppDatabase db) =>
      db.onlineOrderTable.createAlias(
        $_aliasNameGenerator(
          db.onlineOrderItemTable.onlineOrderId,
          db.onlineOrderTable.id,
        ),
      );

  $$OnlineOrderTableTableProcessedTableManager get onlineOrderId {
    final $_column = $_itemColumn<String>('online_order_id')!;

    final manager = $$OnlineOrderTableTableTableManager(
      $_db,
      $_db.onlineOrderTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_onlineOrderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProdukTableTable _produkIdTable(_$AppDatabase db) =>
      db.produkTable.createAlias(
        $_aliasNameGenerator(
          db.onlineOrderItemTable.produkId,
          db.produkTable.id,
        ),
      );

  $$ProdukTableTableProcessedTableManager get produkId {
    final $_column = $_itemColumn<String>('produk_id')!;

    final manager = $$ProdukTableTableTableManager(
      $_db,
      $_db.produkTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_produkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SatuanProdukTableTable _satuanIdTable(_$AppDatabase db) =>
      db.satuanProdukTable.createAlias(
        $_aliasNameGenerator(
          db.onlineOrderItemTable.satuanId,
          db.satuanProdukTable.id,
        ),
      );

  $$SatuanProdukTableTableProcessedTableManager? get satuanId {
    final $_column = $_itemColumn<String>('satuan_id');
    if ($_column == null) return null;
    final manager = $$SatuanProdukTableTableTableManager(
      $_db,
      $_db.satuanProdukTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_satuanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OnlineOrderItemTableTableFilterComposer
    extends Composer<_$AppDatabase, $OnlineOrderItemTableTable> {
  $$OnlineOrderItemTableTableFilterComposer({
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

  ColumnFilters<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnavailable => $composableBuilder(
    column: $table.isUnavailable,
    builder: (column) => ColumnFilters(column),
  );

  $$OnlineOrderTableTableFilterComposer get onlineOrderId {
    final $$OnlineOrderTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.onlineOrderId,
      referencedTable: $db.onlineOrderTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineOrderTableTableFilterComposer(
            $db: $db,
            $table: $db.onlineOrderTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableTableFilterComposer get produkId {
    final $$ProdukTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produkTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableTableFilterComposer(
            $db: $db,
            $table: $db.produkTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SatuanProdukTableTableFilterComposer get satuanId {
    final $$SatuanProdukTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.satuanId,
      referencedTable: $db.satuanProdukTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SatuanProdukTableTableFilterComposer(
            $db: $db,
            $table: $db.satuanProdukTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OnlineOrderItemTableTableOrderingComposer
    extends Composer<_$AppDatabase, $OnlineOrderItemTableTable> {
  $$OnlineOrderItemTableTableOrderingComposer({
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

  ColumnOrderings<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get konversi => $composableBuilder(
    column: $table.konversi,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnavailable => $composableBuilder(
    column: $table.isUnavailable,
    builder: (column) => ColumnOrderings(column),
  );

  $$OnlineOrderTableTableOrderingComposer get onlineOrderId {
    final $$OnlineOrderTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.onlineOrderId,
      referencedTable: $db.onlineOrderTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineOrderTableTableOrderingComposer(
            $db: $db,
            $table: $db.onlineOrderTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableTableOrderingComposer get produkId {
    final $$ProdukTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produkTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableTableOrderingComposer(
            $db: $db,
            $table: $db.produkTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SatuanProdukTableTableOrderingComposer get satuanId {
    final $$SatuanProdukTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.satuanId,
      referencedTable: $db.satuanProdukTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SatuanProdukTableTableOrderingComposer(
            $db: $db,
            $table: $db.satuanProdukTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OnlineOrderItemTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnlineOrderItemTableTable> {
  $$OnlineOrderItemTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namaProduk => $composableBuilder(
    column: $table.namaProduk,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hargaSatuan => $composableBuilder(
    column: $table.hargaSatuan,
    builder: (column) => column,
  );

  GeneratedColumn<int> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get konversi =>
      $composableBuilder(column: $table.konversi, builder: (column) => column);

  GeneratedColumn<bool> get isUnavailable => $composableBuilder(
    column: $table.isUnavailable,
    builder: (column) => column,
  );

  $$OnlineOrderTableTableAnnotationComposer get onlineOrderId {
    final $$OnlineOrderTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.onlineOrderId,
      referencedTable: $db.onlineOrderTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OnlineOrderTableTableAnnotationComposer(
            $db: $db,
            $table: $db.onlineOrderTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProdukTableTableAnnotationComposer get produkId {
    final $$ProdukTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.produkId,
      referencedTable: $db.produkTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProdukTableTableAnnotationComposer(
            $db: $db,
            $table: $db.produkTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SatuanProdukTableTableAnnotationComposer get satuanId {
    final $$SatuanProdukTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.satuanId,
          referencedTable: $db.satuanProdukTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SatuanProdukTableTableAnnotationComposer(
                $db: $db,
                $table: $db.satuanProdukTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$OnlineOrderItemTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnlineOrderItemTableTable,
          OnlineOrderItem,
          $$OnlineOrderItemTableTableFilterComposer,
          $$OnlineOrderItemTableTableOrderingComposer,
          $$OnlineOrderItemTableTableAnnotationComposer,
          $$OnlineOrderItemTableTableCreateCompanionBuilder,
          $$OnlineOrderItemTableTableUpdateCompanionBuilder,
          (OnlineOrderItem, $$OnlineOrderItemTableTableReferences),
          OnlineOrderItem,
          PrefetchHooks Function({
            bool onlineOrderId,
            bool produkId,
            bool satuanId,
          })
        > {
  $$OnlineOrderItemTableTableTableManager(
    _$AppDatabase db,
    $OnlineOrderItemTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnlineOrderItemTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnlineOrderItemTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OnlineOrderItemTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> onlineOrderId = const Value.absent(),
                Value<String> produkId = const Value.absent(),
                Value<String> namaProduk = const Value.absent(),
                Value<double> hargaSatuan = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<bool> isUnavailable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnlineOrderItemTableCompanion(
                id: id,
                onlineOrderId: onlineOrderId,
                produkId: produkId,
                namaProduk: namaProduk,
                hargaSatuan: hargaSatuan,
                jumlah: jumlah,
                subtotal: subtotal,
                satuanId: satuanId,
                konversi: konversi,
                isUnavailable: isUnavailable,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String onlineOrderId,
                required String produkId,
                required String namaProduk,
                Value<double> hargaSatuan = const Value.absent(),
                Value<int> jumlah = const Value.absent(),
                Value<double> subtotal = const Value.absent(),
                Value<String?> satuanId = const Value.absent(),
                Value<double> konversi = const Value.absent(),
                Value<bool> isUnavailable = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnlineOrderItemTableCompanion.insert(
                id: id,
                onlineOrderId: onlineOrderId,
                produkId: produkId,
                namaProduk: namaProduk,
                hargaSatuan: hargaSatuan,
                jumlah: jumlah,
                subtotal: subtotal,
                satuanId: satuanId,
                konversi: konversi,
                isUnavailable: isUnavailable,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OnlineOrderItemTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({onlineOrderId = false, produkId = false, satuanId = false}) {
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
                        if (onlineOrderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.onlineOrderId,
                                    referencedTable:
                                        $$OnlineOrderItemTableTableReferences
                                            ._onlineOrderIdTable(db),
                                    referencedColumn:
                                        $$OnlineOrderItemTableTableReferences
                                            ._onlineOrderIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (produkId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.produkId,
                                    referencedTable:
                                        $$OnlineOrderItemTableTableReferences
                                            ._produkIdTable(db),
                                    referencedColumn:
                                        $$OnlineOrderItemTableTableReferences
                                            ._produkIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (satuanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.satuanId,
                                    referencedTable:
                                        $$OnlineOrderItemTableTableReferences
                                            ._satuanIdTable(db),
                                    referencedColumn:
                                        $$OnlineOrderItemTableTableReferences
                                            ._satuanIdTable(db)
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

typedef $$OnlineOrderItemTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnlineOrderItemTableTable,
      OnlineOrderItem,
      $$OnlineOrderItemTableTableFilterComposer,
      $$OnlineOrderItemTableTableOrderingComposer,
      $$OnlineOrderItemTableTableAnnotationComposer,
      $$OnlineOrderItemTableTableCreateCompanionBuilder,
      $$OnlineOrderItemTableTableUpdateCompanionBuilder,
      (OnlineOrderItem, $$OnlineOrderItemTableTableReferences),
      OnlineOrderItem,
      PrefetchHooks Function({bool onlineOrderId, bool produkId, bool satuanId})
    >;
typedef $$KasHarianTableTableCreateCompanionBuilder =
    KasHarianTableCompanion Function({
      required String id,
      Value<double> modalAwal,
      Value<String?> keterangan,
      required DateTime tanggal,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$KasHarianTableTableUpdateCompanionBuilder =
    KasHarianTableCompanion Function({
      Value<String> id,
      Value<double> modalAwal,
      Value<String?> keterangan,
      Value<DateTime> tanggal,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$KasHarianTableTableFilterComposer
    extends Composer<_$AppDatabase, $KasHarianTableTable> {
  $$KasHarianTableTableFilterComposer({
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

  ColumnFilters<double> get modalAwal => $composableBuilder(
    column: $table.modalAwal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$KasHarianTableTableOrderingComposer
    extends Composer<_$AppDatabase, $KasHarianTableTable> {
  $$KasHarianTableTableOrderingComposer({
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

  ColumnOrderings<double> get modalAwal => $composableBuilder(
    column: $table.modalAwal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$KasHarianTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $KasHarianTableTable> {
  $$KasHarianTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get modalAwal =>
      $composableBuilder(column: $table.modalAwal, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$KasHarianTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KasHarianTableTable,
          KasHarianTableData,
          $$KasHarianTableTableFilterComposer,
          $$KasHarianTableTableOrderingComposer,
          $$KasHarianTableTableAnnotationComposer,
          $$KasHarianTableTableCreateCompanionBuilder,
          $$KasHarianTableTableUpdateCompanionBuilder,
          (
            KasHarianTableData,
            BaseReferences<
              _$AppDatabase,
              $KasHarianTableTable,
              KasHarianTableData
            >,
          ),
          KasHarianTableData,
          PrefetchHooks Function()
        > {
  $$KasHarianTableTableTableManager(
    _$AppDatabase db,
    $KasHarianTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KasHarianTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KasHarianTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KasHarianTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> modalAwal = const Value.absent(),
                Value<String?> keterangan = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KasHarianTableCompanion(
                id: id,
                modalAwal: modalAwal,
                keterangan: keterangan,
                tanggal: tanggal,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<double> modalAwal = const Value.absent(),
                Value<String?> keterangan = const Value.absent(),
                required DateTime tanggal,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KasHarianTableCompanion.insert(
                id: id,
                modalAwal: modalAwal,
                keterangan: keterangan,
                tanggal: tanggal,
                createdAt: createdAt,
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

typedef $$KasHarianTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KasHarianTableTable,
      KasHarianTableData,
      $$KasHarianTableTableFilterComposer,
      $$KasHarianTableTableOrderingComposer,
      $$KasHarianTableTableAnnotationComposer,
      $$KasHarianTableTableCreateCompanionBuilder,
      $$KasHarianTableTableUpdateCompanionBuilder,
      (
        KasHarianTableData,
        BaseReferences<_$AppDatabase, $KasHarianTableTable, KasHarianTableData>,
      ),
      KasHarianTableData,
      PrefetchHooks Function()
    >;
typedef $$PengeluaranOperasionalTableTableCreateCompanionBuilder =
    PengeluaranOperasionalTableCompanion Function({
      required String id,
      Value<double> jumlah,
      Value<String> kategori,
      Value<String?> keterangan,
      required DateTime tanggal,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$PengeluaranOperasionalTableTableUpdateCompanionBuilder =
    PengeluaranOperasionalTableCompanion Function({
      Value<String> id,
      Value<double> jumlah,
      Value<String> kategori,
      Value<String?> keterangan,
      Value<DateTime> tanggal,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PengeluaranOperasionalTableTableFilterComposer
    extends Composer<_$AppDatabase, $PengeluaranOperasionalTableTable> {
  $$PengeluaranOperasionalTableTableFilterComposer({
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

  ColumnFilters<double> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PengeluaranOperasionalTableTableOrderingComposer
    extends Composer<_$AppDatabase, $PengeluaranOperasionalTableTable> {
  $$PengeluaranOperasionalTableTableOrderingComposer({
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

  ColumnOrderings<double> get jumlah => $composableBuilder(
    column: $table.jumlah,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kategori => $composableBuilder(
    column: $table.kategori,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get tanggal => $composableBuilder(
    column: $table.tanggal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PengeluaranOperasionalTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $PengeluaranOperasionalTableTable> {
  $$PengeluaranOperasionalTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get jumlah =>
      $composableBuilder(column: $table.jumlah, builder: (column) => column);

  GeneratedColumn<String> get kategori =>
      $composableBuilder(column: $table.kategori, builder: (column) => column);

  GeneratedColumn<String> get keterangan => $composableBuilder(
    column: $table.keterangan,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get tanggal =>
      $composableBuilder(column: $table.tanggal, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PengeluaranOperasionalTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PengeluaranOperasionalTableTable,
          PengeluaranOperasionalTableData,
          $$PengeluaranOperasionalTableTableFilterComposer,
          $$PengeluaranOperasionalTableTableOrderingComposer,
          $$PengeluaranOperasionalTableTableAnnotationComposer,
          $$PengeluaranOperasionalTableTableCreateCompanionBuilder,
          $$PengeluaranOperasionalTableTableUpdateCompanionBuilder,
          (
            PengeluaranOperasionalTableData,
            BaseReferences<
              _$AppDatabase,
              $PengeluaranOperasionalTableTable,
              PengeluaranOperasionalTableData
            >,
          ),
          PengeluaranOperasionalTableData,
          PrefetchHooks Function()
        > {
  $$PengeluaranOperasionalTableTableTableManager(
    _$AppDatabase db,
    $PengeluaranOperasionalTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PengeluaranOperasionalTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PengeluaranOperasionalTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PengeluaranOperasionalTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<double> jumlah = const Value.absent(),
                Value<String> kategori = const Value.absent(),
                Value<String?> keterangan = const Value.absent(),
                Value<DateTime> tanggal = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PengeluaranOperasionalTableCompanion(
                id: id,
                jumlah: jumlah,
                kategori: kategori,
                keterangan: keterangan,
                tanggal: tanggal,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<double> jumlah = const Value.absent(),
                Value<String> kategori = const Value.absent(),
                Value<String?> keterangan = const Value.absent(),
                required DateTime tanggal,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PengeluaranOperasionalTableCompanion.insert(
                id: id,
                jumlah: jumlah,
                kategori: kategori,
                keterangan: keterangan,
                tanggal: tanggal,
                createdAt: createdAt,
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

typedef $$PengeluaranOperasionalTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PengeluaranOperasionalTableTable,
      PengeluaranOperasionalTableData,
      $$PengeluaranOperasionalTableTableFilterComposer,
      $$PengeluaranOperasionalTableTableOrderingComposer,
      $$PengeluaranOperasionalTableTableAnnotationComposer,
      $$PengeluaranOperasionalTableTableCreateCompanionBuilder,
      $$PengeluaranOperasionalTableTableUpdateCompanionBuilder,
      (
        PengeluaranOperasionalTableData,
        BaseReferences<
          _$AppDatabase,
          $PengeluaranOperasionalTableTable,
          PengeluaranOperasionalTableData
        >,
      ),
      PengeluaranOperasionalTableData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserTableTableTableManager get userTable =>
      $$UserTableTableTableManager(_db, _db.userTable);
  $$ProdukTableTableTableManager get produkTable =>
      $$ProdukTableTableTableManager(_db, _db.produkTable);
  $$SatuanProdukTableTableTableManager get satuanProdukTable =>
      $$SatuanProdukTableTableTableManager(_db, _db.satuanProdukTable);
  $$RiwayatPerubahanProdukTableTableTableManager
  get riwayatPerubahanProdukTable =>
      $$RiwayatPerubahanProdukTableTableTableManager(
        _db,
        _db.riwayatPerubahanProdukTable,
      );
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
  $$PurchaseOrderTableTableTableManager get purchaseOrderTable =>
      $$PurchaseOrderTableTableTableManager(_db, _db.purchaseOrderTable);
  $$PurchaseOrderItemTableTableTableManager get purchaseOrderItemTable =>
      $$PurchaseOrderItemTableTableTableManager(
        _db,
        _db.purchaseOrderItemTable,
      );
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
  $$LocalAuthTableTableTableManager get localAuthTable =>
      $$LocalAuthTableTableTableManager(_db, _db.localAuthTable);
  $$OnlineCustomerTableTableTableManager get onlineCustomerTable =>
      $$OnlineCustomerTableTableTableManager(_db, _db.onlineCustomerTable);
  $$OnlineOrderTableTableTableManager get onlineOrderTable =>
      $$OnlineOrderTableTableTableManager(_db, _db.onlineOrderTable);
  $$OnlineOrderItemTableTableTableManager get onlineOrderItemTable =>
      $$OnlineOrderItemTableTableTableManager(_db, _db.onlineOrderItemTable);
  $$KasHarianTableTableTableManager get kasHarianTable =>
      $$KasHarianTableTableTableManager(_db, _db.kasHarianTable);
  $$PengeluaranOperasionalTableTableTableManager
  get pengeluaranOperasionalTable =>
      $$PengeluaranOperasionalTableTableTableManager(
        _db,
        _db.pengeluaranOperasionalTable,
      );
}
