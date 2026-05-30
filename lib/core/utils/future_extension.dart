import 'package:fpdart/fpdart.dart';
import '../errors/failure.dart';

extension FutureEitherExtension<T> on Future<T> {
  /// Membungkus eksekusi Future ke dalam Either<Failure, T>.
  /// Jika Future sukses, mengembalikan Right(value).
  /// Jika Future melempar exception, mengembalikan Left(Failure(message)).
  Future<Either<Failure, T>> toEither() async {
    try {
      final result = await this;
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
