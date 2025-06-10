import 'package:get/get.dart';

class CreateAccountController extends GetxController {
  var username = ''.obs;
  var passwordFirst = ''.obs;
  var passwordSecond = ''.obs;
  // Corrected: Added phoneNumber variable
  var phoneNumber = ''.obs;

  var obscureTextp1 = true.obs;
  var obscureTextp2 = true.obs;

  var pass = ''.obs;
  var user = ''.obs;

  var minLength = false.obs;
  var hasNumber = false.obs;
  var passwordsMatch = false.obs;

  void validatePassword(String value) {
    passwordFirst.value = value;
    minLength.value = value.length >= 8;
    hasNumber.value = value.contains(RegExp(r'[0-9]'));
    // Passwords match check should consider both fields
    passwordsMatch.value = passwordFirst.value == passwordSecond.value;
  }

  void validatePasswordConfirmation(String value) {
    passwordSecond.value = value;
    passwordsMatch.value = passwordFirst.value == value;
  }

  void toggleVisibilityp1() {
    obscureTextp1.toggle();
  }

  void toggleVisibilityp2() {
    obscureTextp2.toggle();
  }

  // Getter to check overall validity
  bool get isValid => minLength.value && hasNumber.value && passwordsMatch.value;

  // Saves credentials to in-memory variables (user, pass)
  bool saveCredentials() {
    if (isValid) {
      user.value = username.value;
      pass.value = passwordSecond.value;
      // In a real app, you would persist these credentials securely here.
      return true;
    }
    return false;
  }
}