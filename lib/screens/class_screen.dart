import 'package:flutter/material.dart';
import 'package:proyecto_moviles/database/TecRoomdb.dart';
import 'package:proyecto_moviles/models/class_model.dart';
import 'package:proyecto_moviles/styles/global_values.dart';
import 'package:proyecto_moviles/widgets/ClassWidget.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({super.key});

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
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
        title: const Text('Administrador de Clases'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addClass');
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
                          agendadb!.GETFILTEREDCLASSES(searchController.text),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ClassModel>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return classWidget(
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
