import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

import '../widgets/no_internet.dart';

class ConnectivityService {
  ConnectivityService._internal();
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._internal();
  // ignore: unused_field
  late StreamSubscription<ConnectivityResult> _subscription;

  bool _isShowingError = false;

  void initialize(BuildContext context) {
    Connectivity().checkConnectivity().then(
      (value) {
        if (value == ConnectivityResult.none) {
          if (!_isShowingError) {
            _isShowingError = true;
            Navigator.push(
              context,
              MaterialPageRoute<Scaffold>(
                builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: const NoInternetPage(),
                ),
              ),
            );
          }
        }
      },
    );

    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        if (!_isShowingError) {
          _isShowingError = true;
          Navigator.push(
            context,
            MaterialPageRoute<Scaffold>(
              builder: (context) => WillPopScope(
                onWillPop: () async => false,
                child: const NoInternetPage(),
              ),
            ),
          );
        }
      } else if (result != ConnectivityResult.none) {
        if (_isShowingError) {
          _isShowingError = false;
          Navigator.pop(context);
        }
      }
    });
  }

  void dispose() {
    _subscription.cancel();
  }
}
