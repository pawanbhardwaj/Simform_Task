import 'package:dio/dio.dart';

String baseUrl = 'https://randomuser.me/api/';

class ApiManager {
  Future<Dio> dio() async {
    Dio dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    return dio;
  }
}
