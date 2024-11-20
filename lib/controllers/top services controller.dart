import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TopServiceController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive list for services
  var topServices = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopServices(); // Fetch data when the controller is initialized
  }

  void fetchTopServices() async {
    try {
      // Access the 'topservices' document inside the 'admin' collection
      DocumentSnapshot docSnapshot =
      await _firestore.collection('admin').doc('topservices').get();

      // Check if the document exists
      if (docSnapshot.exists) {
        // Retrieve the 'services' array
        List<dynamic> services = docSnapshot['services'];

        // Map the array to a list of maps and update the observable
        topServices.value = services.map((service) {
          return {
            "image": service['image'],
            "title": service['title'],
          };
        }).toList();
      } else {
        print("Document 'topservices' does not exist!");
      }
    } catch (e) {
      print("Error fetching top services: $e");
    }
  }
}
