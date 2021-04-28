import 'package:flutter/material.dart';
import 'package:todolist_flutter/datos.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blueGrey,
      accentColor: Colors.red[400]
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {
  MyDataBase db = MyDataBase();
  
  String input = "";
  String desc = "";
  
  _showList(BuildContext _context){
    return FutureBuilder(
      future: db.obtenerTareas(),
      builder: (BuildContext context, AsyncSnapshot<List<Tarea>> snapshot){
        if (snapshot.hasData){
          return ListView(
            children: <Widget>[
              for(Tarea tarea in snapshot.data)
                Card(
                  elevation: 2,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)
                  ),
                  child: ListTile(
                    title: Text(tarea.titulo),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.red[400],
                      ),
                      onPressed:(){
                        showDialog(context: context, builder: (BuildContext context){
                          return(
                            AlertDialog(
                              title: Text("¿Seguro deseas eliminar este pendiente?"),
                              actions:<Widget>[
                                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cancelar")),
                                TextButton(onPressed: (){ eliminarPendiente(tarea.id); Navigator.of(context).pop();}, child: Text("Eliminar"))
                              ],
                            )
                          );
                        });
                      },
                    ),
                  ),
                )
            ],
          );
        }else{
          return Center(child: Text("Sin Datos"));
        }        
      },
    );
  }
  agregarPendiente(){
    setState(() {
      Tarea tarea = Tarea.fromValues(input, desc);
      db.insert(tarea);
    });
  }
  eliminarPendiente(int i) {
    setState(() {
      db.eliminar(i);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendientes"),
        actions: <Widget>[
          TextButton(
            child: Icon(Icons.info,color: Colors.blueGrey[700]),
            onPressed: (){
              showDialog(context: context, builder: (BuildContext context){
                return(
                  AlertDialog(
                    content: TextButton(
                      child: Text('Lista pendientes v1.0.1 \nDesarrollado por INTDEV'),
                      onPressed: () => launch("http://www.intdev.net")
                    ),
                  )
                );
              });
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title:Text("Agregar Pendiente"),
                content: Container(
                  child: Column(
                    children: <Widget>[
                      TextField(
                        style:  TextStyle(
                          fontSize: 20.0                        
                        ),
                        decoration: InputDecoration(
                          labelText: 'Titulo'
                        ),
                        onChanged: (String value){
                          input = value;
                        }
                      ),
                      TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 3,
                        maxLines: null,
                        decoration: InputDecoration(
                          labelText: 'Descripcion'
                        ),
                        onChanged: (String value){
                          desc = value;
                        }
                      )
                    ],
                  ),
                ), 
                actions: <Widget>[
                  TextButton(onPressed:(){
                    agregarPendiente();
                    Navigator.of(context).pop();
                  }, child: Text("Agregar"))
                ]
              );
            }
          );
        },
        child:Icon(
          Icons.add,
          color:Colors.white60
        )
      ),      
      body: FutureBuilder(
        future: db.initDb(),
        builder: (BuildContext context, snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            return _showList(context);
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }
      )
    );
  }
}