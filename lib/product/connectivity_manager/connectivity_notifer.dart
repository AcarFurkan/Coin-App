import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectivityNotifier extends ChangeNotifier {
  ConnectivityResult connectionStatus = ConnectivityResult.mobile;
  final Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  late BuildContext context;

  void init() {
    initConnectivity();

    connectivitySubscription =
        connectivity.onConnectivityChanged.listen(updateConnectionStatus);
  }

  @override
  void dispose() {
    if (connectivitySubscription != null) {
      connectivitySubscription!.cancel();
    }
    super.dispose();
  }

  void setContext(BuildContext context) {
    this.context = context;
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.mobile;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    return updateConnectionStatus(result);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    connectionStatus = result;
    notifyListeners();
    if (result == ConnectivityResult.none) {
      showConnectionErrorSnackBar();
    }
  }

  showConnectionErrorSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
        //TODO: SCAFFOLDMESSAGER I BİR YERE ATSAN CONTEXT VERME DERDİNDE KURTULURSUN TRY IT
        SnackBar(content: Text("Connection error...check your connection")));
  }
}
