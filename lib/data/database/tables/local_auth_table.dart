import 'package:drift/drift.dart';

class LocalAuthTable extends Table {
  TextColumn get userId => text()();
  TextColumn get pinHash => text()();
  BoolColumn get biometricEnabled =>
      boolean().withDefault(const Constant(false))();
  IntColumn get failedAttempts => integer().withDefault(const Constant(0))();
  DateTimeColumn? get lockoutUntil => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {userId};
}
