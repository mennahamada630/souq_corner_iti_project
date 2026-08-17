import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/firestore_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService =
  FirestoreService();

  AuthCubit() : super(AuthInitial());

  Future<void> register(
      String email,
      String password,
      ) async {
    emit(AuthLoading());

    try {
      final credential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await _firestoreService.createUserProfile(
          user.uid,
          email,
        );
      }

      emit(AuthLoggedIn());
    } on FirebaseAuthException catch (error) {
      emit(
        AuthError(
          error.message ?? 'Registration failed',
        ),
      );
    }
  }

  Future<void> login(
      String email,
      String password,
      ) async {
    emit(AuthLoading());

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(AuthLoggedIn());
    } on FirebaseAuthException catch (error) {
      emit(
        AuthError(
          error.message ?? 'Login failed',
        ),
      );
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();

      emit(AuthLoggedOut());
    } catch (error) {
      emit(
        AuthError('Logout failed'),
      );
    }
  }
}