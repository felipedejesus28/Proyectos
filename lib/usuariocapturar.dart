import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioCapturar extends StatefulWidget {
  @override
  createState() => Estado();
}

class Estado extends State<UsuarioCapturar> {
  String nombre;
  TextEditingController nombreControlador = TextEditingController();

  String celular;
  TextEditingController celularControlador = TextEditingController();

  Future leer() async {
      SharedPreferences preferencias = await SharedPreferences.getInstance();
      List<String> credenciales=[];
      credenciales.add(preferencias.getString('nombre'));
      credenciales.add(preferencias.getString('celular'));
    return credenciales;
  }

  @override
  void initState()  {
    super.initState();

    leer().then((value){
      if(value[0]!=null && value[1]!=null)
        print("Nombre: ${value[0]}");
        print("Celular: ${value[1]}");
        Navigator.pushNamed(context, 'signoscapturar');
      }
    );
  }



  @override
  Widget build(BuildContext context){
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: Text("Registro del usuario"),),
          body:

          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 50),
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: nombreControlador,
                    decoration: InputDecoration(
                      hintText: "Nombre",
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),

                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: celularControlador,
                    decoration: InputDecoration(
                      hintText: "Celular",
                      contentPadding: EdgeInsets.all(15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0)),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 350.0,
                    height: 50.0,
                    child: OutlineButton(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.green,
                      borderSide: BorderSide(color: Colors.blue),
                      textColor: Colors.blue,

                      child: Text("Crear usuario"),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      onPressed: () async {
                        nombre = nombreControlador.text.toString();
                        celular = celularControlador.text.toString();

                        List<String> credenciales = await leerUsuario();

                        print(credenciales);

                        if(credenciales[0]==nombre && credenciales[1]==celular)
                          print("El usuario: $nombre con celular: $celular ya existen, favor de revisar sus datos");
                        else {
                          crearUsuario(nombre, celular);
                          print(credenciales);
                          Navigator.pushNamed(context, 'signoscapturar');
                        }

                      },
                    ),),),
              ],),),
        ));
  }
}


crearUsuario(String nombre, String celular) async {
  SharedPreferences preferencias = await SharedPreferences.getInstance();
  preferencias.setString('nombre', '$nombre');
  preferencias.setString('celular', '$celular');
}

leerUsuario() async {
  SharedPreferences preferencias = await SharedPreferences.getInstance();
  List<String> credenciales=[];
  credenciales.add(preferencias.getString('nombre'));
  credenciales.add(preferencias.getString('celular'));
  return credenciales;
}





/*    Navigator.pushNamed(context, 'signosmostrar',
        arguments: {
          "timeStamp": timeStamp,
          "temperatura": temperatura,
          "oxigenacion": oxigenacion,
          "diastolica": diastolica,
          "sistolica": sistolica,
          "glucosa": glucosa,
      });
*/