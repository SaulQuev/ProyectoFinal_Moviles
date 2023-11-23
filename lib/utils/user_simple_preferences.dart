import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class userPreferences{
  late String token;
  late String tipoUsuario;
  late String estado;
  late String nombre;
  late String apellidos;
  late String imagenPerfil;
  //Late String

   Future<void> setLogin(String token, String tipoUsuario, String estado, String nombre, String apellidos, String imgPerfil)async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', token);
    await preferences.setString('tipoUsuario', tipoUsuario);
    await preferences.setString('estado', estado);
    await preferences.setString('nombre', nombre);
    await preferences.setString('apellidos',apellidos);
    //await convertImga(imgPerfil);
    await preferences.setString('fotoPerfil', imgPerfil);
  }

  Future<void> setSesion(bool b) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('sesion', b);
  }

  Future<bool?> getSesion() async {
     bool? session=false;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('sesion'))
      session = await preferences.getBool('sesion');
    else
      session =false;

    return session;
  }

  Future<void> actualizar(String nombre, String apellidos, String imgPerfil)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('nombre', nombre);
    await preferences.setString('apellidos',apellidos);
    //await convertImga(imgPerfil);
    await preferences.setString('fotoPerfil', imgPerfil);

  }


  Future<String?> getLogin()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
     if(preferences.containsKey('token'))
       return await preferences.getString('token');
     else null;
  }

  Future<String?> getToken()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('token'))
      return await preferences.getString('token');
    else null;
  }


  Future<void> convertImga(String imgRoute)async{
    http.Response response = await http.get(
      Uri.parse(imgRoute),
    );
    this.imagenPerfil = base64.encode(response.bodyBytes);
  }

  Future<String?> getfotoPerfil() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('fotoPerfil'))
      return await preferences.getString('fotoPerfil');
    else null;
  }

  Future<String?> getNombre() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('nombre'))
      return await preferences.getString('nombre');
    else null;
  }

  Future<String?> getApellidos() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('apellidos'))
      return await preferences.getString('apellidos');
    else null;
  }

  Future<String?> getTipoUsuario() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('tipoUsuario'))
      return await preferences.getString('tipoUsuario');
    else null;
  }

  Future<void> logout() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('token');
    await preferences.remove('tipoUsuario');
    await preferences.remove('estado');
    await preferences.remove('nombre');
    await preferences.remove('apellidos');
    await preferences.remove('fotoPerfil');
    await preferences.remove('sesion');
  }
}