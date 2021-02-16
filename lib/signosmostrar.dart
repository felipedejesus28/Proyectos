import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Database miBaseDatos;
final contenido = new StreamController<String>();

class SignosMostrar extends StatefulWidget {
  @override
  createState() => Estado();
}

class Estado extends State<SignosMostrar> {
  Future<Database> abrirBaseDatos() async {
    WidgetsFlutterBinding.ensureInitialized();
    var ruta = await getDatabasesPath();
    String rutaCompletaBD = join(ruta, 'signos.DB');

    Database baseDatos = await openDatabase(rutaCompletaBD);
    return await baseDatos;
  }

  @override
  void initState() {
    super.initState();

    abrirBaseDatos().then((valor) {
      miBaseDatos = valor;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Map signos = ModalRoute.of(context).settings.arguments;
    // print(signos);

    return MaterialApp(
        debugShowCheckedModeBanner: true,
        home: Scaffold(
          appBar: AppBar(
            title: Text("Seguimiento"),
          ),
          body:
            FutureBuilder(
              future: leerDatos(),
              initialData: [Text("Hola")],
              builder: (contexto, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView(
                  children:
                    snapshot.data,
                );
              },
            ),

          /*
      StreamBuilder(
          stream: contenido.stream,
          builder: (contexto, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();

            return
             SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: DataTable(
                columnSpacing: 15,
                sortColumnIndex: 2,
                sortAscending: false,
                columns: [
                  DataColumn(label: Text("Tiempo")),
                  DataColumn(label: Text("Temp"), numeric: true),
                  DataColumn(label: Text("Oxí"), numeric: true),
                  DataColumn(label: Text("Dia"), numeric: true),
                  DataColumn(label: Text("Sys"), numeric: true),
                  DataColumn(label: Text("Pul"), numeric: true),
                  DataColumn(label: Text("Glu"), numeric: true),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text(snapshot.data)),
                    DataCell(Text("36o")),
                    DataCell(Text("94")),
                    DataCell(Text("80")),
                    DataCell(Text("120")),
                    DataCell(Text("60")),
                    DataCell(Text("36")),
                  ]),
                ],
              ),
            );
          }),
*/

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.backspace),
            onPressed: () {
              Navigator.pop(context);

            },
          ),
        ));
  }
}

tablita() {
  DataTable tablita = new DataTable();

  tablita = DataTable(
      columnSpacing: 15,
      columns: [
        DataColumn(label: Text("Tiempo")),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("36")),
        ])
    ]
  );
  return tablita;
}

// ------
Future leerDatos() async {
  List<Widget> listaWidgets = List<Widget>();
  List<Map> tabla = await miBaseDatos.rawQuery('Select * from Seguimiento');

  listaWidgets.add(
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Fecha"),
          Text("Oxige"),
          Text("Temp"),
          Text("Presión"),
          Text("Glucosa"),
        ],
      ));

  listaWidgets.add(Divider());

  for (var registros in tabla) {
    listaWidgets.add(
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(registros['timeStamp'].toString().substring(0, 16).substring(5, 16)),
            Text(registros['oxigenacion'].toString()),
            Text(registros['temperatura'].toString()),
            Text("(" + registros['sistolica'].toString() + "/" +
                registros['diastolica'].toString() + "): " +
                registros['pulso'].toString()),
            Text(registros['glucosa'].toString()),
          ],
        )
    );

    listaWidgets.add(Divider());
  }

  return listaWidgets;
}


// --- CREA LA LISTA PARA EL STREAMBUILDER
crearContenido() {
  List<Map> tabla;
  try {
    miBaseDatos.rawQuery('Select * from Seguimiento').then((value) {
      tabla = value;
      for (var registro in tabla) {
        print(""
            "${registro['nombre']}, ${registro['cel']}, ${registro['timeStamp']}, "
            "${registro['temperatura']}o,  ${registro['oxigenacion']}, ${registro['diastolica']}, ${registro['sistolica']}, ${registro['glucosa']} ");

        contenido.sink.add(registro['timeStamp'].toString());
      }
    });
  } catch (e) {
    print("Error -----------------> $e");
  }
}