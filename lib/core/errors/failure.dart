abstract class Failure {
  const Failure(this.message, {this.code});
  final String message;
  final String? code;
}

class GoogleAuthFailure extends Failure {
  const GoogleAuthFailure(super.message);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message, {super.code});
}

class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message, {super.code});
}

class InvalidApiKeyFailure extends Failure {
  const InvalidApiKeyFailure(super.message, {super.code});
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, {super.code});
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.code});
}

class PlatformFailure extends Failure {
  const PlatformFailure(super.message);
}
