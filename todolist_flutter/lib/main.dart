import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  List todos = List();
  String input = "";

  @override
  void initState(){
    super.initState();
    todos.add("Item1");
  }

  void agregarPendiente(){
    setState(() {
      todos.add(input);
    });
  }
  void eliminarPendiente(int i){
    setState(() {
      todos.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pendientes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title:Text("Agregar Pendiente"),
                content: TextField(
                  onChanged: (String value){
                    input = value;
                  },
                ),
                actions: <Widget>[
                  FlatButton(onPressed:(){
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
      body: ListView.builder(
        itemCount : todos.length,
        itemBuilder:(BuildContext context, int index){
          return Dismissible(
            key: Key(todos[index]),
            child: Card(
              elevation: 2,
              margin: EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)
              ),
              child: ListTile(
                title: Text(todos[index]),
                trailing: IconButton(
                  icon: Icon(
                  Icons.delete_rounded,
                  color: Colors.red,
                  ),
                  onPressed:(){
                    showDialog(context: context, builder: (BuildContext context){
                      return(
                        AlertDialog(
                          title: Text("¿Seguro deseas eliminar este pendiente?"),
                          actions:<Widget>[
                            FlatButton(onPressed: (){Navigator.of(context).pop();}, child: Text("Cancelar")),
                            FlatButton(onPressed: (){
                              eliminarPendiente(index);
                              Navigator.of(context).pop();
                              },child: Text("Eliminar"))
                          ],
                        )
                      );
                    });
                    
                  },
                ),                
              ),
            ),
          );
        }
      ),
    );
  }
}