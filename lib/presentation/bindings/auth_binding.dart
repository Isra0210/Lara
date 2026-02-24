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

    Get.lazyPut<SignInWithEmailUsecase>(
      () => SignInWithEmailUsecase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<RegisterWithEmailUsecase>(
      () => RegisterWithEmailUsecase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<SignInWithGoogleUsecase>(
      () => SignInWithGoogleUsecase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<SignOutUsecase>(
      () => SignOutUsecase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<WatchAuthStateUsecase>(
      () => WatchAuthStateUsecase(Get.find<AuthRepository>()),
    );
    Get.lazyPut<GetCachedUserUsecase>(
      () => GetCachedUserUsecase(Get.find<AuthRepository>()),
    );

    Get.put<AuthController>(
      AuthController(
        signInWithEmail: Get.find<SignInWithEmailUsecase>(),
        registerWithEmail: Get.find<RegisterWithEmailUsecase>(),
        signInWithGoogle: Get.find<SignInWithGoogleUsecase>(),
        signOut: Get.find<SignOutUsecase>(),
        watchAuthState: Get.find<WatchAuthStateUsecase>(),
        getCachedUser: Get.find<GetCachedUserUsecase>(),
      ),
      permanent: true,
    );
  }
}
