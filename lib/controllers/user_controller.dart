import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  RxString userRole = "Customer".obs;
  RxBool availability = true.obs;
  RxString name=''.obs;
  RxString email=''.obs;
  RxString userImage = ''.obs;
  RxString gender = ''.obs;

  Future<void> fetchUserData() async {
    try {
      // isLoading.value =true;
      if (FirebaseAuth.instance.currentUser != null) {
        // Reference to the users collection
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('userDetails');

        // Query to get the document with the specified UID
        DocumentSnapshot userInfo = await usersCollection
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        if (userInfo.exists) {
          name.value = userInfo["userName"] ?? "";
          email.value = userInfo["userEmail"] ?? "";
          gender.value = userInfo["gender"] ?? "";
          userImage.value = userInfo["image"] ?? "";
        } else {
          // User not found
        }
      } else {
        print("User not login");
      }
    } catch (e) {
      print('Error fetching user data: $e');
    } finally {
      update();
    }
  }
}
