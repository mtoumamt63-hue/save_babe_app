/// Représente un échec dans la couche Domain.
/// Utilise les sealed classes natives Dart 3 avec `Either<Failure, T>` (fpdart).
sealed class Failure {
  const Failure(this.message, {this.cause});
  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

/// Erreur de lecture/écriture en stockage local (Hive)
final class StorageFailure extends Failure {
  const StorageFailure({required String message, Object? cause})
    : super(message, cause: cause);
}

/// Erreur réseau (pas de connexion, timeout)
final class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    this.statusCode,
    Object? cause,
  }) : super(message, cause: cause);
  final int? statusCode;
}

/// Erreur lors de la reconnaissance OCR
final class OcrFailure extends Failure {
  const OcrFailure({required String message, Object? cause})
    : super(message, cause: cause);
}

/// Erreur audio (microphone, TTS)
final class AudioFailure extends Failure {
  const AudioFailure({required String message, Object? cause})
    : super(message, cause: cause);
}

/// Erreur générique non catégorisée
final class UnknownFailure extends Failure {
  const UnknownFailure({required String message, Object? cause})
    : super(message, cause: cause);
}
