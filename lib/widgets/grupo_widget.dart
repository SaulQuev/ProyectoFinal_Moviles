import 'package:flutter/material.dart';
import 'package:proyecto_moviles/models/grupo_model.dart';


class GrupoWidget  extends StatelessWidget {
  GrupoWidget ({super.key, required this.grupoModel});

  GrupoModel grupoModel; //llaves indican que los parametros son nombrados
  //AgendaDB? agendaDB;


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        
        child: Row(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text('Nombre:   ${grupoModel.idMateria!}') ],
          ),
          Expanded(child: Container()), //es como espacio entre las columnas
          Column(
            children: [
              GestureDetector(
                onTap: () {}/*=> Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddGrupo(grupoModel: grupoModel)
                        )
                        )*/,
                child: Image.asset(
                  'assets/image/logo.webp',
                  height: 50,
                )
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Mensaje del sistema"),
                          content: Text("Deseas eliminar el elemento"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  /*agendaDB!
                                      .DELETETAREA('Tarea', tareaModel.idTarea!)
                                      .then((value) {
                                    Navigator.pop(context);
                                    GlobalValues.flagTarea.value =
                                        !GlobalValues.flagTarea.value;
                                  });*/
                                },
                                child: Text('Si')),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('No')),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete),
              )
            ],
          ),
        ])
        );
  }
}