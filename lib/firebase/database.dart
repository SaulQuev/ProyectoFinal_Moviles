import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_moviles/models/userModel.dart';
import 'package:proyecto_moviles/user_preferences_dev.dart';



class Database {
  static Future<UserModel> getUserData(String uid) async {
    final docUser = FirebaseFirestore.instance.collection('usuarios').doc(uid);
    final doc = await docUser.get();
    return UserModel.fromMap(doc.data()!);
  }

  static Future saveUserPrefs(UserCredential creds) async {
    final userData = await getUserData(creds.user!.uid);
    userData.id = creds.user!.uid;
    UserPreferencesDev.user = UserModel.toMap(userData);
  }
}