import 'package:get/get.dart';

class GenderController extends GetxController {
  var selectedGender = ''.obs; // Observable variable for selected gender

  void updateGender(String? gender) {
    selectedGender.value = gender ?? ''; // Update the selected gender
  }
}
