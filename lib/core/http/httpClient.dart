import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future<http.Response> get({required String url});
}

class HttpClient implements IHttpClient {
  final http.Client client;
  HttpClient({http.Client? client}) : client = client ?? http.Client();
  @override
  Future<http.Response> get({required String url}) =>
      client.get(Uri.parse(url));
  void close() => client.close();
}
