import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  AuthCubit() : super(AuthInitial());

  // Stream لمتابعة حالة المستخدم
  Stream<User?> get userStream => _auth.authStateChanges();

  // تسجيل مستخدم جديد
  Future<void> register(String email, String password) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseError(e.code)));
    }
  }

  // تسجيل الدخول
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_mapFirebaseError(e.code)));
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    emit(AuthLoading());
    await _auth.signOut();
    emit(AuthInitial());
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case "invalid-email":
        return "البريد الإلكتروني غير صالح";
      case "user-not-found":
        return "المستخدم غير موجود";
      case "wrong-password":
        return "كلمة المرور غير صحيحة";
      case "email-already-in-use":
        return "البريد مستخدم بالفعل";
      case "weak-password":
        return "كلمة المرور ضعيفة جدًا";
      case "400":
        return "بيانات التسجيل غير صحيحة (Bad Request)";
      default:
        return "حدث خطأ غير متوقع";
    }
  }
}
