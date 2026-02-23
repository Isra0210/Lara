import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lara/data/datasources/local/auth_local_datasource.dart';
import 'package:lara/data/datasources/remote/auth_remote_datasource.dart';
import 'package:lara/data/repositories/auth_repository_impl.dart';
import 'package:lara/domain/repositories/auth_repository.dart';
import 'package:lara/domain/usecases/usecases.dart';
import 'package:lara/presentation/controller/auth_controller.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance);
    Get.lazyPut<FirebaseFirestore>(() => FirebaseFirestore.instance);

    Get.lazyPut<GoogleSignIn>(() => GoogleSignIn.instance);

    Get.lazyPut<AuthLocalDataSource>(() => AuthLocalDataSource());
    Get.lazyPut<AuthRemoteDatasource>(
      () => AuthRemoteDatasource(
        Get.find<FirebaseAuth>(),
        Get.find<FirebaseFirestore>(),
        Get.find<GoogleSignIn>(),
      ),
    );
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        Get.find<AuthRemoteDatasource>(),
        Get.find<AuthLocalDataSource>(),
      ),
    );

    Get.lazyPut<SignInWithEmailUseCase>(
      () => SignInWithEmailUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<RegisterWithEmailUseCase>(
      () => RegisterWithEmailUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<SignInWithGoogleUseCase>(
      () => SignInWithGoogleUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<SignOutUseCase>(
      () => SignOutUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<WatchAuthStateUseCase>(
      () => WatchAuthStateUseCase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<GetCachedUserUseCase>(
      () => GetCachedUserUseCase(Get.find<AuthRepository>()),
    );

    Get.put<AuthController>(
      AuthController(
        signInWithEmail: Get.find<SignInWithEmailUseCase>(),
        registerWithEmail: Get.find<RegisterWithEmailUseCase>(),
        signInWithGoogle: Get.find<SignInWithGoogleUseCase>(),
        signOut: Get.find<SignOutUseCase>(),
        watchAuthState: Get.find<WatchAuthStateUseCase>(),
        getCachedUser: Get.find<GetCachedUserUseCase>(),
      ),
      permanent: true,
    );
  }
}
