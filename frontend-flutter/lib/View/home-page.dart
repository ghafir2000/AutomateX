// lib/View/home-page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/barcode_controller.dart'; // Corrected import path
import '../Controller/login-controller.dart'; // For logout
import '../model/baracode_model.dart'; // Import Barcode model

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Put BarcodeController here so it's initialized when HomePage is built
    final BarcodeController barcodeController = Get.put(
      BarcodeController(),
      permanent: false,
    );
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                print('Settings tapped');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Admin'),
              onTap: () {
                Navigator.pop(context);
                print('Add Admin tapped');
              },
            ),
            ListTile(
              leading: const Icon(Icons.perm_device_information_sharp),
              title: const Text('About Us'),
              onTap: () {
                Navigator.pop(context);
                print('About Us tapped');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Get.defaultDialog(
                  title: "Logout",
                  middleText: "Are you sure you want to logout?",
                  textConfirm: "Logout",
                  textCancel: "Cancel",
                  onConfirm: () {
                    loginController.logout();
                  },
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('QR Scanner Data'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              barcodeController.refreshBarcodes();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (barcodeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (barcodeController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    barcodeController.errorMessage.value,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => barcodeController.fetchBarcodes(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (barcodeController.barcodeList.isEmpty) {
          return const Center(
            child: Text('No QR data found.', style: TextStyle(fontSize: 18)),
          );
        }

        // --- Displaying data using DataTable ---
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 20.0,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text(
                    'Barcode',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Product Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Price',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Quantity',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Scanned At',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              rows: barcodeController.barcodeList.map((Barcode barcode) {
                return DataRow(
                  cells: <DataCell>[
                    DataCell(Text(barcode.barcodeValue)),
                    DataCell(Text(barcode.productName ?? 'N/A')),
                    DataCell(
                      Text(
                        barcode.price != null
                            ? '\$${barcode.price!.toStringAsFixed(2)}'
                            : 'N/A',
                      ),
                    ),
                    DataCell(Text(barcode.quantity?.toString() ?? 'N/A')),
                    DataCell(
                      Text(
                        "${barcode.createdAt.toLocal().year}-${barcode.createdAt.toLocal().month.toString().padLeft(2, '0')}-${barcode.createdAt.toLocal().day.toString().padLeft(2, '0')} ${barcode.createdAt.toLocal().hour.toString().padLeft(2, '0')}:${barcode.createdAt.toLocal().minute.toString().padLeft(2, '0')}",
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
