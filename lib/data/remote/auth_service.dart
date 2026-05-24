import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService{
  AuthService({
    FirebaseAuth? auth,
    FlutterSecureStorage? storage,
    GoogleSignIn? googleSignIn,
  }) : _auth = auth ?? FirebaseAuth.instance,
      _storage = storage ?? const FlutterSecureStorage(),
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;
      
    final FirebaseAuth _auth;
    final FlutterSecureStorage _storage;
    final GoogleSignIn _googleSignIn;
    StreamSubscription? _authEventSubscription;

    User? get currentUser => _auth.currentUser;
    Stream<User?> get idTokenChanges => _auth.idTokenChanges();

    Future<void> init() async{
      await _googleSignIn.initialize(
        serverClientId: '1043747608978-m1gisbciuviv5oq4bd4i4je7946iqjn2.apps.googleusercontent.com',
      );

      _authEventSubscription = _googleSignIn.authenticationEvents.listen(
        _handleAuthenticationEvent,
        onError: (error) {
          print('Google Sign-In error: $error');
        },
      );

    }

    Future<void> signInWithGoogle() async{
      await _googleSignIn.authenticate();
      await _auth.authStateChanges()
          .firstWhere((user) => user != null)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw Exception('Sign-in timed out'),
          );
    }

    Future<void> _handleAuthenticationEvent(
      GoogleSignInAuthenticationEvent event,
    ) async {
      try{
        final googleUser = switch(event){
          GoogleSignInAuthenticationEventSignIn() => event.user,
          _ => null,
        };

        if(googleUser == null) return;

        final googleAuth = googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        print('firebase login success');
      }catch(e){
        print('firebase login error: $e');
      }
    }

    Future<void> signOut() async {
      await _googleSignIn.signOut();

      await _auth.signOut();
    }

    void dispose(){
      _authEventSubscription?.cancel();
    }
}