import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lara/core/ui/overlays/loading_overlay.dart';
import 'package:lara/core/ui/overlays/snackbar_overlay.dart';
import 'package:lara/domain/entities/user_entity.dart';
import 'package:lara/domain/usecases/usecases.dart';
import 'package:lara/presentation/controller/settings_controller.dart';
import 'package:lara/presentation/presentation.dart';

enum AuthMode { signIn, signUp }

class AuthController extends GetxController {
  AuthController({
    required SignInWithEmailUseCase signInWithEmail,
    required RegisterWithEmailUseCase registerWithEmail,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignOutUseCase signOut,
    required WatchAuthStateUseCase watchAuthState,
    required GetCachedUserUseCase getCachedUser,
  }) : _signInWithEmail = signInWithEmail,
       _registerWithEmail = registerWithEmail,
       _signInWithGoogle = signInWithGoogle,
       _signOut = signOut,
       _watchAuthState = watchAuthState,
       _getCachedUser = getCachedUser;

  final SignInWithEmailUseCase _signInWithEmail;
  final RegisterWithEmailUseCase _registerWithEmail;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutUseCase _signOut;
  final WatchAuthStateUseCase _watchAuthState;
  final GetCachedUserUseCase _getCachedUser;

  final settingsController = Get.find<SettingsController>();

  final formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final Rx<User?> rxUser = Rx<User?>(null);

  UserEntity? userEntity;
  void setUserEntity(UserEntity? value) {
    userEntity = value;
    update();
  }

  AuthMode authMode = AuthMode.signIn;
  void setAuthMode(AuthMode mode) {
    authMode = mode;
    formKey.currentState?.reset();
    update();
  }

  bool obscurePassword = true;
  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    update();
  }

  void _handleRouting(User? user) {
    if (user == null) {
      if (Get.currentRoute != AuthPage.route) {
        Get.offAllNamed(AuthPage.route);
      }
    } else {
      if (Get.currentRoute != HomePage.route) {
        Get.offAllNamed(HomePage.route);
      }
    }
  }

  void watchUserState() {
    rxUser.bindStream(_watchAuthState.user);

    ever(rxUser, _handleRouting);
  }

  Future<void> loginEmail() async {
    if (!formKey.currentState!.validate()) return;

    LoadingOverlay.show();
    final res = await _signInWithEmail(
      email: emailController.text,
      password: passwordController.text,
    );
    res.fold(
      (f) {
        LoadingOverlay.hidden();
        Future.delayed(Duration.zero, () {
          SnackbarOverlay.error(f.message);
        });
      },
      (u) {
        setUserEntity(u);
        LoadingOverlay.hidden();
      },
    );
  }

  Future<void> registerEmail() async {
    if (!formKey.currentState!.validate()) return;

    LoadingOverlay.show();
    final res = await _registerWithEmail(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
    );
    res.fold(
      (f) {
        LoadingOverlay.hidden();
        Future.delayed(Duration.zero, () {
          SnackbarOverlay.error(f.message);
        });
      },
      (u) {
        setUserEntity(u);
        LoadingOverlay.hidden();
      },
    );
    LoadingOverlay.hidden();
    setAuthMode(AuthMode.signIn);
  }

  Future<void> loginGoogle({String? passwordToLink}) async {
    LoadingOverlay.show();
    final res = await _signInWithGoogle(
      passwordToLinkIfRequired: passwordToLink,
    );
    res.fold((f) => SnackbarOverlay.error(f.message), (u) => setUserEntity(u));
    LoadingOverlay.hidden();
  }

  Future<void> logout() async {
    LoadingOverlay.show();
    await Future.delayed(const Duration(seconds: 2));
    final res = await _signOut();
    res.fold(
      (f) {
        LoadingOverlay.hidden();
        Future.delayed(Duration.zero, () {
          SnackbarOverlay.error(f.message);
        });
      },
      (_) {
        LoadingOverlay.hidden();
      },
    );
  }

  Future<void> getCachedUser() async {
    final res = await _getCachedUser();
    res.fold((f) => SnackbarOverlay.error(f.message), (u) => setUserEntity(u));
  }
}
