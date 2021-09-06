class HttpClientException {
  String? error;

  HttpClientException([this.error]);
}

class HttpUnauthorizedException extends HttpClientException {
  HttpUnauthorizedException() : super();
}

class HttpUnexpectedException extends HttpClientException {
  HttpUnexpectedException() : super();
}

class HttpBadRequestException extends HttpClientException {
  HttpBadRequestException(String? error) : super(error);
}

class HttpNetworkException extends HttpClientException {
  HttpNetworkException() : super();
}

class HttpNotFoundException extends HttpClientException {
  HttpNotFoundException() : super();
}

class HttpForbiddenException extends HttpClientException {
  HttpForbiddenException() : super();
}

class HttpServerException extends HttpClientException {
  HttpServerException() : super();
}
