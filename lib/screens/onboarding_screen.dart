//import 'dart:js';

import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:proyecto_moviles/screens/card_screen.dart';

class ItemScreen extends StatelessWidget {
  ItemScreen({super.key});

  final data = [
    ItemCardData(
        title: "Instituto Tecnologico de Celaya",
        subtitle: "Institución pública de educación, fundada en 1958, iniciando servicios desde secundaria técnica. Actualmente dedicada a la educación superior en niveles de licenciatura, maestría y doctorado.",
        image: const AssetImage('assets/images/tecno.png'),
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        subtitleColor: Colors.white,
        background: LottieBuilder.asset('assets/animation/bg_1.json')),
    ItemCardData(
        title: "'Somos Linces'",
        subtitle:  "¡Desarrolla tus Habilidades al Maximo LINCEEE!",
        image: const AssetImage('assets/images/lince.webp'),
        backgroundColor: Colors.white,
        titleColor:const Color.fromARGB(255, 87, 172, 97),
        subtitleColor: Colors.black,
        background: LottieBuilder.asset('assets/animation/bg_1.json')),
    ItemCardData(
        title: "Ingenieria En Sistemas Computacionales (ISC) 💻",
        subtitle: "El y la estudiante al ingresar, deberá tener habilidades matemáticas y lógicas, capacidad de análisis y síntesis de información, habilidades de investigación, así como interés por la computación y la programación, disposición para trabajar en equipo y sentido de compromiso social.",
        image: const AssetImage('assets/images/Sistemas.png'),
        backgroundColor:const Color.fromARGB(255, 87, 172, 97),
        titleColor: Colors.black,
        subtitleColor: Colors.white,
        background: LottieBuilder.asset('assets/animation/bg_1.json'))
        
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        itemBuilder: (int index) {
          return ItemCard(data: data[index]);
        },
      ),
    );
  }
}
