import 'package:app/View/Home_Page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/Controller/Create_Acount.dart';
import 'package:app/Controller/Check_Acount.dart'; // Though not directly used in UI, kept for consistency

// Keeping global as per original code, but could be a const in a theme file
var Sizebetween = Get.height * 0.03;

final CreateAccountController controllercreate = Get.put(CreateAccountController());
final CheckAccount controllercheck = Get.put(CheckAccount()); // Not used in this UI, but kept for consistency

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shadowColor: Colors.blueAccent,
          centerTitle: true,
          title: const Column(
            children: [
              Text("Create Account"),
            ],
          ),
        ),
        bottomNavigationBar: const Icon(Icons.account_circle_outlined),
        body: ListView(children: [Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Get.width,
              height: Get.height * 0.4,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage('images/ff.png')),
              ),
            ),
            SizedBox(height: Sizebetween),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
              ),
              width: Get.width * 0.8,
              height: Get.height * 0.05,
              child: TextField(
                onChanged: (value) => controllercreate.username(value),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  label: Text("user name"),
                  hintText: "eg : Ahmad",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
                  ),
                ),
              ),
            ),
            SizedBox(height: Sizebetween),
            Container(
              decoration: const BoxDecoration(
                color: Colors.black12,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
              ),
              width: Get.width * 0.8,
              height: Get.height * 0.05,
              child: TextField(
                // Corrected: Now binds to phoneNumber
                onChanged: (value) => controllercreate.phoneNumber(value),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  label: Text("enter your phone number"),
                  hintText: "09********",
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
                  ),
                ),
              ),
            ),
            SizedBox(height: Sizebetween),
            Container(
              decoration: const BoxDecoration(
                backgroundBlendMode: BlendMode.darken,
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
              ),
              width: Get.width * 0.8,
              height: Get.height * 0.05,
              child: Builder(
                builder: (context) {
                  return Obx(
                        () => TextField(
                      onChanged: (value) => controllercreate.validatePassword(value),
                      obscureText: controllercreate.obscureTextp1.value,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        label: const Text("Create your password"),
                        hintText: "*******",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
                        ),
                        suffixIcon: IconButton(
                          iconSize: 18,
                          icon: Icon(
                            color: Colors.black,
                            controllercreate.obscureTextp1.value ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: controllercreate.toggleVisibilityp1,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35),
              child: Obx(
                    () => Column(
                  children: [
                    _buildRule("At least 8 characters", controllercreate.minLength.value),
                    _buildRule("Contains at least 1 number", controllercreate.hasNumber.value),
                    // Corrected: Uncommented for better feedback
                    _buildRule("Passwords match", controllercreate.passwordsMatch.value),
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                backgroundBlendMode: BlendMode.darken,
                color: Colors.black12,
                borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
              ),
              width: Get.width * 0.8,
              height: Get.height * 0.05,
              child: Builder(
                builder: (context) {
                  return Obx(
                        () => TextField(
                      onChanged: (value) => controllercreate.validatePasswordConfirmation(value),
                      obscureText: controllercreate.obscureTextp2.value,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        label: const Text("confirm your password"),
                        hintText: "write your password again",
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
                        ),
                        suffixIcon: IconButton(
                          iconSize: 18,
                          icon: Icon(
                            color: Colors.black,
                            controllercreate.obscureTextp2.value ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: controllercreate.toggleVisibilityp2,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: Sizebetween),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    if (controllercreate.isValid) {
                      if (controllercreate.saveCredentials()) {
                        Get.offAll(const HomePage()); // Only navigate if save was successful
                      }
                      // Removed duplicate Get.offAll here as it would always navigate
                    } else {
                      Get.snackbar(
                        "Error",
                        "Please fulfill all password requirements",
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                      );
                    }
                  },
                  child: Container(
                    width: Get.width * 0.3,
                    height: Get.height * 0.04,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                      color: Colors.blueAccent,
                    ),
                    child: const Center(child: Text("Confirm Account", style: TextStyle(color: Colors.white))),
                  ),
                ),
                SizedBox(width: Get.width * 0.09),
                GestureDetector(
                  onTap: () {
                    Get.offAll(const HomePage());
                  },
                  child: Container(
                    width: Get.width * 0.2,
                    height: Get.height * 0.04,
                    decoration: const BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                      color: Colors.blueAccent,
                    ),
                    child: const Center(child: Text("Back", style: TextStyle(color: Colors.white))),
                  ),
                ),
              ],
            )
          ],
        ),]),
      ),
    );
  }

  // Helper method for displaying password rules
  Widget _buildRule(String text, bool isValid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.error,
            color: isValid ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: isValid ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}