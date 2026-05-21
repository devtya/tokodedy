import '../entities/hutang_piutang.dart';

abstract class HutangPiutangRepository {
  Future<List<HutangPiutang>> getAllHutang();
  Future<List<HutangPiutang>> getHutangByStatus(String status);
  Future<void> addHutang(HutangPiutang hutang);
  Future<void> updateStatus(String id, String status);
}
