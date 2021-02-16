import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

final cloudBaseDatos = Firestore.instance;

class SignosCapturar extends StatefulWidget {
  @override
  createState() => Estado();
}

class Estado extends State<SignosCapturar> {
  TextEditingController temperaturaControlador = TextEditingController();
  TextEditingController oxigenacionControlador = TextEditingController();
  TextEditingController diastolicaControlador = TextEditingController();
  TextEditingController sistolicaControlador = TextEditingController();
  TextEditingController pulsoControlador = TextEditingController();
  TextEditingController glucosaControlador = TextEditingController();

  var timeStamp = DateTime.now().toString();
  double temperatura;
  int oxigenacion, diastolica, sistolica, pulso, glucosa;

  Database miBaseDatos;

  @override
  void initState() {
    super.initState();

    crearBaseDatos().then((valor) {
      miBaseDatos = valor;
    });
  }

  Future<Database> crearBaseDatos() async {
    WidgetsFlutterBinding.ensureInitialized();
    var ruta = await getDatabasesPath();
    String rutaCompletaBD = join(ruta, 'signos.DB');

    Database baseDatos = await openDatabase(rutaCompletaBD, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Seguimiento ('
          'nombre TEXT, '
          'cel INTEGER, '
          'timeStamp TEXT,'
          'temperatura NUM,'
          'oxigenacion INTEGER,'
          'diastolica INTEGER,'
          'sistolica INTEGER,'
          'pulso INTEGER,'
          'glucosa INTEGER)');
    });
    return await baseDatos;
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            title: Text("Signos"),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: temperaturaControlador,
                  decoration: InputDecoration(
                    hintText: "Temperatura",
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: oxigenacionControlador,
                  decoration: InputDecoration(
                    hintText: "Oxigenación",
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: sistolicaControlador,
                  decoration: InputDecoration(
                    hintText: "Presión Sistólica",
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: diastolicaControlador,
                  decoration: InputDecoration(
                    hintText: "Presión Diastólica",
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: pulsoControlador,
                  decoration: InputDecoration(
                    hintText: "Pulso",
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: glucosaControlador,
                  decoration: InputDecoration(
                    hintText: "Glucosa",
                    isDense: true,
                    contentPadding: EdgeInsets.all(15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                  ),
                ),
              ),

              RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Insertar",
                ),
                onPressed: () {
                  temperatura = double.parse(temperaturaControlador.text.toString());
                  oxigenacion = int.parse(oxigenacionControlador.text);
                  diastolica = int.parse(diastolicaControlador.text);
                  sistolica = int.parse(sistolicaControlador.text);
                  glucosa = int.parse(glucosaControlador.text);
                  pulso = int.parse(pulsoControlador.text);

                  miBaseDatos.rawInsert(
                          'INSERT INTO Seguimiento (nombre, cel, timestamp, temperatura, oxigenacion, diastolica, sistolica, pulso, glucosa) '
                          'VALUES("Felipe", 5513894675, "$timeStamp", $temperatura, $oxigenacion, $diastolica, $sistolica, $pulso ,$glucosa)')
                      .then((total) {
                        print("Total de registros insertados: $total");
                  });
                },
              ),

              RaisedButton(
                  color: Colors.purpleAccent,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text("Mostrar datos"),
                  onPressed: () {
                    consultar();
                    actualizar('02-13 12:23', '98');
                    Navigator.pushNamed(context, 'signosmostrar');
                  }),
            ],
          )));
}

void actualizar(String tiempo, String oxigenacion) async {
  try {
    await cloudBaseDatos.collection('f 5')
        .document(tiempo)
        .updateData({
      'oxigenacion': oxigenacion,
    });
  }
  catch (error) {
    print(error);
  }
}

void consultar() async {
  try {
  String oxigenacion;

    cloudBaseDatos.collection('f 5').document('02-13 12:23').get().then(
            (value) {
          if (value.exists) {
            oxigenacion = value.data['oxigenacion'];
            print("Oxigencacion: "+oxigenacion);
          }
          else {
            oxigenacion = "NO EXISTE";
          }
        }
    );
  }
  catch (error) {
    print(error);
  }
}

/*  Navigator.pushNamed(context, 'signosmostrar',
      arguments: {
        "timeStamp": timeStamp,
        "temperatura": temperatura,
        "oxigenacion": oxigenacion,
        "diastolica": diastolica,
        "sistolica": sistolica,
        "glucosa": glucosa,
    });
*/

/*        RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text("Consultar"),
                  onPressed: () {
                    miBaseDatos.rawQuery('SELECT * FROM Seguimiento').then((value) {
                      print("Datos: $value");
                    });
                  }),


              RaisedButton(
                  color: Colors.red,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  child: Text("Borrar BD"),
                  onPressed: () {
                    miBaseDatos.rawDelete('DELETE FROM Seguimiento').then((value){
                      print("Total de registros borrados: $value");
                    });
                  }),
*/