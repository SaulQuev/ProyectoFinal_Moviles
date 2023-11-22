import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';
import 'package:proyecto_moviles/models/teacher_model.dart';
import 'package:proyecto_moviles/styles/global_values.dart';
import 'package:proyecto_moviles/widgets/TeacherWidget.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  Agenda? agendadb;
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    agendadb = Agenda();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Administrador de Profes'),
        actions: [
          IconButton(
              onPressed: () async {
                var res = await agendadb!.GETALLCLASS();
                if (res.isEmpty) {
                  ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                          type: ArtSweetAlertType.danger,
                          title: "¡Primero debe insertar una Clase!",
                          text:
                              "Registra por lo menos una clase para agregar profesores"));
                } else {
                  Navigator.pushNamed(context, '/addTeacher');
                }
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: ValueListenableBuilder(
          valueListenable: GlobalValues.flag_database,
          builder: (context, value, _) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Buscar...",
                    ),
                    controller: searchController,
                    onChanged: (text) {
                      GlobalValues.flag_database.value =
                          !GlobalValues.flag_database.value;
                    },
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                      future:
                          agendadb!.GETFILTEREDTEACHERS(searchController.text),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<TeacherModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return teacherWidget(
                                    snapshot.data![index], context);
                              });
                        } else {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Algo fallo"),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        }
                      }),
                ),
              ],
            );
          }),
    );
  }
}
