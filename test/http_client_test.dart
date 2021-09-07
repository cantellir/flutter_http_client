import 'dart:io';

import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';

import 'package:http_client/http_client.dart';
import 'package:http_client/src/http_client_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements Client {}

void main() {
  late MockClient client;
  late HttpClient sut;
  late String uri;

  setUp(() {
    client = MockClient();
    sut = HttpClientImpl(client);
    uri = faker.internet.httpUrl();
  });

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('get', () {
    void mockResponse(
        {int statusCode = 200, String body = '{"any_key":"any_value"}'}) {
      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenThrow(Exception());
    }

    test('Should call get with correct values', () async {
      mockResponse();

      await sut.get(uri: uri);
      verify(() => client.get(Uri.parse(uri), headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          }));

      await sut.get(uri: uri, headers: {'any_header': 'any_value'});
      verify(() => client.get(Uri.parse(uri), headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          }));
    });

    test('Should return data if get returns 200', () async {
      mockResponse();

      final response = await sut.get(uri: uri);

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if get returns 200 with no data', () async {
      mockResponse(body: '');

      final response = await sut.get(uri: uri);

      expect(response, null);
    });

    test('Should return null if get returns 204', () async {
      mockResponse(statusCode: 204, body: '');

      final response = await sut.get(uri: uri);

      expect(response, null);
    });

    test('Should return null if get returns 204 with data', () async {
      mockResponse(statusCode: 204);

      final response = await sut.get(uri: uri);

      expect(response, null);
    });

    test('Should throws HttpBadRequestError if get returns 400', () async {
      mockResponse(statusCode: 400);

      final future = sut.get(uri: uri);

      expect(future, throwsA(isA<HttpBadRequestError>()));
    });

    test('Should throws HttpUnauthorizedError if get returns 401', () async {
      mockResponse(statusCode: 401);

      final future = sut.get(uri: uri);

      expect(future, throwsA(isA<HttpUnauthorizedError>()));
    });

    test('Should throws HttpNotFoundError if get returns 404', () async {
      mockResponse(statusCode: 404);

      final future = sut.get(uri: uri);

      expect(future, throwsA(isA<HttpNotFoundError>()));
    });

    test('Should throws HttpServerError if get returns 500', () async {
      mockResponse(statusCode: 500);

      final future = sut.get(uri: uri);

      expect(future, throwsA(isA<HttpServerError>()));
    });

    test('Should throws HttpUnexpectedError if get throws', () async {
      mockError();

      final future = sut.get(uri: uri);

      expect(future, throwsA(isA<HttpUnexpectedError>()));
    });

    test('Should throws HttpNetworkError if get throw SocketException',
        () async {
      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenThrow(SocketException(''));

      final future = sut.get(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });

    test('Should throws HttpNetworkError if get throw ClientException',
        () async {
      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenThrow(ClientException(''));

      final future = sut.get(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });
  });

  group('post', () {
    void mockResponse(
        {int statusCode = 200, String body = '{"any_key":"any_value"}'}) {
      when(() => client.post(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      when(() => client.post(any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'))).thenThrow(Exception());
    }

    test('Should call post with correct values', () async {
      mockResponse();

      await sut.post(uri: uri, body: {'any_key': 'any_value'});
      verify(() => client.post(Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.post(
          uri: uri,
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});
      verify(() => client.post(Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call post without body', () async {
      mockResponse();

      await sut.post(uri: uri);

      verify(() => client.post(any(), headers: any(named: 'headers')));
    });

    test('Should return data if post returns 200', () async {
      mockResponse();

      final response = await sut.post(uri: uri);

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if post returns 200 with no data', () async {
      mockResponse(body: '');

      final response = await sut.post(uri: uri);

      expect(response, null);
    });

    test('Should return null if post returns 204', () async {
      mockResponse(statusCode: 204, body: '');

      final response = await sut.post(uri: uri);

      expect(response, null);
    });

    test('Should return null if post returns 204 with data', () async {
      mockResponse(statusCode: 204);

      final response = await sut.post(uri: uri);

      expect(response, null);
    });

    test('Should throws HttpBadRequestError if post returns 400', () async {
      mockResponse(statusCode: 400);

      final future = sut.post(uri: uri);

      expect(future, throwsA(isA<HttpBadRequestError>()));
    });

    test('Should throws HttpUnauthorizedError if post returns 401', () async {
      mockResponse(statusCode: 401);

      final future = sut.post(uri: uri);

      expect(future, throwsA(isA<HttpUnauthorizedError>()));
    });

    test('Should throws HttpNotFoundError if post returns 404', () async {
      mockResponse(statusCode: 404);

      final future = sut.post(uri: uri);

      expect(future, throwsA(isA<HttpNotFoundError>()));
    });

    test('Should throws HttpServerError if post returns 500', () async {
      mockResponse(statusCode: 500);

      final future = sut.post(uri: uri);

      expect(future, throwsA(isA<HttpServerError>()));
    });

    test('Should throws HttpUnexpectedError if post throws', () async {
      mockError();

      final future = sut.post(uri: uri);

      expect(future, throwsA(isA<HttpUnexpectedError>()));
    });

    test('Should throws HttpNetworkError if post throw SocketException',
        () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenThrow(SocketException(''));

      final future = sut.post(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });

    test('Should throws HttpNetworkError if post throw ClientException',
        () async {
      when(() => client.post(any(), headers: any(named: 'headers')))
          .thenThrow(ClientException(''));

      final future = sut.post(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });
  });

  group('put', () {
    void mockResponse(
        {int statusCode = 200, String body = '{"any_key":"any_value"}'}) {
      when(() => client.put(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      when(() => client.put(any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'))).thenThrow(Exception());
    }

    test('Should call put with correct values', () async {
      mockResponse();

      await sut.put(uri: uri, body: {'any_key': 'any_value'});
      verify(() => client.put(Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.put(
          uri: uri,
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});
      verify(() => client.put(Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call put without body', () async {
      mockResponse();

      await sut.put(uri: uri);

      verify(() => client.put(any(), headers: any(named: 'headers')));
    });

    test('Should return data if put returns 200', () async {
      mockResponse();

      final response = await sut.put(uri: uri);

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if put returns 200 with no data', () async {
      mockResponse(body: '');

      final response = await sut.put(uri: uri);

      expect(response, null);
    });

    test('Should return null if put returns 204', () async {
      mockResponse(statusCode: 204, body: '');

      final response = await sut.put(uri: uri);

      expect(response, null);
    });

    test('Should return null if put returns 204 with data', () async {
      mockResponse(statusCode: 204);

      final response = await sut.put(uri: uri);

      expect(response, null);
    });

    test('Should throws HttpBadRequestError if put returns 400', () async {
      mockResponse(statusCode: 400);

      final future = sut.put(uri: uri);

      expect(future, throwsA(isA<HttpBadRequestError>()));
    });

    test('Should throws HttpUnauthorizedError if put returns 401', () async {
      mockResponse(statusCode: 401);

      final future = sut.put(uri: uri);

      expect(future, throwsA(isA<HttpUnauthorizedError>()));
    });

    test('Should throws HttpNotFoundError if put returns 404', () async {
      mockResponse(statusCode: 404);

      final future = sut.put(uri: uri);

      expect(future, throwsA(isA<HttpNotFoundError>()));
    });

    test('Should throws HttpServerError if put returns 500', () async {
      mockResponse(statusCode: 500);

      final future = sut.put(uri: uri);

      expect(future, throwsA(isA<HttpServerError>()));
    });

    test('Should throws HttpUnexpectedError if put throws', () async {
      mockError();

      final future = sut.put(uri: uri);

      expect(future, throwsA(isA<HttpUnexpectedError>()));
    });

    test('Should throws HttpNetworkError if put throw SocketException',
        () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenThrow(SocketException(''));

      final future = sut.put(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });

    test('Should throws HttpNetworkError if put throw ClientException',
        () async {
      when(() => client.put(any(), headers: any(named: 'headers')))
          .thenThrow(ClientException(''));

      final future = sut.put(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });
  });

  group('patch', () {
    void mockResponse(
        {int statusCode = 200, String body = '{"any_key":"any_value"}'}) {
      when(() => client.patch(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      when(() => client.patch(any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'))).thenThrow(Exception());
    }

    test('Should call patch with correct values', () async {
      mockResponse();

      await sut.patch(uri: uri, body: {'any_key': 'any_value'});
      verify(() => client.patch(Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.patch(
          uri: uri,
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});

      verify(() => client.patch(Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call patch without body', () async {
      mockResponse();

      await sut.patch(uri: uri);

      verify(() => client.patch(any(), headers: any(named: 'headers')));
    });

    test('Should return data if patch returns 200', () async {
      mockResponse();

      final response = await sut.patch(uri: uri);

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if patch returns 200 with no data', () async {
      mockResponse(body: '');

      final response = await sut.patch(uri: uri);

      expect(response, null);
    });

    test('Should return null if patch returns 204', () async {
      mockResponse(statusCode: 204, body: '');

      final response = await sut.patch(uri: uri);

      expect(response, null);
    });

    test('Should return null if patch returns 204 with data', () async {
      mockResponse(statusCode: 204);

      final response = await sut.patch(uri: uri);

      expect(response, null);
    });

    test('Should throws HttpBadRequestError if patch returns 400', () async {
      mockResponse(statusCode: 400);

      final future = sut.patch(uri: uri);

      expect(future, throwsA(isA<HttpBadRequestError>()));
    });

    test('Should throws HttpUnauthorizedError if patch returns 401', () async {
      mockResponse(statusCode: 401);

      final future = sut.patch(uri: uri);

      expect(future, throwsA(isA<HttpUnauthorizedError>()));
    });

    test('Should throws HttpNotFoundError if patch returns 404', () async {
      mockResponse(statusCode: 404);

      final future = sut.patch(uri: uri);

      expect(future, throwsA(isA<HttpNotFoundError>()));
    });

    test('Should throws HttpServerError if patch returns 500', () async {
      mockResponse(statusCode: 500);

      final future = sut.patch(uri: uri);

      expect(future, throwsA(isA<HttpServerError>()));
    });

    test('Should throws HttpUnexpectedError if patch throws', () async {
      mockError();

      final future = sut.patch(uri: uri);

      expect(future, throwsA(isA<HttpUnexpectedError>()));
    });

    test('Should throws HttpNetworkError if patch throw SocketException',
        () async {
      when(() => client.patch(any(), headers: any(named: 'headers')))
          .thenThrow(SocketException(''));

      final future = sut.patch(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });

    test('Should throws HttpNetworkError if patch throw ClientException',
        () async {
      when(() => client.patch(any(), headers: any(named: 'headers')))
          .thenThrow(ClientException(''));

      final future = sut.patch(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });
  });

  group('delete', () {
    void mockResponse(
        {int statusCode = 200, String body = '{"any_key":"any_value"}'}) {
      when(() => client.delete(any(),
              body: any(named: 'body'), headers: any(named: 'headers')))
          .thenAnswer((_) async => Response(body, statusCode));
    }

    void mockError() {
      when(() => client.delete(any(),
          body: any(named: 'body'),
          headers: any(named: 'headers'))).thenThrow(Exception());
    }

    test('Should call delete with correct values', () async {
      mockResponse();

      await sut.delete(uri: uri, body: {'any_key': 'any_value'});

      verify(() => client.delete(Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json'
          },
          body: '{"any_key":"any_value"}'));

      await sut.delete(
          uri: uri,
          body: {'any_key': 'any_value'},
          headers: {'any_header': 'any_value'});

      verify(() => client.delete(Uri.parse(uri),
          headers: {
            'content-type': 'application/json',
            'accept': 'application/json',
            'any_header': 'any_value'
          },
          body: '{"any_key":"any_value"}'));
    });

    test('Should call delete without body', () async {
      mockResponse();

      await sut.delete(uri: uri);

      verify(() => client.delete(any(), headers: any(named: 'headers')));
    });

    test('Should return data if delete returns 200', () async {
      mockResponse();

      final response = await sut.delete(uri: uri);

      expect(response, {'any_key': 'any_value'});
    });

    test('Should return null if delete returns 200 with no data', () async {
      mockResponse(body: '');

      final response = await sut.delete(uri: uri);

      expect(response, null);
    });

    test('Should return null if delete returns 204', () async {
      mockResponse(statusCode: 204, body: '');

      final response = await sut.delete(uri: uri);

      expect(response, null);
    });

    test('Should return null if delete returns 204 with data', () async {
      mockResponse(statusCode: 204);

      final response = await sut.delete(uri: uri);

      expect(response, null);
    });

    test('Should throws HttpBadRequestError if delete returns 400', () async {
      mockResponse(statusCode: 400);

      final future = sut.delete(uri: uri);

      expect(future, throwsA(isA<HttpBadRequestError>()));
    });

    test('Should throws HttpUnauthorizedError if delete returns 401', () async {
      mockResponse(statusCode: 401);

      final future = sut.delete(uri: uri);

      expect(future, throwsA(isA<HttpUnauthorizedError>()));
    });

    test('Should throws HttpNotFoundError if delete returns 404', () async {
      mockResponse(statusCode: 404);

      final future = sut.delete(uri: uri);

      expect(future, throwsA(isA<HttpNotFoundError>()));
    });

    test('Should throws HttpServerError if delete returns 500', () async {
      mockResponse(statusCode: 500);

      final future = sut.delete(uri: uri);

      expect(future, throwsA(isA<HttpServerError>()));
    });

    test('Should throws HttpUnexpectedError if delete throws', () async {
      mockError();

      final future = sut.delete(uri: uri);

      expect(future, throwsA(isA<HttpUnexpectedError>()));
    });

    test('Should throws HttpNetworkError if delete throw SocketException',
        () async {
      when(() => client.delete(any(), headers: any(named: 'headers')))
          .thenThrow(SocketException(''));

      final future = sut.delete(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });

    test('Should throws HttpNetworkError if delete throw ClientException',
        () async {
      when(() => client.delete(any(), headers: any(named: 'headers')))
          .thenThrow(ClientException(''));

      final future = sut.delete(uri: uri);

      expect(future, throwsA(isA<HttpNetworkError>()));
    });
  });
}
