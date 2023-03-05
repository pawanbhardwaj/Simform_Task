import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:local_db_task/model/user_model.dart';
import 'package:local_db_task/webservices/api_provider.dart';

/* Moor was not used in this project , as it has been discontinued and shifted to drift*/

class UserProvider with ChangeNotifier {
  late UserModel _userModel;
  UserModel get userModel => _userModel;
  bool _isloadingData = true;
  bool get isLoadingData => _isloadingData;
  final apiService = ApiProvider();
  bool _internetOn = false;
  bool get internetOn => _internetOn;
  bool _syncingNewData = false;
  bool get syncingNewData => _syncingNewData;

  toogleInternetValues(bool v) async {
    log('provider called with $v value');
    _internetOn = v;
    notifyListeners();
  }

  Future getUsersFromRemote() async {
    var box = await Hive.openBox<Result>('users');
    // _isloadingData = true;
    if (box.values.toList().isNotEmpty) {
      _syncingNewData = true;
    }
    UserModel userModel = (await apiService.getAllUsersFromRemote())!;
    log('Data arrived from internt/// ${userModel.results.first.email}');
    if (box.values.toList().isEmpty || _internetOn) {
      _userModel = userModel;
    }

    await saveDataLocally(userModel.results);
    _syncingNewData = false;

    _isloadingData = false;
    notifyListeners();
  }

  Future saveDataLocally(List<Result> results) async {
    var box = await Hive.openBox<Result>('users');

    box.clear();
    box.addAll(results);
    log('Data saved to local db/// ${results.last.email}');
  }

  Future getDataFromLocalDb() async {
    var box = await Hive.openBox<Result>('users');
    List<Result> results = box.values.toList();
    log("Users length from local db l${results.length}");

    _userModel = UserModel(results: results);
    if (results.isNotEmpty) {
      log('Data arrived from local db/// ${results.first.email}');
    } else {
      getUsersFromRemote();
    }
    log('success');

    _isloadingData = false;
    notifyListeners();
  }
}
