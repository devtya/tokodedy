class Failure {
  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  const Failure(this.message, {this.exception, this.stackTrace});

  @override
  String toString() => message;
}
