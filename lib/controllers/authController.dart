import 'package:cargaliberada/models/userModel.dart';
import 'package:cargaliberada/repository/authRepository.dart';
import 'package:cargaliberada/screens/homeScreen.dart';
import 'package:cargaliberada/screens/loginScreen.dart';
import 'package:cargaliberada/services/authService.dart';
import 'package:cargaliberada/services/sessionService.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final AuthService _auth = AuthService();
  final AuthRepository _repo = AuthRepository();
  final SessionService _session = SessionService();

  final isLoading = false.obs;
  final errorMessage = RxnString();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  UserModel? current;

  @override
  void onInit() {
    super.onInit();
    _auth.userChanges.listen((u) async {});
  }

  Future<void> loginEmail(String email, String password) async {
    await _run(() async {
      final u = await _auth.signInWithEmail(email, password);
      await _afterFirebaseLogin(u, loginProviderIsGoogle: false);
    });
  }

  Future<void> registerEmail(String email, String password) async {
    await _run(() async {
      final u = await _auth.registerWithEmail(email, password);
      await _afterFirebaseLogin(
        u,
        loginProviderIsGoogle: false,
        newUserDefaultRole: UserRole.student,
      );
    });
  }

  Future<void> loginGoogle() async {
    await _run(() async {
      final u = await _auth.signInWithGoogle();
      await _afterFirebaseLogin(u, loginProviderIsGoogle: true);
    });
  }

  Future<void> logout() async {
    await _run(() async {
      await _auth.signOut();
      await _session.clear();
      current = null;
      Get.offAll(() => const LoginScreen());
    }, showErrors: false);
  }

  Future<bool> tryRestoreSession() async {
    final s = await _session.load();
    if (s == null) return false;
    current = s;
    return true;
  }

  bool get canAccessTeacherArea =>
      current?.role == UserRole.teacher || current?.role == UserRole.admin;
  bool get isStudent => current?.role == UserRole.student;

  Future<void> _afterFirebaseLogin(
    User? fbUser, {
    required bool loginProviderIsGoogle,
    UserRole newUserDefaultRole = UserRole.student,
  }) async {
    if (fbUser == null)
      throw Exception('Falha ao autenticar. Tente novamente.');
    var remote = await _repo.getFromFirestore(fbUser.uid);
    if (remote == null) {
      remote = UserModel(
        firebaseUid: fbUser.uid,
        name: fbUser.displayName ?? (fbUser.email ?? 'Usuário'),
        email: fbUser.email ?? 'sem-email@local',
        avatarUrl: fbUser.photoURL,
        isGoogleUser: loginProviderIsGoogle,
        role: newUserDefaultRole,
        classId: null,
      );
      await _repo.upsertFirestore(remote);
    }
    final local = await _repo.syncUser(remote);
    await _session.save(local);
    current = local;
    Get.offAll(() => const HomeScreen());
  }

  Future<void> _run(
    Future<void> Function() body, {
    bool showErrors = true,
  }) async {
    try {
      errorMessage.value = null;
      isLoading.value = true;
      await body();
    } on FirebaseAuthException catch (e) {
      if (showErrors) errorMessage.value = _mapFirebaseError(e);
    } on Exception catch (e) {
      if (showErrors) errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Usuário não encontrado.';
      case 'wrong-password':
        return 'Senha incorreta.';
      case 'invalid-credential':
        return 'Credenciais inválidas.';
      case 'email-already-in-use':
        return 'E-mail já em uso.';
      case 'weak-password':
        return 'Senha muito fraca.';
      case 'invalid-email':
        return 'E-mail inválido.';
      default:
        return 'Erro de autenticação: ${e.message ?? e.code}';
    }
  }
}
