import 'package:flutter/material.dart';
import 'package:proyecto_moviles/models/userModel.dart';


class UserProvider with ChangeNotifier{
  
  UserModel? user;

  setUserData(UserModel user){
    this.user=user;
    notifyListeners();
  }

  getUserData() => this.user;

}