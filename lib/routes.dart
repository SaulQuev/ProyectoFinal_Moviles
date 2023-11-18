import 'package:flutter/material.dart';
import 'package:proyecto_moviles/screens/grupos_screen.dart';

Map<String,WidgetBuilder> getRoutes(){
  return{
     '/grupos' : (BuildContext context) => GruposScreen(),
    };
}