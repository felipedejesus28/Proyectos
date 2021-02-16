import 'package:flutter/material.dart';
import 'principal.dart';
import 'signoscapturar.dart';
import 'signosmostrar.dart';
import 'usuariocapturar.dart';

main() async => runApp(Estructura());

class Estructura extends StatefulWidget {
  @override
  createState() => Estado();
}

class Estado extends State<Estructura> {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,

    initialRoute: 'usuariocapturar',

    routes: {
      'principal': (context) => Principal(),
      'usuariocapturar': (context) =>UsuarioCapturar(),
      'signoscapturar': (context) => SignosCapturar(),
      'signosmostrar': (context)=>SignosMostrar(),
    },
  );
}