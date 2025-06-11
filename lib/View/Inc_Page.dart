// View/Inc_Page.dart
import 'package:app/Controller/CheckBoxController.dart';
import 'package:app/Controller/Create_Acount.dart';
import 'package:app/View/Home_Page.dart';
import 'package:app/View/Smart_Incubaiter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Controller/Check_Acount.dart';

// Initialize controllers globally (as per your original structure)
final CheckAccount controllercheck = Get.put(CheckAccount());
final CheckBoxController contrllercheckbox = Get.put(CheckBoxController());
final CreateAccountController controllercreateaccount =
    Get.put(CreateAccountController());

int id = 0; // Keeping as global as per your original code

class Inc_Page extends StatelessWidget {
  const Inc_Page({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          shadowColor: Colors.blueAccent,
          actions: const [],
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.list),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            },
          ),
          shape: LinearBorder.bottom(
            alignment:
                30, // Note: alignment is for the border position, not visual alignment.
            side: const BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          centerTitle: true,
          title: const Column(
            children: [
              Text("Controller Page"),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        gradient: SweepGradient(colors: Colors.primaries),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Container(
                          width: 47,
                          height: 47,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: AssetImage("images/ff.png"),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 75,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // Align text to start
                        children: [
                          Obx(() => Text(
                                controllercreateaccount.user.value.isNotEmpty
                                    ? controllercreateaccount.user.value
                                    : "Guest User", // Default if no username
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                          const SizedBox(height: 5),
                          Obx(() => Text(
                                controllercreateaccount
                                        .phoneNumber.value.isNotEmpty
                                    ? controllercreateaccount.phoneNumber.value
                                    : "No phone number", // Reactive phone number
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 14),
                              )),
                          const SizedBox(height: 5),
                          const Text(
                            "Project Type: Default", // Static, consider making reactive if needed
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 10),
                    Text("setting"),
                  ],
                ),
                onTap: () {},
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 10),
                    Text("Logout"),
                  ],
                ),
                onTap: () {
                  Get.offAll(const HomePage());
                  controllercheck.logout();
                },
                splashColor: Colors.green,
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.info_outline),
                    SizedBox(width: 10),
                    Text("About Us"),
                  ],
                ),
                onTap: () {},
                splashColor: Colors.green,
                subtitle: const Text(" لمحة عن الفريق ",
                    textDirection: TextDirection.rtl),
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: Get.width,
              height: Get.height * 0.8,
              child: ListView(
                padding: const EdgeInsets.only(
                    top: 29, left: 29, right: 29, bottom: 29),
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
                    ),
                    child: Column(
                      children: List.generate(
                        contrllercheckbox.checkList.length,
                        (index) {
                          return Obx(
                            () => Row(
                              children: [
                                Checkbox(
                                  value: contrllercheckbox.checkList[index],
                                  onChanged: (value) {
                                    contrllercheckbox.toggleCheckbox(index);
                                    id = index; // Update global id
                                  },
                                ),
                                Image.asset(
                                  "images/ff.png",
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                    "(description of the project ${index + 1})"),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: Get.width, height: Get.height * 0.002),
            GestureDetector(
              onTap: () {
                enter();
              },
              child: Container(
                width: Get.width * 0.8,
                height: Get.height * 0.05,
                decoration: const BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.elliptical(5, 5)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Next"),
                    Icon(size: 15, Icons.double_arrow),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void enter() {
    if (id + 1 == 1) {
      Get.to(() =>
          const SmartIncubater()); // Navigate to SmartIncubater for project 1
    }
    contrllercheckbox.accessPages(id + 1);
  }
}
