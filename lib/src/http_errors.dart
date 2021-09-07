class HttpError {
  String? error;

  HttpError([this.error]);
}

class HttpUnauthorizedError extends HttpError {
  HttpUnauthorizedError() : super();
}

class HttpUnexpectedError extends HttpError {
  HttpUnexpectedError() : super();
}

class HttpBadRequestError extends HttpError {
  HttpBadRequestError(String? error) : super(error);
}

class HttpNetworkError extends HttpError {
  HttpNetworkError() : super();
}

class HttpNotFoundError extends HttpError {
  HttpNotFoundError() : super();
}

class HttpForbiddenError extends HttpError {
  HttpForbiddenError() : super();
}

class HttpServerError extends HttpError {
  HttpServerError() : super();
}
