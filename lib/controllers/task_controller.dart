import 'package:get/get.dart';

class TaskController extends GetxController {
  var userUid = ''.obs; // Observable variable to hold userUid

  void setUserUid(String uid) {
    userUid.value = uid; // Update the userUid
  }
}
