import 'package:http/http.dart';
import 'package:http_client/src/http_client.dart';
import 'package:http_client/src/http_client_impl.dart';

HttpClient makeHttpClient() => HttpClientImpl(Client());
