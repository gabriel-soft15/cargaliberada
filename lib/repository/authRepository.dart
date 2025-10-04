import 'package:exportasystem/screens/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class Authrepository extends GetxController {
  static Authrepository instance = Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final Rx<User?> _firebaseUser;
  var vereficatenId = ''.obs;

  User? get firebaseUser => _firebaseUser.value;

  @override
  void onReady() {
    super.onReady();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    setInitialScreen(_firebaseUser.value);
  }

  void setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const HomeScreen());
    } else if (user.emailVerified) {
      Get.offAll(() => const ProfileScreen());
    } else {
      Get.offAll(() => const ProfileScreen());
    }
  }
  //---------------------------Celular------------------------------------//

  //------------------------Email e Senha------------------------------//

  Future<void> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _firebaseUser.value != null
          ? Get.offAll(() => const HomeScreen())
          : Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      final ex = SingUpFailure.code(e.code);
      print("Firebase Auth Exception - ${ex.message}");
      throw ex;
    } catch (_) {
      const ex = SingUpFailure();
      print("Exeption - ${ex.message}");
      throw ex;
    }
  }

  Future<String?> loginWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.loginWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("Usuarios não encontrado para o email: $email");
        return "Email não cadastrada";
      } else if (e.code == 'wrong-password') {
        print('Senha incoreta para o email: $email');
        return 'Senha incorreta.';
      } else if (e.code == 'invalid-email') {
        print('email inválido: $email');
        return 'formato e email inválido';
      } else if (e.code == 'network-request-failed') {
        print('falha de rede ao tentar logar: $email');
        return 'falha de conexão. Verifique sua internet';
      } else {
        print('erro não tratado: ${e.message}');
        return 'ocorreu um erro durante o login. Por favor, tente novamente mais tarde';
      }
    } catch (e) {
      print('erro ineperado: $e');
      return 'Ocorreu um erro inesperado durante o login';
    }
  }
}
