import 'package:sqflite/sqflite.dart';
import 'dart:async';

class MyDataBase{
  Database _db;

  initDb() async{
    _db = await openDatabase("todoDB.db",
      version: 1, onCreate: (Database db, int version){
        db.execute('Create Table tareas (id INTEGER PRIMARY KEY, titulo VARCHAR(100), descripcion TEXT);');
      }
    );
    print("Base de datos inicializada");
  }

  insert(Tarea tarea) async{
    await _db.insert("tareas", tarea.toMap());
  }
  eliminar(int id) async{    
    print("Eliminando id: " + id.toString());
    await _db.delete("tareas", where: "id = ?", whereArgs: [id]);
  }

 Future<List<Tarea>> obtenerTareas() async{
    List<Map<String,dynamic>> listado = await _db.query("tareas");
    return listado.map((e) => Tarea.fromMap(e)).toList();
  }
}

class Tarea{
  int id = 0;
  String titulo = "";
  String descripcion = "";

  //***Constructor
  Tarea.fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.titulo = map['titulo'];
    this.descripcion = map['descripcion'];
  }
  //Constructor 2
  Tarea.fromValues(String tit, String desc){
    this.id = 0;
    this.titulo = tit;
    this.descripcion = desc;
  }

  Map<String, dynamic> toMap(){
    return{
      "titulo":titulo,
      "descripcion":descripcion
    };
  }

  

}