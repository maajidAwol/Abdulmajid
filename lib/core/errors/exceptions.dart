class ServerException implements Exception {
  final String? message;

  const ServerException([this.message]);

  @override
  String toString() {
    return message ?? "Server Exception";
  }
}

class FetchDataException implements Exception {
  final String? message;

  const FetchDataException([this.message]);

  @override
  String toString() {
    return message ?? "Error During Communication";
  }
}

class BadRequestException implements Exception {
  final String? message;

  const BadRequestException([this.message]);

  @override
  String toString() {
    return message ?? "Bad Request";
  }
}

class UnauthorizedException implements Exception {
  final String? message;

  const UnauthorizedException([this.message]);

  @override
  String toString() {
    return message ?? "Unauthorized";
  }
}

class NotFoundException implements Exception {
  final String? message;

  const NotFoundException([this.message]);

  @override
  String toString() {
    return message ?? "Not Found";
  }
}

class ConflictException implements Exception {
  final String? message;

  const ConflictException([this.message]);

  @override
  String toString() {
    return message ?? "Conflict";
  }
}

class UnprocessableEntityException implements Exception {
  final String? message;

  const UnprocessableEntityException([this.message]);

  @override
  String toString() {
    return message ?? "Unprocessable Entity";
  }
}

class InternalServerErrorException implements Exception {
  final String? message;

  const InternalServerErrorException([this.message]);

  @override
  String toString() {
    return message ?? "Internal Server Error";
  }
}

class NoInternetConnectionException implements Exception {
  final String? message;

  const NoInternetConnectionException([this.message]);

  @override
  String toString() {
    return message ?? "No Internet Connection";
  }
}

class CacheException implements Exception {
  final String? message;

  const CacheException([this.message]);

  @override
  String toString() {
    return message ?? "Cache Exception";
  }
}

class BadCertificateException implements Exception {
  final String? message;

  const BadCertificateException([this.message]);

  @override
  String toString() {
    return message ?? "Bad Certificate";
  }
}
