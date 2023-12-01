

import 'package:firebase_auth/firebase_auth.dart';

class GitHubLogin{
   UserCredential? userCredential;
  String? usr = '';

  Future<UserCredential> signInGit() async{
    GithubAuthProvider githubauthprovider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(githubauthprovider);
  }
}