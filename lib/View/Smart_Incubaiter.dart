// View/Smart_Incubaiter.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/CheckBoxController.dart';
import '../Controller/Check_Acount.dart';
import '../Controller/Create_Acount.dart';
import '../Controller/pusher_controller.dart';
import 'Home_Page.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';
import 'pusher_table_view.dart';

// Initialize controllers globally (as per your original structure)
final CheckAccount controllercheck = Get.put(CheckAccount());
final CheckBoxController contrllercheckbox = Get.put(CheckBoxController());
final CreateAccountController controllercreateaccount = Get.put(CreateAccountController());
// Retrieve PusherController using Get.find() as it's Get.put() in main.dart
final PusherController pusherController = Get.find<PusherController>(tag: 'pusher');

class SmartIncubater extends StatefulWidget {
  const SmartIncubater({super.key});

  @override
  _SmartIncubaterState createState() => _SmartIncubaterState();
}

class _SmartIncubaterState extends State<SmartIncubater> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // Define titles for your pages based on tab index
  final List<String> _pageTitles = const [
    "Real-time Table", // For index 0 (PusherTableView)
    "Favorite",       // For index 1
    "Notifications",  // For index 2
    "Profile",        // For index 3
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
            alignment: 30,
            side: const BorderSide(
              width: 1,
              color: Colors.red,
            ),
          ),
          centerTitle: true,
          title: Column( // Use Column if you had multiple lines, otherwise just Text
            children: [
              // Display dynamic title based on the selected tab
              Text(_pageTitles[_selectedIndex]),
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
                            image: DecorationImage(image: AssetImage("images/ff.png"), fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 75,
                      width: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                        children: [
                          Obx(() => Text(
                            controllercreateaccount.user.value.isNotEmpty
                                ? controllercreateaccount.user.value
                                : "Guest User", // Default if no username
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          )),
                          const SizedBox(height: 5),
                          Obx(() => Text(
                            controllercreateaccount.phoneNumber.value.isNotEmpty
                                ? controllercreateaccount.phoneNumber.value
                                : "No phone number", // Reactive phone number
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          )),
                          const SizedBox(height: 5),
                          const Text(
                            "Project Type: Default", // Static, consider making reactive if needed
                            style: TextStyle(color: Colors.white70, fontSize: 14),
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
                subtitle: const Text(" لمحة عن الفريق ", textDirection: TextDirection.rtl),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            PageView(
              clipBehavior: Clip.hardEdge,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: [
                ListView(
                  children: [
                    PusherTableView(
                      apiKey: "cb788493e8aa5bf58a70",
                      cluster: "mt1",
                    ),
                  ],
                ),
                Container(
                  width: Get.width,
                  height: Get.height,
                  color: Colors.white,
                  child: const Center(child: Text("page2")),
                ),
                Container(
                  width: Get.width,
                  height: Get.height,
                  color: Colors.white,
                  child: const Center(child: Text("page3")),
                ),
                Container(
                  width: Get.width,
                  height: Get.height,
                  color: Colors.white,
                  child: const Center(child: Text("page4")),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: MoltenBottomNavigationBar(
                domeWidth: 300,
                domeCircleSize: 50,
                domeHeight: 20,
                domeCircleColor: Colors.white30,
                barHeight: 40,
                borderRaduis: const BorderRadius.vertical(top: Radius.circular(10)),
                curve: Curves.easeOutSine,
                borderColor: Colors.black,
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                    _pageController.jumpToPage(index);
                  });
                },
                barColor: Colors.blueAccent,
                tabs:  [
                  MoltenTab(unselectedColor: Colors.grey, selectedColor: Colors.blue, icon: Icon(Icons.home)),
                  MoltenTab(unselectedColor: Colors.grey, selectedColor: Colors.red, icon: Icon(Icons.favorite)),
                  MoltenTab(unselectedColor: Colors.grey, selectedColor: Colors.yellow, icon: Icon(Icons.notifications)),
                  MoltenTab(unselectedColor: Colors.grey, selectedColor: Colors.green, icon: Icon(Icons.person)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}