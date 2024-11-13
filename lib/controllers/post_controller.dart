import 'package:get/get.dart';

class PostController extends GetxController {
  var selectedIndices = <int>[].obs;
  var selectedcommentslikes = <int>[].obs;
  RxList<bool> tappedList = <bool>[].obs;
  RxList<dynamic> posts = [
    {
      "postType": 'video',
      "postUrl": 'assets/video/postvideo.mp4',
    },
  ].obs;
}
