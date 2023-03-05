import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:local_db_task/model/user_model.dart';

import 'api_manager.dart';

class ApiProvider {
  final ApiManager apiManager = ApiManager();

  /// API to fetch all users
  Future<UserModel?> getAllUsersFromRemote() async {
    try {
      Dio dio = await apiManager.dio();

      Response response = await dio.get('?results=100');

      var dataFromApi = response.data;

      return userModelFromJson(jsonEncode(dataFromApi));
    } on DioError catch (e) {
      log("Dio error");
      log(e.message.toString());
      return null;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
