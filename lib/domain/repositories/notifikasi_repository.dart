import '../entities/notifikasi.dart';

abstract class NotifikasiRepository {
  Future<List<Notifikasi>> getUnreadNotifikasi();
  Future<List<Notifikasi>> getAllNotifikasi();
  Future<void> addNotifikasi(Notifikasi notifikasi);
  Future<void> markAsRead(String id);
  Stream<int> watchUnreadCount();
  Future<List<Notifikasi>> getNotifikasiByJudul(String search);
}
