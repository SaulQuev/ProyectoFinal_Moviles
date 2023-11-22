import 'dart:convert';

import 'package:proyecto_moviles/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserPreferencesDev {
  static String _user = '["no_user"]';

  static late SharedPreferences _userPrefs;

  // Agrega un método para inicializar las preferencias
  static Future<void> initPreferences() async {
    _userPrefs = await SharedPreferences.getInstance();
  }

  static Future preferences() async {
    //_userPrefs = await SharedPreferences.getInstance();
    await initPreferences();
  }

  static set user(String user){
    _user=user;
    _userPrefs.setString('user', user);
  }

  static String get user{
    return _userPrefs.getString('user') ?? _user;
  }

  static clearPrefs(){
    _userPrefs.clear();
    _user='["no_user"]';
  }

  static UserModel getUserObject(){
    if(UserPreferencesDev.user!='["no_user"]'){
      final userData = json.decode(UserPreferencesDev.user);
      return UserModel.fromMap(userData);
    } return UserModel();
  }

}