import 'package:get/get.dart';
import 'package:qianshi_music/models/login_account.dart';
import 'package:qianshi_music/models/login_profile.dart';

class CurrentUserController extends GetxController {
  final Rx<LoginAccount?> currentAccount = Rx<LoginAccount?>(null);
  final Rx<LoginProfile?> currentProfile = Rx<LoginProfile?>(null);
}
