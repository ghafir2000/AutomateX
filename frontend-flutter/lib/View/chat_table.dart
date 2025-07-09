// views/pusher_table_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/Pusher_Controller.dart';

class PusherTableView extends StatelessWidget {
  final String apiKey;
  final String cluster;

  const PusherTableView(
      {super.key, required this.apiKey, required this.cluster});

  @override
  Widget build(BuildContext context) {
    final PusherController controller = Get.put(
      PusherController(apiKey: apiKey, cluster: cluster),
      tag: 'pusher',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Table')),
      body: Obx(() => SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('DateTime')),
                ],
                rows: controller.parsedMessages.map((msg) {
                  final receivedAt = msg['receivedAt'];
                  final formattedTime = receivedAt is DateTime
                      ? controller.formatDateTime(receivedAt)
                      : 'none';
                  return DataRow(cells: [
                    DataCell(Text(msg['name']?.toString() ?? '')),
                    DataCell(Text(msg['id']?.toString() ?? '')),
                    DataCell(Text(formattedTime)),
                  ]);
                }).toList(),
              ),
            ),
          )),
    );
  }
}
