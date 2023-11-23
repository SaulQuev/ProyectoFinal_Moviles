import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proyecto_moviles/app_preferences.dart';
import 'package:proyecto_moviles/firebase/database.dart';


class GoogleAuth {
  GoogleSignIn? _googleSignIn;
  bool? hasData;
  final FirebaseAuth _auth= FirebaseAuth.instance;

  Future<String> signInWithGoogle() async {
    String tokenDevice = AppPreferences.token;
    try {
      _googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      //verificar si existe registro de usuario en Firestorage, si existe solo iniciar ssesión. si no existe redirigir a register_screen
      final user = await FirebaseAuth.instance.signInWithCredential(
          credential); 
          
          /*agregar credenciales a preferencias de usuario
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentReference documentReference =
          firestore.collection('usuarios').doc(user.user!.uid);
      await documentReference.update({'tokenDevice': tokenDevice});*/

      /*if (await hasUserData(user.user!.uid)) {
        await Database.saveUserPrefs(user);

        return 'logged-successful';
      }
      return 'logged-without-info';*/
       return 'logged-successful';
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException caught:');
    print('Code: ${e.code}');
    print('Message: ${e.message}');
    
    // Puedes imprimir detalles adicionales según la necesidad
    // Por ejemplo, para obtener más detalles sobre la ApiException de Google Sign-In:
    if (e.code == 'sign_in_failed') {
      print('Google Sign-In ApiException details:');
      print('Google Sign-In Status Code: ${e.code}');
      print('Google Sign-In Status Message: ${e.message}');
    }
      return e.code;
    }
  }

  Future<String> signOutFromGoogle() async {
    _googleSignIn = GoogleSignIn();
    try {
      await _googleSignIn?.disconnect();
      await FirebaseAuth.instance.signOut();
      //Limpiar preferencias de usuario?
      return 'succesful-sign-out';
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  Future<bool> hasUserData(String id) async {
    final docUser = FirebaseFirestore.instance.collection('usuarios').doc(id);
    final doc = await docUser.get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }
}