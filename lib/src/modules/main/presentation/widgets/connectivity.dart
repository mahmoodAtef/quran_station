// ignore_for_file: library_private_types_in_public_api

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:quran_station/src/core/utils/color_manager.dart';
import 'package:sizer/sizer.dart';

class ConnectionWidget extends StatefulWidget {
  final Widget child;
  final void Function()? onRetry;
  const ConnectionWidget({super.key, required this.child, this.onRetry});

  @override
  _ConnectionWidgetState createState() => _ConnectionWidgetState();
}

class _ConnectionWidgetState extends State<ConnectionWidget> {
  bool isConnected = true;

  @override
  void initState() {
    super.initState();
    checkInternetConnection();
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isConnected = false;
      });
    } else {
      setState(() {
        isConnected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isConnected ? _connectedWidget() : _notConnectedWidget();
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
            color: ColorManager.darkBlue,
            size: 45.sp,
          ),
          SizedBox(height: 5.sp),
          const Text('تعذر اتصال الانترنت'),
          SizedBox(height: 10.sp),
          if (widget.onRetry != null)
            ElevatedButton(
              onPressed: () async {
                await checkInternetConnection();

                widget.onRetry!.call();
              },
              child: const Text('أعد المحاولة'),
            ),
        ],
      ),
    );
  }
}
