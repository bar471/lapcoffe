import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lapcoffee/view/menu_page.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  final box = GetStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to the connectivity changes (now correctly receives a List<ConnectivityResult>)
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> connectivityResults) {
      // Get the first element from the list, since the list may have more than one result
      ConnectivityResult connectivityResult = connectivityResults.first;
      _updateConnectionStatus(connectivityResult);
    });
  }

  // Update connectivity status based on the result from Connectivity Plus
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      isConnected.value = false;
      Get.snackbar(
        'Connectivity Status',
        'You are offline!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        
      );
      Get.offAll(() => MenuPage());
    } else {
      isConnected.value = true;
      Get.snackbar(
        'Connectivity Status',
        'You are online!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent,
        colorText: Colors.white,
      );
      if (Get.currentRoute == '/NoConnectionView') {
        Get.offAll(() => MenuPage());  // Navigate to the login page if offline page is showing
      }
      uploadPendingData(); // Upload pending data if connected
    }
  }

  // Save data to local storage
  void saveDataLocally(Map<String, dynamic> data) {
    List<Map<String, dynamic>> pendingUploads = box.read('pendingUploads') ?? [];
    pendingUploads.add(data);
    box.write('pendingUploads', pendingUploads);
  }

  // Upload pending data to Firestore
  void uploadPendingData() async {
    try {
      List<Map<String, dynamic>> pendingUploads = box.read('pendingUploads') ?? [];
      for (var data in pendingUploads) {
        await _firestore.collection('your-collection').add(data);
      }
      box.remove('pendingUploads'); // Remove local data after successful upload
    } catch (e) {
      print("Error uploading data to Firestore: $e");
      Get.snackbar(
        'Upload Error',
        'Failed to upload data. Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
    }
  }
}
