import 'package:drift/drift.dart';

/// Queue operasi yang belum berhasil di-sync ke Supabase (offline mode).
/// Saat koneksi kembali, semua record di sini di-flush ke Supabase.
class PendingSyncQueueTable extends Table {
  IntColumn get id        => integer().autoIncrement()();
  TextColumn get targetTable => text()(); // nama tabel Supabase target
  TextColumn get operation => text()(); // 'upsert' | 'delete'
  TextColumn get recordId  => text()(); // UUID record
  TextColumn get payload   => text()(); // JSON encoded data
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
