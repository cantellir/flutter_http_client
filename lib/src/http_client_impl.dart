import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http_client/src/http_client.dart';
import 'package:http_client/src/http_exceptions.dart';

class HttpClientImpl implements HttpClient {
  final Client client;

  HttpClientImpl(this.client);

  Duration get _timeout => Duration(seconds: 15);

  @override
  Future<dynamic> get({required String uri, Map? headers}) async {
    late Response response;
    try {
      final newHeaders = _handleHeaders(headers);
      response = await client
          .get(Uri.parse(uri), headers: newHeaders)
          .timeout(_timeout);
    } catch (e) {
      _handleException(e);
    }
    return _handleResponse(response);
  }

  Future<dynamic> post({required String uri, Map? body, Map? headers}) async {
    late Response response;
    try {
      final newHeaders = _handleHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;
      response = await client
          .post(Uri.parse(uri), body: jsonBody, headers: newHeaders)
          .timeout(_timeout);
    } catch (e) {
      _handleException(e);
    }
    return _handleResponse(response);
  }

  @override
  Future<dynamic> put({required String uri, Map? body, Map? headers}) async {
    late Response response;
    try {
      final newHeaders = _handleHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;
      response = await client
          .put(Uri.parse(uri), body: jsonBody, headers: newHeaders)
          .timeout(_timeout);
    } catch (e) {
      _handleException(e);
    }
    return _handleResponse(response);
  }

  @override
  Future<dynamic> patch({required String uri, Map? body, Map? headers}) async {
    late Response response;
    try {
      final newHeaders = _handleHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;
      response = await client
          .patch(Uri.parse(uri), body: jsonBody, headers: newHeaders)
          .timeout(_timeout);
    } catch (e) {
      _handleException(e);
    }
    return _handleResponse(response);
  }

  @override
  Future<dynamic> delete({required String uri, Map? body, Map? headers}) async {
    late Response response;
    try {
      final newHeaders = _handleHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;
      response = await client
          .delete(Uri.parse(uri), body: jsonBody, headers: newHeaders)
          .timeout(_timeout);
    } catch (e) {
      _handleException(e);
    }
    return _handleResponse(response);
  }

  Map<String, String> _handleHeaders([Map? headers]) {
    return ((headers ?? {})
          ..addAll({
            'content-type': 'application/json',
            'accept': 'application/json',
          }))
        .cast();
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.body.isEmpty ? null : jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw HttpBadRequestException(
            response.body.isEmpty ? null : response.body);
      case 401:
        throw HttpUnauthorizedException();
      case 403:
        throw HttpForbiddenException();
      case 404:
        throw HttpNotFoundException();
      case 500:
        throw HttpServerException();
      default:
        throw HttpUnexpectedException();
    }
  }

  void _handleException(Object exception) {
    if (exception is SocketException || exception is ClientException) {
      throw HttpNetworkException();
    }
    throw HttpUnexpectedException();
  }
}
