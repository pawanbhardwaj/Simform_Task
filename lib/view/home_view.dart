import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_db_task/model/user_model.dart';
import 'package:local_db_task/viewModel/user_remote_local.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserProvider userProvider;
  final ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    userProvider.toogleInternetValues(result != ConnectivityResult.none);
    if (result != ConnectivityResult.none) {
      userProvider.getUsersFromRemote();
    }
  }

  @override
  void initState() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    log(_connectionStatus.name);
    if (_connectionStatus != ConnectivityResult.none) {
      log('internet is there');
      userProvider.getUsersFromRemote();
      userProvider.getDataFromLocalDb();
    } else {
      userProvider.getDataFromLocalDb();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    userProvider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Consumer<UserProvider>(
                builder: (context, value, child) => SingleChildScrollView(
                        child: Column(children: [
                      const SizedBox(
                        height: 11,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Internet Connectivity: ${userProvider.internetOn ? "Connected to interenet" : "Internet Not connected, from local db"}",
                          style: const TextStyle(fontSize: 21),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            if (userProvider.internetOn) {
                              userProvider.getUsersFromRemote();
                            } else {
                              userProvider.getDataFromLocalDb();
                            }
                          },
                          icon: const Icon(
                            Icons.refresh,
                            size: 30,
                          )),
                      const SizedBox(
                        height: 11,
                        child: Divider(
                          height: 12,
                          thickness: 2,
                        ),
                      ),
                      if (userProvider.syncingNewData &&
                          userProvider.internetOn)
                        const LinearProgressIndicator(),
                      const SizedBox(
                        height: 21,
                      ),
                      SizedBox(
                        height: userProvider.syncingNewData ? 31 : 0,
                        child: const Text(
                            "Users data is getting fetched from API"),
                      ),
                      userProvider.isLoadingData
                          ? const Center(child: CircularProgressIndicator())
                          : userProvider.userModel.results.isEmpty
                              ? const Center(
                                  child: Text(
                                      "No data in the local database, Please turn on internet"),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  shrinkWrap: true,
                                  itemCount:
                                      userProvider.userModel.results.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Result result =
                                        userProvider.userModel.results[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(result.email),
                                    );
                                  },
                                )
                    ])))));
  }
}
