import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_food_storage/provider/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AuthNotifier extends StreamNotifier<User?>{
  @override
  Stream<User?> build(){
    return ref.read(authServiceProvider).idTokenChanges;
  }

  Future<void> signInWithGoogle() async {
    try{
      await ref.read(authServiceProvider).signInWithGoogle();
    }catch(e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await ref.read(authServiceProvider).signOut();
  }
}

final authNotifierProvider = StreamNotifierProvider<AuthNotifier, User?>(AuthNotifier.new);