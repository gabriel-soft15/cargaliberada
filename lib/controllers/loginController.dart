import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';

class Logincontroller extends GetxController {
  final showPassword = false.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final isGoogleLoading = false.obs;
  final isFacebookLoading = false.obs;

  Future<void> Login() async {
    try {
      isLoading.value = true;
      if (!loginFormKey.currentState!.validate()) {
        isLoading.value = false;
        return;
      }

      final auth = AuthRepository.instance;
      String? erro = await auth.loginWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );
      auth.setInitialScreen(auth.firebaseUser);

      if (erro != null) {
        Get.showSnackbar(
          GetSnackBar(
            message: erro.toString(),
          ),
        );
      }
    } 
  }
}
