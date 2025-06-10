import 'package:get/get.dart';
import 'Create_Acount.dart';

class CheckAccount extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var obscureText = true.obs;
final CreateAccountController createAccountController= Get.put(CreateAccountController());
  void toggleVisibility() {
    obscureText.value = !obscureText.value;
  }

  Future<bool> login() async {
    if (username.value == createAccountController.user.value &&
        password.value == createAccountController.pass.value &&
        username.value !='' &&
        password.value !='')
    {
      print("true");
      return true;
    } else {
      print("false");
      print(username.value);
      print(password.value);
      return false;
    }
  }

  void logout() {
    username = ''.obs;
    password = ''.obs;
  }
}
