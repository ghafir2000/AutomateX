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

      channel = pusher.subscribe('mqtt-channel');

      channel.bind('mqtt.message.received', (PusherEvent? event) {
        if (event != null && event.data != null) {
          try {
            final Map<String, dynamic> data = jsonDecode(event.data!);

            // --- CRITICAL CHANGE FOR NULL SAFETY & TYPE CHECKING ---
            // Safely access 'message' and check its type before decoding.
            final dynamic innerJsonStringDynamic = data['message'];

            if (innerJsonStringDynamic is String) {
              final parsedMessage = jsonDecode(innerJsonStringDynamic);

              parsedMessage['receivedAt'] = DateTime.now(); // Add timestamp
              parsedMessages.add(parsedMessage); // Add to RxList
              errorMessage.value = ''; // Clear error if message received
            } else {
              // Handle case where 'message' field is missing or not a String
              print("Pusher message 'message' field is missing or not a valid JSON string: $innerJsonStringDynamic");
              errorMessage.value = "Invalid Pusher message format: 'message' field missing or not a JSON string.";
            }
            // --- END OF CRITICAL CHANGE ---

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
    pusher.unsubscribe('mqtt-channel');
    pusher.disconnect();
    super.onClose();
  }
}