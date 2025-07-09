// Controller/pusher_controller.dart
import 'package:get/get.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class PusherController extends GetxController {
  final String apiKey;
  final String cluster;
  late PusherClient pusher;
  late Channel channel;

  var parsedMessages = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  PusherController({required this.apiKey, required this.cluster});

  @override
  void onInit() {
    super.onInit();
    _initPusher();
  }

  void _initPusher() {
    try {
      pusher = PusherClient(
        apiKey,
        PusherOptions(cluster: cluster),
        enableLogging: true,
      );

      pusher.connect();

      // --- CRITICAL CHANGE: Use 'my-channel' and 'my-event' as per Pusher dashboard ---
      channel = pusher.subscribe('my-channel'); // Changed from 'mqtt-channel'

      channel.bind('my-event', (PusherEvent? event) {
        // Changed from 'mqtt.message.received'
        if (event != null && event.data != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(event.data!);

            // Safely access 'message' field. Assuming 'my-event' will now have a 'message' field.
            // If the structure of 'my-event' is different, you'll need to adjust this parsing.
            final dynamic innerJsonStringDynamic = data['message'];

            if (innerJsonStringDynamic is String) {
              final parsedMessage = jsonDecode(innerJsonStringDynamic);

              parsedMessage['receivedAt'] = DateTime.now(); // Add timestamp
              parsedMessages.add(parsedMessage); // Add to RxList
              errorMessage.value =
                  ''; // Clear error if message received successfully
            } else {
              print(
                  "Pusher event 'my-event' data['message'] is missing or not a valid JSON string: $innerJsonStringDynamic");
              errorMessage.value =
                  "Invalid Pusher event format: 'message' field missing or not a JSON string.";
            }
          } catch (e) {
            print("Error parsing event data from Pusher: $e");
            errorMessage.value = "Error parsing Pusher data: $e";
          }
        } else {
          print("Received null Pusher event or event data.");
          errorMessage.value = "Received empty Pusher event data.";
        }
      });
      isLoading.value = false;
    } catch (e) {
      print("Error initializing Pusher connection: $e");
      errorMessage.value = "Failed to connect to Pusher: $e";
      isLoading.value = false;
    }
  }

  String formatDateTime(DateTime dt) {
    return DateFormat('HH:mm:ss').format(dt);
  }

  @override
  void onClose() {
    pusher.unsubscribe('my-channel'); // Changed from 'mqtt-channel'
    pusher.disconnect();
    super.onClose();
  }
}
