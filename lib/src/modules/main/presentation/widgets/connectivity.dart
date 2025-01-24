// ignore_for_file: library_private_types_in_public_api
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:sizer/sizer.dart';

import 'components.dart';

class ConnectionWidget extends StatefulWidget {
  final Widget child;
  final void Function() onRetry;

  const ConnectionWidget(
      {super.key, required this.child, required this.onRetry});

  @override
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.mobile];
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  Widget build(BuildContext context) {
    return _connectionStatus.contains(ConnectivityResult.mobile) ||
            _connectionStatus.contains(ConnectivityResult.wifi)
        ? _connectedWidget()
        : _notConnectedWidget();
  }

  Widget _connectedWidget() {
    return widget.child;
  }

  Widget _notConnectedWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.wifi_off,
            color: ColorManager.secondary,
            size: 45.sp,
          ),
          SizedBox(height: 5.sp),
          const Text('تعذر اتصال الانترنت'),
          SizedBox(height: 10.sp),
          DefaultButton(
            title: "اعادة المحاولة",
            width: 40.w,
            onPressed: () async {
              widget.onRetry.call();
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    if (_connectivitySubscription != null) {
      _connectivitySubscription!.cancel();
    }
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      widget.onRetry.call();
    });
  }
}
