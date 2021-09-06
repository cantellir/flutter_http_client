abstract class HttpClient {
  Future<dynamic> get({required String uri, Map? headers});
  Future<dynamic> post({required String uri, Map? body, Map? headers});
  Future<dynamic> put({required String uri, Map? body, Map? headers});
  Future<dynamic> patch({required String uri, Map? body, Map? headers});
  Future<dynamic> delete({required String uri, Map? body, Map? headers});
}
