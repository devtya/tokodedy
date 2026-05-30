import 'package:fpdart/fpdart.dart';
import '../errors/failure.dart';

Future<Either<Failure, T>> runGuard<T>(Future<T> Function() action) async {
  try {
    final result = await action();
    return Right(result);
  } catch (e) {
    return Left(Failure(e.toString()));
  }
}

Either<Failure, T> runGuardSync<T>(T Function() action) {
  try {
    final result = action();
    return Right(result);
  } catch (e) {
    return Left(Failure(e.toString()));
  }
}
