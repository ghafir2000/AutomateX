import 'package:get/get.dart';
class CheckBoxController extends GetxController {
  // Initialize a list of 6 checkboxes, all set to false
  var checkList = List<bool>.filled(20, false).obs;

  // Track the currently selected index
  var selectedIndex = (-1).obs; // -1 means no checkbox is selected

  void accessPages(int index){
    if (index == 1){
      print ("true,${index}");
    }
    else
      print ("false,${index}");
  }

  void toggleCheckbox(int index) {
    if (selectedIndex.value == index) {
      // If the clicked checkbox is already selected, uncheck it
      checkList[index] = false;
      selectedIndex.value = -1;
    } else {
      // Uncheck all checkboxes
      for (int i = 0; i < checkList.length; i++) {
        checkList[i] = false;
      }
      // Check the selected checkbox
      checkList[index] = true;
      selectedIndex.value = index;
    }
  }

}
