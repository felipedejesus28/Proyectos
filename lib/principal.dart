import 'package:flutter/material.dart';

class Principal extends StatefulWidget {
  @override
  createState() => Estado();
}

class Estado extends State<Principal> {
  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("Principal"),
          ),
          body:
            Text("Favor de seleccionar una opción del lado izquierdo")
      ));
}
