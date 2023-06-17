import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController {
  RxBool connection = true.obs;
  final Connectivity _connectivity = Connectivity();

  void onInit() {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      connection.value = false;
    } else {
      connection.value = true;
    }
    // print(connection.value);
  }
}
