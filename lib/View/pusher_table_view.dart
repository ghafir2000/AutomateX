// View/pusher_table_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/pusher_controller.dart'; // Ensure correct casing: pusher_controller.dart

class PusherTableView extends StatelessWidget {
  final String apiKey;
  final String cluster;

  const PusherTableView({Key? key, required this.apiKey, required this.cluster})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PusherController controller =
        Get.find<PusherController>(tag: 'pusher');

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }

      // --- ADD THIS CHECK ---
      if (controller.parsedMessages.isEmpty) {
        return const Center(
            child: Text("No messages received yet. Waiting for data..."));
      }
      // --- END ADDITION ---

      return LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
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
                            DataCell(Text(msg['name']?.toString() ?? 'N/A')),
                            DataCell(Text(msg['id']?.toString() ?? 'N/A')),
                            DataCell(Text(formattedTime)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Messages received: ${controller.parsedMessages.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}
