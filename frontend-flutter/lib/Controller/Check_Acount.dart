import 'package:get/get.dart';
import 'Create_Acount.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CheckAccount extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var obscureText = true.obs;
  final CreateAccountController createAccountController =
      Get.put(CreateAccountController());
  void toggleVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<bool> login() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/login'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'email': username.value,
        'password': password.value,
      },
    );

    if (response.statusCode == 200) {
      print("true");
      return true;
    } else {
      print("false");
      print(response.statusCode);
      return false;
    }
  }

  void logout() {
    username = ''.obs;
    password = ''.obs;
  }
}
